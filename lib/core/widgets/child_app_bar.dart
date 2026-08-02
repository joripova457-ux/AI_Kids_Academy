import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'progress_star.dart';

/// Bolalar rejimi uchun mo'ljallangan yuqori panel (ChildAppBar)
class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int starCount;
  final VoidCallback? onBackTap;
  final VoidCallback? onProfileTap;
  final bool showBack;

  const ChildAppBar({
    super.key,
    required this.title,
    this.starCount = 0,
    this.onBackTap,
    this.onProfileTap,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (showBack)
              GestureDetector(
                onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primaryViolet,
                    size: 28,
                  ),
                ),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ProgressStar(
              count: starCount,
              showBadgeLabel: true,
              starSize: 22,
            ),
            if (onProfileTap != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.playfulGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.face_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
