import 'package:flutter/material.dart';

/// Two dice drawn with plain widgets (no image files needed).
/// To use your own picture, replace this widget with Image.asset(...).
class DicePicture extends StatelessWidget {
  final double size;
  const DicePicture({super.key, this.size = 240});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Transform.rotate(
              angle: -0.15,
              child: _Die(
                size: size * 0.62,
                value: 5,
                color: const Color(0xFFD0D0D0),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: 0.12,
              child: _Die(
                size: size * 0.42,
                value: 3,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Die extends StatelessWidget {
  final double size;
  final int value;
  final Color color;
  const _Die({required this.size, required this.value, required this.color});

  static const double _a = 0.55;
  static const Map<int, List<Alignment>> _dots = {
    1: [Alignment(0, 0)],
    2: [Alignment(-_a, -_a), Alignment(_a, _a)],
    3: [Alignment(-_a, -_a), Alignment(0, 0), Alignment(_a, _a)],
    4: [
      Alignment(-_a, -_a),
      Alignment(_a, -_a),
      Alignment(-_a, _a),
      Alignment(_a, _a)
    ],
    5: [
      Alignment(-_a, -_a),
      Alignment(_a, -_a),
      Alignment(0, 0),
      Alignment(-_a, _a),
      Alignment(_a, _a)
    ],
    6: [
      Alignment(-_a, -_a),
      Alignment(-_a, 0),
      Alignment(-_a, _a),
      Alignment(_a, -_a),
      Alignment(_a, 0),
      Alignment(_a, _a)
    ],
  };

  @override
  Widget build(BuildContext context) {
    final dot = size * 0.16;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(4, 6)),
        ],
      ),
      child: Stack(
        children: (_dots[value] ?? const <Alignment>[])
            .map(
              (a) => Align(
                alignment: a,
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: const BoxDecoration(
                    color: Color(0xFF444444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
