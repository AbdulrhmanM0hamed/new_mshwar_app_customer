/// ─────────────────────────────────────────────────────────────
/// Registers storage‑related singletons in GetIt.
///
/// Note: [Preferences.init()] must be called BEFORE this module
///       (handled by AppInitializer).
/// ─────────────────────────────────────────────────────────────
class StorageModule {
  StorageModule._();

  static void register() {
    // Preferences is static‑only, no instance registration needed.
    // SecureStorage is also static‑only.
    //
    // If you need to inject them as abstractions for testing:
    // getIt.registerLazySingleton<Preferences>(() => Preferences());
    // getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());
  }
}
