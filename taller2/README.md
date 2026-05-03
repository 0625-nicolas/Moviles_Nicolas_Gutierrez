# Taller 2: Firebase App Distribution

Este proyecto demuestra el flujo de distribución de aplicaciones Flutter utilizando **Firebase App Distribution**.

## Flujo de Trabajo

1.  **Generar APK**: Se configuró el archivo `AndroidManifest.xml` con los permisos necesarios (INTERNET) y se generó el build de release mediante `flutter build apk --release`.
2.  **Configuración en Firebase**:
    *   Se creó un proyecto en Firebase Console.
    *   Se registró la aplicación Android con el Application ID: `com.example.taller1_flutter`.
3.  **App Distribution**:
    *   Se creó el grupo de testers `QA_Clase`.
    *   Se agregó al tester: `dduran@uceva.edu.co`.
4.  **Distribución**:
    *   Se subió el APK inicial (v1.0.0+1).
    *   Se incluyeron Release Notes descriptivas.
5.  **Instalación y Pruebas**:
    *   El tester recibió la invitación y procedió con la instalación en un dispositivo físico.
6.  **Actualización**:
    *   Se incrementó la versión en `pubspec.yaml` (v1.0.1+2).
    *   Se generó un nuevo APK y se distribuyó nuevamente para validar el flujo de actualización.

## Publicación

Para replicar este proceso en el equipo:
1. Ejecutar `flutter build apk --release`.
2. Acceder a [Firebase Console](https://console.firebase.google.com/).
3. Ir a **App Distribution** y arrastrar el archivo `build/app/outputs/flutter-apk/app-release.apk`.
4. Seleccionar el grupo de testers y añadir las notas de la versión.
5. Notificar a los testers.

## Notas sobre Versionado

*   **Formato**: `version: 1.0.0+1` (VersionName+VersionCode).
*   **Incremento**: Para actualizaciones, se debe cambiar tanto el nombre como el código (ej. `1.0.1+2`).

## Evidencias

Las capturas de pantalla y la bitácora detallada se encuentran en el archivo [Evidencias_Taller2.pdf](./Evidencias_Taller2.pdf) (generado a partir de la documentación).
