import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/item_coleccion.dart';
import '../utils/snackbar_utils.dart';
import '../db/mongo_database.dart';

/// Formulario para crear y editar items de la colección.
class FormPage extends StatefulWidget {
  final ItemColeccion? item;

  const FormPage({super.key, this.item});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloCtrl;
  late final TextEditingController _categoriaCtrl;
  late final TextEditingController _plataformaCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _imagenCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _fuenteCtrl;

  bool _saving = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _tituloCtrl = TextEditingController(text: item?.titulo ?? '');
    _categoriaCtrl = TextEditingController(text: item?.categoria ?? '');
    _plataformaCtrl = TextEditingController(text: item?.plataforma ?? '');
    _precioCtrl = TextEditingController(
        text: item != null ? item.precio.toStringAsFixed(2) : '');
    _stockCtrl =
        TextEditingController(text: item != null ? item.stock.toString() : '');
    _imagenCtrl = TextEditingController(text: item?.imagen ?? '');
    _descripcionCtrl = TextEditingController(text: item?.descripcion ?? '');
    _fuenteCtrl = TextEditingController(text: item?.fuente ?? 'Manual');
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _categoriaCtrl.dispose();
    _plataformaCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _imagenCtrl.dispose();
    _descripcionCtrl.dispose();
    _fuenteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final newItem = ItemColeccion(
      mongoId: widget.item?.mongoId,
      id: widget.item?.id ?? const Uuid().v4(),
      titulo: _tituloCtrl.text.trim(),
      categoria: _categoriaCtrl.text.trim(),
      plataforma: _plataformaCtrl.text.trim(),
      precio: double.tryParse(_precioCtrl.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      imagen: _imagenCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      fuente: _fuenteCtrl.text.trim(),
    );

    try {
      if (_isEditing) {
        await MongoDatabase.updateItem(newItem);
      } else {
        await MongoDatabase.insertItem(newItem);
      }

      if (!mounted) return;

      SnackBarUtils.showSuccess(
        context,
        _isEditing ? 'Item actualizado correctamente.' : 'Item guardado correctamente.',
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, 'Error al guardar: $e');
    } finally {
      if (mounted) {
        setState(() { _saving = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Item' : 'Nuevo Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPreviewImage(),
              const SizedBox(height: 16),
              _field(_tituloCtrl, 'Título',
                  icon: Icons.title, required: true),
              _field(_categoriaCtrl, 'Categoría',
                  icon: Icons.category_outlined, required: true),
              _field(_plataformaCtrl, 'Plataforma',
                  icon: Icons.devices_outlined, required: true),
              _numberField(_precioCtrl, 'Precio',
                  icon: Icons.attach_money, isDecimal: true),
              _numberField(_stockCtrl, 'Stock',
                  icon: Icons.inventory_2_outlined),
              _field(_imagenCtrl, 'Imagen',
                  icon: Icons.image_outlined, required: false),
              _field(_descripcionCtrl, 'Descripción',
                  icon: Icons.description_outlined,
                  required: true,
                  maxLines: 3),
              _field(_fuenteCtrl, 'Fuente',
                  icon: Icons.source_outlined, required: true),
              const SizedBox(height: 24),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewImage() {
    final url = _imagenCtrl.text.trim();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: url.isNotEmpty ? 160 : 80,
      decoration: BoxDecoration(
        color: const Color(0xFFCCCCCC).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Color(0xFFCCCCCC),
              ),
            )
          : const Center(
              child: Icon(
                Icons.image_outlined,
                size: 40,
                color: Color(0xFFCCCCCC),
              ),
            ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    required IconData icon,
    bool required = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
        ),
        onChanged: label == 'Imagen' ? (_) => setState(() {}) : null,
        validator: required
            ? (v) => (v == null || v.trim().isEmpty)
                ? 'Este campo es obligatorio'
                : null
            : null,
      ),
    );
  }

  Widget _numberField(
    TextEditingController ctrl,
    String label, {
    required IconData icon,
    bool isDecimal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C63FF)),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Este campo es obligatorio';
          if (isDecimal && double.tryParse(v.trim()) == null) {
            return 'Ingrese un número válido';
          }
          if (!isDecimal && int.tryParse(v.trim()) == null) {
            return 'Ingrese un número válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _saving ? null : _save,
      icon: _saving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.save_outlined),
      label: Text(_saving ? 'Guardando...' : 'Guardar'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
