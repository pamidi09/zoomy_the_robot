// lib/pages/control_page.dart
import 'package:flutter/material.dart';
import '../esp32_services.dart';

class ControlPage extends StatelessWidget {
  final String espIp;

  const ControlPage({super.key, required this.espIp});

  @override
  Widget build(BuildContext context) {
    final esp32 = ESP32Service(espIp);

    return Scaffold(
      backgroundColor: const Color(0xFF0D8BFF),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 👈 important
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/mic.png',
                          fit: BoxFit.contain,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Zoomy Voice Control",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ),

            // Main Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Direction Control Buttons
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Up Button
                        _controlButton(
                          Icons.keyboard_arrow_up,
                          top: 0,
                          onPress: () => esp32.moveForward(0.7),
                          onRelease: () => esp32.stop(),
                        ),
                        // Down Button
                        _controlButton(
                          Icons.keyboard_arrow_down,
                          bottom: 0,
                          onPress: () => esp32.moveForward(0.3),
                          onRelease: () => esp32.stop(),
                        ),
                        // Left Button
                        _controlButton(
                          Icons.keyboard_arrow_left,
                          left: 0,
                          onPress: () => esp32.turn(0.3),
                          onRelease: () => esp32.stop(),
                        ),
                        // Right Button
                        _controlButton(
                          Icons.keyboard_arrow_right,
                          right: 0,
                          onPress: () => esp32.turn(0.7),
                          onRelease: () => esp32.stop(),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Bottom Section
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),

                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                        'assets/footer_robot.png',
                        fit: BoxFit.contain,
                        height: 120,
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/Footer2.png',
                          fit: BoxFit.contain,
                          height: 36,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Control Button Widget
  static Widget _controlButton(
      IconData icon, {
        double? top,
        double? bottom,
        double? left,
        double? right,
        required VoidCallback onPress,
        required VoidCallback onRelease,
      }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTapDown: (_) => onPress(),
        onTapUp: (_) => onRelease(),
        onTapCancel: onRelease,
        child: Container(
          width: 75,
          height: 75,
          decoration: const BoxDecoration(
            color: Color(0xFF3A3A3A),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}