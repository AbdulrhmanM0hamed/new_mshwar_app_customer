import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/constants/app_constants.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';

/// ─────────────────────────────────────────────────────────────
/// Auto‑retries failed requests due to network issues.
///
/// Retries on:  connection timeout, send timeout, receive timeout,
///              connection error.
/// Does NOT retry on: cancelled, bad response (4xx/5xx).
/// ─────────────────────────────────────────────────────────────
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int _maxRetries;
  final Duration _retryDelay;

  RetryInterceptor(
    this._dio, {
    int maxRetries = AppConstants.maxRetries,
    Duration retryDelay = const Duration(seconds: 1),
  }) : _maxRetries = maxRetries,
       _retryDelay = retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final attempt = (err.requestOptions.extra['retry_count'] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      AppLogger.warning(
        'Retry limit reached (${_maxRetries}x) for '
        '${err.requestOptions.uri}',
      );
      return handler.next(err);
    }

    err.requestOptions.extra['retry_count'] = attempt + 1;
    AppLogger.info(
      'Retrying (${attempt + 1}/$_maxRetries) ${err.requestOptions.uri}',
    );

    await Future.delayed(_retryDelay * (attempt + 1)); // exponential‑ish

    try {
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      _ => false,
    };
  }
}
