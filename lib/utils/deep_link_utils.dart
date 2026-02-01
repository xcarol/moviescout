import 'dart:io' show Platform;
import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class DeepLinkUtils {
  static Future<void> openDeepLinkSettings(BuildContext context) async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.settings.APP_OPEN_BY_DEFAULT_SETTINGS',
          data: 'package:com.xicra.moviescout',
        );
        await intent.launch();
      } catch (e) {
        // Fallback to general settings
        AppSettings.openAppSettings();
      }
    } else {
      AppSettings.openAppSettings();
    }
  }
}
