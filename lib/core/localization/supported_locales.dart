import 'dart:ui';

/// ─────────────────────────────────────────────────────────────
/// All locales supported by the application.
/// ─────────────────────────────────────────────────────────────
class SupportedLocales {
  SupportedLocales._();

  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');
  static const Locale urdu = Locale('ur');

  static const Locale defaultLocale = arabic;

  static const List<Locale> all = [arabic, english, urdu];

  /// RTL locales
  static const List<String> rtlLanguages = ['ar', 'ur'];

  static bool isRtl(Locale locale) =>
      rtlLanguages.contains(locale.languageCode);

  static Locale fromCode(String code) {
    return all.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => defaultLocale,
    );
  }
}
