import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';

import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth screen layout — consistent modern branding.
///
/// Provides:
///   • Elegant top gradient
///   • Floating circular logo
///   • Elevated content card with large borders
/// ─────────────────────────────────────────────────────────────
class AuthScreenLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBackButton;

  const AuthScreenLayout({
    super.key,
    required this.child,
    this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Elegant Background Header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.42,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar (back + title) ──
                if (showBackButton || title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      children: [
                        if (showBackButton)
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          )
                        else
                          const SizedBox(width: 48),
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              textAlign: TextAlign.center,
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: Spacing.xl),

                // ── Logo ──
                const SizedBox(height: Spacing.md),
                _buildLogo(),
                const SizedBox(height: Spacing.xxl),

                // ── Elevated Content Card ──
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: Spacing.xl,
                          right: Spacing.xl,
                          top: Spacing.xxl,
                          bottom: Spacing.xxl * 2,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
