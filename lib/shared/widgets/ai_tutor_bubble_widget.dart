import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/tts_service.dart';

/// Reusable AI Tutor Mascot Bubble Widget (1 & 9-Talablar)
/// Barcha modullarda sun'iy intellekt o'qituvchisi sifatida namoyon bo'ladi.
class AiTutorBubbleWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onTapSpeech;

  const AiTutorBubbleWidget({
    super.key,
    required this.message,
    this.onTapSpeech,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softTeal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softTeal.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        children: [
          const Text(
            "🤖",
            style: TextStyle(fontSize: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkSlate,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryViolet),
            onPressed: () {
              TtsService().speak(message, language: 'uz-UZ');
              if (onTapSpeech != null) onTapSpeech!();
            },
          ),
        ],
      ),
    );
  }
}
