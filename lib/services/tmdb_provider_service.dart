import 'dart:convert';

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
    for (String url in providerUrls) {
      dynamic response = await get(url
          .replaceFirst('{LOCALE}', '${getLanguageCode()}-${getCountryCode()}')
          .replaceFirst('{COUNTRY}', getCountryCode()));

      if (response.statusCode == 200) {
        List<dynamic> providers =
            (jsonDecode((response.body)) as Map<String, dynamic>)['results'];

        if (providers.isEmpty ||
            providers[0]['provider_id'] == null ||
            providers[0]['provider_id'].runtimeType != int) {
          throw Exception('Failed to load providers');
        }

        for (var provider in providers) {
          _providerMap[provider['provider_id']] = {
            'name': provider['provider_name'].toString(),
            'logo_path': provider['logo_path'].toString(),
            'enabled': PreferencesService()
                .prefs
                .getString('provider_${provider['provider_id']}') ??
                'false',
          };
        }
      } else {
        throw Exception(
            'Failed to load providers: ${response.statusCode}'
            ' ${response.reasonPhrase}');
      }
    }
    _isLoaded = true;
  }

  void toggleProvider(int id, bool value) {
    if (_providerMap.containsKey(id)) {
      _providerMap[id]!['enabled'] = value.toString();
      PreferencesService().prefs.setString('provider_$id', value.toString());
    }
  }
}
