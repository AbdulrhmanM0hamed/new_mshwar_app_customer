import 'package:equatable/equatable.dart';

/// ─────────────────────────────────────────────────────────────
/// Base failure class — all domain‑level errors extend this.
/// Using [Equatable] so two failures with the same data compare equal.
///
/// ⚠️  [message] stores an English key / raw server message.
///     Use [ErrorMapper] to get the localised user‑facing text.
/// ─────────────────────────────────────────────────────────────
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// ── Concrete failure types ──────────────────────────────────

/// Returned when a network call fails (timeout, no connection, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

/// Returned when the server responds with an error body.
class ServerFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ServerFailure({required super.message, super.statusCode, this.errors});

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Returned when local storage read/write fails.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Returned when input validation fails before hitting the API.
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  const ValidationFailure({required super.message, this.fieldErrors});

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Returned when the user is not authenticated / token expired.
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// Generic / unexpected failures.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'unexpected_error',
    super.statusCode,
  });
}
