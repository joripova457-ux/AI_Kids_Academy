import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/big_round_button.dart';
import '../../../core/widgets/child_app_bar.dart';
import '../../../core/widgets/child_mode_scaffold.dart';
import '../../../core/widgets/confetti_overlay.dart';
import '../../../core/widgets/mascot_bubble.dart';
import '../../../services/audio_service.dart';
import '../../../services/storage_service.dart';

class _ShapeItem {
  final String name;
  final IconData icon;
  final Color color;
  final String colorName;

  const _ShapeItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.colorName,
  });
}

/// Shapes & Colors Game Screen (Shakllar va Ranglar O'yini)
class ShapesGameScreen extends StatefulWidget {
  const ShapesGameScreen({super.key});

  @override
  State<ShapesGameScreen> createState() => _ShapesGameScreenState();
}

class _ShapesGameScreenState extends State<ShapesGameScreen> {
  final List<_ShapeItem> _allShapes = const [
    _ShapeItem(name: "Doyra 🔴", icon: Icons.circle, color: Colors.redAccent, colorName: "Qizil"),
    _ShapeItem(name: "Kvadrat 🟦", icon: Icons.square, color: Colors.blueAccent, colorName: "Ko'k"),
    _ShapeItem(name: "Uchburchak 🔺", icon: Icons.change_history_rounded, color: Colors.amber, colorName: "Sariq"),
    _ShapeItem(name: "Yulduz ⭐", icon: Icons.star_rounded, color: Colors.orangeAccent, colorName: "Zargaldoq"),
    _ShapeItem(name: "Yurak ❤️", icon: Icons.favorite_rounded, color: Colors.pinkAccent, colorName: "Pushti"),
    _ShapeItem(name: "Olmos 💎", icon: Icons.diamond_rounded, color: Colors.purpleAccent, colorName: "Binafsha"),
  ];

  int _targetIndex = 0;
  int? _selectedIndex;
  bool _isSuccess = false;
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _stars = StorageService.instance.getTotalStars();
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _targetIndex = (_targetIndex + 1) % _allShapes.length;
      _selectedIndex = null;
      _isSuccess = false;
    });
  }

  void _checkShape(int index) {
    if (_isSuccess) return;

    setState(() {
      _selectedIndex = index;
      if (index == _targetIndex) {
        _isSuccess = true;
        AudioService().playSuccessSound();
        AudioService().playStarEarnSound();
        StorageService.instance.addModuleStars('mini_games', 1).then((updated) {
          if (mounted) {
            setState(() {
              _stars = updated;
            });
          }
        });
      } else {
        AudioService().playErrorSound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = _allShapes[_targetIndex];

    return ConfettiOverlay(
      isTriggered: _isSuccess,
      child: ChildModeScaffold(
        appBar: ChildAppBar(
          title: "🎨 Shakllar va Ranglar",
          starCount: _stars,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MascotBubble(
                speechText: _isSuccess
                    ? "Juda ham to'g'ri! Barakalla! 🎉+1 ⭐️"
                    : "Qaysi biri '${target.name}'? Barmoq bilan bosing! 👇",
              ),
              const SizedBox(height: 24),

              // Target Prompt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softTeal.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Topish kerak bo'lgan shakl:",
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      target.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: target.color,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Options Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: _allShapes.length,
                itemBuilder: (context, index) {
                  final item = _allShapes[index];
                  final isSelected = _selectedIndex == index;

                  Color cardBorderColor = Colors.transparent;
                  if (isSelected) {
                    cardBorderColor = _isSuccess ? AppColors.softTeal : AppColors.warmCoral;
                  }

                  return GestureDetector(
                    onTap: () => _checkShape(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cardBorderColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: item.color.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 48,
                            color: item.color,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.colorName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              if (_isSuccess)
                BigRoundButton(
                  text: "Keyingi Shakl ➡️",
                  variant: BigRoundButtonVariant.success,
                  onPressed: _nextQuestion,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
