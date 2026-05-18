// Pruebas básicas de widget para la aplicación Taller Firebase Universidades.
import 'package:flutter_test/flutter_test.dart';
import 'package:taller_firebase_universidades/main.dart';

void main() {
  testWidgets('Prueba de humo para la Pantalla de Guía de Firebase', (WidgetTester tester) async {
    // Construir la aplicación en modo fallback (sin inicialización activa de Firebase)
    await tester.pumpWidget(const MyApp(hasValidFirebase: false));

    // Verificar que el título y la descripción del taller se rendericen correctamente
    expect(find.text('Taller Firebase'), findsOneWidget);
    expect(find.text('Gestión de Universidades'), findsOneWidget);
  });
}
