import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';

const String _tmdbMovieProviders =
    '/watch/providers/movie?language={LOCALE}&watch_region={COUNTRY}';
const String _tmdbTvProviders =
    '/watch/providers/tv?language={LOCALE}&watch_region={COUNTRY}';

class TmdbProviderService extends TmdbBaseService with ChangeNotifier {
  final CloudTitleRepository _cloudRepository;

  final Map<int, Map<String, String>> _providerMap = {};
  Map<int, Map<String, String>> get providers => _providerMap;
  bool _isInitialized = false;
  bool _isInitializing = false;

  bool get isInitialized => _isInitialized;

  @visibleForTesting
  set isInitialized(bool value) => _isInitialized = value;

  List<int> get enabledProviderIds {
    if (!_isInitialized) return [];
    return _providerMap.entries
        .where((entry) => entry.value[TmdbProvider.providerEnabled] == 'true')
        .map((entry) => int.parse(entry.value[TmdbProvider.providerId]!))
        .toList();
  }

  TmdbProviderService({CloudTitleRepository? cloudRepository})
      : _cloudRepository = cloudRepository ?? CloudTitleRepository();

  Future<void> _retrieveProviders() async {
    List<String> providerUrls = [_tmdbMovieProviders, _tmdbTvProviders];

    for (String url in providerUrls) {
      final response = await get(url
          .replaceFirst('{LOCALE}', '${getLanguageCode()}-${getCountryCode()}')
          .replaceFirst('{COUNTRY}', getCountryCode()));

      if (response.statusCode != 200) {
        final message =
            'Failed to load providers: ${response.statusCode} ${response.reasonPhrase}';
        ErrorService.log(
          message,
          userMessage: 'Error loading platforms',
        );
        throw Exception(message);
      }
      List<dynamic> providers = (jsonDecode(response.body)
          as Map<String, dynamic>)['results'] as List<dynamic>;

      if (providers.isEmpty) {
        continue;
      }

      if (providers[0][TmdbProvider.providerId] == null ||
          providers[0][TmdbProvider.providerId].runtimeType != int) {
        const message = 'Failed to load providers (invalid payload)';
        ErrorService.log(
          message,
          userMessage: 'Error loading platforms',
        );
        throw Exception(message);
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

  Future<void> setup([
    String? accountId,
    String? sessionId,
    String? accessToken,
  ]) async {
    final isSupabaseLoggedIn = CloudDatabaseService.isLoggedIn;

    if (!isSupabaseLoggedIn &&
        ((accountId ?? '').isEmpty ||
            (sessionId ?? '').isEmpty ||
            (accessToken ?? '').isEmpty)) {
      return;
    }

    if (_isInitialized || _isInitializing) {
      if (isSupabaseLoggedIn) {
        await fetchProviders();
      }
      return;
    }

    try {
      _isInitializing = true;
      _providerMap.clear();

      if (_getLocalProviders() == false) {
        await _retrieveProviders();
        await fetchProviders();
        _setLocalProviders(_providerMap);
      } else {
        await fetchProviders();
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error initializing platforms',
      );
    } finally {
      _isInitialized = true;
      _isInitializing = false;
      notifyListeners();
    }
  }

  void applyData(dynamic data) {
    if (data is! String) return;
    _stringToProviders(data);
    _setLocalProviders(_providerMap);
    notifyListeners();
  }

  Future<void> fetchProviders() async {
    final user = CloudDatabaseService.currentUser;
    if (user != null) {
      try {
        final providersString =
            await _cloudRepository.fetchUserProviders(user.id);
        if (providersString != null) {
          applyData(providersString);
        }
      } catch (e, stackTrace) {
        ErrorService.log(e,
            stackTrace: stackTrace, userMessage: 'Error fetching platforms');
      }
    }
  }

  Future<bool> updateCloudProviders(String data) async {
    final user = CloudDatabaseService.currentUser;
    if (user != null) {
      try {
        await _cloudRepository.updateUserProviders(user.id, data);
        return true;
      } catch (e, stackTrace) {
        ErrorService.log(e,
            stackTrace: stackTrace, userMessage: 'Error saving platforms');
        return false;
      }
    }
    return false;
  }

  String _providersToString() {
    final enabledProviders = _providerMap.entries
        .where((entry) => entry.value[TmdbProvider.providerEnabled] == 'true')
        .map((entry) => entry.key)
        .toList();
    return enabledProviders.join(',');
  }

  void _stringToProviders(String providersString) {
    try {
      if (providersString.isEmpty) return;
      final providerIds = providersString.split(',').map(int.parse).toList();
      for (var entry in _providerMap.entries) {
        if (providerIds.contains(entry.key)) {
          entry.value[TmdbProvider.providerEnabled] = 'true';
        } else {
          entry.value[TmdbProvider.providerEnabled] = 'false';
        }
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error parsing platforms',
      );
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
      updateCloudProviders(_providersToString());
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
