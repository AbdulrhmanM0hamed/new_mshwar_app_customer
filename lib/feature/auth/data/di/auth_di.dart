import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/repo/auth_repo.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/repo/auth_repo_api.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_cubit.dart';

/// ─────────────────────────────────────────────────────────────
/// Auth feature DI — registers repo + cubit.
/// ─────────────────────────────────────────────────────────────
class AuthDi {
  AuthDi._();

  static void register() {
    // API
    getIt.registerLazySingleton<AuthRepoApi>(() => AuthRepoApi(getIt<Dio>()));

    // Repository
    getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(getIt<AuthRepoApi>()),
    );

    // Cubit — factory (new instance per page)
    getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
  }
}
