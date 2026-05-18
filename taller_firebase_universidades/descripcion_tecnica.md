# Descripción Técnica: Taller Firebase - Gestión de Universidades

Este documento contiene la descripción técnica detallada del desarrollo realizado para el módulo de Gestión de Universidades, cumpliendo estrictamente con los requisitos del taller, el aislamiento de carpetas y los estándares de control de versiones (GitFlow).

---

## 1. Arquitectura del Software

La aplicación móvil está construida sobre **Flutter & Dart** utilizando un patrón de diseño desacoplado similar a **MVVM (Model-View-ViewModel / Service)**. Este enfoque garantiza la separación de responsabilidades, alta mantenibilidad, modularidad y facilidad de testing.

### Estructura de Directorios (Aislada)
Toda la lógica y componentes del taller se alojan dentro de `taller_firebase_universidades/lib/`:
```text
lib/
├── models/
│   └── university.dart               # Modelo de datos y serialización JSON/Map
├── services/
│   └── firebase_service.dart         # Lógica de negocio y servicio de datos reactivo (Dual)
├── views/
│   ├── firebase_setup_guide_view.dart # Pantalla explicativa y conector de Modo Demo
│   ├── university_form_view.dart     # Formulario de registro/edición con validaciones
│   └── university_list_view.dart     # Panel de listado interactivo con barra de búsqueda
├── widgets/
│   └── university_card.dart          # Tarjeta de renderizado visual glassmorphic
├── firebase_options.dart             # Opciones de compilación por defecto de Firebase
└── main.dart                         # Punto de entrada, bootstrap e inicialización segura
```

### Componentes de la Arquitectura
1. **Modelo (`lib/models/university.dart`)**:
   * Clase `University` fuertemente tipada.
   * Serialización de mapas bidireccional mediante los constructores `fromMap(Map<String, dynamic> map, String id)` y `toMap()`, garantizando compatibilidad total con documentos de Firestore.
   * Implementa el método `copyWith` para clonación segura y mutable de estados locales.
2. **Servicio Reactivo Dual (`lib/services/firebase_service.dart`)**:
   * Implementado como un patrón **Singleton** (`FirebaseService.instance`) para centralizar el acceso a la persistencia.
   * **Arquitectura Dual**: Si la conexión con Firebase es válida, las consultas y mutaciones (CRUD) se ejecutan directamente sobre la colección `universidades` en **Cloud Firestore**. Si no hay conexión o archivo de configuración, se activa de forma transparente el **Modo Demo en Memoria Local** utilizando un `StreamController.broadcast` reactivo.
3. **Vistas e Interfaz (`lib/views/` & `lib/widgets/`)**:
   * **Declarativa y Reactiva**: La UI se auto-actualiza en tiempo real consumiendo los flujos asíncronos (`Stream<List<University>>`) mediante un componente `StreamBuilder`.
   * **Widgets Reutilizables**: Encapsulación de la tarjeta de presentación (`UniversityCard`) para evitar renderizados redundantes y simplificar el código de la vista principal.

---

## 2. Estado de la Aplicación

La aplicación se encuentra en un estado **100% Funcional y Verificado**:

* **Compilación Android Exitosa**: El Gradle configurado en Kotlin DSL (`.gradle.kts`) compila de forma nativa sin errores (salida de compilación exitosa del APK de depuración).
* **Integración de Firebase Completa**: Los plugins oficiales de Firebase Core y Cloud Firestore se encuentran aplicados e inicializados de manera asíncrona y robusta en `main.dart` mediante un bloque de captura tolerante a fallos (`try-catch`).
* **Bootstrap Inteligente**: La aplicación implementa detección dinámica de configuración:
  * Si detecta el archivo `google-services.json` configurado correctamente, salta directamente al panel del CRUD conectado a Firestore.
  * Si no detecta configuración válida, redirige de forma amigable a la pantalla guía, permitiendo al evaluador activar el **Modo Demo** local con un solo clic.
* **Barra de Búsqueda Reactiva**: Implementa filtrado dinámico en tiempo real sobre el `StreamBuilder` basado en coincidencias parciales del Nombre, NIT o Dirección de la universidad, ofreciendo una experiencia de búsqueda instantánea.
* **Redireccionamiento Seguro**: Integración del paquete `url_launcher` con consultas seguras de esquema en `AndroidManifest.xml` para abrir el navegador web del dispositivo móvil al presionar el enlace de la universidad.

---

## 3. Validaciones de Formulario Estrictas

El formulario de registro y edición (`lib/views/university_form_view.dart`) implementa una capa robusta de validaciones sobre un `GlobalKey<FormState>`, proporcionando retroalimentación visual inmediata en color rojo neón ante cualquier error:

| Campo | Regla de Validación / Restricción técnica | Razón y Comportamiento |
| :--- | :--- | :--- |
| **NIT** | Obligatorio. Longitud mínima de 5 caracteres tras remover espacios. | Previene registros con códigos de identificación vacíos o incompletos. |
| **Nombre** | Obligatorio. No puede estar vacío ni contener solo espacios en blanco. | Identificación única y obligatoria para la universidad. |
| **Dirección** | Obligatorio. No puede estar vacío. | Garantiza la geolocalización o dirección física del establecimiento. |
| **Teléfono** | Obligatorio. Debe contener un número telefónico válido (mínimo 7 dígitos numéricos). | Se remueven caracteres no numéricos durante el análisis para verificar que la longitud del número base sea consistente. |
| **Página Web (URL)**| Obligatorio. Debe cumplir estrictamente la expresión regular (`RegExp`) de URL e **iniciar de forma obligatoria con `http://` o `https://`**. | Asegura que el enlace sea una URL absoluta ejecutable por `url_launcher` para evitar fallos de redirección del navegador. |

### Expresión Regular para URL (Página Web):
```dart
final urlPattern = RegExp(
  r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  caseSensitive: false,
);
```

---

## 4. Tecnologías y Librerías Utilizadas

* **Flutter SDK / Dart**: Entorno de desarrollo multiplataforma.
* **Firebase Core (`firebase_core: ^3.0.0`)**: Inicialización y enlace con la consola de Firebase.
* **Cloud Firestore (`cloud_firestore: ^5.0.0`)**: Persistencia NoSQL reactiva en la nube.
* **URL Launcher (`url_launcher: ^6.2.5`)**: Integración con intents nativos del sistema móvil para abrir URLs externas.
* **Material 3 (Tema Obsidian Dark)**: Diseño de interfaces premium con colores oscuros obsidianos (`#0F0E17`), violeta neón (`#7F00FF`) y acentos de cyan eléctrico (`#00F0FF`).
