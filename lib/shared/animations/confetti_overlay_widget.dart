import 'dart:math';
import 'package:flutter/material.dart';

/// Confetti Animation Widget (10-Talab)
/// G'alaba va to'g'ri javoblarda quvnoq konfetti zarralarini yog'diradi.
class ConfettiOverlayWidget extends StatefulWidget {
  final Widget child;
  final bool show;

  const ConfettiOverlayWidget({
    super.key,
    required this.child,
    required this.show,
  });

  @override
  State<ConfettiOverlayWidget> createState() => _ConfettiOverlayWidgetState();
}

class _ConfettiOverlayWidgetState extends State<ConfettiOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.update();
          }
        });
      });

    _generateParticles();
  }

  void _generateParticles() {
    _particles.clear();
    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.amberAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
    ];
    for (int i = 0; i < 60; i++) {
      _particles.add(_ConfettiParticle(
        x: _random.nextDouble() * 400,
        y: _random.nextDouble() * -200,
        size: _random.nextDouble() * 8 + 6,
        color: colors[_random.nextInt(colors.length)],
        speedY: _random.nextDouble() * 4 + 2,
        speedX: _random.nextDouble() * 2 - 1,
        rotation: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void didUpdateWidget(ConfettiOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _generateParticles();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.show || _controller.isAnimating)
          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(_particles),
            ),
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double size;
  Color color;
  double speedY;
  double speedX;
  double rotation;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedY,
    required this.speedX,
    required this.rotation,
  });

  void update() {
    y += speedY;
    x += speedX;
    rotation += 0.05;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x % size.width, p.y % size.height);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
