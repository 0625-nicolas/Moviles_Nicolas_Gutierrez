import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/university.dart';

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onEdit,
    required this.onDelete,
  });

  // Abre el enlace web de forma segura
  Future<void> _launchURL(BuildContext context, String urlString) async {
    try {
      final urlStr = urlString.startsWith('http') ? urlString : 'https://$urlString';
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir el enlace: $urlString'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Formato de URL no soportado: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0x991E1B29), // Fondo glassmorphic
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Cabecera de la tarjeta con gradiente sutil
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white.withOpacity(0.02),
              child: Row(
                children: [
                  // Avatar de la Universidad
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF7F00FF), Color(0xFF00F0FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        university.nombre.isNotEmpty
                            ? university.nombre[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Nombre e Información Básica
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Badge para el NIT
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00F0FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF00F0FF).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'NIT: ${university.nit}',
                            style: const TextStyle(
                              color: Color(0xFF00F0FF),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Cuerpo de la tarjeta con datos
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(Icons.location_on_outlined, university.direccion),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.phone_outlined, university.telefono),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _launchURL(context, university.paginaWeb),
                    child: _buildInfoRow(
                      Icons.language_outlined,
                      university.paginaWeb,
                      textColor: const Color(0xFF00F0FF),
                      isLink: true,
                    ),
                  ),
                ],
              ),
            ),

            // Línea divisoria fina
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.05),
            ),

            // Barra de acciones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white.withOpacity(0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón "Visitar Web"
                  TextButton.icon(
                    onPressed: () => _launchURL(context, university.paginaWeb),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF00F0FF)),
                    label: const Text(
                      'Visitar Sitio',
                      style: TextStyle(color: Color(0xFF00F0FF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Acciones CRUD
                  Row(
                    children: [
                      // Editar
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_rounded, color: Colors.white70, size: 20),
                        tooltip: 'Editar Universidad',
                        style: IconButton.styleFrom(
                          hoverColor: Colors.white10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Eliminar
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                        tooltip: 'Eliminar Universidad',
                        style: IconButton.styleFrom(
                          hoverColor: Colors.redAccent.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color textColor = Colors.white70, bool isLink = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: isLink ? const Color(0xFF00F0FF) : Colors.white30),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text.isNotEmpty ? text : 'No especificado',
            style: TextStyle(
              color: textColor,
              fontSize: 13.5,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
