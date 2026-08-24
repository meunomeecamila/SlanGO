import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mantém e persiste o idioma escolhido pela pessoa usuária.
class LanguageService extends ChangeNotifier {
  static const _preferenceKey = 'selected_locale';
  Locale _locale = const Locale('pt');

  Locale get locale => _locale;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_preferenceKey);
    if (const {'pt', 'en', 'es', 'it'}.contains(languageCode)) {
      _locale = Locale(languageCode!);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!const {'pt', 'en', 'es', 'it'}.contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, locale.languageCode);
  }
}