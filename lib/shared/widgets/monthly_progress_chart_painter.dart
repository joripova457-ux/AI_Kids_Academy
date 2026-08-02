import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Oylik Progress Grafigi Custom Painter (Parent Dashboard 2.0 — 4-Talab)
class MonthlyProgressChartPainter extends CustomPainter {
  final List<double> weeklyHours; // 4 haftalik soatlar masalan [2.0, 3.5, 4.0, 2.5]

  MonthlyProgressChartPainter(this.weeklyHours);

  @override
  void paint(Canvas canvas, Size size) {
    if (weeklyHours.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.primaryViolet
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.warmCoral
      ..style = PaintingStyle.fill;

    final double maxVal = 10.0;
    final int count = weeklyHours.length;
    final double stepX = size.width / (count - 1 > 0 ? count - 1 : 1);

    final path = Path();

    for (int i = 0; i < count; i++) {
      final double x = i * stepX;
      final double ratio = (weeklyHours[i] / maxVal).clamp(0.0, 1.0);
      final double y = size.height - (ratio * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant MonthlyProgressChartPainter oldDelegate) => true;
}
