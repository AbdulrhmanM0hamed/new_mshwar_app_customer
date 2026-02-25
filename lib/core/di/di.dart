import 'package:get_it/get_it.dart';
import 'package:new_mshwar_app_customer/core/di/modules/network_module.dart';
import 'package:new_mshwar_app_customer/core/di/modules/storage_module.dart';
import 'package:new_mshwar_app_customer/core/di/modules/localization_module.dart';
import 'package:new_mshwar_app_customer/feature/auth/data/di/auth_di.dart';

/// ─────────────────────────────────────────────────────────────
/// Global GetIt instance — ONE single instance for the whole app.
///
/// Call [configureDependencies()] in AppInitializer.
/// Features register their own deps via feature‑level DI files.
/// ─────────────────────────────────────────────────────────────
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Core modules ──
  NetworkModule.register();
  StorageModule.register();
  LocalizationModule.register();

  // ── Feature DI ──
  AuthDi.register();
}
