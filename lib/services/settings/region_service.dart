import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/workers/update_providers_worker.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/country_translator.dart';

class RegionService with ChangeNotifier {
  static final RegionService _instance = RegionService._internal();

  factory RegionService() {
    return _instance;
  }

  RegionService._internal();

  String? _detectedRegion =
      PreferencesService().prefs.getString('detected_region');
  String? _manualRegion =
      PreferencesService().prefs.getString(AppConstants.region);

  String? get detectedRegion => _detectedRegion;
  String? get manualRegion => _manualRegion;

  /// Returns the effective country code: manual override > detected region > null
  String? get currentRegion =>
      _manualRegion ??
      _detectedRegion ??
      ui.PlatformDispatcher.instance.locale.countryCode;

  Future<void> init() async {
    if (_manualRegion == null) {
      detectRegion(); // Don't await, run in background
    }
  }

  Future<String?> _fetchRegionFromUrl(String url) async {
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final country = (data['country_code'] ?? data['country'])?.toString();
      if (country != null && country.length == 2) {
        return country.toUpperCase();
      }
    }
    return null;
  }

  Future<void> detectRegion() async {
    final endpoints = [
      UrlConstants.ipWhoIsUrl,
      UrlConstants.countryIsUrl,
    ];

    int retryCount = 0;
    while (retryCount < 5) {
      for (final url in endpoints) {
        try {
          final newRegion = await _fetchRegionFromUrl(url);
          if (newRegion != null) {
            if (_detectedRegion != newRegion) {
              _detectedRegion = newRegion;
              PreferencesService()
                  .prefs
                  .setString('detected_region', newRegion);
              if (_manualRegion == null) {
                UpdateProvidersWorker.dispatchAll();
              }
              notifyListeners();
            }
            return;
          }
        } catch (e, stackTrace) {
          if (retryCount == 4 && url == endpoints.last) {
            ErrorService.log(
              e,
              stackTrace: stackTrace,
              userMessage: 'Error detecting region',
            );
          }
        }
      }

      retryCount++;
      if (retryCount < 5) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (_detectedRegion == null) {
      final fallbackCountryCode =
          ui.PlatformDispatcher.instance.locale.countryCode;
      if (fallbackCountryCode != null && fallbackCountryCode.isNotEmpty) {
        _detectedRegion = fallbackCountryCode;
        if (_manualRegion == null) {
          UpdateProvidersWorker.dispatchAll();
        }
        notifyListeners();
      }
    }
  }

  void setManualRegion(String? countryCode) {
    if (_manualRegion == countryCode) return;
    _manualRegion = countryCode;
    if (countryCode != null) {
      PreferencesService().prefs.setString(AppConstants.region, countryCode);
    } else {
      PreferencesService().prefs.remove(AppConstants.region);
    }
    UpdateProvidersWorker.dispatchAll();
    notifyListeners();
  }

  String getRegionName(String? countryCode) {
    if (countryCode == null) return '';
    return CountryTranslator.translate(
        countryCode, LanguageService().currentLanguage);
  }
}
