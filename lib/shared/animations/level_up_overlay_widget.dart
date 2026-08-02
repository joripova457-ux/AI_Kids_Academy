import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Level Up Overlay Widget (10-Talab)
/// Level oshganda maxsus dialog, ovoz va fireworks vizual effekti.
class LevelUpOverlayWidget extends StatelessWidget {
  final int newLevel;
  final VoidCallback onDismiss;

  const LevelUpOverlayWidget({
    super.key,
    required this.newLevel,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🎆 👑 🎆",
              style: TextStyle(fontSize: 54),
            ),
            const SizedBox(height: 12),
            Text(
              "LEVEL UP!",
              style: AppTextStyles.h1.copyWith(color: AppColors.warmCoral),
            ),
            const SizedBox(height: 8),
            Text(
              "Tabriklaymiz! Sen $newLevel-darajaga erishding! 🏆",
              textAlign: TextAlign.center,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brightYellow,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Davom etamiz! ⚡",
                style: AppTextStyles.buttonText
                    .copyWith(color: AppColors.darkSlate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
