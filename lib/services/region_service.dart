import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_configuration_service.dart';
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
      detectRegion(); // Don't await, run in background
    }
  }

  Future<void> detectRegion() async {
    int retryCount = 0;
    while (retryCount < 5 && _detectedRegion == null) {
      try {
        final response = await http
            .get(Uri.parse('https://ipapi.co/json/'))
            .timeout(const Duration(seconds: 2));
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _detectedRegion = data['country_code'];
          notifyListeners();
          return;
        }
      } catch (e, stackTrace) {
        if (retryCount == 4) {
          ErrorService.log(
            e,
            stackTrace: stackTrace,
            userMessage: 'Error detecting region',
            showSnackBar: false,
          );
        }
      }
      retryCount++;
      if (_detectedRegion == null) {
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }
    
    // Fallback if IP detection completely fails
    if (_detectedRegion == null) {
      final String? fallbackCountryCode = ui.PlatformDispatcher.instance.locale.countryCode;
      if (fallbackCountryCode != null && fallbackCountryCode.isNotEmpty) {
        _detectedRegion = fallbackCountryCode;
        notifyListeners();
      }
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

  String getRegionName(String? countryCode) {
    if (countryCode == null) return '';
    return TmdbConfigurationService().getCountryName(countryCode);
  }
}
