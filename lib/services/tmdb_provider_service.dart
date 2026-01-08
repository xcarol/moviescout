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
  final Map<int, Map<String, String>> _providerMap = {};
  Map<int, Map<String, String>> get providers => _providerMap;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String _accessToken = '';
  String _listId = '';
  String _accountId = '';
  String _sessionId = '';

  bool get isInitialized => _isInitialized;

  Future<void> _retrieveProviders() async {
    List<String> providerUrls = [_tmdbMovieProviders, _tmdbTvProviders];

    for (String url in providerUrls) {
      final response = await get(url
          .replaceFirst('{LOCALE}', '${getLanguageCode()}-${getCountryCode()}')
          .replaceFirst('{COUNTRY}', getCountryCode()));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load providers: ${response.statusCode} ${response.reasonPhrase}');
      }
      List<dynamic> providers = (jsonDecode(response.body)
          as Map<String, dynamic>)['results'] as List<dynamic>;

      if (providers.isEmpty ||
          providers[0][TmdbProvider.providerId] == null ||
          providers[0][TmdbProvider.providerId].runtimeType != int) {
        throw Exception('Failed to load providers (invalid payload)');
      }

      for (var provider in providers) {
        _providerMap[provider[TmdbProvider.providerId]] = {
          TmdbProvider.providerId: provider[TmdbProvider.providerId].toString(),
          TmdbProvider.providerName:
              provider[TmdbProvider.providerName].toString(),
          TmdbProvider.logoPathName:
              provider[TmdbProvider.logoPathName].toString(),
          TmdbProvider.providerEnabled: 'false',
        };
      }
    }
  }

  void clearProvidersStatus() {
    _isInitialized = false;
    for (var entry in _providerMap.entries) {
      entry.value[TmdbProvider.providerEnabled] = 'false';
    }
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    if (_isInitialized || _isInitializing) return;

    if (accountId.isEmpty || sessionId.isEmpty || accessToken.isEmpty) {
      return;
    }

    try {
      _isInitializing = true;

      _accountId = accountId;
      _sessionId = sessionId;
      _accessToken = accessToken;

      _providerMap.clear();

      if (_getLocalProviders() == false) {
        await _retrieveProviders();
        await _retrieveUserProviders();
        _setLocalProviders(_providerMap);
      }
    } catch (e) {
      debugPrint('Error in TmdbProviderService setup: $e');
    } finally {
      _isInitialized = true;
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _retrieveUserProviders() async {
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
      // Reset list ID to retry on next setup.
      PreferencesService().prefs.setString('providerListId', '');
      return;
    }

    final data = jsonDecode(response.body);
    if (data['description'] == null || data['description'].isEmpty) {
      return;
    }

    _stringToProviders(data['description']);
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

  Future<void> _createServerProviderList({bool forced = false}) async {
    if (_listId.isNotEmpty && !forced) return;

    const String myurl = 'list';
    const Map<String, dynamic> mybody = {
      'name': _providersListName,
      'iso_639_1': 'ca',
      'description': '',
      'public': false,
    };

    try {
      final response = await post(
        myurl,
        mybody,
        version: ApiVersion.v4,
        accessToken: _accessToken,
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final String listId = json['id'].toString();
        _listId = listId;
        PreferencesService().prefs.setString('providerListId', _listId);
      } else {
        debugPrint('Error creating provider list: ${response.statusCode}'
            ' ${response.reasonPhrase}');
      }
    } catch (error) {
      debugPrint('Error creating provider list: $error');
    }
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

    try {
      final response = await put(
        url,
        body,
        version: ApiVersion.v4,
        accessToken: _accessToken,
      );

      if (response.statusCode == 404) {
        await _createServerProviderList(forced: true);
        final newurl = 'list/$_listId';
        final retryResponse = await put(
          newurl,
          body,
          version: ApiVersion.v4,
          accessToken: _accessToken,
        );
        return retryResponse.statusCode == 201;
      }

      return response.statusCode == 201;
    } catch (error) {
      debugPrint('Error updating providers to server: $error');
      return false;
    }
  }

  bool _getLocalProviders() {
    final providers =
        PreferencesService().prefs.getStringList('providers') ?? [];
    final String lastUpdated =
        PreferencesService().prefs.getString('providers_updateTime') ??
            DateTime(1970).toString();
    bool isUpToDate =
        DateTime.now().difference(DateTime.parse(lastUpdated)).inDays <
            DateTime.daysPerWeek;

    if (providers.isEmpty || !isUpToDate) return false;

    _listId = PreferencesService().prefs.getString('providerListId') ?? '';

    providers
        .map((provider) => jsonDecode(provider) as Map<String, dynamic>)
        .forEach((provider) {
      _providerMap[provider[TmdbProvider.providerId]] = {
        TmdbProvider.providerId: provider[TmdbProvider.providerId].toString(),
        TmdbProvider.providerName:
            provider[TmdbProvider.providerName].toString(),
        TmdbProvider.logoPathName:
            provider[TmdbProvider.logoPathName].toString(),
        TmdbProvider.providerEnabled:
            provider[TmdbProvider.providerEnabled].toString(),
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
              TmdbProvider.providerEnabled:
                  entry.value[TmdbProvider.providerEnabled],
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
      _setLocalProviders(_providerMap);
    }
  }

  void applyProvidersFilter() {
    notifyListeners();
  }

  List<int> getIdsFromNames(List<String> names) {
    if (names.isEmpty) {
      return [];
    }

    return _providerMap.entries
        .where(
            (entry) => names.contains(entry.value[TmdbProvider.providerName]))
        .map((entry) => entry.key)
        .toList();
  }
}
