import 'dart:async';

typedef TimerTick = void Function();

class TimerController {
  Timer? _timer;
  int seconds = 0;

  bool get isRunning => _timer != null && _timer!.isActive;

  void start(TimerTick onTick) {
    if (isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds++;
      onTick();
    });
    print('--- [TIMER] Iniciar/Reanudar ---');
  }

  void pause() {
    if (!isRunning) return;
    _timer?.cancel();
    _timer = null;
    print('--- [TIMER] Pausado ---');
  }

  void reset(TimerTick onReset) {
    _timer?.cancel();
    _timer = null;
    seconds = 0;
    onReset();
    print('--- [TIMER] Reiniciado ---');
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    print('--- [TIMER] Dispose: recursos liberados ---');
  }
}