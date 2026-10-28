import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../logic/history_store.dart';
import '../widgets/app_button.dart';
import '../widgets/back_circle_button.dart';
import '../widgets/gradient_background.dart';
import 'level_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color _win = Color(0xFF2E7D32);
  static const Color _lose = Color(0xFFD32F2F);

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _play(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LevelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = HistoryStore.instance;

    return GradientBackground(
      child: SafeArea(
        child: Stack(
          children: [
            // Faded dice in the background
            const Positioned(
              right: -34,
              top: 70,
              child: Icon(Icons.casino_outlined,
                  size: 170, color: Color(0x297C8DC4)),
            ),
            const Positioned(
              left: -46,
              bottom: 70,
              child: Icon(Icons.casino_outlined,
                  size: 190, color: Color(0x177C8DC4)),
            ),

            ListenableBuilder(
              listenable: store,
              builder: (context, _) {
                final rounds = store.rounds;
                final isEmpty = rounds.isEmpty;

                return Column(
                  children: [
                    // Top bar: back, title, clear
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        children: [
                          BackCircleButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const Expanded(
                            child: Text(
                              'History',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            iconSize: 28,
                            tooltip: 'Clear history',
                            onPressed: isEmpty ? null : store.clear,
                            color: Colors.white70,
                            disabledColor: Colors.white24,
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Summary boxes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _StatBox(label: 'Played', value: '${store.played}'),
                          const SizedBox(width: 12),
                          _StatBox(label: 'Won', value: '${store.wins}'),
                          const SizedBox(width: 12),
                          _StatBox(
                              label: 'Points', value: '${store.totalPoints}'),
                        ],
                      ),
                    ),

                    // Body: list or empty state
                    Expanded(
                      child: isEmpty
                          ? const _EmptyState()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(28, 20, 28, 10),
                                  child: Text(
                                    'RECENT GAMES',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 0, 24, 16),
                                    itemCount: rounds.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (_, i) => _RoundCard(
                                        record: rounds[i], time: _time),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // Bottom button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8, 50, 40),
                      child: AppButton(
                        height: 50,
                        onTap: () => _play(context),
                        child: Text(
                          isEmpty ? 'START TO PLAY' : 'PLAY AGAIN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Blue card background with a lighter strip on the left edge.
const BoxDecoration _cardDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1A59AA), Color(0xFF0F4690), Color(0xFF0F4690)],
    stops: [0, 0.12, 1],
  ),
  boxShadow: [
    BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(5, 6)),
  ],
);

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 72,
        decoration: _cardDecoration.copyWith(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  final RoundRecord record;
  final String Function(DateTime) time;
  const _RoundCard({required this.record, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                record.won ? HistoryScreen._win : HistoryScreen._lose,
            child: Icon(
              record.won ? Icons.check : Icons.close,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.levelName} • Number ${record.secret}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Guesses: ${record.guesses.join(', ')}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.attemptsUsed} attempts • ${time(record.time)}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            record.won ? '+${record.points}' : 'Lost',
            style: TextStyle(
              color: record.won
                  ? const Color(0xFF7DDC9A)
                  : const Color(0xFFFFA8A0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: AppColors.circle,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(6, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.casino_rounded,
                size: 84,
                color: Color(0xE6D9D9D9),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No games played yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 260,
              child: Text(
                'Play a round and every guess, win and score will show up here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
