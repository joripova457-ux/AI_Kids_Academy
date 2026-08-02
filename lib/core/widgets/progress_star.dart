import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Yulduzli progress indikatori va reyting vidjeti
class ProgressStar extends StatefulWidget {
  final int count;
  final int total;
  final double starSize;
  final bool showBadgeLabel;

  const ProgressStar({
    super.key,
    required this.count,
    this.total = 5,
    this.starSize = 32.0,
    this.showBadgeLabel = false,
  });

  @override
  State<ProgressStar> createState() => _ProgressStarState();
}

class _ProgressStarState extends State<ProgressStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(covariant ProgressStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBadgeLabel) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.brightYellow.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.star_rounded,
                color: AppColors.brightYellow,
                size: widget.starSize,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${widget.count}',
              style: AppTextStyles.starCounter,
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.total, (index) {
        final isEarned = index < widget.count;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ScaleTransition(
            scale: isEarned && index == widget.count - 1
                ? _scaleAnimation
                : const AlwaysStoppedAnimation(1.0),
            child: Icon(
              isEarned ? Icons.star_rounded : Icons.star_border_rounded,
              color: isEarned
                  ? AppColors.brightYellow
                  : Colors.grey.shade300,
              size: widget.starSize,
            ),
          ),
        );
      }),
    );
  }
}
