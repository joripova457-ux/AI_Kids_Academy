import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum BigRoundButtonVariant { primary, secondary, success, warning, playful }

/// Bolalar uchun interaktiv, animatsiyali va yirik tugma vidjeti
class BigRoundButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BigRoundButtonVariant variant;
  final bool isLoading;
  final double height;

  const BigRoundButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.variant = BigRoundButtonVariant.primary,
    this.isLoading = false,
    this.height = 64,
  });

  @override
  State<BigRoundButton> createState() => _BigRoundButtonState();
}

class _BigRoundButtonState extends State<BigRoundButton> {
  bool _isPressed = false;

  LinearGradient get _gradient {
    switch (widget.variant) {
      case BigRoundButtonVariant.secondary:
        return AppColors.secondaryGradient;
      case BigRoundButtonVariant.success:
        return AppColors.successGradient;
      case BigRoundButtonVariant.warning:
        return AppColors.warmGradient;
      case BigRoundButtonVariant.playful:
        return AppColors.playfulGradient;
      case BigRoundButtonVariant.primary:
        return AppColors.primaryGradient;
    }
  }

  Color get _shadowColor {
    switch (widget.variant) {
      case BigRoundButtonVariant.secondary:
        return AppColors.skyBlue;
      case BigRoundButtonVariant.success:
        return AppColors.tealDark;
      case BigRoundButtonVariant.warning:
        return AppColors.warmCoral;
      case BigRoundButtonVariant.playful:
        return AppColors.playfulPink;
      case BigRoundButtonVariant.primary:
        return AppColors.primaryVioletDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed == null || widget.isLoading
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null || widget.isLoading
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: widget.onPressed == null || widget.isLoading
          ? null
          : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: _gradient,
            borderRadius: BorderRadius.circular(widget.height / 2),
            boxShadow: [
              BoxShadow(
                color: _shadowColor.withValues(alpha: 0.4),
                offset: _isPressed ? const Offset(0, 2) : const Offset(0, 6),
                blurRadius: _isPressed ? 4 : 12,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading) ...[
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
              ] else if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                widget.text,
                style: AppTextStyles.buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
