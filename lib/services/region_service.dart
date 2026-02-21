import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class RegionService with ChangeNotifier {
  static final RegionService _instance = RegionService._internal();

  factory RegionService() {
    return _instance;
  }

  RegionService._internal();

  String? _detectedRegion;
  String? _manualRegion =
      PreferencesService().prefs.getString(AppConstants.region);

  String? get detectedRegion => _detectedRegion;
  String? get manualRegion => _manualRegion;

  /// Returns the effective country code: manual override > detected region > null
  String? get currentRegion => _manualRegion ?? _detectedRegion;

  Future<void> init() async {
    if (_manualRegion == null) {
      await detectRegion();
    }
  }

  Future<void> detectRegion() async {
    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _detectedRegion = data['country_code'];
        notifyListeners();
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error detecting region',
        showSnackBar: false,
      );
    }
  }

  void setManualRegion(String? countryCode) {
    _manualRegion = countryCode;
    if (countryCode != null) {
      PreferencesService().prefs.setString(AppConstants.region, countryCode);
    } else {
      PreferencesService().prefs.remove(AppConstants.region);
    }
    notifyListeners();
  }
}
