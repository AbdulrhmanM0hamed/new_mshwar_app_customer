import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';

/// ─────────────────────────────────────────────────────────────
/// Global navigation without BuildContext — useful from Cubits,
/// interceptors, or services.
///
/// Attach the [navigatorKey] to your MaterialApp:
///   MaterialApp(navigatorKey: NavigationService.navigatorKey, …)
/// ─────────────────────────────────────────────────────────────
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get _nav => navigatorKey.currentState;
  static BuildContext? get context => navigatorKey.currentContext;

  // ── Push ──
  static Future<T?>? push<T>(String routeName, {Object? arguments}) {
    AppLogger.navigation('NavigationService → $routeName');
    return _nav?.pushNamed<T>(routeName, arguments: arguments);
  }

  // ── Push replacement ──
  static Future<T?>? pushReplacement<T>(String routeName, {Object? arguments}) {
    return _nav?.pushReplacementNamed<T, void>(routeName, arguments: arguments);
  }

  // ── Push and clear ──
  static Future<T?>? pushAndClear<T>(String routeName, {Object? arguments}) {
    return _nav?.pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  // ── Pop ──
  static void pop<T>([T? result]) => _nav?.pop(result);

  // ── Can pop? ──
  static bool canPop() => _nav?.canPop() ?? false;

  // ── Pop to root ──
  static void popToRoot() {
    _nav?.popUntil((route) => route.isFirst);
  }
}
