import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Konfetti va yulduzlar portlashi animatsiya overlay vidjeti (Mounted Safe)
class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool isTriggered;
  final VoidCallback? onFinished;

  const ConfettiOverlay({
    super.key,
    required this.child,
    required this.isTriggered,
    this.onFinished,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onFinished?.call();
      }
    });

    if (widget.isTriggered) {
      _spawnParticles();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isTriggered && widget.isTriggered) {
      _spawnParticles();
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    }
  }

  void _spawnParticles() {
    _particles.clear();
    const colors = [
      AppColors.primaryViolet,
      AppColors.softTeal,
      AppColors.warmCoral,
      AppColors.brightYellow,
      AppColors.skyBlue,
      AppColors.playfulPink,
    ];

    for (int i = 0; i < 50; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble() * 0.3,
          vx: (_random.nextDouble() - 0.5) * 0.6,
          vy: _random.nextDouble() * 0.8 + 0.4,
          size: _random.nextDouble() * 8 + 6,
          color: colors[_random.nextInt(colors.length)],
          rotation: _random.nextDouble() * pi * 2,
          vr: (_random.nextDouble() - 0.5) * 4,
          isStar: _random.nextBool(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double vx;
  final double vy;
  final double size;
  final Color color;
  final double rotation;
  final double vr;
  final bool isStar;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotation,
    required this.vr,
    required this.isStar,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final currentX = (p.x + p.vx * progress) * size.width;
      final currentY = (p.y + p.vy * progress) * size.height;
      final currentRot = p.rotation + p.vr * progress;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRot);

      paint.color = p.color.withValues(alpha: opacity);

      if (p.isStar) {
        _drawStar(canvas, paint, p.size);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.6,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    const points = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;
    double angle = -pi / 2;
    final angleStep = pi / points;

    path.moveTo(
      cos(angle) * outerRadius,
      sin(angle) * outerRadius,
    );

    for (int i = 0; i < points; i++) {
      angle += angleStep;
      path.lineTo(cos(angle) * innerRadius, sin(angle) * innerRadius);
      angle += angleStep;
      path.lineTo(cos(angle) * outerRadius, sin(angle) * outerRadius);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
