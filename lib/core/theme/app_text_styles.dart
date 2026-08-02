import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography hierarchy using Google Fonts (Nunito / Baloo) for kids readability
abstract class AppTextStyles {
  static TextStyle titleLarge = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle headingMedium = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.25,
  );

  static TextStyle headingSmall = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle buttonText = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle mascotText = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle starCounter = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.brightYellow,
  );

  // Aliases for 6-BOSQICH
  static TextStyle get h1 => titleLarge;
  static TextStyle get h2 => headingMedium;
  static TextStyle get h3 => headingSmall;
  static TextStyle get bodyText => bodyLarge;
  static TextStyle get caption => bodyMedium;
}
