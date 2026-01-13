import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/utils/app_constants.dart';

class PersonTranslator {
  static final Map<String, Map<String, String>> _jobMappings = {};
  static final Map<String, Map<String, String>> _deptMappings = {};

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
          await rootBundle.loadString('assets/l10n/person_jobs_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _deptMappings[lang] = Map<String, String>.from(data['departments']);
      _jobMappings[lang] = Map<String, String>.from(data['jobs']);
    } catch (e) {
      // Fallback or log error
    }
  }

  static String translateDepartment(String dept, String languageCode) {
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);
    return _deptMappings[fullLocale]?[dept] ?? dept;
  }

  static String translateJob(String job, String languageCode) {
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);
    return _jobMappings[fullLocale]?[job] ?? job;
  }
}
