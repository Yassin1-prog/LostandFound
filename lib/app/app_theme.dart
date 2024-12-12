import 'package:flutter/material.dart';

class AppColors {
  // Define all your colors as static constants using hex codes
  static const Color primary = Color(0xFF1D3557); // Dark Slate blue
  static const Color background = Color(0xFFEEF4ED); // light green
  static const Color background2 = Color(0XFFF8F8F8); // Off-White
  static const Color text = Color(0xFF000000); // Black
  static const Color accent = Color(0xFF457B9D); // Lighter blue
  static const Color buttonText = Color(0xFFFFFFFF); // White
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.text,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.buttonText,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.buttonText,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
