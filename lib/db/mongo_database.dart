import 'package:mongo_dart/mongo_dart.dart';
import '../models/item_coleccion.dart';

/// Clase estática que gestiona la conexión y operaciones con MongoDB Atlas.
class MongoDatabase {
  // ⚠️ Reemplaza con tu cadena de conexión de MongoDB Atlas
  static const String _mongoUrl =
      'mongodb+srv://kaltamirano_db_user:uFhRfYKVP5ByaiCo@ventas.fpqwl2x.mongodb.net/moviles?retryWrites=true&w=majority';

  static const String _collectionName = 'videojuegos';

  static late Db _db;
  static late DbCollection _collection;
  static bool _isConnected = false;

  /// Establece la conexión con MongoDB Atlas.
  static Future<void> connect() async {
    if (_isConnected) return;
    _db = await Db.create(_mongoUrl);
    await _db.open();
    _collection = _db.collection(_collectionName);
    _isConnected = true;
    print("Conectado a MongoDB Atlas");
  }

  /// Inserta un nuevo item en la colección.
  static Future<void> insertItem(ItemColeccion item) async {
    await connect();
    await _collection.insertOne(item.toJson());
  }

  /// Actualiza un item existente por su campo 'id'.
  static Future<void> updateItem(ItemColeccion item) async {
    await connect();
    await _collection.updateOne(
      where.eq('id', item.id),
      modify
          .set('titulo', item.titulo)
          .set('categoria', item.categoria)
          .set('plataforma', item.plataforma)
          .set('precio', item.precio)
          .set('stock', item.stock)
          .set('imagen', item.imagen)
          .set('descripcion', item.descripcion)
          .set('fuente', item.fuente),
    );
  }

  /// Elimina un item por su campo 'id'.
  static Future<void> deleteItem(String id) async {
    await connect();
    await _collection.deleteOne(where.eq('id', id));
  }

  /// Obtiene todos los items de la colección.
  static Future<List<ItemColeccion>> getItems() async {
    await connect();
    final List<Map<String, dynamic>> data = await _collection.find().toList();
    return data.map((map) => ItemColeccion.fromJson(map)).toList();
  }

  /// Obtiene un item específico por su campo 'id'.
  static Future<ItemColeccion?> getItemById(String id) async {
    await connect();
    final map = await _collection.findOne(where.eq('id', id));
    if (map == null) return null;
    return ItemColeccion.fromJson(map);
  }

  /// Busca items cuyo título contenga el término (búsqueda case-insensitive).
  static Future<List<ItemColeccion>> searchItems(String query) async {
    await connect();
    final List<Map<String, dynamic>> data = await _collection
        .find(where.match('titulo', query, caseInsensitive: true))
        .toList();
    return data.map((map) => ItemColeccion.fromJson(map)).toList();
  }

  /// Verifica si ya existe un item con el mismo título.
  static Future<bool> existsByTitle(String titulo) async {
    await connect();
    final count = await _collection
        .count(where.match('titulo', '^${RegExp.escape(titulo)}\$',
            caseInsensitive: true));
    return (count ?? 0) > 0;
  }

  /// Obtiene estadísticas agregadas de la colección.
  static Future<Map<String, dynamic>> getStats() async {
    await connect();
    final List<Map<String, dynamic>> allItems =
        await _collection.find().toList();

    if (allItems.isEmpty) {
      return {
        'total': 0,
        'precioPromedio': 0.0,
        'precioMaximo': 0.0,
        'precioMinimo': 0.0,
        'stockTotal': 0,
        'porCategoria': <String, int>{},
        'porPlataforma': <String, int>{},
      };
    }

    final precios = allItems
        .map((item) => (item['precio'] as num?)?.toDouble() ?? 0.0)
        .toList();

    final stocks = allItems
        .map((item) => (item['stock'] as num?)?.toInt() ?? 0)
        .toList();

    final Map<String, int> porCategoria = {};
    final Map<String, int> porPlataforma = {};

    for (final item in allItems) {
      final cat = item['categoria']?.toString() ?? 'Sin categoría';
      final plat = item['plataforma']?.toString() ?? 'Sin plataforma';
      porCategoria[cat] = (porCategoria[cat] ?? 0) + 1;
      porPlataforma[plat] = (porPlataforma[plat] ?? 0) + 1;
    }

    return {
      'total': allItems.length,
      'precioPromedio': precios.reduce((a, b) => a + b) / precios.length,
      'precioMaximo': precios.reduce((a, b) => a > b ? a : b),
      'precioMinimo': precios.reduce((a, b) => a < b ? a : b),
      'stockTotal': stocks.reduce((a, b) => a + b),
      'porCategoria': porCategoria,
      'porPlataforma': porPlataforma,
    };
  }

  /// Obtiene todas las categorías únicas.
  static Future<List<String>> getCategories() async {
    await connect();
    final items = await _collection.find().toList();
    final Set<String> cats = {};
    for (final item in items) {
      final cat = item['categoria']?.toString();
      if (cat != null && cat.isNotEmpty) cats.add(cat);
    }
    return cats.toList()..sort();
  }

  /// Obtiene todas las plataformas únicas.
  static Future<List<String>> getPlatforms() async {
    await connect();
    final items = await _collection.find().toList();
    final Set<String> plats = {};
    for (final item in items) {
      final plat = item['plataforma']?.toString();
      if (plat != null && plat.isNotEmpty) plats.add(plat);
    }
    return plats.toList()..sort();
  }
}
