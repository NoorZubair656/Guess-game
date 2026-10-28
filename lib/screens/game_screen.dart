import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../logic/game_logic.dart';
import '../widgets/app_button.dart';
import '../widgets/back_circle_button.dart';
import '../widgets/gradient_background.dart';
import '../widgets/key_button.dart';
import 'history_screen.dart';

class GameScreen extends StatefulWidget {
  final LevelConfig config;
  const GameScreen({super.key, required this.config});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameLogic _game = GameLogic(widget.config);

  static const Color _red = Color(0xFFD32F2F);
  static const Color _green = Color(0xFF2E7D32);
  static const Color _orange = Color(0xFFEF6C00);
  static const Color _neutral = Color(0x33FFFFFF);

  String get _rangeText =>
      'Guess a number from 1 to ${widget.config.maxNumber}';

  late String _message = _rangeText;
  Color _messageColor = _neutral;
  IconData _messageIcon = Icons.help_outline;

  void _setMessage(String text, Color color, IconData icon) {
    _message = text;
    _messageColor = color;
    _messageIcon = icon;
  }

  void _onDigit(String digit) => setState(() => _game.addDigit(digit));

  void _onClear() => setState(() => _game.clear());

  Future<void> _showInfoDialog(String title, String text) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Score button: shows the current score and game info.
  void _onScore() {
    _showInfoDialog(
      'Your Score',
      'Score: ${_game.score}\n'
          'Level: ${widget.config.level} (${widget.config.name})\n'
          'Attempts left: ${_game.attemptsLeft}',
    );
  }

  Future<void> _onCheck() async {
    final result = _game.check();

    String? dialogTitle;
    String? dialogText;

    if (result == GuessResult.empty) {
      _setMessage('Enter a number first', _orange, Icons.info_outline);
    } else if (result == GuessResult.tooLow) {
      _setMessage('Wrong! Your number is too LOW, try higher', _red,
          Icons.close_rounded);
    } else if (result == GuessResult.tooHigh) {
      _setMessage('Wrong! Your number is too HIGH, try lower', _red,
          Icons.close_rounded);
    } else if (result == GuessResult.correct) {
      _setMessage('Correct! Your number is right', _green,
          Icons.check_circle_outline);
      dialogTitle = 'Correct!';
      dialogText = 'The number was ${_game.lastSecret}.\n'
          'You won ${_game.lastPoints} points.';
    } else {
      _setMessage('Out of attempts', _red, Icons.close_rounded);
      dialogTitle = 'Out of attempts';
      dialogText = 'The number was ${_game.lastSecret}.\nTry the next one!';
    }

    setState(() {});

    if (dialogTitle != null && mounted) {
      await _showInfoDialog(dialogTitle, dialogText!);
      if (!mounted) return;
      setState(() => _setMessage(_rangeText, _neutral, Icons.help_outline));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _game.input.isNotEmpty;

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackCircleButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    iconSize: 36,
                    tooltip: 'History',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HistoryScreen()),
                    ),
                    icon: const Icon(Icons.history, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Result message (always visible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _messageColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(_messageIcon, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Number circle
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 190,
                        height: 190,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.circle,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 16,
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          hasInput ? _game.input : '?',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Attempts left: ${_game.attemptsLeft}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  _row([
                    _digit('1'),
                    _digit('2'),
                    _digit('3'),
                    Expanded(
                      child: KeyButton(label: 'C', onTap: _onClear),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  _row([
                    _digit('4'),
                    _digit('5'),
                    _digit('6'),
                    Expanded(
                      child: AppButton(
                        radius: 6,
                        onTap: _onScore,
                        child: const Text('Score',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  _row([
                    _digit('7'),
                    _digit('8'),
                    _digit('9'),
                    Expanded(
                      child: AppButton(
                        radius: 6,
                        onTap: _onScore,
                        child: Text(
                          '${_game.score}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      _digit('0'),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: AppButton(
                          onTap: _onCheck,
                          child: Text(
                            'Check',
                            style: TextStyle(
                              fontSize: 22,
                              color: hasInput ? Colors.white : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _digit(String d) =>
      Expanded(child: KeyButton(label: d, onTap: () => _onDigit(d)));

  Widget _row(List<Widget> children) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) spaced.add(const SizedBox(width: 16));
      spaced.add(children[i]);
    }
    return Row(children: spaced);
  }
}
