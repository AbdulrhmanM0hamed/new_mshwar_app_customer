/// ─────────────────────────────────────────────────────────────
/// App‑wide constants. Values that NEVER change at runtime.
/// ─────────────────────────────────────────────────────────────
class AppConstants {
  AppConstants._();

  // ── App info ──
  static const String appName = 'Mshwar';
  static const String appNameAr = 'مشوار';
  static const String packageName = 'com.mshwar.customer';

  // ── Network ──
  static const int connectTimeout = 30; // seconds
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  static const int maxRetries = 3;

  // ── Pagination ──
  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  // ── Cache ──
  static const int cacheMaxAge = 7; // days

  // ── Input limits ──
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;
}
