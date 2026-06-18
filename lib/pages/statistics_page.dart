import 'package:flutter/material.dart';
import '../db/mongo_database.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _statsFuture = MongoDatabase.getStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final stats = snapshot.data!;

          final total = stats['total'] as int;
          final avg = stats['precioPromedio'] as double;
          final max = stats['precioMaximo'] as double;
          final min = stats['precioMinimo'] as double;
          final stock = stats['stockTotal'] as int;

          if (total == 0) {
            return const Center(
              child: Text(
                'Tu colección está vacía',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _title('Resumen general'),

                _statCard(
                  icon: Icons.library_books,
                  title: 'Total de registros',
                  value: '$total',
                  color: Colors.blue,
                ),

                _statCard(
                  icon: Icons.attach_money,
                  title: 'Precio promedio',
                  value: '\$${avg.toStringAsFixed(2)}',
                  color: Colors.indigo,
                ),

                _statCard(
                  icon: Icons.trending_up,
                  title: 'Precio máximo',
                  value: '\$${max.toStringAsFixed(2)}',
                  color: Colors.red,
                ),

                _statCard(
                  icon: Icons.trending_down,
                  title: 'Precio mínimo',
                  value: '\$${min.toStringAsFixed(2)}',
                  color: Colors.green,
                ),

                _statCard(
                  icon: Icons.inventory_2,
                  title: 'Stock total',
                  value: '$stock',
                  color: Colors.orange,
                ),

                const SizedBox(height: 20),
                _title('Distribución'),

                _simpleBox(
                  'Por categoría',
                  stats['porCategoria'].toString(),
                ),

                const SizedBox(height: 10),

                _simpleBox(
                  'Por plataforma',
                  stats['porPlataforma'].toString(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===================== WIDGETS LOCALES =====================

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _simpleBox(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(value),
          ],
        ),
      ),
    );
  }
}