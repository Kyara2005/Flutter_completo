import 'package:flutter/material.dart';
import 'collection_page.dart';
import 'api_explorer_page.dart';
import 'statistics_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediaExplorer App"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.video_library_rounded,
              size: 100,
              color: Colors.indigo,
            ),

            const SizedBox(height: 20),

            const Text(
              "Bienvenido a MediaExplorer",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              "Administra tu colección personal y descubre videojuegos desde CheapShark.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            _menuButton(
              context,
              icon: Icons.collections_bookmark,
              title: "Mi colección",
              color: Colors.blue,
              page: const CollectionPage(),
            ),

            const SizedBox(height: 15),

            _menuButton(
              context,
              icon: Icons.public,
              title: "Explorar API",
              color: Colors.green,
              page: const ApiExplorerPage(),
            ),

            const SizedBox(height: 15),

            _menuButton(
              context,
              icon: Icons.bar_chart,
              title: "Estadísticas",
              color: Colors.orange,
              page: const StatisticsPage(),
            ),

            const SizedBox(height: 15),

            _menuButton(
              context,
              icon: Icons.info,
              title: "Acerca de",
              color: Colors.purple,
              page: const AboutPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget page,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}