import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const CyberTaskerApp());
}

class CyberTaskerApp extends StatelessWidget {
  const CyberTaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEURAL LINK v2.0',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: Colors.cyan,
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Color(0xFFFF00FF),
          surface: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'monospace', color: Colors.cyan),
          headlineMedium: TextStyle(fontFamily: 'monospace', color: Colors.cyan, fontSize: 20),
          titleLarge: TextStyle(fontFamily: 'monospace', color: Colors.cyan),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.cyan,
            letterSpacing: 2,
            fontFamily: 'monospace',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}