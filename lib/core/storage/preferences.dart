import 'package:hive_flutter/hive_flutter.dart';

/// ─────────────────────────────────────────────────────────────
/// Wrapper around Hive for simple key‑value storage.
///
/// ⚡ Hive is blazing‑fast & synchronous for reads.
/// Call [Preferences.init()] once at app startup.
/// ─────────────────────────────────────────────────────────────
class Preferences {
  Preferences._();

  static const String _boxName = 'app_preferences';
  static late Box _box;

  /// Must be called before any read/write.
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  // ── Generic ─────────────────────────────────────────────

  static T? get<T>(String key, {T? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> set<T>(String key, T value) {
    return _box.put(key, value);
  }

  static Future<void> remove(String key) {
    return _box.delete(key);
  }

  static Future<void> clear() {
    return _box.clear();
  }

  static bool containsKey(String key) {
    return _box.containsKey(key);
  }

  // ── Typed helpers ──────────────────────────────────────

  static String? getString(String key) => get<String>(key);

  static Future<void> setString(String key, String value) =>
      set<String>(key, value);

  static int? getInt(String key) => get<int>(key);

  static Future<void> setInt(String key, int value) => set<int>(key, value);

  static double? getDouble(String key) => get<double>(key);

  static Future<void> setDouble(String key, double value) =>
      set<double>(key, value);

  static bool getBool(String key, {bool defaultValue = false}) =>
      get<bool>(key) ?? defaultValue;

  static Future<void> setBool(String key, bool value) => set<bool>(key, value);

  // ── Convenience for common data ────────────────────────

  static String? get token => getString('auth_token');
  static Future<void> setToken(String value) => setString('auth_token', value);
  static Future<void> clearToken() => remove('auth_token');

  static String? get userId => getString('user_id');
  static Future<void> setUserId(String value) => setString('user_id', value);

  static String? get userJson => getString('user_data');
  static Future<void> setUserJson(String value) =>
      setString('user_data', value);
  static Future<void> clearUserData() => remove('user_data');

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static bool get isFirstLaunch =>
      getBool('is_first_launch', defaultValue: true);
  static Future<void> setFirstLaunchDone() => setBool('is_first_launch', false);

  /// Clears all auth‑related data (logout).
  static Future<void> logout() async {
    await clearToken();
    await clearUserData();
    await remove('user_id');
  }
}
