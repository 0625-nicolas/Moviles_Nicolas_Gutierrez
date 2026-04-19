import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

import 'data_service.dart';
import 'timer_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final TimerController _timerController = TimerController();

  // Estados para el Future
  String _futureStatus = 'SISTEMA LISTO';
  Color _futureColor = Colors.cyan;
  bool _isFetching = false;

  // Estados para el Timer
  bool _timerPaused = false;
  int _selectedIndex = 0;

  // Estados para el Isolate
  String _isolateStatus = 'NÚCLEO EN ESPERA';
  Color _isolateColor = Colors.cyan;
  bool _isComputing = false;
  ReceivePort? _receivePort;
  Isolate? _worker;
  StreamSubscription? _isolateSubscription;

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _onTimerTick() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startTimer() {
    setState(() {
      _timerController.start(_onTimerTick);
      _timerPaused = false;
    });
  }

  void _pauseTimer() {
    setState(() {
      _timerController.pause();
      _timerPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      _timerController.start(_onTimerTick);
      _timerPaused = false;
    });
  }

  void _resetTimer() {
    _timerController.reset(() {
      if (mounted) {
        setState(() {
          _timerPaused = false;
        });
      }
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _futureTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cyberCard('DATA STREAM (FUTURE)', [
            if (_isFetching) const CircularProgressIndicator(color: Color(0xFFFF00FF)),
            const SizedBox(height: 12),
            Text(
              _futureStatus,
              style: TextStyle(color: _futureColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _cyberButton('ESTABLECER VÍNCULO', const Color(0xFF00FFFF), () async {
              setState(() {
                _isFetching = true;
                _futureStatus = 'CARGANDO...';
                _futureColor = Colors.yellow;
              });

              try {
                final String res = await _dataService.fetchData();
                setState(() {
                  _futureStatus = 'ÉXITO: $res';
                  _futureColor = Colors.greenAccent;
                });
              } catch (error) {
                setState(() {
                  _futureStatus = 'ERROR: $error';
                  _futureColor = Colors.redAccent;
                });
              } finally {
                setState(() => _isFetching = false);
              }
            }),
          ]),
        ],
      ),
    );
  }

  Widget _timerTab() {
    final bool timerRunning = _timerController.isRunning;
    final String timerLabel = timerRunning ? 'PAUSAR' : (_timerPaused ? 'REANUDAR' : 'INICIAR');
    final Color timerColor = timerRunning ? Colors.orange : Colors.green;
    final VoidCallback timerAction = timerRunning ? _pauseTimer : (_timerPaused ? _resumeTimer : _startTimer);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cyberCard('CHRONOS CORE (TIMER)', [
            Text(
              _formatTime(_timerController.seconds),
              style: const TextStyle(fontSize: 72, color: Color(0xFFFF00FF), fontFamily: 'monospace'),
            ),
            const SizedBox(height: 8),
            Text(
              timerRunning ? 'EN EJECUCIÓN' : (_timerPaused ? 'PAUSADO' : 'LISTO PARA ARRANCAR'),
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _miniButton(timerLabel, timerColor, timerAction),
                _miniButton('REINICIAR', Colors.red, _resetTimer),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _isolateTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cyberCard('HEAVY COMPUTING (ISOLATE)', [
            Text(
              _isolateStatus,
              style: TextStyle(color: _isolateColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _isComputing
                ? const LinearProgressIndicator(color: Color(0xFFFF00FF))
                : _cyberButton('SPAWN ISOLATE', const Color(0xFFFF00FF), _runIsolate),
          ]),
        ],
      ),
    );
  }

  // --- LÓGICA ISOLATE ---
  static void _heavyTask(SendPort sendPort) {
    print('--- [ISOLATE] Antes de iniciar la tarea pesada ---');
    try {
      print('--- [ISOLATE] Durante: sumando valores en el núcleo ---');
      int sum = 0;
      for (int i = 0; i < 250000000; i++) {
        sum += i;
      }
      sendPort.send({'result': sum});
      print('--- [ISOLATE] Después: tarea pesada completada ---');
    } catch (error) {
      sendPort.send({'error': error.toString()});
    }
  }

  Future<void> _runIsolate() async {
    if (_isComputing) return;

    setState(() {
      _isComputing = true;
      _isolateStatus = 'CARGANDO IA...';
      _isolateColor = Colors.yellow;
    });

    _receivePort?.close();
    _isolateSubscription?.cancel();

    _receivePort = ReceivePort();
    _isolateSubscription = _receivePort!.listen((message) {
      if (!mounted) return;

      if (message is Map && message.containsKey('error')) {
        setState(() {
          _isolateStatus = 'ERROR: ${message['error']}';
          _isolateColor = Colors.redAccent;
          _isComputing = false;
        });
      } else if (message is Map && message.containsKey('result')) {
        setState(() {
          _isolateStatus = 'ÉXITO: RESULTADO ${message['result']}';
          _isolateColor = Colors.greenAccent;
          _isComputing = false;
        });
      }

      _receivePort?.close();
      _receivePort = null;
      _isolateSubscription?.cancel();
      _isolateSubscription = null;
    });

    try {
      _worker = await Isolate.spawn(_heavyTask, _receivePort!.sendPort);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isolateStatus = 'ERROR: $error';
        _isolateColor = Colors.redAccent;
        _isComputing = false;
      });
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    _receivePort?.close();
    _isolateSubscription?.cancel();
    _worker?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('NEURAL LINK v2.0', style: TextStyle(color: Colors.cyan, letterSpacing: 2)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'CYBERPUNK 2077 - SISTEMA NEXUS',
              style: const TextStyle(color: Color.fromRGBO(255, 0, 255, 0.8), fontFamily: 'monospace', fontSize: 12, letterSpacing: 1.5),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF02010A), Color(0xFF09001E), Color(0xFF05050D)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _futureTab(),
              _timerTab(),
              _isolateTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF05030A),
          border: Border(top: BorderSide(color: Color.fromRGBO(255, 0, 255, 0.25), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFFF00FF),
          unselectedItemColor: Colors.cyanAccent,
          showUnselectedLabels: true,
          onTap: _onNavTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_queue),
              label: 'FUTURE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'TIMER',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.memory),
              label: 'ISOLATE',
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS DE DISEÑO CYBERPUNK
  Widget _cyberCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyan, width: 1.5),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 255, 255, 0.3), blurRadius: 8)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.cyan, fontSize: 13, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.cyan),
          ...children,
        ],
      ),
    );
  }

  Widget _cyberButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color, fontFamily: 'monospace')),
    );
  }

  Widget _miniButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color.withAlpha(26),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontFamily: 'monospace')),
    );
  }
}
