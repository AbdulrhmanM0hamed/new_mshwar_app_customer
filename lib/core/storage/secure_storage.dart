import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ─────────────────────────────────────────────────────────────
/// Secure storage for sensitive data (tokens, secrets).
/// Uses platform Keychain (iOS) / EncryptedSharedPrefs (Android).
/// ─────────────────────────────────────────────────────────────
class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Generic ─────────────────────────────────────────────

  static Future<String?> read(String key) => _storage.read(key: key);

  static Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  static Future<void> delete(String key) => _storage.delete(key: key);

  static Future<void> deleteAll() => _storage.deleteAll();

  static Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  // ── Convenience ────────────────────────────────────────

  static Future<String?> get accessToken => read('access_token');
  static Future<void> setAccessToken(String value) =>
      write('access_token', value);

  static Future<String?> get refreshToken => read('refresh_token');
  static Future<void> setRefreshToken(String value) =>
      write('refresh_token', value);

  /// Clears all secure credentials.
  static Future<void> clearCredentials() async {
    await delete('access_token');
    await delete('refresh_token');
  }
}
