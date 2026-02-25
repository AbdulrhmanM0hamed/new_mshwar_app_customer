/// ─────────────────────────────────────────────────────────────
/// Read‑only app configuration — injected at startup.
/// ─────────────────────────────────────────────────────────────
class AppConfig {
  final String appName;
  final String baseUrl;
  final bool enableLogging;

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    this.enableLogging = false,
  });
}
