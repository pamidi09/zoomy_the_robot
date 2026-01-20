import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../esp32_services.dart';

class ControlPage extends StatefulWidget {
  final String espIp;

  const ControlPage({super.key, required this.espIp});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late ESP32Service esp32;
  late stt.SpeechToText _speech;
  late FlutterTts _tts;

  bool _isListening = false;
  String _spokenText = "";
  String _activeButton = "";

  Timer? _autoStopTimer;

  @override
  void initState() {
    super.initState();
    esp32 = ESP32Service(widget.espIp);
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
  }

  // ================= VOICE CONTROL =================

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords.toLowerCase();
          });
          _handleVoiceCommand(_spokenText);
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    _cancelAutoStop();
    setState(() => _isListening = false);
  }

  // ================= AUTO STOP =================

  void _resetAutoStop() {
    _cancelAutoStop();
    _autoStopTimer = Timer(const Duration(seconds: 2), () {
      _stopRobot();
    });
  }

  void _cancelAutoStop() {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
  }

  // ================= TEXT TO SPEECH =================

  Future<void> _speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  // ================= COMMON COMMAND FUNCTIONS =================

  void _moveForward() {
    esp32.moveForward(0.7);
    _speak("Moving forward");
    _resetAutoStop();
    setState(() {
      _spokenText = "Moving forward";
    });
  }

  void _moveBackward() {
    esp32.moveBackward(0.7);
    _speak("Moving backward");
    _resetAutoStop();
    setState(() {
      _spokenText = "Moving backward";
    });
  }

  void _turnLeft() {
    esp32.turnLeft();
    _speak("Turning left");
    _resetAutoStop();
  }

  void _turnRight() {
    esp32.turnRight();
    _speak("Turning right");
    _resetAutoStop();
  }

  void _stopRobot() {
    esp32.stop();
    _speak("Robot stopped");
    _cancelAutoStop();
    setState(() {
      _activeButton = "";
      _spokenText = "Robot stopped";
    });
  }

  // ================= VOICE COMMAND HANDLER =================

  void _handleVoiceCommand(String command) {
    print("VOICE: $command");

    if (command.contains("forward") || command.contains("ඉදිරියට")) {
      _moveForward();
    } else if (command.contains("back") || command.contains("පසුපසට")) {
      _moveBackward();
    } else if (command.contains("left") || command.contains("වම")) {
      _turnLeft();
    } else if (command.contains("right") || command.contains("දකුණ")) {
      _turnRight();
    } else if (command.contains("stop") || command.contains("නවත්වන්න")) {
      _stopRobot();
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D8BFF),
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR WITH MIC =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: _isListening ? Colors.red : const Color(0xFF0D8BFF),
                          child: Icon(
                            _isListening ? Icons.mic_off : Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Zoomy Voice Control",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== SPOKEN TEXT =====
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _spokenText.isEmpty
                    ? "Say: forward / ඉදිරියට"
                    : "You said: $_spokenText",
              ),
            ),

            const SizedBox(height: 30),

            // ===== DIRECTION BUTTONS =====
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _controlButton(
                      Icons.keyboard_arrow_up,
                      id: "forward",
                      onPress: _moveForward,
                      onRelease: _stopRobot,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _controlButton(
                          Icons.keyboard_arrow_left,
                          id: "left",
                          onPress: _turnLeft,
                          onRelease: _stopRobot,
                        ),
                        const SizedBox(width: 50),
                        _controlButton(
                          Icons.keyboard_arrow_right,
                          id: "right",
                          onPress: _turnRight,
                          onRelease: _stopRobot,
                        ),
                      ],
                    ),
                    _controlButton(
                      Icons.keyboard_arrow_down,
                      id: "backward",
                      onPress: _moveBackward,
                      onRelease: _stopRobot,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/footer_robot.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/Footer2.png',
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== BUTTON WITH VISUAL FEEDBACK =====
  Widget _controlButton(
      IconData icon, {
        required String id,
        required VoidCallback onPress,
        required VoidCallback onRelease,
      }) {
    final bool isPressed = _activeButton == id;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _activeButton = id);
        onPress();
      },
      onTapUp: (_) {
        setState(() => _activeButton = "");
        onRelease();
      },
      onTapCancel: () {
        setState(() => _activeButton = "");
        onRelease();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: isPressed ? Colors.orange : const Color(0xFF2B2B2B),
          shape: BoxShape.circle,
          boxShadow: isPressed
              ? []
              : const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 38),
      ),
    );
  }
}
