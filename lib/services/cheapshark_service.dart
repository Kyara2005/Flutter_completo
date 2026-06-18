import 'dart:convert';
import 'package:http/http.dart' as http;

class CheapSharkService {
  static const String _baseUrl = "https://www.cheapshark.com/api/1.0";

  /// Obtiene una lista de ofertas con paginación.
  ///
  /// [page] -> Número de página.
  /// [limit] -> Cantidad de registros por página.
  static Future<List<dynamic>> getDeals({
    required int page,
    required int limit,
  }) async {
    try {
      final Uri url = Uri.parse(
        "$_baseUrl/deals?pageNumber=$page&pageSize=$limit",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception(
          "Error ${response.statusCode}: No fue posible obtener los datos.",
        );
      }
    } catch (e) {
      throw Exception("Error al conectar con CheapShark: $e");
    }
  }
}