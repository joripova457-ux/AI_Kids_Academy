import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';

class _DrawingPoint {
  final Offset offset;
  final Paint paint;

  _DrawingPoint({required this.offset, required this.paint});
}

class _DrawingPainter extends CustomPainter {
  final List<_DrawingPoint?> points;

  _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!.offset, points[i]!.paint.strokeWidth / 2, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Rasm chizish taxtasi (Drawing Canvas Screen)
class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<_DrawingPoint?> _points = [];
  Color _selectedColor = AppColors.primaryViolet;
  double _strokeWidth = 5.0;
  bool _isEraser = false;
  int _stars = 0;

  final List<Color> _colors = const [
    AppColors.primaryViolet,
    AppColors.softTeal,
    AppColors.warmCoral,
    AppColors.brightYellow,
    AppColors.skyBlue,
    AppColors.playfulPink,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
  }

  void _clearCanvas() {
    AudioService().playClickSound();
    setState(() {
      _points.clear();
    });
  }

  void _saveDrawing() async {
    AudioService().playStarEarnSound();
    final updatedStars = await StorageService.instance.addModuleStars('drawing', 2);

    if (mounted) {
      setState(() {
        _stars = updatedStars;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Rasm galereyaga saqlandi! 🎨✨ +2 ⭐️",
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.softTeal,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      appBar: ChildAppBar(
        title: "🎨 Rasm Chizish Taxtasi",
        starCount: _stars,
      ),
      body: Column(
        children: [
          // Canvas Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                    final localPos = renderBox.globalToLocal(details.globalPosition);

                    setState(() {
                      _points.add(
                        _DrawingPoint(
                          offset: localPos,
                          paint: Paint()
                            ..color = _isEraser ? Colors.white : _selectedColor
                            ..strokeCap = StrokeCap.round
                            ..strokeWidth = _isEraser ? _strokeWidth * 2.5 : _strokeWidth,
                        ),
                      );
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null);
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(points: _points),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),

          // Tools Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Color Palette & Eraser
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._colors.map((color) {
                        final isSel = !_isEraser && _selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            AudioService().playClickSound();
                            setState(() {
                              _selectedColor = color;
                              _isEraser = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel ? Colors.black : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 8),
                      // Eraser Tool
                      GestureDetector(
                        onTap: () {
                          AudioService().playClickSound();
                          setState(() => _isEraser = !_isEraser);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isEraser ? AppColors.warmCoral : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cleaning_services_rounded,
                            color: _isEraser ? Colors.white : AppColors.textDark,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Stroke Width & Clear/Save Action Buttons
                Row(
                  children: [
                    Text("O'lcham:", style: AppTextStyles.bodyMedium),
                    Expanded(
                      child: Slider(
                        value: _strokeWidth,
                        min: 2.0,
                        max: 15.0,
                        activeColor: AppColors.primaryViolet,
                        onChanged: (val) => setState(() => _strokeWidth = val),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: _clearCanvas,
                      tooltip: "Tozalash",
                    ),
                    IconButton(
                      icon: const Icon(Icons.save_alt_rounded, color: AppColors.softTeal),
                      onPressed: _saveDrawing,
                      tooltip: "Saqlash",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
