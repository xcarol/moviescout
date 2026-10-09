import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_configuration_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class CountryTranslator {
  static final Map<String, Map<String, String>> _countryMappings = {};

  static Future<void> init() async {
    for (var lang in AppConstants.supportedLanguages) {
      await _load(lang);
    }
  }

  static Future<void> _load(String lang) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/l10n/countries_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data['countries'] != null) {
        _countryMappings[lang] = Map<String, String>.from(data['countries']);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading countries for $lang: $e',
        stackTrace: stackTrace,
      );
    }
  }

  static String translate(String code, String appLocale) {
    if (code.isEmpty) return code;
    final iso = code.toUpperCase();

    final fullLocale = AppConstants.supportedLanguages.firstWhere(
      (l) => l == appLocale || l.startsWith(appLocale),
      orElse: () => appLocale,
    );

    final mapping = _countryMappings[fullLocale];
    if (mapping != null && mapping.containsKey(iso)) {
      final translated = mapping[iso];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }

    return TmdbConfigurationService().getCountryName(iso);
  }
}
