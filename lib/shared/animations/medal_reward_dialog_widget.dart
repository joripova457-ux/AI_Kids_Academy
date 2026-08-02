import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Medal Reward Dialog Widget (10-Talab)
/// Yangi medal va mukofot olganda chiroqli muloqot oynasi va animatsiya.
class MedalRewardDialogWidget extends StatelessWidget {
  final String title;
  final String description;
  final String medalEmoji;
  final VoidCallback onClose;

  const MedalRewardDialogWidget({
    super.key,
    required this.title,
    required this.description,
    this.medalEmoji = '🏅',
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              medalEmoji,
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(color: AppColors.primaryViolet),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                "Rahmat! 🚀",
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
