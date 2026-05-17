import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/error_service.dart';

Future<void> saveLogs(List<String> logLines) async {
  if (kDebugMode == false && dotenv.env[AppConstants.enableLogs] != 'true') {
    return;
  }

  try {
    final prefs = PreferencesService().prefs;
    final currentLogs = prefs.getStringList(AppConstants.updateLogs) ?? [];
    final newEntry = logLines.join('\n');
    currentLogs.add(newEntry);
    if (currentLogs.length > 50) {
      currentLogs.removeRange(0, currentLogs.length - 50);
    }
    await prefs.setStringList(AppConstants.updateLogs, currentLogs);
  } catch (e) {
    final errorMessage = 'Error saving logs: $e';
    debugPrint(errorMessage);
    ErrorService.log(
      errorMessage,
      userMessage: AppConstants.saveLogsMessage,
      reportToCrashlytics: true,
      stackTrace: StackTrace.current,
    );
  }
}
