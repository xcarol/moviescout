import 'package:flutter/foundation.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class AppSettingsService extends ChangeNotifier {
  static final AppSettingsService _instance = AppSettingsService._internal();
  factory AppSettingsService() => _instance;
  AppSettingsService._internal();

  bool _showEditContent = false;
  bool _showCommunityTab = true;

  bool get showEditContent => _showEditContent;
  bool get showCommunityTab => _showCommunityTab;

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
