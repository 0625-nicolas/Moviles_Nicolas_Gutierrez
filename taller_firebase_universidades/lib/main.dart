import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/firebase_setup_guide_view.dart';
import 'views/university_list_view.dart';

void main() async {
  // Asegurar la inicialización correcta de los bindings de Flutter antes del arranque asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  bool hasValidFirebase = false;
  Object? firebaseError;

  try {
    // 1. Intentar inicialización nativa automática (lee google-services.json directamente en Android)
    await Firebase.initializeApp();
    hasValidFirebase = true;
  } catch (e) {
    // 2. Si falla la nativa automática, intentar con opciones explícitas de la plataforma
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.apiKey.contains('Placeholder')) {
        // Son de plantilla/ficticias
        hasValidFirebase = false;
      } else {
        hasValidFirebase = true;
      }
    } catch (e2) {
      hasValidFirebase = false;
      firebaseError = e2;
    }
  }

  runApp(MyApp(
    hasValidFirebase: hasValidFirebase,
    error: firebaseError,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasValidFirebase;
  final Object? error;

  const MyApp({
    super.key,
    required this.hasValidFirebase,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Universidades',
      debugShowCheckedModeBanner: false,
      // Configuración del Tema Oscuro Premium (Obsidian Dark)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7F00FF), // Violeta vibrante
          brightness: Brightness.dark,
          primary: const Color(0xFF7F00FF),
          secondary: const Color(0xFF00F0FF), // Cyan neón
          background: const Color(0xFF0F0E17),
          surface: const Color(0xFF1E1B29),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0E17),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1E1B29),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      // Navegación condicional automática: si Firebase es válido va al CRUD, si no, a la guía
      home: hasValidFirebase ? const UniversityListView() : FirebaseSetupGuideView(error: error),
    );
  }
}
