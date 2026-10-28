import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Blue gradient used behind every screen.
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.background),
        child: child,
      ),
    );
  }
}
