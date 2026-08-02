import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Interaktiv, bosilganda sakraydigan karta vidjeti (BouncyCard - Mounted Safe)
class BouncyCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double progress; // 0.0 dan 1.0 gacha
  final int? stars;
  final Widget? child;

  const BouncyCard({
    super.key,
    String? title,
    this.subtitle,
    IconData? icon,
    this.color = AppColors.primaryViolet,
    required this.onTap,
    this.progress = 0.0,
    this.stars,
    this.child,
  })  : title = title ?? '',
        icon = icon ?? Icons.star_rounded;

  @override
  State<BouncyCard> createState() => _BouncyCardState();
}

class _BouncyCardState extends State<BouncyCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (mounted) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (mounted) setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        if (mounted) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.child != null ? widget.color : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.15),
                blurRadius: _isPressed ? 6 : 16,
                offset: _isPressed ? const Offset(0, 3) : const Offset(0, 8),
              ),
            ],
          ),
          child: widget.child ??
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      if (widget.stars != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.brightYellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.brightYellow,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.stars}',
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: AppTextStyles.headingMedium,
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                  if (widget.progress > 0) ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: widget.progress.clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: widget.color.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
