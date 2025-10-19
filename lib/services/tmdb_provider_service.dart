import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbMovieProviders =
    '/watch/providers/movie?language={LOCALE}&watch_region={COUNTRY}';
const String _tmdbTvProviders =
    '/watch/providers/tv?language={LOCALE}&watch_region={COUNTRY}';
const String _tmdbLists = '/list/{LIST_ID}';

const String _providersListName = 'providers';

class TmdbProviderService extends TmdbBaseService with ChangeNotifier {
  static final TmdbProviderService _instance = TmdbProviderService._internal();
  factory TmdbProviderService() => _instance;
  TmdbProviderService._internal();

  final Map<int, Map<String, String>> _providerMap = {};
  Map<int, Map<String, String>> get providers => _providerMap;
  bool _isLoaded = false;
  String _accessToken = '';
  String _listId = '';
  String _accountId = '';
  String _sessionId = '';

  bool get isLoaded => _isLoaded;
  Future<void> init() async {
    if (_isLoaded) return;

    _providerMap.clear();

    if (_getLocalProviders()) {
      _isLoaded = true;
      return;
    }

    List<String> providerUrls = [_tmdbMovieProviders, _tmdbTvProviders];

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
          };
        }
      } else {
        throw Exception('Failed to load providers: ${response.statusCode}'
            ' ${response.reasonPhrase}');
      }
    }
    _isLoaded = true;
    _setLocalProviders(_providerMap);
  }

  void clearProvidersStatus() {
    for (var entry in _providerMap.entries) {
      entry.value[TmdbProvider.providerEnabled] = 'false';
    }
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    _accountId = accountId;
    _sessionId = sessionId;
    _accessToken = accessToken;

    _listId = PreferencesService().prefs.getString('providerListId') ?? '';
    if (_listId.isEmpty) {
      await _retrieveServerProvidersListId();
      if (_listId.isEmpty) {
        return;
      }
    }

    final response = await get(_tmdbLists.replaceFirst('{LIST_ID}', _listId),
        accessToken: _accessToken);

    if (response.statusCode != 200) {
      // List may not exist yet
      return;
    }

    final data = jsonDecode(response.body);
    if (data['description'] == null || data['description'].isEmpty) {
      return;
    }

    try {
      _stringToProviders(data['description']);
    } catch (e) {
      // User can change content through TMDB web, ignore errors
      return;
    }
  }

  Future<bool> _retrieveServerProvidersListId() async {
    final response =
        await get('/account/$_accountId/lists?session_id=$_sessionId');
    if (response.statusCode == 200) {
      final lists = jsonDecode(response.body)['results'] as List;
      final providerList = lists.firstWhere(
        (list) => list['name'] == _providersListName,
        orElse: () => null,
      );
      if (providerList != null) {
        _listId = providerList['id'].toString();
        PreferencesService().prefs.setString('providerListId', _listId);
        return true;
      }
    }
    return false;
  }

  Future<void> _createServerProviderList() async {
    if (_listId.isNotEmpty) return;

    const String myurl = 'list';
    const Map<String, dynamic> mybody = {
      'name': _providersListName,
      'iso_639_1': 'ca',
      'description': '',
      'public': false,
    };

    await post(
      myurl,
      mybody,
      version: ApiVersion.v4,
      accessToken: _accessToken,
    ).then((response) {
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final String listId = json['id'].toString();
        _listId = listId;
        PreferencesService().prefs.setString('providerListId', _listId);
      } else {
        debugPrint('Error creating provider list: ${response.statusCode}'
            ' ${response.reasonPhrase}');
      }
    }).catchError((error) {
      debugPrint('Error: $error');
    });
  }

  String _providersToString() {
    final enabledProviders = _providerMap.entries
        .where((entry) => entry.value[TmdbProvider.providerEnabled] == 'true')
        .map((entry) => entry.key)
        .toList();
    return enabledProviders.join(',');
  }

  void _stringToProviders(String providersString) {
    final providerIds = providersString.split(',').map(int.parse).toList();
    for (var entry in _providerMap.entries) {
      if (providerIds.contains(entry.key)) {
        entry.value[TmdbProvider.providerEnabled] = 'true';
      } else {
        entry.value[TmdbProvider.providerEnabled] = 'false';
      }
    }
  }

  Future<bool> _updateProvidersToServer() async {
    await _createServerProviderList();

    final url = 'list/$_listId';
    final Map<String, dynamic> body = {
      'description': _providersToString(),
    };

    final response = await put(
      url,
      body,
      version: ApiVersion.v4,
      accessToken: _accessToken,
    );
    return response.statusCode == 201;
  }

  bool _getLocalProviders() {
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
      };
    });

    return true;
  }

  void _setLocalProviders(Map<int, Map<String, String>> providers) {
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
      _updateProvidersToServer();
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
