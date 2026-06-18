import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6C63FF);
    const textGray = Color(0xFF6B7280);

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videogame_asset_rounded,
                      size: 50,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MediaExplorer',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Administra tu colección personal y explora ofertas de videojuegos desde CheapShark API.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: primary.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: const Text('v1.0.0'),
                    backgroundColor: primary.withOpacity(0.1),
                    labelStyle: TextStyle(color: primary.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section(context, 'Integrantes del equipo', Icons.people_outline, [
            _infoTile(Icons.person_outline, 'Estudiante 1', 'Desarrollador Flutter'),
            _infoTile(Icons.person_outline, 'Estudiante 2', 'Backend'),
            _infoTile(Icons.person_outline, 'Estudiante 3', 'UI/UX'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'API utilizada', Icons.cloud_outlined, [
            _infoTile(Icons.api, 'CheapShark API', 'API pública de ofertas'),
            _infoTile(Icons.public, 'Tipo', 'REST API'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Base de datos', Icons.storage_outlined, [
            _infoTile(Icons.cloud_done_outlined, 'MongoDB Atlas', 'Base en la nube'),
            _infoTile(Icons.folder_outlined, 'Colección', 'coleccion'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Arquitectura', Icons.architecture_outlined, [
            _infoTile(Icons.layers_outlined, 'Estado', 'setState (sin Provider)'),
            _infoTile(Icons.route_outlined, 'Navegación', 'Navigator push'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Tecnologías', Icons.code_outlined, [
            _infoTile(Icons.flutter_dash, 'Flutter', 'Framework UI'),
            _infoTile(Icons.language, 'Dart', 'Lenguaje'),
            _infoTile(Icons.storage, 'MongoDB', 'NoSQL'),
            _infoTile(Icons.http, 'http', 'Requests HTTP'),
            _infoTile(Icons.key, 'uuid', 'IDs únicos'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Capturas', Icons.photo_library_outlined, [
            _screenshotPlaceholder('Pantalla principal'),
            _screenshotPlaceholder('Colección'),
            _screenshotPlaceholder('API'),
            _screenshotPlaceholder('Estadísticas'),
          ]),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    const primary = Color(0xFF6C63FF);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(icon, color: primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    const gray = Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(icon, size: 20, color: gray),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(color: gray, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _screenshotPlaceholder(String label) {
    const primary = Color(0xFF6C63FF);
    const gray = Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 120,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 32, color: primary.withOpacity(0.5)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: gray)),
          ],
        ),
      ),
    );
  }
}