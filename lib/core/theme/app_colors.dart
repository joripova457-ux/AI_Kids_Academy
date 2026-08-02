import 'package:flutter/material.dart';

/// Vivid-pastel design system colors tailored for kids (3-10 yosh)
abstract class AppColors {
  // Brand & Accent Colors
  static const Color primaryViolet = Color(0xFF7C4DFF);
  static const Color primaryVioletDark = Color(0xFF651FFF);
  static const Color softTeal = Color(0xFF00E676);
  static const Color tealDark = Color(0xFF00C853);
  static const Color warmCoral = Color(0xFFFF6E40);
  static const Color brightYellow = Color(0xFFFFD600);
  static const Color skyBlue = Color(0xFF40C4FF);
  static const Color playfulPink = Color(0xFFFF4081);

  // Background & Surface
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color backgroundSky = Color(0xFFE8F5E9);
  static const Color cardSurface = Colors.white;
  static const Color parentBackground = Color(0xFF1E1E2C);

  // Text & Neutral Colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color darkSlate = Color(0xFF2C3E50); // Alias
  static const Color textMuted = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;

  // Feedback Colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryViolet, skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [softTeal, Color(0xFF69F0AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [warmCoral, brightYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient playfulGradient = LinearGradient(
    colors: [playfulPink, primaryViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [skyBlue, softTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
