import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Grey keypad key (digits and the C button).
class KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const KeyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.key,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(8, 8),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }
}
