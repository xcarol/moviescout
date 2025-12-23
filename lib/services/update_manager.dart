import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateManager {
  static const Duration watchlistTimeout = Duration(days: 1);
  static const Duration rateslistTimeout = Duration(days: 1);
  static const Duration discoverlistTimeout = Duration(days: 7);
  static const Duration genresTimeout = Duration(days: 7);

  static final UpdateManager _instance = UpdateManager._internal();
  factory UpdateManager() => _instance;
  UpdateManager._internal();

  SharedPreferencesWithCache get _prefs => PreferencesService().prefs;

  bool isUpToDate(String key, Duration timeout) {
    final String? lastUpdateStr =
        _prefs.getString('$key${AppConstants.lastUpdateSuffix}');
    if (lastUpdateStr == null) return false;

    final DateTime lastUpdate = DateTime.parse(lastUpdateStr);
    return DateTime.now().difference(lastUpdate) < timeout;
  }

  Future<void> updateLastUpdate(String key) async {
    await _prefs.setString(
      '$key${AppConstants.lastUpdateSuffix}',
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> removeLastUpdate(String key) async {
    await _prefs.remove('$key${AppConstants.lastUpdateSuffix}');
  }

  bool isWatchlistUpToDate() =>
      isUpToDate(AppConstants.watchlist, watchlistTimeout);
  bool isRateslistUpToDate() =>
      isUpToDate(AppConstants.rateslist, rateslistTimeout);
  bool isDiscoverlistUpToDate() =>
      isUpToDate(AppConstants.discoverlist, discoverlistTimeout);
  bool isGenresUpToDate() => isUpToDate('genres', genresTimeout);

  Future<void> updateWatchlistLastUpdate() =>
      updateLastUpdate(AppConstants.watchlist);
  Future<void> updateRateslistLastUpdate() =>
      updateLastUpdate(AppConstants.rateslist);
  Future<void> updateDiscoverlistLastUpdate() =>
      updateLastUpdate(AppConstants.discoverlist);
  Future<void> updateGenresLastUpdate() => updateLastUpdate('genres');
}
