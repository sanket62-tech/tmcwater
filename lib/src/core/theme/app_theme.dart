import 'package:flutter/material.dart';
import 'package:water_collector/src/core/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = AppColors.primary;
  static const Color primaryDark = AppColors.primaryDark;
  static const Color surface = AppColors.surface;
  static const Color cardBg = Colors.white;
  static const Color labelColor = AppColors.textPrimary;
  static const Color hintColor = AppColors.hint;

  static const List<Color> sectionColors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.success,
    AppColors.warning,
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
