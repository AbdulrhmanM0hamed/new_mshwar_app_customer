import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/localization/locale_cubit.dart';
import 'package:new_mshwar_app_customer/core/theme/theme_cubit.dart';

/// ─────────────────────────────────────────────────────────────
/// Registers localization & theme cubits in GetIt.
/// ─────────────────────────────────────────────────────────────
class LocalizationModule {
  LocalizationModule._();

  static void register() {
    getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
    getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  }
}
