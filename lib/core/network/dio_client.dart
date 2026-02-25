import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';
import 'package:new_mshwar_app_customer/core/constants/app_constants.dart';
import 'package:new_mshwar_app_customer/core/network/interceptors/auth_interceptor.dart';
import 'package:new_mshwar_app_customer/core/network/interceptors/lang_interceptor.dart';
import 'package:new_mshwar_app_customer/core/network/interceptors/logging_interceptor.dart';
import 'package:new_mshwar_app_customer/core/network/interceptors/retry_interceptor.dart';

/// ─────────────────────────────────────────────────────────────
/// Single Dio instance factory — configured once, reused everywhere.
///
/// Features:
///   • Base URL from [Env]
///   • Timeout configuration from [AppConstants]
///   • Auto‑attached interceptors (auth, lang, retry, logging)
/// ─────────────────────────────────────────────────────────────
class DioClient {
  DioClient._();

  static Dio? _instance;

  /// Returns the singleton [Dio] instance. Call after [Env.init()].
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Force‑recreate (useful after environment switch or logout).
  static void reset() {
    _instance?.close();
    _instance = null;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
        sendTimeout: const Duration(seconds: AppConstants.sendTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Order matters — interceptors execute in list order.
    dio.interceptors.addAll([
      AuthInterceptor(),
      LangInterceptor(),
      RetryInterceptor(dio),
      if (!Env.isProd) LoggingInterceptor(),
    ]);

    return dio;
  }
}
