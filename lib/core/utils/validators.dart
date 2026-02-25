import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Input validation helpers.
///
/// Each method returns `null` if valid, or a localised error
/// string if invalid — ready for TextFormField validators.
/// ─────────────────────────────────────────────────────────────
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegex = RegExp(r'^[+]?[0-9]{8,15}$');

  static final RegExp _arabicRegex = RegExp(r'[\u0600-\u06FF]');

  /// Not empty.
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationService.instance.fieldRequired;
    }
    return null;
  }

  /// Valid e‑mail.
  static String? email(String? value) {
    final req = required(value);
    if (req != null) return req;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return LocalizationService.instance.invalidEmail;
    }
    return null;
  }

  /// Valid phone.
  static String? phone(String? value) {
    final req = required(value);
    if (req != null) return req;
    if (!_phoneRegex.hasMatch(value!.trim())) {
      return LocalizationService.instance.invalidPhone;
    }
    return null;
  }

  /// Minimum length.
  static String? minLength(String? value, int min) {
    final req = required(value);
    if (req != null) return req;
    if (value!.trim().length < min) {
      return LocalizationService.instance.passwordTooShort;
    }
    return null;
  }

  /// Password (min 6).
  static String? password(String? value) => minLength(value, 6);

  /// Confirm password matches.
  static String? confirmPassword(String? value, String password) {
    final req = required(value);
    if (req != null) return req;
    if (value!.trim() != password.trim()) {
      return LocalizationService.instance.passwordsNotMatch;
    }
    return null;
  }

  /// Numeric only.
  static String? numeric(String? value) {
    final req = required(value);
    if (req != null) return req;
    if (double.tryParse(value!) == null) {
      return 'Invalid number';
    }
    return null;
  }

  /// Check if text contains Arabic.
  static bool containsArabic(String text) => _arabicRegex.hasMatch(text);
}
