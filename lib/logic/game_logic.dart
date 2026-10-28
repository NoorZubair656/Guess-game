import 'dart:math';

import 'history_store.dart';

/// Result of pressing "Check".
enum GuessResult { empty, tooLow, tooHigh, correct, outOfAttempts }

/// Settings for one difficulty level.
class LevelConfig {
  final int level;
  final String name;
  final int maxNumber;
  final int attempts;

  const LevelConfig({
    required this.level,
    required this.name,
    required this.maxNumber,
    required this.attempts,
  });

  static const LevelConfig easy =
      LevelConfig(level: 1, name: 'Easy', maxNumber: 20, attempts: 8);
  static const LevelConfig normal =
      LevelConfig(level: 2, name: 'Normal', maxNumber: 50, attempts: 7);
  static const LevelConfig hard =
      LevelConfig(level: 3, name: 'Hard', maxNumber: 100, attempts: 7);

  static const List<LevelConfig> all = [easy, normal, hard];
}

/// All game rules. No Flutter widgets in here, so it is easy to test.
class GameLogic {
  GameLogic(this.config) {
    newRound();
  }

  final LevelConfig config;
  final Random _rng = Random();

  int _secret = 1;
  int attemptsLeft = 0;
  int score = 0;

  /// Points won in the last correct guess.
  int lastPoints = 0;

  /// The number that was hidden in the round that just ended.
  int lastSecret = 0;

  /// Digits typed by the player (shown in the circle).
  String input = '';

  /// Guesses made in the current round (saved to history when it ends).
  final List<int> _guesses = [];

  int get maxDigits => config.maxNumber.toString().length;

  void newRound() {
    _secret = _rng.nextInt(config.maxNumber) + 1; // 1..maxNumber
    attemptsLeft = config.attempts;
    input = '';
    _guesses.clear();
  }

  void addDigit(String digit) {
    if (input.length >= maxDigits) return;
    if (input.isEmpty && digit == '0') return; // numbers start at 1
    input += digit;
  }

  void clear() => input = '';

  void _saveRound({required bool won, required int points}) {
    HistoryStore.instance.add(
      RoundRecord(
        levelName: config.name,
        secret: _secret,
        won: won,
        guesses: List<int>.of(_guesses),
        points: points,
        time: DateTime.now(),
      ),
    );
  }

  GuessResult check() {
    if (input.isEmpty) return GuessResult.empty;

    final guess = int.parse(input);
    input = '';
    _guesses.add(guess);

    if (guess == _secret) {
      // The fewer attempts used, the more points; harder levels pay more.
      lastPoints = attemptsLeft * 10 * config.level;
      score += lastPoints;
      lastSecret = _secret;
      _saveRound(won: true, points: lastPoints);
      newRound();
      return GuessResult.correct;
    }

    attemptsLeft--;
    if (attemptsLeft <= 0) {
      lastSecret = _secret;
      _saveRound(won: false, points: 0);
      newRound();
      return GuessResult.outOfAttempts;
    }

    return guess < _secret ? GuessResult.tooLow : GuessResult.tooHigh;
  }
}
