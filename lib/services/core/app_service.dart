import 'package:flutter/foundation.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_lists/discoverlist_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class AppService extends ChangeNotifier {
  static final AppService _instance = AppService._internal();
  factory AppService() => _instance;
  AppService._internal();

  bool _showEditContent = false;
  bool _showCommunityTab = true;

  WatchlistService? _watchlistService;
  RateslistService? _rateslistService;
  TmdbDiscoverlistService? _discoverlistService;
  TmdbProviderService? _providerService;

  bool get showEditContent => _showEditContent;
  bool get showCommunityTab => _showCommunityTab;

  void attachServices({
    required WatchlistService watchlistService,
    required RateslistService rateslistService,
    required TmdbDiscoverlistService discoverlistService,
    required TmdbProviderService providerService,
  }) {
    _watchlistService = watchlistService;
    _rateslistService = rateslistService;
    _discoverlistService = discoverlistService;
    _providerService = providerService;
  }

  Future<void> clearUserData() async {
    await _watchlistService?.clearList();
    await _rateslistService?.clearList();
    await _discoverlistService?.clearList();
    _discoverlistService?.resetPagination();
    _providerService?.clearProvidersStatus();

    await _discoverlistService?.retrieveDiscoverlist(
      LanguageService().locale,
      forceUpdate: true,
    );
  }

  Future<void> init() async {
    final prefs = PreferencesService().prefs;
    _showEditContent = prefs.getBool(AppConstants.showEditContent) ?? false;
    _showCommunityTab = prefs.getBool(AppConstants.showCommunityTab) ?? true;
  }

  Future<void> setShowEditContent(bool value) async {
    _showEditContent = value;
    await PreferencesService()
        .prefs
        .setBool(AppConstants.showEditContent, value);
    notifyListeners();
  }

  Future<void> setShowCommunityTab(bool value) async {
    _showCommunityTab = value;
    await PreferencesService()
        .prefs
        .setBool(AppConstants.showCommunityTab, value);
    notifyListeners();
  }
}

