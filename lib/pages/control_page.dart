// lib/pages/control_page.dart
import 'package:flutter/material.dart';
import '../esp32_services.dart'; // Correct import path

class ControlPage extends StatelessWidget {
  final String espIp;

  const ControlPage({super.key, required this.espIp});

  @override
  Widget build(BuildContext context) {
    final esp32 = ESP32Service(espIp);

    return Scaffold(
      backgroundColor: const Color(0xFF0D8BFF), // Blue background
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF0D8BFF),
                      child: Image.asset(
                        'assets/small_robot_icon.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Esp32 Self-Balancing Robot",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Main content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // 🔹 Direction Buttons
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _controlButton(
                              Icons.keyboard_arrow_up,
                              top: 0,
                              onPress: () => esp32.moveForward(0.7),
                              onRelease: () => esp32.stop(),
                            ),
                            _controlButton(
                              Icons.keyboard_arrow_down,
                              bottom: 0,
                              onPress: () => esp32.moveForward(0.3),
                              onRelease: () => esp32.stop(),
                            ),
                            _controlButton(
                              Icons.keyboard_arrow_left,
                              left: 0,
                              onPress: () => esp32.turn(0.3),
                              onRelease: () => esp32.stop(),
                            ),
                            _controlButton(
                              Icons.keyboard_arrow_right,
                              right: 0,
                              onPress: () => esp32.turn(0.7),
                              onRelease: () => esp32.stop(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Footer section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          // Robots Image (optional)
                          // const SizedBox(height: 8),

                          // University Logo
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: Image.asset(
                              'assets/startupPage_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Direction Button Widget
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
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF2B2B2B),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 36),
        ),
      ),
    );
  }
}
