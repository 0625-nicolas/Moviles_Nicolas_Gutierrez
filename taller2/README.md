# Taller 3: Segundo Plano, Asincronía y Servicios en Flutter

Este repositorio contiene la implementación del Taller 3, enfocado en el manejo avanzado de procesos asíncronos, control del tiempo en el hilo principal y procesamiento paralelo mediante Isolates en Flutter.

## Descripción General

La aplicación está dividida en tres módulos principales, cada uno diseñado para demostrar un patrón específico de manejo de concurrencia y asincronía, garantizando siempre la fluidez de la Interfaz de Usuario (UI) y evitando bloqueos (*jank*).

---

## Conceptos Core: ¿Cuándo usar cada herramienta?

### 1. `Future` y `async / await` (Asincronía I/O)
* **Cuándo usarlo:** Cuando la aplicación necesita **esperar** a que termine una operación externa, pero el procesador del dispositivo no está haciendo un trabajo intensivo.
* **Casos de uso en el taller:** Simulación de consulta a un servicio externo y recuperación de datos (Data Stream).
* **Objetivo:** Informar a Flutter que debe esperar la resolución de los datos mientras continúa renderizando la interfaz.

### 2. `Timer` (Eventos basados en tiempo)
* **Cuándo usarlo:** Cuando se requiere ejecutar código después de un retraso o en intervalos regulares, operando dentro del **hilo principal** (Main Thread).
* **Casos de uso en el taller:** Implementación del módulo Chronos Core (Cronómetro digital).
* **Objetivo:** Actualizar el estado de la UI cíclicamente sin perder el registro de los datos al pausar o reanudar.

### 3. `Isolate` (Procesamiento Paralelo Real)
* **Cuándo usarlo:** Para tareas de cómputo matemático o de procesamiento tan pesadas que, de ejecutarse en el hilo principal, congelarían la pantalla por completo.
* **Casos de uso en el taller:** Módulo Heavy Computing, ejecutando una suma matemática masiva.
* **Objetivo:** Levantar un hilo de memoria y procesamiento totalmente independiente, procesar en segundo plano y devolver el resultado sin afectar los *frames* de la aplicación.

---

## Flujos y Transiciones de Pantalla

A continuación, se detalla el comportamiento de la Interfaz de Usuario para cada módulo de la aplicación.

### Flujo A: Módulo de Datos (Future)
1. **Pantalla Inicial:** Panel de conexión en reposo. Botón "Establecer Vínculo" disponible.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/b27f6542-d2c6-415a-8aa1-a0747acf33f6" />

2. **Transición (Estado de Espera):** Al interactuar, la UI muestra un indicador circular con el texto **"CARGANDO..."**. La app no se bloquea.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/c8bca9ea-64bf-435d-b26c-c455868ae254" />

3. **Resolución:**
   * **Éxito:** Muestra "ÉXITO: CONEXIÓN EXITOSA: DATOS RECUPERADOS".
   <img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/bfac9cc3-9bc2-43ce-8a4b-430c7bf8b8b9" />

   * **Fallo:** Muestra "ERROR: Exception: FALLO DE ENLACE: SEÑAL INTERCEPTADA".
   <img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/b8f45e31-5715-40b6-8985-690da4d386c0" />


### Flujo B: Módulo Chronos Core (Timer)
1. **Pantalla Inicial:** Contador en `00:00`. Estado en reposo con el botón **Iniciar** disponible.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/c44af4b3-5cd3-415c-a10a-7f59f1e5d0a4" />

2. **Estado de Ejecución:** Se activa el `Timer`. El texto se actualiza por segundo (ej. `00:01`, `00:15`). Aparecen los controles "Pausar" y "Reiniciar".
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/a7b747f0-c526-4c19-83f7-3afd7e006b37" />
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/6734cd3b-05cb-4b23-9c36-45f340e1b184" />

3. **Estado Pausado:** El cronómetro se detiene reteniendo el valor en pantalla. El botón principal cambia a **Reanudar**.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/95b18d17-7a62-4e27-8046-2d44e82006ff" />

4. **Reinicio:** Los valores caen a `00:00` y el módulo vuelve al estado de la Pantalla Inicial.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/c44af4b3-5cd3-415c-a10a-7f59f1e5d0a4" />

### Flujo C: Módulo Heavy Computing (Isolate)
1. **Pantalla Inicial:** Esperando la orden de procesar. Botón "Spawn Isolate" visible.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/4c3ee7aa-0c79-4895-b7b7-a3be6ce3ae5d" />

2. **Transición (Procesamiento):** El hilo principal envía el trabajo de cómputo al Isolate. La pantalla sigue fluida y respondiendo a interacciones.
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/178b5f14-e2d2-4d90-a3fa-06ae40e82bc5" />

3. **Resolución:** El cálculo finaliza y la UI se actualiza de inmediato con el resultado masivo (ej. `31249999875000000`).
<img width="610" height="1356" alt="imagen" src="https://github.com/user-attachments/assets/51dbaf1d-e6ef-4ffe-870f-d39e570145fe" />

---

## 🛠 Entorno y GitFlow

El desarrollo de esta funcionalidad se llevó a cabo de manera aislada utilizando las mejores prácticas de control de versiones:
* **Rama de desarrollo:** `feature/taller2`
* **Integración:** Volcado a la rama `dev` para asegurar la herencia del código base estable.
