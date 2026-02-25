import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';
import 'package:new_mshwar_app_customer/core/utils/extensions/context_ext.dart';

/// ─────────────────────────────────────────────────────────────
/// Social login buttons (Google / Apple).
/// ─────────────────────────────────────────────────────────────
class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final bool isLoading;

  const SocialLoginButtons({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return Column(
      children: [
        // ── OR divider ──
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.divider, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              child: Text(
                l.or_,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  color: AppColors.textSecondary,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.divider, thickness: 1),
            ),
          ],
        ),
        const SizedBox(height: Spacing.lg),

        // ── Google ──
        _SocialButton(
          label: l.signInWithGoogle,
          icon: Icons.g_mobiledata_rounded,
          iconColor: const Color(0xFFDB4437),
          onTap: isLoading ? null : onGoogleTap,
        ),
        const SizedBox(height: Spacing.md),

        // ── Apple ──
        _SocialButton(
          label: l.signInWithApple,
          icon: Icons.apple_rounded,
          iconColor: Colors.black,
          onTap: isLoading ? null : onAppleTap,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.buttonRadius),
        child: Container(
          width: double.infinity,
          height: Spacing.buttonHeight + 4,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(width: Spacing.sm),
              Text(
                label,
                style: getSemiBoldStyle(
                  fontSize: FontSize.size15,
                  color: AppColors.textPrimary,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
