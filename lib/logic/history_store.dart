import 'package:flutter/foundation.dart';

/// One finished round (either won or lost).
class RoundRecord {
  final String levelName;
  final int secret;
  final bool won;
  final List<int> guesses;
  final int points;
  final DateTime time;

  const RoundRecord({
    required this.levelName,
    required this.secret,
    required this.won,
    required this.guesses,
    required this.points,
    required this.time,
  });

  int get attemptsUsed => guesses.length;
}

/// Keeps every finished round while the app is open.
/// One shared instance, so Game screen and History screen see the same data.
class HistoryStore extends ChangeNotifier {
  HistoryStore._();
  static final HistoryStore instance = HistoryStore._();

  final List<RoundRecord> _rounds = [];

  /// Newest round first.
  List<RoundRecord> get rounds => List.unmodifiable(_rounds.reversed);

  int get played => _rounds.length;
  int get wins => _rounds.where((r) => r.won).length;
  int get totalPoints => _rounds.fold(0, (sum, r) => sum + r.points);

  void add(RoundRecord record) {
    _rounds.add(record);
    notifyListeners();
  }

  void clear() {
    _rounds.clear();
    notifyListeners();
  }
}
