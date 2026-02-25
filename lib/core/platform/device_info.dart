import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ─────────────────────────────────────────────────────────────
/// Device info helper (optional utility).
/// ─────────────────────────────────────────────────────────────
class DeviceInfo {
  DeviceInfo._();

  /// Screen width.
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Screen height.
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Status bar height.
  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  /// Bottom safe area.
  static double bottomSafeArea(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  /// Is tablet (width ≥ 600).
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600;

  /// Is landscape.
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Set status bar style.
  static void setStatusBarLight() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  static void setStatusBarDark() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
