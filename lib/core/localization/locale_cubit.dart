import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/localization/supported_locales.dart';
import 'package:new_mshwar_app_customer/core/localization/localization_service.dart';
import 'package:new_mshwar_app_customer/core/storage/preferences.dart';
import 'package:new_mshwar_app_customer/core/constants/keys.dart';

/// ─────────────────────────────────────────────────────────────
/// Manages the current app locale via Bloc.
/// Persists the user's language choice in Hive.
/// ─────────────────────────────────────────────────────────────

// ── State ──
class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}

// ── Cubit ──
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(_loadSavedLocale()));

  static Locale _loadSavedLocale() {
    final code = Preferences.getString(StorageKeys.languageCode);
    if (code != null) return SupportedLocales.fromCode(code);
    return SupportedLocales.defaultLocale;
  }

  void changeLocale(Locale locale) {
    Preferences.setString(StorageKeys.languageCode, locale.languageCode);
    LocalizationService.instance.setLocale(locale);
    emit(LocaleState(locale));
  }

  void toggleArabicEnglish() {
    final next = state.locale.languageCode == 'ar'
        ? SupportedLocales.english
        : SupportedLocales.arabic;
    changeLocale(next);
  }

  bool get isRtl => SupportedLocales.isRtl(state.locale);
}
