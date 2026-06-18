import 'package:flutter/material.dart';
import 'form_page.dart';
import 'detail_page.dart';
import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';
import '../widgets/item_card.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final ScrollController _scrollController = ScrollController();

  List<ItemColeccion> items = [];
  List<ItemColeccion> filteredItems = [];

  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cargarItems();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> cargarItems() async {
    try {
      setState(() {
        isLoading = true;
      });

      items = await MongoDatabase.getItems();

      // Mantener filtro activo al refrescar
      _searchItems(searchQuery, rebuild: false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cargando items: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _searchItems(String query, {bool rebuild = true}) {
    searchQuery = query;

    if (query.trim().isEmpty) {
      filteredItems = List.from(items);
    } else {
      filteredItems = items.where((item) {
        return item.titulo
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }

    if (rebuild && mounted) {
      setState(() {});
    }
  }

  Future<void> _goToForm({ItemColeccion? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(item: item),
      ),
    );

    if (mounted) {
      await cargarItems();
    }
  }

  void _goToDetail(ItemColeccion item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: item),
      ),
    );
  }

  Future<void> _deleteItem(ItemColeccion item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Deseas eliminar "${item.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await MongoDatabase.deleteItem(item.id);

    if (mounted) {
      await cargarItems();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.titulo} eliminado correctamente',
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.library_books_outlined,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                searchQuery.isEmpty
                    ? 'No hay registros'
                    : 'No se encontraron resultados',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: searchQuery.isEmpty
                    ? () => _goToForm()
                    : () {
                        _searchItems('');
                      },
                icon: Icon(
                  searchQuery.isEmpty
                      ? Icons.add
                      : Icons.clear,
                ),
                label: Text(
                  searchQuery.isEmpty
                      ? 'Agregar item'
                      : 'Limpiar búsqueda',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cargarItems,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8).copyWith(bottom: 100),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];

          return ItemCard(
            item: item,
            onTapDetail: () => _goToDetail(item),
            onTapEdit: () => _goToForm(item: item),
            onTapDelete: () => _deleteItem(item),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi colección'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: cargarItems,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnAgregar',
        onPressed: () => _goToForm(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              onChanged: (value) => _searchItems(value.trim()),
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchItems('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }
}