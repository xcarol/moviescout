import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/main.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/save_logs.dart';

class ErrorService {
  static void log(
    dynamic error, {
    StackTrace? stackTrace,
    String? userMessage,
    bool showSnackBar = false,
    bool? reportToCrashlytics,
  }) {
    final isNetwork = isNetworkError(error);
    debugPrint(isNetwork ? '--- NETWORK ---' : '--- ERROR ---');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('-------------');

    if (userMessage == null || userMessage != AppConstants.saveLogsMessage) {
      final tag = isNetwork ? '== NETWORK ==' : '== ERROR ==';
      saveLogs([
        tag,
        'Error: $error',
        tag,
      ]);
    }

    final shouldReport =
        reportToCrashlytics ?? _shouldReportAutomatically(error);

    if (shouldReport && !kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      if (Firebase.apps.isNotEmpty) {
        try {
          FirebaseCrashlytics.instance.recordError(
            error,
            stackTrace,
            reason: userMessage ?? 'General Error',
          );
        } catch (e) {
          final errorMessage = 'Failed to report to Firebase Crashlytics: $e';
          debugPrint(errorMessage);

          // Don't save logs for errors that are already being saved
          if (userMessage != null &&
              userMessage != AppConstants.saveLogsMessage) {
            saveLogs([errorMessage]);
          }
        }
      }
    }

    if (showSnackBar) {
      final context = scaffoldMessengerKey.currentContext;
      String message = userMessage ?? '';

      if (context != null) {
        final loc = AppLocalizations.of(context);
        if (isNetwork) {
          message = loc?.networkErrorMessage ??
              'Unable to connect to the server. Please check your internet connection.';
        } else if (message.isEmpty || message.startsWith('Error ')) {
          message = loc?.errorMessageGeneric ??
              'An error occurred. Please try again later.';
        }
      } else if (message.isEmpty || message.startsWith('Error ')) {
        message = isNetwork
            ? 'Unable to connect to the server. Please check your internet connection.'
            : 'An error occurred. Please try again later.';
      }

      if (message.isNotEmpty) {
        SnackMessage.showSnackBar(message);
      }
    }
  }

  static bool isNetworkError(dynamic error) {
    if (error is SocketException ||
        error is HandshakeException ||
        error is HttpException ||
        error is TimeoutException ||
        error is TlsException) {
      return true;
    }

    final msg = error.toString().toLowerCase();
    return msg.contains('socketexception') ||
        msg.contains('failed host lookup') ||
        msg.contains('network is unreachable') ||
        msg.contains('connection refused') ||
        msg.contains('connection reset') ||
        msg.contains('connection closed') ||
        msg.contains('connection timed out') ||
        msg.contains('clientexception') ||
        msg.contains('software caused connection abort');
  }

  static bool _shouldReportAutomatically(dynamic error) {
    if (isNetworkError(error)) {
      return false;
    }

    if (error.toString().contains('permission-denied') ||
        error.toString().contains('PERMISSION_DENIED')) {
      return false;
    }

    if (error is PlatformException &&
        error.message?.contains('Unable to establish connection on channel') ==
            true &&
        error.message?.contains('FirebaseCoreHostApi.initializeCore') == true) {
      return false;
    }

    return true;
  }
}
