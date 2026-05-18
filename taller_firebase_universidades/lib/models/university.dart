// Modelo de datos para representar una Universidad en la aplicación.
class University {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  University({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  // Crea una instancia de University a partir de un mapa de Firestore
  factory University.fromMap(Map<String, dynamic> map, String documentId) {
    return University(
      id: documentId,
      nit: map['nit']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      direccion: map['direccion']?.toString() ?? '',
      telefono: map['telefono']?.toString() ?? '',
      paginaWeb: map['pagina_web']?.toString() ?? '',
    );
  }

  // Convierte la instancia de University a un mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }

  // Permite copiar un objeto modificando algunos de sus campos
  University copyWith({
    String? id,
    String? nit,
    String? nombre,
    String? direccion,
    String? telefono,
    String? paginaWeb,
  }) {
    return University(
      id: id ?? this.id,
      nit: nit ?? this.nit,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      paginaWeb: paginaWeb ?? this.paginaWeb,
    );
  }
}
