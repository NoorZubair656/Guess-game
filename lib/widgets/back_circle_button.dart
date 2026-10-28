import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Round purple back arrow shown at the top-left of every screen.
class BackCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackCircleButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: 44,
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.arrow_circle_left_outlined,
        color: AppColors.backIcon,
      ),
    );
  }
}
