import 'package:flutter/material.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/language_translator.dart';

class LanguageService with ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();

  factory LanguageService() {
    return _instance;
  }

  LanguageService._internal();

  String _currentLanguage =
      PreferencesService().prefs.getString(AppConstants.language) ??
          AppConstants.catalan;

  String get currentLanguage => _currentLanguage;

  Locale get locale => parseLocale(_currentLanguage);

  static Locale parseLocale(String localeString) {
    final parts = localeString.split('-');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    PreferencesService().prefs.setString(AppConstants.language, languageCode);
    notifyListeners();
  }

  String getLanguageName(String? languageCode) {
    if (languageCode == null) return '';
    return LanguageTranslator.translateLanguageCode(
        languageCode, _currentLanguage);
  }
}
