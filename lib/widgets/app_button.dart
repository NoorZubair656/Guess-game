import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Blue rounded button with a soft shadow. Pass onTap = null for a static box.
class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final double radius;

  const AppButton({
    super.key,
    required this.child,
    this.onTap,
    this.height = 64,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.button,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(6, 6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
