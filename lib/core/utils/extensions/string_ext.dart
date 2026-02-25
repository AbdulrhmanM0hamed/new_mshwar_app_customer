/// ─────────────────────────────────────────────────────────────
/// String extensions.
/// ─────────────────────────────────────────────────────────────
extension StringExt on String {
  /// "hello world" → "Hello World"
  String get capitalizeWords => split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  /// "hello" → "Hello"
  String get capitalizeFirst =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Remove all whitespace.
  String get removeSpaces => replaceAll(' ', '');

  /// Check if string is a valid email.
  bool get isEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(this);

  /// Check if string is numeric.
  bool get isNumeric => double.tryParse(this) != null;

  /// Check if string is a valid phone.
  bool get isPhone =>
      RegExp(r'^[+]?[0-9]{8,15}$').hasMatch(replaceAll(' ', ''));

  /// Check if string is a valid URL.
  bool get isUrl => Uri.tryParse(this)?.hasAbsolutePath ?? false;

  /// Truncate with ellipsis.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';

  /// "null" or empty → null, otherwise the string itself.
  String? get nullIfEmpty => (isEmpty || this == 'null') ? null : this;

  /// Convert Arabic/Eastern numerals to Western.
  String get toEnglishDigits {
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var result = this;
    for (var i = 0; i < eastern.length; i++) {
      result = result.replaceAll(eastern[i], western[i]);
    }
    return result;
  }

  /// Convert Western numerals to Arabic/Eastern.
  String get toArabicDigits {
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var result = this;
    for (var i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    return result;
  }

  /// Contains Arabic characters?
  bool get containsArabic => RegExp(r'[\u0600-\u06FF]').hasMatch(this);

  /// Extract only digits.
  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');
}

/// Nullable string helpers.
extension NullableStringExt on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String orEmpty() => this ?? '';
}
