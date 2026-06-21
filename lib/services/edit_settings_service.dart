import 'package:flutter/foundation.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class EditSettingsService extends ChangeNotifier {
  static final EditSettingsService _instance = EditSettingsService._internal();
  factory EditSettingsService() => _instance;
  EditSettingsService._internal();

  bool _showEditContent = false;

  bool get showEditContent => _showEditContent;

  Future<void> init() async {
    _showEditContent =
        PreferencesService().prefs.getBool(AppConstants.showEditContent) ?? false;
  }

  Future<void> setShowEditContent(bool value) async {
    _showEditContent = value;
    await PreferencesService().prefs.setBool(AppConstants.showEditContent, value);
    notifyListeners();
  }
}
