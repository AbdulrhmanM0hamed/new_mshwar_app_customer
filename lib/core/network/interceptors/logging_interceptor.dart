import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';

/// ─────────────────────────────────────────────────────────────
/// Pretty‑prints request / response / error for dev builds.
/// Automatically skipped in production via [DioClient].
/// ─────────────────────────────────────────────────────────────
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.network(
      '┌── REQUEST ─────────────────────────────\n'
      '│ ${options.method} ${options.uri}\n'
      '│ Headers: ${options.headers}\n'
      '│ Body: ${options.data}\n'
      '└────────────────────────────────────────',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.network(
      '┌── RESPONSE ────────────────────────────\n'
      '│ ${response.statusCode} ${response.requestOptions.uri}\n'
      '│ Data: ${_truncate(response.data.toString(), 500)}\n'
      '└────────────────────────────────────────',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '┌── ERROR ───────────────────────────────\n'
      '│ ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      '│ Message: ${err.message}\n'
      '│ Response: ${_truncate(err.response?.data?.toString() ?? '', 500)}\n'
      '└────────────────────────────────────────',
    );
    handler.next(err);
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…[truncated]';
  }
}
