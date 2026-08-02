import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Haftalik Progress Grafigi Custom Painter (Parent Dashboard 2.0 — 4 & 5-Talablar)
class WeeklyProgressChartPainter extends CustomPainter {
  final List<double> dailyMinutes; // 7 kunlik minutlar [15, 25, 10, 30, 20, 45, 18]

  WeeklyProgressChartPainter(this.dailyMinutes);

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = AppColors.skyBlue
      ..style = PaintingStyle.fill;

    final bgPaint = Paint()
      ..color = AppColors.skyBlue.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final double maxVal = 60.0;
    final int count = dailyMinutes.length > 7 ? 7 : dailyMinutes.length;
    final double barWidth = size.width / (count * 2);

    for (int i = 0; i < count; i++) {
      final double x = i * (barWidth * 2) + barWidth / 2;
      final double ratio = (dailyMinutes[i] / maxVal).clamp(0.0, 1.0);
      final double barHeight = size.height * ratio;

      // Orqa fon ustuni
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 0, barWidth, size.height),
          const Radius.circular(8),
        ),
        bgPaint,
      );

      // Faol minutlar ustuni
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
          const Radius.circular(8),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WeeklyProgressChartPainter oldDelegate) => true;
}
