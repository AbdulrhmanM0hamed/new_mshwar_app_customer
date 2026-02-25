/// ─────────────────────────────────────────────────────────────
/// Environment configuration — switch between dev / staging / prod.
/// ─────────────────────────────────────────────────────────────
enum Environment { dev, staging, prod }

class Env {
  Env._();

  static Environment _current = Environment.dev;
  static Environment get current => _current;

  static void init(Environment env) => _current = env;

  static bool get isDev => _current == Environment.dev;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProd => _current == Environment.prod;

  /// API Key — mandatory in all request headers as `apikey`.
  static const String apiKey =
      'base64:Npu3FfBZFo1sxlY/LBzHY/VwL59xbfNoCJUZzCkYtKY=';

  /// Default user category.
  static const String userCategory = 'customer';

  /// Default country code (Kuwait).
  static const String defaultCountryCode = '965';

  /// Base URL per environment.
  static String get baseUrl {
    return switch (_current) {
      Environment.dev => 'https://mshwar-app.com/api/v1',
      Environment.staging => 'https://mshwar-app.com/api/v1',
      Environment.prod => 'https://mshwar-app.com/api/v1',
    };
  }

  /// Socket / WebSocket URL if needed.
  static String get socketUrl {
    return switch (_current) {
      Environment.dev => 'wss://mshwar-app.com',
      Environment.staging => 'wss://mshwar-app.com',
      Environment.prod => 'wss://mshwar-app.com',
    };
  }

  /// Google Maps key (example — replace with real keys).
  static String get googleMapsKey {
    return switch (_current) {
      Environment.dev => 'DEV_MAPS_KEY',
      Environment.staging => 'STAGING_MAPS_KEY',
      Environment.prod => 'PROD_MAPS_KEY',
    };
  }
}
