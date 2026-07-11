import 'dart:async';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/services/notification_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/preferences_service.dart';

class UninitializedTitlesWorker {
  static bool _isRunning = false;
  static final StreamController<void> onFinished =
      StreamController<void>.broadcast();

  static void dispatch() {
    if (_isRunning) return;
    _runAsync();
  }

  static Future<void> _runAsync() async {
    _isRunning = true;
    try {
      final repository = TmdbTitleRepository();
      final titleService = TmdbTitleService();
      final notificationService = NotificationService();

      while (true) {
        final uninitializedTitles = await repository.getUninitializedTitles();

        if (uninitializedTitles.isEmpty) {
          break;
        }

        final localeStr =
            PreferencesService().prefs.getString(AppConstants.language) ?? 'ca';
        final locale = LanguageService.parseLocale(localeStr);
        final localizations = await AppLocalizations.delegate.load(locale);

        const chunkSize = AppConstants.defaultBatchSize;
        for (var i = 0; i < uninitializedTitles.length; i += chunkSize) {
          final end = (i + chunkSize < uninitializedTitles.length)
              ? i + chunkSize
              : uninitializedTitles.length;

          await notificationService.showProgressNotification(
            id: AppConstants.uninitializedTitlesNotificationId,
            title: localizations.notificationDownloadingTitle,
            body: localizations.notificationFetchingData(
                i, uninitializedTitles.length),
            progress: i,
            maxProgress: uninitializedTitles.length,
          );

          final chunk = uninitializedTitles.sublist(i, end);
          final futures = chunk.map((t) => titleService.updateTitleDetails(t));
          final updated = await Future.wait(futures);

          await repository.updateTitlesMetadata(updated.cast<TmdbTitle>());
          await Future.delayed(const Duration(milliseconds: 50));
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await notificationService
          .cancelNotification(AppConstants.uninitializedTitlesNotificationId);
      onFinished.add(null);
    } catch (e, stack) {
      ErrorService.log(
        e.toString(),
        stackTrace: stack,
        userMessage: 'Error in UninitializedTitlesWorker',
      );
      await NotificationService()
          .cancelNotification(AppConstants.uninitializedTitlesNotificationId);
    } finally {
      _isRunning = false;
    }
  }
}
