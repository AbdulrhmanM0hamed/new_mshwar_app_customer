import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/text_styles.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic empty‑state view.
/// ─────────────────────────────────────────────────────────────
class EmptyView extends StatelessWidget {
  final String? title;
  final String? message;
  final String? imagePath;
  final IconData? icon;
  final Widget? action;

  const EmptyView({
    super.key,
    this.title,
    this.message,
    this.imagePath,
    this.icon,
    this.action,
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
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: AppColors.disabled,
              ),
            const SizedBox(height: Spacing.lg),
            Text(
              title ?? l.emptyHere,
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              message ?? l.emptyHereDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: Spacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
