import 'package:mongo_dart/mongo_dart.dart';

/// Modelo principal para los items de la colección personal.
class ItemColeccion {
  final ObjectId mongoId;
  final String id;
  final String titulo;
  final String categoria;
  final String plataforma;
  final double precio;
  final int stock;
  final String imagen;
  final String descripcion;
  final String fuente;

  ItemColeccion({
    ObjectId? mongoId,
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.plataforma,
    required this.precio,
    required this.stock,
    required this.imagen,
    required this.descripcion,
    required this.fuente,
  }) : mongoId = mongoId ?? ObjectId();

  /// Construye un ItemColeccion desde un Map de MongoDB.
  factory ItemColeccion.fromJson(Map<String, dynamic> map) {
    return ItemColeccion(
      mongoId: map['_id'] is ObjectId ? map['_id'] as ObjectId : ObjectId(),
      id: map['id']?.toString() ?? '',
      titulo: map['titulo']?.toString() ?? '',
      categoria: map['categoria']?.toString() ?? '',
      plataforma: map['plataforma']?.toString() ?? '',
      precio: (map['precio'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      imagen: map['imagen']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      fuente: map['fuente']?.toString() ?? '',
    );
  }

  /// Convierte el modelo a un Map para MongoDB.
  Map<String, dynamic> toJson() {
    return {
      '_id': mongoId,
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'plataforma': plataforma,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'descripcion': descripcion,
      'fuente': fuente,
    };
  }

  /// Retorna una copia con valores reemplazados.
  ItemColeccion copyWith({
    ObjectId? mongoId,
    String? id,
    String? titulo,
    String? categoria,
    String? plataforma,
    double? precio,
    int? stock,
    String? imagen,
    String? descripcion,
    String? fuente,
  }) {
    return ItemColeccion(
      mongoId: mongoId ?? this.mongoId,
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      plataforma: plataforma ?? this.plataforma,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      imagen: imagen ?? this.imagen,
      descripcion: descripcion ?? this.descripcion,
      fuente: fuente ?? this.fuente,
    );
  }

  @override
  String toString() =>
      'ItemColeccion(id: $id, titulo: $titulo, categoria: $categoria)';
}
