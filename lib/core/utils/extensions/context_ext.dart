import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// BuildContext extensions — quick access to theme, media, nav, etc.
/// ─────────────────────────────────────────────────────────────
extension ContextExt on BuildContext {
  // ── Theme ──
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;

  // ── Media ──
  MediaQueryData get mq => MediaQuery.of(this);
  Size get screenSize => mq.size;
  double get screenW => screenSize.width;
  double get screenH => screenSize.height;
  double get statusBar => mq.padding.top;
  double get bottomPad => mq.padding.bottom;
  Orientation get orientation => mq.orientation;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isTablet => screenW >= 600;

  // ── Navigation ──
  NavigatorState get nav => Navigator.of(this);

  void pop<T>([T? result]) => nav.pop(result);

  Future<T?> push<T>(Widget page) =>
      nav.push<T>(MaterialPageRoute(builder: (_) => page));

  Future<T?> pushReplacement<T>(Widget page) =>
      nav.pushReplacement(MaterialPageRoute(builder: (_) => page));

  Future<T?> pushAndClear<T>(Widget page) => nav.pushAndRemoveUntil<T>(
    MaterialPageRoute(builder: (_) => page),
    (_) => false,
  );

  Future<T?> pushNamed<T>(String route, {Object? args}) =>
      nav.pushNamed<T>(route, arguments: args);

  Future<T?> pushReplacementNamed<T>(String route, {Object? args}) =>
      nav.pushReplacementNamed<T, void>(route, arguments: args);

  Future<T?> pushNamedAndClear<T>(String route, {Object? args}) =>
      nav.pushNamedAndRemoveUntil<T>(route, (_) => false, arguments: args);

  // ── SnackBar ──
  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colorScheme.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ── Focus ──
  void unfocus() => FocusScope.of(this).unfocus();

  // ── Localization ──
  LocalizationService get l => LocalizationService.of(this);

  // ── Safe area padding ──
  EdgeInsets get safePadding => EdgeInsets.only(
    top: statusBar,
    bottom: bottomPad,
    left: Spacing.screenH,
    right: Spacing.screenH,
  );
}
