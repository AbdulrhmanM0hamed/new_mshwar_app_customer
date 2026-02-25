import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/error/failure.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Maps [Failure] objects → user‑facing localised strings.
///
/// Usage:
///   final msg = ErrorMapper.toMessage(context, failure);
///   // or without context (uses current locale):
///   final msg = ErrorMapper.toMessageRaw(failure);
/// ─────────────────────────────────────────────────────────────
class ErrorMapper {
  ErrorMapper._();

  /// Returns a localised, user‑friendly message for the given [failure].
  static String toMessage(BuildContext context, Failure failure) {
    final l = LocalizationService.of(context);
    return _resolve(l, failure);
  }

  /// Same as [toMessage] but uses the global [LocalizationService] instance
  /// when you don't have a [BuildContext] (e.g. inside a Cubit).
  static String toMessageRaw(Failure failure) {
    final l = LocalizationService.instance;
    return _resolve(l, failure);
  }

  static String _resolve(LocalizationService l, Failure failure) {
    // If the server already sent a user‑facing message, use it directly.
    if (failure is ServerFailure && failure.message.length > 3) {
      return failure.message;
    }

    return switch (failure) {
      NetworkFailure() => l.noInternetConnection,
      ServerFailure() => l.serverError,
      CacheFailure() => l.cacheError,
      ValidationFailure() => l.validationError,
      AuthFailure() => l.unauthorized,
      UnexpectedFailure() => l.unexpectedError,
      _ => l.unexpectedError,
    };
  }
}
