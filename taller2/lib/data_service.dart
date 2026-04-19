import 'dart:async';

class DataService {
  Future<String> fetchData() async {
    print('--- [EJECUCIÓN] Antes de llamar al Future ---');

    try {
      print('--- [EJECUCIÓN] Durante: Consultando datos simulados... ---');
      await Future.delayed(const Duration(seconds: 2));

      if (DateTime.now().second % 2 == 0) {
        return 'CONEXIÓN EXITOSA: DATOS RECUPERADOS';
      } else {
        throw Exception('FALLO DE ENLACE: SEÑAL INTERCEPTADA');
      }
    } finally {
      print('--- [EJECUCIÓN] Después de completar el Future ---');
    }
  }
}