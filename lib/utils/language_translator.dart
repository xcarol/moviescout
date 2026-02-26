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

  static String translateLanguageCode(String code, String appLocale) {
    if (code.isEmpty) return code;

    final mapping = _languageMappings[appLocale];
    if (mapping != null && mapping.containsKey(code)) {
      final translated = mapping[code];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }

    return TmdbConfigurationService()
        .getLanguageName(code, appLangIso: appLocale);
  }
}
