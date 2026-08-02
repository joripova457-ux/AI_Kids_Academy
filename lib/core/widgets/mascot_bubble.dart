import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Sun'iy intellekt Maskoti dialog va suhbat sharigi vidjeti
class MascotBubble extends StatelessWidget {
  final String speechText;
  final String mascotName;
  final IconData mascotIcon;
  final VoidCallback? onTapMascot;

  const MascotBubble({
    super.key,
    required this.speechText,
    this.mascotName = 'Bolajon AI',
    this.mascotIcon = Icons.smart_toy_rounded,
    this.onTapMascot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTapMascot,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryViolet.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              mascotIcon,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.skyBlue.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mascotName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryViolet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  speechText,
                  style: AppTextStyles.mascotText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
