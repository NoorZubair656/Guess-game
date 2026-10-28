import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/back_circle_button.dart';
import '../widgets/gradient_background.dart';
import 'history_screen.dart';
import 'level_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;
    final w = size.width;
    final h = size.height;

    return GradientBackground(
      child: Stack(
        children: [
          // ---- Faded decoration in the background ----
          Positioned(
            left: w * 0.18,
            top: h * 0.13,
            child: const Icon(Icons.sports_esports,
                size: 160, color: Color(0x12FFFFFF)),
          ),
          Positioned(
            left: -40,
            top: h * 0.43,
            child: const Icon(Icons.sports_esports,
                size: 150, color: Color(0x0DFFFFFF)),
          ),
          Positioned(
            left: 22,
            top: h * 0.115,
            child: const Icon(Icons.casino_rounded,
                size: 52, color: Color(0x667C8DC4)),
          ),
          Positioned(
            right: w * 0.14,
            top: h * 0.27,
            child: const _Invader(),
          ),

          // ---- Back button (first screen, so it closes the app) ----
          Positioned(
            top: pad.top + 6,
            left: 12,
            child: BackCircleButton(onTap: () => SystemNavigator.pop()),
          ),

          // ---- Game controller card ----
          Positioned(
            right: w * 0.04,
            top: h * 0.147,
            child: _ControllerCard(width: w * 0.58),
          ),

          // ---- 1 2 4 ----
          Positioned(
            top: h * 0.345,
            left: 0,
            right: 0,
            child: const Text(
              '1  2  4',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Color(0x66000000),
                      blurRadius: 6,
                      offset: Offset(3, 4)),
                ],
              ),
            ),
          ),

          // ---- Title ----
          Positioned(
            left: w * 0.14,
            top: h * 0.555,
            child: const Text(
              'Guess',
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.w900,
                color: AppColors.faded,
                height: 1,
              ),
            ),
          ),
          Positioned(
            left: w * 0.045,
            top: h * 0.617,
            child: const Text(
              'Number',
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),

          // ---- Buttons ----
          Positioned(
            left: 50,
            right: 50,
            bottom: pad.bottom + 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  height: 50,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LevelScreen()),
                  ),
                  child: const Text(
                    'START TO PLAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  height: 50,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  child: const Text(
                    'HISTORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded game-controller card with a plus pad and two buttons.
class _ControllerCard extends StatelessWidget {
  final double width;
  const _ControllerCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xE67C8DC4),
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 14, offset: Offset(6, 8)),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 24,
            top: 22,
            child: Icon(
              Icons.add,
              size: 58,
              color: Color(0xFF0B3A7A),
              shadows: [
                Shadow(
                    color: Color(0x66000000),
                    blurRadius: 4,
                    offset: Offset(3, 3)),
              ],
            ),
          ),
          Positioned(
            right: 30,
            top: 24,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF0B3A7A),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 4,
                      offset: Offset(2, 3)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 72,
            bottom: 24,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 5,
                      offset: Offset(3, 4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small pixel-art space invader (faded).
class _Invader extends StatelessWidget {
  const _Invader();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(58, 42),
      painter: _InvaderPainter(),
    );
  }
}

class _InvaderPainter extends CustomPainter {
  static const List<String> _rows = [
    '00100000100',
    '00010001000',
    '00111111100',
    '01101110110',
    '11111111111',
    '10111111101',
    '10100000101',
    '00011011000',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 11;
    final paint = Paint()..color = const Color(0x597C8DC4);
    for (var y = 0; y < _rows.length; y++) {
      for (var x = 0; x < _rows[y].length; x++) {
        if (_rows[y][x] == '1') {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
