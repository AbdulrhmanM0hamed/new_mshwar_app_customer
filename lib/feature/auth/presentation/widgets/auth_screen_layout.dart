import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';
import 'package:new_mshwar_app_customer/core/constants/styles_manger.dart';
import 'package:new_mshwar_app_customer/core/constants/font_manger.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth screen layout — consistent modern branding.
///
/// Provides:
///   • Rich gradient header packed with city/transport icons
///   • Floating logo with glow effect
///   • Elevated content card with smooth curves
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
    final screenH = MediaQuery.of(context).size.height;
    final headerH = screenH * 0.38;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          // ── Rich Gradient Header ──
          _GradientHeader(height: headerH),

          // ── Dense Floating City Icons ──
          _FloatingIcons(height: headerH),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar ──
                if (showBackButton || title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    child: Row(
                      children: [
                        if (showBackButton)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
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
                  const SizedBox(height: Spacing.md),

                // ── Logo ──
                const SizedBox(height: Spacing.sm),
                _buildLogo(),
                const SizedBox(height: Spacing.xl),

                // ── Elevated Content Card ──
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, -8),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          blurRadius: 60,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: Spacing.xl,
                          right: Spacing.xl,
                          top: Spacing.xxl,
                          bottom: Spacing.xxxl + 20,
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
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 5),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// ── Gradient header background ──
class _GradientHeader extends StatelessWidget {
  final double height;
  const _GradientHeader({required this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF005F5F), Color(0xFF018484), Color(0xFF029E9E)],
            stops: [0.0, 0.55, 1.0],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
    );
  }
}

/// ── Dense floating city/transport icons scattered in the header ──
class _FloatingIcons extends StatelessWidget {
  final double height;
  const _FloatingIcons({required this.height});

  // Repeatable icon pool — transport & city themed
  static const List<IconData> _iconPool = [
    Icons.directions_car_filled_rounded,
    Icons.local_taxi_rounded,
    Icons.location_city_rounded,
    Icons.apartment_rounded,
    Icons.map_rounded,
    Icons.route_rounded,
    Icons.navigation_rounded,
    Icons.location_on_rounded,
    Icons.two_wheeler_rounded,
    Icons.directions_bus_filled_rounded,
    Icons.home_work_rounded,
    Icons.pin_drop_rounded,
    Icons.near_me_rounded,
    Icons.local_shipping_rounded,
    Icons.flight_rounded,
    Icons.commute_rounded,
    Icons.local_gas_station_rounded,
    Icons.traffic_rounded,
    Icons.speed_rounded,
    Icons.gps_fixed_rounded,
    Icons.explore_rounded,
    Icons.add_road_rounded,
    Icons.alt_route_rounded,
    Icons.departure_board_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final rng = Random(77);
    // Generate 40 scattered icons for a dense pattern
    const count = 40;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Stack(
          children: List.generate(count, (i) {
            final icon = _iconPool[i % _iconPool.length];
            final x = rng.nextDouble() * screenW;
            final y = rng.nextDouble() * height;
            final size = 14.0 + rng.nextDouble() * 22;
            final opacity = 0.07 + rng.nextDouble() * 0.12;
            final rotation = rng.nextDouble() * 0.8 - 0.4;

            return Positioned(
              left: x,
              top: y,
              child: Transform.rotate(
                angle: rotation,
                child: Icon(
                  icon,
                  size: size,
                  color: Colors.white.withValues(alpha: opacity),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
