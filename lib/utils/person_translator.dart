import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/services/error_service.dart';
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
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading jobs/departments for $lang: $e',
        stackTrace: stackTrace,
        showSnackBar: false,
      );
    }
  }

  static String translateDepartment(String dept, String languageCode) {
    if (dept.isEmpty) return dept;
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);

    if (dept.contains(',')) {
      return dept
          .split(',')
          .map((d) => d.trim())
          .map((d) => _deptMappings[fullLocale]?[d] ?? d)
          .join(', ');
    }
    return _deptMappings[fullLocale]?[dept] ?? dept;
  }

  static String translateJob(String job, String languageCode) {
    if (job.isEmpty) return job;
    final fullLocale = AppConstants.supportedLanguages.firstWhere(
        (l) => l.startsWith(languageCode),
        orElse: () => languageCode);

    if (job.contains(',')) {
      return job
          .split(',')
          .map((j) => j.trim())
          .map((j) => _jobMappings[fullLocale]?[j] ?? j)
          .join(', ');
    }
    return _jobMappings[fullLocale]?[job] ?? job;
  }
}
