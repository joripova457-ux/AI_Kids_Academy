import 'package:flutter/material.dart';

/// Bosh sahifadagi har bir o'quv va ko'ngilochar bo'lim ma'lumotlari modeli
class SectionItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final int stars;
  final Widget Function(BuildContext) builder;

  const SectionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.progress = 0.0,
    this.stars = 0,
    required this.builder,
  });
}
