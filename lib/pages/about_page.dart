import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const primary = Color(0xFF6C63FF);
  static const textGray = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {

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

          _section(context, 'Integrantes del proyecto', Icons.people_outline, [
            _infoTile(Icons.person_outline, 'Santiago Vargas', 'Conexion con API y base de datos'),
            _infoTile(Icons.person_outline, 'Kyara Altamirano', 'Diseño de UI/UX y navegación'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'API utilizada', Icons.cloud_outlined, [
            _infoTile(Icons.api, 'CheapShark API', 'API pública de ofertas'),
            _infoTile(Icons.public, 'Tipo', 'REST API'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Base de datos', Icons.storage_outlined, [
            _infoTile(Icons.cloud_done_outlined, 'MongoDB Atlas', 'Base en la nube'),
            _infoTile(Icons.folder_outlined, 'Colección', 'Videojuegos'),
          ]),

          const SizedBox(height: 16),

          _section(context, 'Arquitectura', Icons.architecture_outlined, [
            _infoTile(Icons.layers_outlined, 'Estado', 'setState'),
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

          _section(context,'Explicación técnica',Icons.description_outlined,[
            _infoTile(Icons.code,'Frontend','Desarrollado en Flutter utilizando widgets y ayuda de inteligencia artificial.',),
            _infoTile(Icons.cloud,'Consumo de API','La aplicación consulta CheapShark API mediante solicitudes HTTP para obtener videojuegos y ofertas.',),
            _infoTile(Icons.storage,'Persistencia','Los videojuegos de la colección se almacenan en MongoDB Atlas.',),
            _infoTile(Icons.sync,'Flujo','Los datos obtenidos desde la API pueden ser agregados a la colección y posteriormente analizados mediante estadísticas además, existe la verificación del duplicado con UUID.',),
            ],
          ),

          const SizedBox(height: 16),

          _section(context, 'Capturas', Icons.photo_library_outlined,
            [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _screenshot('assets/screenshots/home.jpg', 'Pantalla principal'),
                  _screenshot('assets/screenshots/coleccion.jpg', 'Colección'),
                  _screenshot('assets/screenshots/api.jpg', 'API'),
                  _screenshot('assets/screenshots/formulario.jpg', 'Formulario'),
                  _screenshot('assets/screenshots/estadisticas.jpg', 'Estadísticas'),
                ],
              ),
            ],
          ),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primary, size: 22),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: textGray),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(color: textGray, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _screenshot(String path, String title) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              path,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}