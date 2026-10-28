import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../logic/game_logic.dart';
import '../widgets/back_circle_button.dart';
import '../widgets/dice_picture.dart';
import '../widgets/gradient_background.dart';
import 'game_screen.dart';

/// Put your dice logo at this path (and list it in pubspec.yaml).
/// If the file is missing, a drawn dice picture is shown instead.
const String kDiceImage = 'assets/images/dice.png';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final diceWidth = (width * 0.62).clamp(160.0, 300.0);

    return GradientBackground(
      child: SafeArea(
        child: Stack(
          children: [
            // Faded game icons in the background (like the design)
            const Positioned(
              left: 18,
              top: 150,
              child: Icon(Icons.sports_esports,
                  size: 150, color: Color(0x14FFFFFF)),
            ),
            const Positioned(
              right: 14,
              top: 250,
              child: Icon(Icons.desktop_windows_outlined,
                  size: 120, color: Color(0x14FFFFFF)),
            ),

            // Back button
            Positioned(
              top: 8,
              left: 12,
              child: BackCircleButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),

            // Dice logo with a soft glow behind it
            Align(
              alignment: const Alignment(0, -0.5),
              child: SizedBox(
                width: diceWidth * 1.3,
                height: diceWidth * 1.3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x26FFFFFF), Color(0x00FFFFFF)],
                        ),
                      ),
                    ),
                    Image.asset(
                      kDiceImage,
                      width: diceWidth,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          DicePicture(size: diceWidth * 0.85),
                    ),
                  ],
                ),
              ),
            ),

            // Level buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: LevelConfig.all
                      .map(
                        (cfg) => Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: _LevelButton(config: cfg),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelButton extends StatefulWidget {
  final LevelConfig config;
  const _LevelButton({required this.config});

  @override
  State<_LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<_LevelButton> {
  bool _pressed = false;

  void _open() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GameScreen(config: widget.config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;

    return GestureDetector(
      onTap: _open,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 68,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          // lighter strip on the left edge, like the design
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF1A59AA),
              AppColors.button,
              AppColors.button,
            ],
            stops: [0, 0.08, 1],
          ),
          border: Border.all(
            color: _pressed ? Colors.black : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: _pressed
              ? const []
              : const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(5, 7),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'level ${cfg.level}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${cfg.name}  •  1 to ${cfg.maxNumber}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
