import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// ─────────────────────────────────────────────────────────────
/// Centralised logger — zero‑cost in release mode.
///
/// Uses [dart:developer] log so it shows in DevTools.
/// All methods are no‑ops in release builds.
/// ─────────────────────────────────────────────────────────────
class AppLogger {
  AppLogger._();

  static const String _tag = '🚀 Mshwar';

  static void info(String message, [String? tag]) {
    _log(message, tag: tag ?? _tag, level: 800);
  }

  static void debug(String message, [String? tag]) {
    _log(message, tag: tag ?? '🐛 DEBUG', level: 500);
  }

  static void warning(String message, [String? tag]) {
    _log(message, tag: tag ?? '⚠️ WARNING', level: 900);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(
      message,
      tag: '❌ ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(String message) {
    _log(message, tag: '🌐 NETWORK', level: 700);
  }

  static void bloc(String message) {
    _log(message, tag: '🧊 BLOC', level: 600);
  }

  static void navigation(String message) {
    _log(message, tag: '🧭 NAV', level: 600);
  }

  static void storage(String message) {
    _log(message, tag: '💾 STORAGE', level: 600);
  }

  static void _log(
    String message, {
    required String tag,
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;
    dev.log(
      message,
      name: tag,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
