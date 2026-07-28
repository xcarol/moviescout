import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class StatusTranslator {
  static final Map<String, Map<String, String>> _statusMappings = {};

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
          await rootBundle.loadString('assets/l10n/status_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final Map<String, String> parsedMappings = {};
      data.forEach((key, value) {
        if (value != null && value is String) {
          parsedMappings[key] = value;
        }
      });
      _statusMappings[lang] = parsedMappings;
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading status for $lang: $e',
        stackTrace: stackTrace,
      );
    }
  }

  static String translate(String status, String languageCode) {
    if (status.isEmpty) return status;
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);

    return _statusMappings[fullLocale]?[status] ?? status;
  }
}
