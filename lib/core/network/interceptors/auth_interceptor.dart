import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/storage/preferences.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';

/// ─────────────────────────────────────────────────────────────
/// Attaches the accesstoken + apikey to every outgoing request.
/// If a 401 is received, clears credentials and could trigger
/// a navigation to login (via a callback or event bus).
/// ─────────────────────────────────────────────────────────────
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // API key — mandatory for all requests
    options.headers['apikey'] = Env.apiKey;

    // Access token — if logged in
    final token = Preferences.token;
    if (token != null && token.isNotEmpty) {
      options.headers['accesstoken'] = token;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired / invalid — clear and let the app handle re‑login.
      Preferences.clearToken();
      // MIGRATION_TODO: broadcast session‑expired event when needed.
    }
    handler.next(err);
  }
}
