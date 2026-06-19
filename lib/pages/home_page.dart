import 'package:flutter/material.dart';
import 'collection_page.dart';
import 'api_explorer_page.dart';
import 'statistics_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const primary = Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [
          _header(),

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _tile(
                    context,
                    icon: Icons.collections_bookmark_outlined,
                    title: "Mi Colección",
                    color: Colors.blue,
                    page: const CollectionPage(),
                  ),
                  _tile(
                    context,
                    icon: Icons.public,
                    title: "Explorar API",
                    color: Colors.green,
                    page: const ApiExplorerPage(),
                  ),
                  _tile(
                    context,
                    icon: Icons.bar_chart_outlined,
                    title: "Estadísticas",
                    color: Colors.orange,
                    page: const StatisticsPage(),
                  ),
                  _tile(
                    context,
                    icon: Icons.info_outline,
                    title: "Acerca de",
                    color: Colors.purple,
                    page: const AboutPage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: const [
          Icon(Icons.videogame_asset_rounded, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "MediaExplorer",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Explora y gestiona tu mundo gamer",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}