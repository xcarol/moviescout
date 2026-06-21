import 'package:moviescout/utils/app_constants.dart';

class TmdbTranslation {
  final String iso3166_1;
  final String iso639_1;
  final String name;
  final String englishName;
  final Map<String, dynamic> data;

  TmdbTranslation({
    required this.iso3166_1,
    required this.iso639_1,
    required this.name,
    required this.englishName,
    required this.data,
  });

  factory TmdbTranslation.fromJson(Map<String, dynamic> json) {
    return TmdbTranslation(
      iso3166_1: json[AppConstants.iso3166_1] as String? ?? '',
      iso639_1: json[AppConstants.iso639_1] as String? ?? '',
      name: json[AppConstants.name] as String? ?? '',
      englishName: json[AppConstants.englishName] as String? ?? '',
      data: json[AppConstants.data] as Map<String, dynamic>? ?? {},
    );
  }

  String get translatedTitle {
    if (data.containsKey(AppConstants.title)) {
      return data[AppConstants.title] as String? ?? '';
    }
    if (data.containsKey(AppConstants.name)) {
      return data[AppConstants.name] as String? ?? '';
    }
    return '';
  }

  String get description {
    // Biography for persons, overview for everything else
    if (data.containsKey(AppConstants.biography)) {
      return data[AppConstants.biography] as String? ?? '';
    }
    if (data.containsKey(AppConstants.overview)) {
      return data[AppConstants.overview] as String? ?? '';
    }
    return '';
  }
}
