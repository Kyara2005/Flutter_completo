import 'package:flutter/material.dart';
import '../models/item_coleccion.dart';

class ItemCard extends StatelessWidget {
  final ItemColeccion item;
  final VoidCallback? onTapDetail;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;
  final Widget? trailingButton;

  const ItemCard({
    super.key,
    required this.item,
    this.onTapDetail,
    this.onTapEdit,
    this.onTapDelete,
    this.trailingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTapDetail,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 6),
                  _buildChips(context),
                  const SizedBox(height: 8),
                  _buildPriceRow(context),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: item.imagen.isNotEmpty
          ? Image.network(
              item.imagen,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderImage(),
            )
          : _placeholderImage(),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFF6C63FF).withOpacity(0.1),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 60,
        color: Color(0xFF6C63FF),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      item.titulo,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A2E),
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildChips(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        if (item.categoria.isNotEmpty)
          _chip(
            item.categoria,
            const Color(0xFF6C63FF).withOpacity(0.12),
            const Color(0xFF6C63FF),
          ),
        if (item.plataforma.isNotEmpty)
          _chip(
            item.plataforma,
            const Color(0xFF03DAC6).withOpacity(0.12),
            const Color(0xFF03DAC6),
          ),
      ],
    );
  }

  Widget _chip(String label, Color bgColor, Color textColor) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${item.precio.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'Stock: ${item.stock}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: onTapDetail ?? () {},
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('Detalle'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6C63FF),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: onTapEdit ?? () {},
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Editar'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF59E0B),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: onTapDelete ?? () {},
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Eliminar'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB00020),
            ),
          ),
        ),
        if (trailingButton != null) trailingButton!,
      ],
    );
  }
}