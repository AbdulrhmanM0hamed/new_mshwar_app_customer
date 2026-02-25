import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_mshwar_app_customer/core/app/env.dart';
import 'package:new_mshwar_app_customer/core/storage/preferences.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';
import 'package:new_mshwar_app_customer/core/localization/supported_locales.dart';
import 'package:new_mshwar_app_customer/core/constants/keys.dart';
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';

/// ─────────────────────────────────────────────────────────────
/// Bootstraps everything before runApp():
///   1. Flutter bindings
///   2. Hive storage
///   3. Environment
///   4. Localization
///   5. DI
///   6. System UI
/// ─────────────────────────────────────────────────────────────
class AppInitializer {
  AppInitializer._();

  static Future<void> init({Environment env = Environment.dev}) async {
    // 1. Ensure Flutter is ready
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Hive (local storage)
    await Preferences.init();
    AppLogger.info('✅ Hive initialised');

    // 3. Environment
    Env.init(env);
    AppLogger.info('✅ Environment: ${env.name} → ${Env.baseUrl}');

    // 4. Localization
    final savedLang = Preferences.getString(StorageKeys.languageCode);
    final locale = savedLang != null
        ? SupportedLocales.fromCode(savedLang)
        : SupportedLocales.defaultLocale;
    LocalizationService.init(locale);
    AppLogger.info('✅ Locale: ${locale.languageCode}');

    // 5. DI
    await configureDependencies();
    AppLogger.info('✅ Dependencies registered');

    // 6. System UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    AppLogger.info('🚀 App initialisation complete');
  }
}
