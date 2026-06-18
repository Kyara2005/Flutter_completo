import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';
import '../services/cheapshark_service.dart';
import '../utils/snackbar_utils.dart';

class ApiExplorerPage extends StatefulWidget {
  const ApiExplorerPage({super.key});

  @override
  State<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends State<ApiExplorerPage> {
  final List<dynamic> _deals = [];
  final ScrollController _scrollController = ScrollController();

  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  final Set<String> _saving = {};

  @override
  void initState() {
    super.initState();
    _loadMore();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
              _scrollController.position.maxScrollExtent - 200 &&
          !_loading &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;

    setState(() => _loading = true);

    final results =
        await CheapSharkService.getDeals(pageNumber: _page);

    setState(() {
      if (results.isEmpty) {
        _hasMore = false;
      } else {
        _deals.addAll(results);
        _page++;
      }
      _loading = false;
    });
  }

  Future<void> _saveDeal(dynamic deal) async {
    if (_saving.contains(deal.dealId)) return;

    setState(() => _saving.add(deal.dealId));

    try {
      final exists = await MongoDatabase.searchItems(deal.title);
      if (exists.isNotEmpty) {
        SnackBarUtils.showWarning(context, 'Ya existe en colección');
        return;
      }

      final item = ItemColeccion(
        id: const Uuid().v4(),
        titulo: deal.title,
        categoria: 'Videojuego',
        plataforma: deal.storeId.toString(),
        precio: deal.salePriceDouble,
        stock: 1,
        imagen: deal.thumb,
        descripcion: 'Desde CheapShark',
        fuente: 'API',
      );

      await MongoDatabase.insertItem(item);

      if (!mounted) return;

      SnackBarUtils.showSuccess(context, 'Guardado correctamente');
    } catch (e) {
      SnackBarUtils.showError(context, 'Error: $e');
    } finally {
      if (mounted) {
        setState(() => _saving.remove(deal.dealId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar API'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _deals.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _deals.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final deal = _deals[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(deal.title),
              subtitle: Text('\$${deal.salePrice}'),
              trailing: IconButton(
                icon: _saving.contains(deal.dealId)
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.save),
                onPressed: () => _saveDeal(deal),
              ),
            ),
          );
        },
      ),
    );
  }
}