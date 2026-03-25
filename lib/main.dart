import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // 🔹 Estado (esto es lo importante del taller)
  String titulo = "Hola, Flutter";

  // 🔹 Función que usa setState()
  void cambiarTitulo() {
    setState(() {
      titulo = (titulo == "Hola, Flutter")
          ? "¡Título cambiado!"
          : "Hola, Flutter";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Título actualizado"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔹 Nombre
            const Text(
              "Nicolas Gutierrez", // cambia si quieres
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 🔹 Imágenes
            Image.asset(
              "assets/kratos.png",
              height: 80,
            ),

            const SizedBox(height: 20),

            /// 🔹 Botón con setState
            ElevatedButton(
              onPressed: cambiarTitulo,
              child: const Text("Cambiar título"),
            ),

            const SizedBox(height: 20),

            /// 🔹 Widget adicional 1: Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Kratos The best"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Mejores personajes de los videojuegos de la historia",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            /// 🔹 Widget adicional 2: ListView
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.sports_martial_arts),
                    title: Text("Kratos"),
                  ),
                  ListTile(
                    leading: Icon(Icons.games),
                    title: Text("Arthur Morgan"),
                  ),
                  ListTile(
                    leading: Icon(Icons.shield),
                    title: Text("Leon S. Kennedy"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}