import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/network/dio_client.dart';
import 'package:new_mshwar_app_customer/core/network/network_info.dart';

/// ─────────────────────────────────────────────────────────────
/// Registers network‑related singletons in GetIt.
/// ─────────────────────────────────────────────────────────────
class NetworkModule {
  NetworkModule._();

  static void register() {
    // Dio client
    getIt.registerLazySingleton<Dio>(() => DioClient.instance);

    // Connectivity
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());

    // Network info
    getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(getIt<Connectivity>()),
    );
  }
}
