import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLangCode = 'app_language_code';

/// Current UI [Locale]: Arabic (default) or English. Persisted in [SharedPreferences].
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    Future.microtask(_restore);
    return const Locale('ar');
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLangCode);
    if (code != null && (code == 'en' || code == 'ar')) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode == 'en' ? 'en' : 'ar';
    state = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLangCode, code);
  }

  bool get isArabic => state.languageCode == 'ar';
}
