import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/network/dio_client.dart';

/// ─────────────────────────────────────────────────────────────
/// Base class for Retrofit API clients.
///
/// Each feature creates its own Retrofit client that extends
/// or uses this via `@RestApi(baseUrl: '')`.
///
/// Usage in a feature:
/// ```dart
/// @RestApi()
/// abstract class AuthApi {
///   factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;
///
///   @POST('/auth/login')
///   Future<LoginResponse> login(@Body() LoginRequest body);
/// }
///
/// // Registration in DI:
/// getIt.registerLazySingleton(() => AuthApi(DioClient.instance));
/// ```
/// ─────────────────────────────────────────────────────────────
class RetrofitClient {
  RetrofitClient._();

  /// Provides the configured [Dio] for Retrofit code‑gen factories.
  static Dio get dio => DioClient.instance;
}
