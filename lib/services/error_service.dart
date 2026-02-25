import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/main.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class ErrorService {
  static void log(
    dynamic error, {
    StackTrace? stackTrace,
    String? userMessage,
    bool showSnackBar = true,
  }) {
    debugPrint('--- ERROR ---');
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
    debugPrint('-------------');

    bool shouldReport = _shouldReportAutomatically(error);

    if (shouldReport && (Platform.isAndroid || Platform.isIOS)) {
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          reason: userMessage ?? 'General Error',
        );
      } catch (e) {
        debugPrint('Failed to report to Crashlytics: $e');
      }
    }
    if (showSnackBar) {
      final context = scaffoldMessengerKey.currentContext;
      String message = userMessage ?? '';

      if (message.isEmpty && context != null) {
        try {
          message = AppLocalizations.of(context)!.errorMessageGeneric;
        } catch (e) {
          message = 'An error occurred. Please try again later.';
        }
      }

      if (message.isNotEmpty) {
        SnackMessage.showSnackBar(message);
      }
    }
  }

  static bool _shouldReportAutomatically(dynamic error) {
    if (error is SocketException ||
        error is HandshakeException ||
        error is HttpException) {
      return false;
    }

    if (error is PlatformException &&
        error.message!.contains('Unable to establish connection on channel') &&
        error.message!.contains('FirebaseCoreHostApi.initializeCore')) {
      return false;
    }

    return true;
  }
}
