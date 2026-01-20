// lib/esp32_services.dart
import 'package:http/http.dart' as http;

class ESP32Service {
  final String espIp;
  ESP32Service(this.espIp);

  // Internal helper to control both motors together
  Future<void> _send(double fader1, double fader2) async {
    final url = Uri.parse(
      'http://$espIp/?fader1=$fader1&fader2=$fader2',
    );
    await http.get(url);
  }

  // Forward
  Future<void> moveForward(double speed) async {
    await _send(speed, 0.5);
  }

  // Backward
  Future<void> moveBackward(double speed) async {
    await _send(1 - speed, 0.5);
  }

  // Turn left
  Future<void> turnLeft() async {
    await _send(0.5, 0.3);
  }

  // Turn right
  Future<void> turnRight() async {
    await _send(0.5, 0.7);
  }

  // Stop robot
  Future<void> stop() async {
    await _send(0.5, 0.5);
  }
}
