import 'package:flutter/material.dart';
import '../models/item_coleccion.dart';
import '../db/mongo_database.dart';
import 'form_page.dart';

class DetailPage extends StatelessWidget {
  final ItemColeccion item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoCard(),
                const SizedBox(height: 12),
                _buildPriceCard(),
                const SizedBox(height: 12),
                _buildDescriptionCard(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),

      // 👇 SIN routes.dart
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormPage(item: item),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Editar'),
      ),
    );
  }

  // ---------------- APP BAR ----------------
  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.indigo,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          item.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: item.imagen.isNotEmpty
            ? Image.network(
                item.imagen,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.indigo.withOpacity(0.2),
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 80),
      ),
    );
  }

  // ---------------- INFO ----------------
  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información general',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _row('Título', item.titulo),
            _row('Categoría', item.categoria),
            _row('Plataforma', item.plataforma),
            _row('Fuente', item.fuente),
            _row('ID', item.id),
          ],
        ),
      ),
    );
  }

  // ---------------- PRICE ----------------
  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Precio y stock',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _stat(
                    '\$${item.precio.toStringAsFixed(2)}',
                    'Precio',
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _stat(
                    item.stock.toString(),
                    'Stock',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  // ---------------- DESCRIPTION ----------------
  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descripción',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              item.descripcion.isNotEmpty
                  ? item.descripcion
                  : 'Sin descripción.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value.isNotEmpty ? value : '—'),
          ),
        ],
      ),
    );
  }
}