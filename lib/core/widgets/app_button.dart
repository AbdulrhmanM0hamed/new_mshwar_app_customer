import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable button with loading state, icon, and variants.
/// ─────────────────────────────────────────────────────────────
enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
  });

  /// Named factories for convenience.
  const AppButton.filled({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
  }) : variant = AppButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final h = height ?? Spacing.buttonHeight;
    final r = borderRadius ?? Spacing.buttonRadius;

    Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == AppButtonVariant.filled
                  ? AppColors.textOnPrimary
                  : effectiveColor,
            ),
          )
        : _buildContent(effectiveColor);

    Widget button;
    switch (variant) {
      case AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: textColor ?? AppColors.textOnPrimary,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            elevation: 0,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            side: BorderSide(color: effectiveColor),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
          ),
          child: child,
        );
        break;
    }
    return button;
  }

  Widget _buildContent(Color effectiveColor) {
    final style = getSemiBoldStyle(
      fontSize: FontSize.size16,
      fontFamily: FontConstant.cairo,
      color: variant == AppButtonVariant.filled
          ? (textColor ?? AppColors.textOnPrimary)
          : (textColor ?? effectiveColor),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: Spacing.sm),
          Text(text, style: style),
        ],
      );
    }
    return Text(text, style: style);
  }
}
