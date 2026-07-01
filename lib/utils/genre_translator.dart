import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class GenreTranslator {
  static final Map<String, Map<int, String>> _genreMappings = {};

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
          await rootBundle.loadString('assets/l10n/genres_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final Map<int, String> parsedMappings = {};
      data.forEach((key, value) {
        if (value != null && value is String) {
          parsedMappings[int.parse(key)] = value;
        }
      });
      _genreMappings[lang] = parsedMappings;
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading genres for $lang: $e',
        stackTrace: stackTrace,
      );
    }
  }

  static String? translate(int genreId, String languageCode) {
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);

    return _genreMappings[fullLocale]?[genreId];
  }
}
