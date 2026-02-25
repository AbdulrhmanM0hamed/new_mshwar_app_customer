import 'dart:async';

/// ─────────────────────────────────────────────────────────────
/// Limits how often a function fires — perfect for search input.
///
/// Usage:
///   final _debouncer = Debouncer();
///
///   onChanged: (query) {
///     _debouncer.run(() => cubit.search(query));
///   }
///
///   dispose:
///     _debouncer.dispose();
/// ─────────────────────────────────────────────────────────────
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel pending callback.
  void cancel() {
    _timer?.cancel();
  }

  /// Permanently cancel. Call in widget dispose.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer?.isActive ?? false;
}
