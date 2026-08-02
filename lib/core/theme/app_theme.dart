import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// AppTheme — loyiha mavzulari (ThemeData) sozlamasi
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryViolet,
        primary: AppColors.primaryViolet,
        secondary: AppColors.softTeal,
        tertiary: AppColors.warmCoral,
        surface: AppColors.cardSurface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.titleLarge,
        headlineMedium: AppTextStyles.headingMedium,
        titleMedium: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium,
      ),
    );
  }
}
