import 'package:http/http.dart' as http;

class ESP32Service {
  final String espIp;

  ESP32Service(this.espIp);

  // Forward / Backward
  Future<void> moveForward(double value) async {
    final url = Uri.parse('http://$espIp/?fader1=$value');
    await http.get(url);
  }

  // Left / Right
  Future<void> turn(double value) async {
    final url = Uri.parse('http://$espIp/?fader2=$value');
    await http.get(url);
  }

  // Stop robot
  Future<void> stop() async {
    final url = Uri.parse('http://$espIp/?fader1=0.5&fader2=0.5');
    await http.get(url);
  }
}
