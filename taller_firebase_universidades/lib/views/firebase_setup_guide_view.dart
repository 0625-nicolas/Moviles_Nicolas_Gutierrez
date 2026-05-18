import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'university_list_view.dart';

class FirebaseSetupGuideView extends StatelessWidget {
  final Object? error;

  const FirebaseSetupGuideView({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: Stack(
        children: [
          // Gradientes de fondo decorativos neón
          Positioned(
            top: -size.height * 0.2,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1F7F00FF), // Violeta difuminado
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.2,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1F00F0FF), // Cyan difuminado
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono animado o estilizado
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1F1D2C),
                          border: Border.all(
                            color: const Color(0x4000F0FF),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3300F0FF),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFFF8C00),
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Título de bienvenida
                    const Text(
                      'Taller Firebase',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gestión de Universidades',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF00F0FF),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tarjeta Glassmorphic de instrucciones
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xAA1F1D2C),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white10,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, color: Color(0xFF7F00FF)),
                              SizedBox(width: 8),
                              Text(
                                'Guía de Configuración',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white12, height: 24),
                          _buildStep(
                            number: '1',
                            text: 'Crea un proyecto en Firebase Console.',
                          ),
                          _buildStep(
                            number: '2',
                            text: 'Registra la aplicación Android con el ID:\ncom.example.taller_firebase_universidades',
                          ),
                          _buildStep(
                            number: '3',
                            text: 'Descarga google-services.json y colócalo en:\ntaller_firebase_universidades/android/app/',
                          ),
                          _buildStep(
                            number: '4',
                            text: '¡Compila e inicia de nuevo tu aplicación!',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Botón neón para Modo Demo
                    GestureDetector(
                      onTap: () {
                        // Activar el modo demo
                        FirebaseService.useDemoMode = true;
                        
                        // Ir al listado
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UniversityListView(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7F00FF), Color(0xFF00F0FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x4400F0FF),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Activar Modo Demo en Memoria',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estado técnico descriptivo
                    Text(
                      error != null
                          ? 'Estado: Firebase sin conectar (compilado en modo standalone)\nDetalle: ${error.toString().split('\n').first}'
                          : 'Esperando inicialización de credenciales de Google Services...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white30,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required String number, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00F0FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x3300F0FF)),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF00F0FF),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
