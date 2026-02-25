import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/text_styles.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable confirmation / alert dialog.
/// ─────────────────────────────────────────────────────────────
class AppDialog {
  AppDialog._();

  /// Shows a confirmation dialog. Returns `true` if confirmed.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) {
    final l = LocalizationService.instance;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.h4),
        content: Text(message, style: AppTextStyles.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText ?? l.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? AppColors.primary,
            ),
            child: Text(confirmText ?? l.ok),
          ),
        ],
      ),
    );
  }

  /// Shows a simple info dialog.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final l = LocalizationService.instance;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.h4),
        content: Text(message, style: AppTextStyles.bodyMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.ok),
          ),
        ],
      ),
    );
  }

  /// Destructive confirm — red button.
  static Future<bool?> destructive(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
  }) {
    final l = LocalizationService.instance;
    return confirm(
      context,
      title: title,
      message: message,
      confirmText: confirmText ?? l.delete_,
      confirmColor: AppColors.error,
    );
  }
}
