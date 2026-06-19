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
  List<String> _categorias = [];
  List<String> _plataformas = [];

  bool isLoading = true;
  String searchQuery = '';
  String? _selectedCategoria;
  String? _selectedPlataforma;

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
      setState(() => isLoading = true);

      items = await MongoDatabase.getItems();

      // Construir listas únicas de categorías y plataformas
      final cats = <String>{};
      final plats = <String>{};
      for (final item in items) {
        if (item.categoria.isNotEmpty) cats.add(item.categoria);
        if (item.plataforma.isNotEmpty) plats.add(item.plataforma);
      }
      _categorias = cats.toList()..sort();
      _plataformas = plats.toList()..sort();

      _applyFilters(rebuild: false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando items: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _applyFilters({bool rebuild = true}) {
    filteredItems = items.where((item) {
      final matchesSearch = searchQuery.isEmpty ||
          item.titulo.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategoria = _selectedCategoria == null ||
          item.categoria == _selectedCategoria;
      final matchesPlataforma = _selectedPlataforma == null ||
          item.plataforma == _selectedPlataforma;
      return matchesSearch && matchesCategoria && matchesPlataforma;
    }).toList();

    if (rebuild && mounted) setState(() {});
  }

  void _onSearchChanged(String query) {
    searchQuery = query.trim();
    _applyFilters();
  }

  void _clearFilters() {
    searchQuery = '';
    _selectedCategoria = null;
    _selectedPlataforma = null;
    _applyFilters();
  }

  bool get _hasActiveFilters =>
      searchQuery.isNotEmpty ||
      _selectedCategoria != null ||
      _selectedPlataforma != null;

  Future<void> _goToForm({ItemColeccion? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage(item: item)),
    );
    if (mounted) await cargarItems();
  }

  void _goToDetail(ItemColeccion item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(item: item)),
    );
  }

  Future<void> _deleteItem(ItemColeccion item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Deseas eliminar "${item.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await MongoDatabase.deleteItem(item.id);
    if (mounted) await cargarItems();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.titulo} eliminado correctamente')),
      );
    }
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          // Dropdown categoría
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategoria,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Categoría',
                prefixIcon: const Icon(Icons.category_outlined, size: 18),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todas')),
                ..._categorias.map(
                  (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedCategoria = value);
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: 8),
          // Dropdown plataforma
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPlataforma,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Plataforma',
                prefixIcon: const Icon(Icons.devices_outlined, size: 18),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todas')),
                ..._plataformas.map(
                  (plat) => DropdownMenuItem(value: plat, child: Text(plat)),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedPlataforma = value);
                _applyFilters();
              },
            ),
          ),
          // Botón limpiar filtros
          if (_hasActiveFilters) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              tooltip: 'Limpiar filtros',
              onPressed: _clearFilters,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_books_outlined, size: 80),
              const SizedBox(height: 16),
              Text(
                _hasActiveFilters
                    ? 'No se encontraron resultados'
                    : 'No hay registros',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _hasActiveFilters ? _clearFilters : () => _goToForm(),
                icon: Icon(_hasActiveFilters ? Icons.filter_alt_off : Icons.add),
                label: Text(_hasActiveFilters ? 'Limpiar filtros' : 'Agregar item'),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
            .copyWith(bottom: 100),
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
        title: Text(
          _hasActiveFilters
              ? 'Mi colección (${filteredItems.length})'
              : 'Mi colección',
        ),
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
          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchQuery = '';
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Filtros categoría / plataforma
          _buildFilterBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}