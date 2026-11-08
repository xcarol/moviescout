import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/services/tmdb_configuration_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';

class MetadataTranslator {
  static final Map<String, Map<String, String>> _countryMappings = {};
  static final Map<String, Map<String, String>> _languageMappings = {};
  static final Map<String, Map<int, String>> _genreMappings = {};
  static final Map<String, Map<String, String>> _jobMappings = {};
  static final Map<String, Map<String, String>> _deptMappings = {};
  static final Map<String, Map<String, String>> _statusMappings = {};

  static String _resolveLocale(String languageCode) {
    return AppConstants.supportedLanguages.firstWhere(
      (l) => l == languageCode || l.startsWith(languageCode),
      orElse: () => languageCode,
    );
  }

  static Future<void> init() async {
    final futures = <Future<void>>[];
    for (var lang in AppConstants.supportedLanguages) {
      futures.add(_loadCountries(lang));
      futures.add(_loadLanguages(lang));
      futures.add(_loadGenres(lang));
      futures.add(_loadPersonJobs(lang));
      futures.add(_loadStatus(lang));
    }
    await Future.wait(futures);
  }

  static Future<void> _loadCountries(String lang) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/l10n/countries_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data['countries'] != null) {
        _countryMappings[lang] = Map<String, String>.from(data['countries']);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading countries for $lang: $e',
        stackTrace: stackTrace,
        reportToCrashlytics: false,
      );
    }
  }

  static Future<void> _loadLanguages(String lang) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/l10n/languages_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data['languages'] != null) {
        _languageMappings[lang] = Map<String, String>.from(data['languages']);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading languages for $lang: $e',
        stackTrace: stackTrace,
        reportToCrashlytics: false,
      );
    }
  }

  static Future<void> _loadGenres(String lang) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/l10n/genres_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final Map<int, String> parsed = {};
      data.forEach((key, value) {
        if (value != null && value is String) {
          parsed[int.parse(key)] = value;
        }
      });
      _genreMappings[lang] = parsed;
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading genres for $lang: $e',
        stackTrace: stackTrace,
        reportToCrashlytics: false,
      );
    }
  }

  static Future<void> _loadPersonJobs(String lang) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/l10n/person_jobs_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _deptMappings[lang] = Map<String, String>.from(data['departments']);
      _jobMappings[lang] = Map<String, String>.from(data['jobs']);
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading jobs/departments for $lang: $e',
        stackTrace: stackTrace,
        reportToCrashlytics: false,
      );
    }
  }

  static Future<void> _loadStatus(String lang) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/l10n/status_$lang.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final Map<String, String> parsed = {};
      data.forEach((key, value) {
        if (value != null && value is String) {
          parsed[key] = value;
        }
      });
      _statusMappings[lang] = parsed;
    } catch (e, stackTrace) {
      ErrorService.log(
        'Error loading status for $lang: $e',
        stackTrace: stackTrace,
        reportToCrashlytics: false,
      );
    }
  }

  static String translateCountry(String code, String appLocale) {
    if (code.isEmpty) return code;
    final iso = code.toUpperCase();
    final fullLocale = _resolveLocale(appLocale);

    final mapping = _countryMappings[fullLocale];
    if (mapping != null && mapping.containsKey(iso)) {
      final translated = mapping[iso];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }

    return TmdbConfigurationService().getCountryName(iso);
  }

  static String translateLanguage(String code, String appLocale) {
    if (code.isEmpty) return code;
    final fullLocale = _resolveLocale(appLocale);

    final mapping = _languageMappings[fullLocale];
    if (mapping != null && mapping.containsKey(code)) {
      final translated = mapping[code];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }

    return TmdbConfigurationService()
        .getLanguageName(code, appLangIso: appLocale);
  }

  static String? translateGenre(int genreId, String languageCode) {
    final fullLocale = _resolveLocale(languageCode);
    return _genreMappings[fullLocale]?[genreId];
  }

  static String translateDepartment(String dept, String languageCode) {
    if (dept.isEmpty) return dept;
    final fullLocale = _resolveLocale(languageCode);

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
    final fullLocale = _resolveLocale(languageCode);

    if (job.contains(',')) {
      return job
          .split(',')
          .map((j) => j.trim())
          .map((j) => _jobMappings[fullLocale]?[j] ?? j)
          .join(', ');
    }
    return _jobMappings[fullLocale]?[job] ?? job;
  }

  static String translateStatus(String status, String languageCode) {
    if (status.isEmpty) return status;
    final fullLocale = _resolveLocale(languageCode);
    return _statusMappings[fullLocale]?[status] ?? status;
  }
}
