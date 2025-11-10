import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF00ADEF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00ADEF),
    secondary: const Color(0xFFE38524),
    background: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00ADEF),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00ADEF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  cardTheme: const CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFF00ADEF), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
  ),
  useMaterial3: true,
);

// Custom text styles for consistent usage across the app
class AppTextStyles {
  static const headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );
}

// Custom colors for easy access
class AppColors {
  static const primary = Color(0xFF00ADEF);
  static const primaryDark = Color(0xFF008BC6);
  static const primaryLight = Color(0xFF4DCFFF);
  static const accent = Color(0xFFE38524);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFF5F5F5);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
  static const warning = Color(0xFFFF9800);
}