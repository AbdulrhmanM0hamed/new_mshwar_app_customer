import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/text_styles.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_button.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic error view with retry button.
/// ─────────────────────────────────────────────────────────────
class ErrorView extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? imagePath;
  final IconData? icon;

  const ErrorView({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l = LocalizationService.instance;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, height: 150)
            else
              Icon(
                icon ?? Icons.error_outline_rounded,
                size: 80,
                color: AppColors.error,
              ),
            const SizedBox(height: Spacing.lg),
            Text(
              title ?? l.errorOccurred,
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              message ?? l.errorOccurredDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.xl),
              AppButton(text: l.retry, onPressed: onRetry, isExpanded: false),
            ],
          ],
        ),
      ),
    );
  }
}
