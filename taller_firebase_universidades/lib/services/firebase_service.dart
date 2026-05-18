import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university.dart';

class FirebaseService {
  // Flag global para activar el modo de demostración en memoria local
  static bool useDemoMode = false;

  // Lista en memoria para el modo Demo
  static final List<University> _mockUniversities = [
    University(
      id: 'mock-1',
      nit: '890.123.456-7',
      nombre: 'Universidad Central del Valle (UCEVA)',
      direccion: 'Cra 27A #48-144, Tuluá - Valle',
      telefono: '+57 602 2242202',
      paginaWeb: 'https://www.uceva.edu.co',
    ),
    University(
      id: 'mock-2',
      nit: '890.399.010-3',
      nombre: 'Universidad del Valle (Univalle)',
      direccion: 'Calle 13 # 100-00, Cali - Valle',
      telefono: '+57 602 3212100',
      paginaWeb: 'https://www.univalle.edu.co',
    ),
    University(
      id: 'mock-3',
      nit: '899.999.063-3',
      nombre: 'Universidad Nacional de Colombia',
      direccion: 'Av. Cra 30 # 45-03, Bogotá',
      telefono: '+57 601 3165000',
      paginaWeb: 'https://unal.edu.co',
    ),
  ];

  // Controlador de Stream para difundir cambios en el modo demo
  static final StreamController<List<University>> _demoStreamController =
      StreamController<List<University>>.broadcast();

  // Instancia única del servicio (Singleton)
  static final FirebaseService instance = FirebaseService._internal();

  FirebaseService._internal() {
    // Inicializar el stream del modo demo con los datos base
    _publishDemoChanges();
  }

  // Colección principal en Firestore
  CollectionReference get _universitiesCollection =>
      FirebaseFirestore.instance.collection('universidades');

  /// Emite los cambios actuales en la lista en memoria al Stream del modo demo
  void _publishDemoChanges() {
    // Ordenar mock por nombre para mantener consistencia
    _mockUniversities.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
    _demoStreamController.add(List.from(_mockUniversities));
  }

  /// Obtiene el Stream de universidades en tiempo real.
  /// Escucha a Firestore en modo de producción, o al controlador local en modo demo.
  Stream<List<University>> getUniversitiesStream() {
    if (useDemoMode) {
      // Iniciar el stream emitiendo el estado actual
      Timer.run(() => _publishDemoChanges());
      return _demoStreamController.stream;
    } else {
      return _universitiesCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return University.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    }
  }

  /// Crea una nueva universidad.
  Future<void> addUniversity(University university) async {
    if (useDemoMode) {
      final newUni = university.copyWith(
        id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      );
      _mockUniversities.add(newUni);
      _publishDemoChanges();
    } else {
      await _universitiesCollection.add(university.toMap());
    }
  }

  /// Actualiza una universidad existente.
  Future<void> updateUniversity(University university) async {
    if (useDemoMode) {
      final index = _mockUniversities.indexWhere((element) => element.id == university.id);
      if (index != -1) {
        _mockUniversities[index] = university;
        _publishDemoChanges();
      }
    } else {
      await _universitiesCollection.doc(university.id).update(university.toMap());
    }
  }

  /// Elimina una universidad.
  Future<void> deleteUniversity(String id) async {
    if (useDemoMode) {
      _mockUniversities.removeWhere((element) => element.id == id);
      _publishDemoChanges();
    } else {
      await _universitiesCollection.doc(id).delete();
    }
  }
}
