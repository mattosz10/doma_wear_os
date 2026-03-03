import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart'; // Item 5
import 'dart:async';

void main() => runApp(const DomaApp());

class DomaApp extends StatelessWidget {
  const DomaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
      ),
      home: const DomaHomePage(),
    );
  }
}

class DomaHomePage extends StatefulWidget {
  const DomaHomePage({super.key});
  @override
  State<DomaHomePage> createState() => _DomaHomePageState();
}

class _DomaHomePageState extends State<DomaHomePage> {
  static const platform = MethodChannel('com.doma/audio');
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _segundos = 0;
  Timer? _timer;
  bool _rodando = false;
  String _statusAudio = "Hardware não checado";
  String _feedbackTreino = "DOMA FITNESS";

  @override
  void initState() {
    super.initState();
    // Item 3: Listener para atualizações automáticas do Android
    platform.setMethodCallHandler((call) async {
      if (call.method == "onAudioChanged") _verificarAudio();
      return null;
    });
  }

  // Item 5 & 6: Reprodução de Áudio e Feedback Educativo/Fitness
  Future<void> _tocarAlerta() async {
    try {
      setState(() => _feedbackTreino = "🔔 TROQUE O EXERCÍCIO!");
      await _audioPlayer.play(
        UrlSource(
          'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/pause.wav',
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _feedbackTreino = "DOMA FITNESS");
      });
    } catch (e) {
      debugPrint("Erro de áudio: $e");
    }
  }

  Future<void> _verificarAudio() async {
    try {
      final bool speaker = await platform.invokeMethod('checkAudioOutput', {
        'type': 2,
      });
      final bool bluetooth = await platform.invokeMethod('checkAudioOutput', {
        'type': 8,
      });
      setState(() {
        if (bluetooth)
          _statusAudio = "Bluetooth Conectado 🎧";
        else if (speaker)
          _statusAudio = "Alto-falante Ativo 🔊";
        else
          _statusAudio = "Sem saída de áudio";
      });
    } on PlatformException catch (e) {
      setState(() => _statusAudio = "Erro: ${e.message}");
    }
  }

  Future<void> _abrirBluetooth() async {
    try {
      await platform.invokeMethod('openBluetoothSettings');
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  void _toggleTimer() {
    if (_rodando) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          _segundos++;
          if (_segundos == 10) {
            HapticFeedback.vibrate(); // Vibração tátil
            _tocarAlerta(); // Item 6: Feedback auditivo
          }
        });
      });
    }
    setState(() => _rodando = !_rodando);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          // Resolve Overflow
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _feedbackTreino,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_segundos s',
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleTimer,
                    icon: Icon(
                      _rodando ? Icons.pause_circle : Icons.play_circle,
                      color: _rodando ? Colors.redAccent : Colors.greenAccent,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      _segundos = 0;
                      _timer?.cancel();
                      _rodando = false;
                    }),
                    icon: const Icon(Icons.refresh, color: Colors.white54),
                  ),
                ],
              ),

              const Divider(color: Colors.white10),

              Text(
                _statusAudio,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: _verificarAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                    ),
                    child: const Text("SCAN", style: TextStyle(fontSize: 8)),
                  ),
                  ElevatedButton(
                    onPressed: _abrirBluetooth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: const Icon(
                      Icons.bluetooth,
                      size: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
