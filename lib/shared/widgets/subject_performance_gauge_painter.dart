import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Fanlar Bo'yicha Progress Indikatori Gauge Custom Painter (Parent Panel 2.0)
class SubjectPerformanceGaugePainter extends CustomPainter {
  final double percentage; // 0.0 -> 1.0 (masalan 0.85 = 85%)

  SubjectPerformanceGaugePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 6;

    final bgPaint = Paint()
      ..color = AppColors.softTeal.withValues(alpha: 0.2)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = AppColors.softTeal
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * percentage.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SubjectPerformanceGaugePainter oldDelegate) => true;
}
