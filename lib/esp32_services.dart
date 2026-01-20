// lib/esp32_services.dart
import 'package:http/http.dart' as http;

class ESP32Service {
  final String espIp;
  ESP32Service(this.espIp);

  Future<void> _send(double left, double right) async {
    final url = Uri.parse(
      'http://$espIp/?left=$left&right=$right',
    );
    await http.get(url);
  }

  // Forward
  Future<void> moveForward(double speed) async {
    await _send(speed, speed);
  }

  // Backward
  Future<void> moveBackward(double speed) async {
    await _send(1 - speed, 1 - speed);
  }

  // Turn left
  Future<void> turnLeft() async {
    await _send(0.3, 0.7);
  }

  // Turn right
  Future<void> turnRight() async {
    await _send(0.7, 0.3);
  }

  // Stop
  Future<void> stop() async {
    await _send(0.5, 0.5);
  }
}
