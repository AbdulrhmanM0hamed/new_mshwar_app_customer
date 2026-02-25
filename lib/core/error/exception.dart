/// Custom exceptions thrown at the data layer.
library;

/// Custom exceptions thrown at the data layer.
/// These are caught in repositories and mapped to [Failure]s.
///
/// ⚠️  NO hardcoded user‑facing strings here.
///     Use keys / codes → resolved to localised text via [ErrorMapper].
/// ─────────────────────────────────────────────────────────────

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ServerException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'no_internet_connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'cache_error'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException({this.message = 'unauthorized'});

  @override
  String toString() => 'AuthException: $message';
}

class ConnectionTimeoutException implements Exception {
  final String message;
  const ConnectionTimeoutException({this.message = 'connection_timeout'});

  @override
  String toString() => 'ConnectionTimeoutException: $message';
}
