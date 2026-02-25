import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/text_styles.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/durations.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Snackbar / Toast helpers.
///
/// Supports two modes:
/// 1. With BuildContext → `AppSnackbar.error(context, msg)`
/// 2. Without context (global) → `AppSnackbar.showGlobal(msg)`
///
/// For global mode, set [scaffoldMessengerKey] on your MaterialApp:
///   MaterialApp(scaffoldMessengerKey: AppSnackbar.messengerKey, …)
/// ─────────────────────────────────────────────────────────────
class AppSnackbar {
  AppSnackbar._();

  /// Global key — attach to [MaterialApp.scaffoldMessengerKey].
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // ── With context ──

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
    bool isWarning = false,
    Duration? duration,
    SnackBarAction? action,
  }) {
    _display(
      ScaffoldMessenger.of(context),
      message,
      isError: isError,
      isSuccess: isSuccess,
      isWarning: isWarning,
      duration: duration,
      action: action,
    );
  }

  static void error(BuildContext context, String message) =>
      show(context, message, isError: true);

  static void success(BuildContext context, String message) =>
      show(context, message, isSuccess: true);

  static void warning(BuildContext context, String message) =>
      show(context, message, isWarning: true);

  // ── Without context (global) ──

  static void showGlobal(
    String message, {
    bool isError = false,
    bool isSuccess = false,
    bool isWarning = false,
    Duration? duration,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    _display(
      messenger,
      message,
      isError: isError,
      isSuccess: isSuccess,
      isWarning: isWarning,
      duration: duration,
    );
  }

  static void errorGlobal(String message) => showGlobal(message, isError: true);

  static void successGlobal(String message) =>
      showGlobal(message, isSuccess: true);

  // ── Internal ──

  static void _display(
    dynamic messenger,
    String message, {
    bool isError = false,
    bool isSuccess = false,
    bool isWarning = false,
    Duration? duration,
    SnackBarAction? action,
  }) {
    Color bg = AppColors.textPrimary;
    IconData icon = Icons.info_outline_rounded;

    if (isError) {
      bg = AppColors.error;
      icon = Icons.error_outline_rounded;
    }
    if (isSuccess) {
      bg = AppColors.success;
      icon = Icons.check_circle_outline_rounded;
    }
    if (isWarning) {
      bg = AppColors.warning;
      icon = Icons.warning_amber_rounded;
    }

    final translatedMessage = LocalizationService.instance.translate(message);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              translatedMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.sm,
      ),
      elevation: 8,
      duration: duration ?? AppDurations.snackbar,
      action: action,
    );

    if (messenger is ScaffoldMessengerState) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}
