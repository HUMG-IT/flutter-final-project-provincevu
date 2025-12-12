import 'package:flutter/material.dart';

/// Màu sắc chính của ứng dụng
class AppColors {
  // Primary colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1B5E20);

  // Accent colors
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentBlue = Color(0xFF2196F3);

  // Semantic colors
  static const Color income = Color(0xFF4CAF50);
  static const Color expense = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Light theme
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark theme - improved contrast
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkCard = Color(0xFF0F3460);
}

/// Theme sáng
final ThemeData _kLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryGreen,
    secondary: AppColors.lightGreen,
    surface: AppColors.lightSurface,
    error: AppColors.expense,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.lightSurface,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: AppColors.primaryGreen,
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.primaryGreen,
    unselectedLabelColor: AppColors.lightTextSecondary,
    indicatorColor: AppColors.primaryGreen,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  chipTheme: ChipThemeData(
    selectedColor: AppColors.lightGreen.withValues(alpha: 0.3),
    backgroundColor: AppColors.lightBackground,
    labelStyle: const TextStyle(color: AppColors.lightText),
  ),
);

/// Theme tối - improved contrast
final ThemeData _kDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.lightGreen,
    secondary: AppColors.primaryGreen,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
    error: AppColors.expense,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkText,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkCard,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightGreen,
    foregroundColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.darkSurface,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: AppColors.lightGreen,
    textColor: AppColors.darkText,
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.lightGreen,
    unselectedLabelColor: AppColors.darkTextSecondary,
    indicatorColor: AppColors.lightGreen,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkText),
    bodyMedium: TextStyle(color: AppColors.darkText),
    bodySmall: TextStyle(color: AppColors.darkTextSecondary),
    titleLarge:
        TextStyle(color: AppColors.darkText, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.darkText),
  ),
  iconTheme: const IconThemeData(color: AppColors.darkText),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.lightGreen, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  chipTheme: ChipThemeData(
    selectedColor: AppColors.lightGreen.withValues(alpha: 0.3),
    backgroundColor: AppColors.darkSurface,
    labelStyle: const TextStyle(color: AppColors.darkText),
  ),
);

/// Class helper để truy cập theme
class AppTheme {
  static ThemeData get lightTheme => _kLightTheme;
  static ThemeData get darkTheme => _kDarkTheme;
}
