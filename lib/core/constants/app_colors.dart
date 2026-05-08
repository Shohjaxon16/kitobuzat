import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors
  static const darkBg = Color(0xFF0A0A0F);
  static const darkSurface = Color(0xFF13131A);
  static const darkSurface2 = Color(0xFF1C1C26);
  static const darkBorder = Color(0x12FFFFFF); // rgba(255,255,255,0.07)
  static const darkText = Color(0xFFF8FAFC);
  static const darkText2 = Color(0xFF94A3B8);

  // Light theme colors  
  static const lightBg = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF1F5F9);
  static const lightBorder = Color(0x14000000); // rgba(0,0,0,0.08)
  static const lightText = Color(0xFF0F172A);
  static const lightText2 = Color(0xFF64748B);

  // Accent colors
  static const blue = Color(0xFF3B82F6);
  static const blueDark = Color(0xFF1D4ED8);
  static const blueLight = Color(0xFF60A5FA);
  static const amber = Color(0xFFF59E0B);
  static const green = Color(0xFF22C55E);
  static const red = Color(0xFFEF4444);
  static const purple = Color(0xFFA855F7);

  static Color getText2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkText2 : lightText2;
  }
}
