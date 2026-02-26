import 'dart:convert';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_cacheable_service.dart';

class TmdbConfigData {
  final Map<String, Map<String, String>> languages;
  final Map<String, String> countries;

  TmdbConfigData({required this.languages, required this.countries});

  Map<String, dynamic> toJson() => {
        'languages': languages,
        'countries': countries,
      };

  factory TmdbConfigData.fromJson(Map<String, dynamic> json) => TmdbConfigData(
        languages: (json['languages'] as Map).map(
          (k, v) => MapEntry(k as String, Map<String, String>.from(v as Map)),
        ),
        countries: Map<String, String>.from(json['countries']),
      );
}

class TmdbConfigurationService extends TmdbCacheableService<TmdbConfigData> {
  static final TmdbConfigurationService _instance =
      TmdbConfigurationService._internal();
  factory TmdbConfigurationService() => _instance;

  TmdbConfigurationService._internal()
      : super(
          cacheKey: 'tmdb_configuration',
          timeout: const Duration(days: 7),
        );

  @override
  Future<void> fetchAndCache() async {
    final Map<String, Map<String, String>> languagesMap = {};
    final Map<String, String> countriesMap = {};
    bool reportError = false;
    String? errorMessage;

    try {
      final langResponse = await get('configuration/languages');
      if (langResponse.statusCode == 200) {
        final List<dynamic> languages = jsonDecode(langResponse.body);
        for (var lang in languages) {
          languagesMap[lang['iso_639_1']] = {
            'en': lang['english_name'] ?? '',
            'native': lang['name'] ?? '',
          };
        }
      } else {
        reportError = true;
        errorMessage = 'Failed to load languages: ${langResponse.statusCode}';
      }

      final countryResponse = await get(
          'configuration/countries?language=${getLanguageCode()}-${getCountryCode()}');
      if (countryResponse.statusCode == 200) {
        final List<dynamic> countries = jsonDecode(countryResponse.body);
        for (var country in countries) {
          countriesMap[country['iso_3166_1']] =
              country['native_name'] ?? country['english_name'];
        }
      } else {
        reportError = true;
        errorMessage =
            'Failed to load countries: ${countryResponse.statusCode}';
      }

      if (reportError) {
        ErrorService.log(
          errorMessage!,
          userMessage: 'Failed to load TMDB configuration',
        );
      }

      data = TmdbConfigData(languages: languagesMap, countries: countriesMap);
      saveToCache(data!.toJson());
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error fetching TMDB configuration',
      );
    }
  }

  @override
  TmdbConfigData parseData(dynamic json) {
    return TmdbConfigData.fromJson(json as Map<String, dynamic>);
  }

  String getLanguageName(String iso, {String? appLangIso}) {
    final details = data?.languages[iso];
    if (details == null) return iso;

    final String englishName = details['en'] ?? iso;
    final String nativeName = details['native'] ?? '';

    if (appLangIso != null && nativeName.isNotEmpty) {
      if (appLangIso.startsWith(iso)) {
        return nativeName;
      }
    }

    return englishName;
  }

  String getCountryName(String iso) {
    return data?.countries[iso.toUpperCase()] ?? iso;
  }
}
