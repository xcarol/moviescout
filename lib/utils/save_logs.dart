import 'package:flutter/material.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

Future<void> saveLogs(List<String> logLines) async {
  try {
    final prefs = PreferencesService().prefs;
    final currentLogs =
        prefs.getStringList(AppConstants.watchlistUpdateLogs) ?? [];
    final newEntry = logLines.join('\n');
    currentLogs.add(newEntry);
    if (currentLogs.length > 50) {
      currentLogs.removeRange(0, currentLogs.length - 50);
    }
    await prefs.setStringList(AppConstants.watchlistUpdateLogs, currentLogs);
  } catch (e) {
    debugPrint('Error saving logs: $e');
  }
}

