import 'dart:convert';

import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbMovieProviders =
    '/watch/providers/movie?language={LOCALE}&watch_region={COUNTRY}';
const String _tmdbTvProviders =
    '/watch/providers/tv?language={LOCALE}&watch_region={COUNTRY}';

class TmdbProviderService extends TmdbBaseService {
  static final TmdbProviderService _instance = TmdbProviderService._internal();
  factory TmdbProviderService() => _instance;
  TmdbProviderService._internal();

  final Map<int, Map<String, String>> _providerMap = {};
  Map<int, Map<String, String>> get providers => _providerMap;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  Future<void> init() async {
    if (_isLoaded) return;

    List<String> providerUrls = [_tmdbMovieProviders, _tmdbTvProviders];

    _providerMap.clear();

    if (_getLocaleProviders()) {
      _isLoaded = true;
      return;
    }

    for (String url in providerUrls) {
      dynamic response = await get(url
          .replaceFirst('{LOCALE}', '${getLanguageCode()}-${getCountryCode()}')
          .replaceFirst('{COUNTRY}', getCountryCode()));

      if (response.statusCode == 200) {
        List<dynamic> providers =
            (jsonDecode((response.body)) as Map<String, dynamic>)['results'];

        if (providers.isEmpty ||
            providers[0][TmdbProvider.providerId] == null ||
            providers[0][TmdbProvider.providerId].runtimeType != int) {
          throw Exception('Failed to load providers');
        }

        for (var provider in providers) {
          _providerMap[provider[TmdbProvider.providerId]] = {
            TmdbProvider.providerId:
                provider[TmdbProvider.providerId].toString(),
            TmdbProvider.providerName:
                provider[TmdbProvider.providerName].toString(),
            TmdbProvider.logoPathName:
                provider[TmdbProvider.logoPathName].toString(),
            TmdbProvider.providerEnabled: PreferencesService().prefs.getString(
                    'provider_${provider[TmdbProvider.providerId]}') ??
                'false',
          };
        }
      } else {
        throw Exception('Failed to load providers: ${response.statusCode}'
            ' ${response.reasonPhrase}');
      }
    }
    _isLoaded = true;
    _setLocaleProviders(_providerMap);
  }

  bool _getLocaleProviders() {
    final providers =
        PreferencesService().prefs.getStringList('providers') ?? [];
    final String lastUpdated =
        PreferencesService().prefs.getString('providers_updateTime') ??
            DateTime(1970).toString();
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(lastUpdated)).inDays < 7;

    if (providers.isEmpty || !isUpToDate) return false;

    providers
        .map((provider) => jsonDecode(provider) as Map<String, dynamic>)
        .forEach((provider) {
      _providerMap[provider[TmdbProvider.providerId]] = {
        TmdbProvider.providerName:
            provider[TmdbProvider.providerName].toString(),
        TmdbProvider.logoPathName:
            provider[TmdbProvider.logoPathName].toString(),
        TmdbProvider.providerEnabled: PreferencesService()
                .prefs
                .getString('provider_${provider[TmdbProvider.providerId]}') ??
            'false',
      };
    });

    return true;
  }

  void _setLocaleProviders(Map<int, Map<String, String>> providers) {
    final providerList = providers.entries
        .map((entry) => jsonEncode({
              TmdbProvider.providerId: entry.key,
              TmdbProvider.providerName: entry.value[TmdbProvider.providerName],
              TmdbProvider.logoPathName: entry.value[TmdbProvider.logoPathName],
            }))
        .toList();
    PreferencesService().prefs.setStringList('providers', providerList);
    PreferencesService()
        .prefs
        .setString('providers_updateTime', DateTime.now().toString());
  }

  void toggleProvider(int id, bool value) {
    if (_providerMap.containsKey(id)) {
      _providerMap[id]![TmdbProvider.providerEnabled] = value.toString();
      PreferencesService().prefs.setString('provider_$id', value.toString());
    }
  }

  List<int> getIdsFromNames(List<String> names) {
    return _providerMap.entries
        .where(
            (entry) => names.contains(entry.value[TmdbProvider.providerName]))
        .map((entry) => entry.key)
        .toList();
  }
}
