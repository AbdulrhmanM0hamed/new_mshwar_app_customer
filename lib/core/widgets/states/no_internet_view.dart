import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/text_styles.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_button.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// No internet connection view with retry.
/// ─────────────────────────────────────────────────────────────
class NoInternetView extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? imagePath;

  const NoInternetView({super.key, this.onRetry, this.imagePath});

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
              const Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: AppColors.disabled,
              ),
            const SizedBox(height: Spacing.lg),
            Text(
              l.noInternet,
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l.noInternetDesc,
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
