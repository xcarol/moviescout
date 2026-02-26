import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_configuration_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class LanguageTranslator {
  static final Map<String, Map<String, String>> _languageMappings = {};

  static Future<void> init() async {
    for (var lang in AppConstants.supportedLanguages) {
      if (lang != AppConstants.english) {
        await _load(lang);
      }
    }
  }

  static Future<void> _load(String lang) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/l10n/languages_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data['languages'] != null) {
        _languageMappings[lang] = Map<String, String>.from(data['languages']);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading languages for $lang: $e',
        stackTrace: stackTrace,
        showSnackBar: false,
      );
    }
  }

  /// Translates a language code (e.g. 'en', 'es') to its localized name.
  ///
  /// Priority:
  /// 1. Local JSON asset for the current [appLocale] (e.g. 'ca-ES', 'es-ES').
  /// 2. TMDB Configuration service (conditional logic native vs english).
  /// 3. Fallback to the [code] itself.
  static String translateLanguageCode(String code, String appLocale) {
    if (code.isEmpty) return code;

    // 1. Try local JSON mapping
    final mapping = _languageMappings[appLocale];
    if (mapping != null && mapping.containsKey(code)) {
      final translated = mapping[code];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }

    // 2. Fallback to TMDB Configuration (which handles native naming if app matches title)
    return TmdbConfigurationService()
        .getLanguageName(code, appLangIso: appLocale);
  }
}
