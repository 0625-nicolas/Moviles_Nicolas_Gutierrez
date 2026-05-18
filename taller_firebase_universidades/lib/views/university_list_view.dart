import 'package:flutter/material.dart';
import '../models/university.dart';
import '../services/firebase_service.dart';
import '../widgets/university_card.dart';
import 'university_form_view.dart';
import 'firebase_setup_guide_view.dart';

class UniversityListView extends StatefulWidget {
  const UniversityListView({super.key});

  @override
  State<UniversityListView> createState() => _UniversityListViewState();
}

class _UniversityListViewState extends State<UniversityListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Abre el cuadro de diálogo elegante para confirmar la eliminación
  void _confirmDelete(BuildContext context, University university) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: const Color(0xFF1E1B29),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white10),
              ),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Text(
                    '¿Eliminar registro?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                'Esta acción eliminará de forma permanente a la universidad "${university.nombre}" de la base de datos.',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      await FirebaseService.instance.deleteUniversity(university.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"${university.nombre}" eliminada correctamente.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al eliminar: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E17),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Universidades',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FirebaseService.useDemoMode ? Colors.orange : Colors.green,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  FirebaseService.useDemoMode
                      ? 'Base de datos local (Modo Demo)'
                      : 'Sincronizado con Firebase Firestore',
                  style: TextStyle(
                    color: FirebaseService.useDemoMode ? Colors.orange : Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Botón para desconectar/volver a guía
          IconButton(
            onPressed: () {
              // Restaurar modo base e ir a la pantalla de guía
              FirebaseService.useDemoMode = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirebaseSetupGuideView(),
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white60),
            tooltip: 'Configurar Firebase',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Buscador premium superior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x7F1E1B29),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, NIT o ciudad...',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white30),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          // Listado en tiempo real mediante StreamBuilder
          Expanded(
            child: StreamBuilder<List<University>>(
              stream: FirebaseService.instance.getUniversitiesStream(),
              builder: (context, snapshot) {
                // Estado de espera/carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                    ),
                  );
                }

                // Captura de errores
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            'Error de Conexión',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final List<University> allUniversities = snapshot.data ?? [];

                // Filtrado dinámico según la barra de búsqueda
                final filteredUniversities = allUniversities.where((uni) {
                  return uni.nombre.toLowerCase().contains(_searchQuery) ||
                      uni.nit.toLowerCase().contains(_searchQuery) ||
                      uni.direccion.toLowerCase().contains(_searchQuery);
                }).toList();

                // Estado vacío
                if (filteredUniversities.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.domain_disabled_rounded,
                            size: 72,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Sin coincidencias para "$_searchQuery"'
                                : 'No hay universidades registradas',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Intenta escribir palabras clave diferentes.'
                                : 'Agrega una nueva universidad usando el botón flotante inferior.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white30,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Renderizado de listado con animaciones suaves
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredUniversities.length,
                  itemBuilder: (context, index) {
                    final uni = filteredUniversities[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 300)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1.0 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: UniversityCard(
                        university: uni,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UniversityFormView(university: uni),
                            ),
                          );
                        },
                        onDelete: () => _confirmDelete(context, uni),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UniversityFormView(),
            ),
          );
        },
        backgroundColor: const Color(0xFF7F00FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFF00F0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
