// Archivo de configuración de Firebase por defecto para la aplicación.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opciones de Firebase por defecto que sirven como base para compilar e iniciar la app.
/// Si ejecutas la herramienta `flutterfire configure`, este archivo se sobrescribirá
/// automáticamente con tus credenciales reales de la consola de Firebase.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están soportadas para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderApiKeyForWeb12345',
    appId: '1:1234567890:web:abcdef1234567890',
    messagingSenderId: '1234567890',
    projectId: 'taller-firebase-universidades',
    authDomain: 'taller-firebase-universidades.firebaseapp.com',
    storageBucket: 'taller-firebase-universidades.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderApiKeyForAndroid12345',
    appId: '1:1234567890:android:abcdef1234567890',
    messagingSenderId: '1234567890',
    projectId: 'taller-firebase-universidades',
    storageBucket: 'taller-firebase-universidades.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderApiKeyForIos12345',
    appId: '1:1234567890:ios:abcdef1234567890',
    messagingSenderId: '1234567890',
    projectId: 'taller-firebase-universidades',
    storageBucket: 'taller-firebase-universidades.appspot.com',
    iosBundleId: 'com.example.tallerFirebaseUniversidades',
  );
}
