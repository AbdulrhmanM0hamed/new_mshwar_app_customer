import 'package:dio/dio.dart';
import 'package:new_mshwar_app_customer/core/storage/preferences.dart';
import 'package:new_mshwar_app_customer/core/constants/keys.dart';
import 'package:new_mshwar_app_customer/core/localization/supported_locales.dart';

/// ─────────────────────────────────────────────────────────────
/// Sends the current app language in headers so the backend
/// can return localised content.
/// ─────────────────────────────────────────────────────────────
class LangInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final langCode =
        Preferences.getString(StorageKeys.languageCode) ??
        SupportedLocales.defaultLocale.languageCode;

    options.headers['Accept-Language'] = langCode;
    // Some backends use a custom header:
    options.headers['X-Lang'] = langCode;

    handler.next(options);
  }
}
