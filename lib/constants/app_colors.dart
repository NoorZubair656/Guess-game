import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color top = Color(0xFF0F4C98);
  static const Color bottom = Color(0xFF051830);
  static const Color button = Color(0xFF0F4690);
  static const Color key = Color(0xFFD9D9D9);
  static const Color backIcon = Color(0xFF5B4CF0);
  static const Color faded = Color(0xFF7C8DC4);
  static const Color circle = Color(0xFF2563B8);
  static const Color shadow = Color(0x66000000);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  );
}
