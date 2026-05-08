import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      surfaceContainerHighest: AppColors.darkSurface2,
      primary: AppColors.blue,
      outline: AppColors.darkBorder,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(color: AppColors.darkText),
      displayMedium: GoogleFonts.playfairDisplay(color: AppColors.darkText),
      bodyLarge: GoogleFonts.dmSans(color: AppColors.darkText),
      bodyMedium: GoogleFonts.dmSans(color: AppColors.darkText2),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      surfaceContainerHighest: AppColors.lightSurface2,
      primary: AppColors.blue,
      outline: AppColors.lightBorder,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(color: AppColors.lightText),
      displayMedium: GoogleFonts.playfairDisplay(color: AppColors.lightText),
      bodyLarge: GoogleFonts.dmSans(color: AppColors.lightText),
      bodyMedium: GoogleFonts.dmSans(color: AppColors.lightText2),
    ),
  );
}
