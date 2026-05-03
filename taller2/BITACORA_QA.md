# Bitácora de QA - Taller 2

**Proyecto:** taller2 (Firebase App Distribution)
**Fecha:** 2026-05-03

| Versión | Fecha | Cambios Realizados | Incidencias Encontradas | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 1.0.0+1 | 2026-05-03 | Build inicial con permisos de internet. | El build falló inicialmente por falta de configuración de firma (signing). Se procedió a usar la configuración de debug para la prueba. | Resuelto |
| 1.0.0+1 | 2026-05-03 | Distribución en Firebase App Distribution. | Ninguna. | Exitoso |
| 1.0.1+2 | 2026-05-03 | Incremento de versión y nueva distribución. | El tester no recibió el correo inmediatamente (retraso de 2 minutos). | Resuelto (Espera) |

## Resumen de Pruebas
1. **Instalación Inicial**: Se validó que el tester `dduran@uceva.edu.co` recibió el correo y pudo instalar la app mediante el enlace de Firebase.
2. **Ejecución**: La app abre correctamente en el dispositivo físico sin errores de permisos.
3. **Flujo de Actualización**: Se notificó al tester de la versión 1.0.1+2 y se verificó que la actualización se aplicó correctamente sobre la versión anterior.
