import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/update_manager.dart';

abstract class TmdbCacheableService<T> extends TmdbBaseService {
  final String cacheKey;
  final Duration timeout;

  TmdbCacheableService({
    required this.cacheKey,
    required this.timeout,
  });

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  @protected
  T? data;

  Future<void> init() async {
    if (_isLoaded) return;

    if (_loadFromCache()) {
      _isLoaded = true;
      return;
    }

    await fetchAndCache();
    _isLoaded = true;
  }

  Future<void> reload() async {
    _isLoaded = false;
    await UpdateManager().removeLastUpdate(cacheKey);
    await PreferencesService().prefs.remove(cacheKey);
    await init();
  }

  @protected
  Future<void> fetchAndCache();

  @protected
  void saveToCache(dynamic jsonData) {
    PreferencesService().prefs.setString(cacheKey, jsonEncode(jsonData));
    UpdateManager().updateLastUpdate(cacheKey);
  }

  bool _loadFromCache() {
    try {
      final cachedData = PreferencesService().prefs.getString(cacheKey);
      final bool upToDate = UpdateManager().isUpToDate(cacheKey, timeout);

      if (cachedData == null || !upToDate) return false;

      data = parseData(jsonDecode(cachedData));
      return true;
    } catch (e) {
      debugPrint('Error loading or parsing cached data for $cacheKey: $e');
      // If there's a type mismatch or parsing error, we return false to force a refetch
      return false;
    }
  }

  @protected
  T parseData(dynamic json);
}
