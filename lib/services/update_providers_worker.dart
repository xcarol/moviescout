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

class UpdateProvidersWorker {
  static bool _isRunning = false;
  static final StreamController<void> onFinished =
      StreamController<void>.broadcast();

  static void dispatch(String listName) {
    if (_isRunning) return;
    _runAsync(listName);
  }

  static Future<void> _runAsync(String listName) async {
    _isRunning = true;
    try {
      final repository = TmdbTitleRepository();
      final titleService = TmdbTitleService();
      final notificationService = NotificationService();

      final totalCount = repository.countTitlesSync(listName);
      if (totalCount == 0) return;

      final localeStr =
          PreferencesService().prefs.getString(AppConstants.language) ?? 'ca';
      final locale = LanguageService.parseLocale(localeStr);
      final localizations = await AppLocalizations.delegate.load(locale);

      const batchSize = AppConstants.defaultBatchSize;

      for (var i = 0; i < totalCount; i += batchSize) {
        await notificationService.showProgressNotification(
          id: AppConstants.updateProvidersNotificationId,
          title: localizations.notificationUpdatingProviders,
          body: localizations.notificationCheckingAvailability(i, totalCount),
          progress: i,
          maxProgress: totalCount,
        );

        final batch = await repository.getTitles(
          listName: listName,
          offset: i,
          limit: batchSize,
        );

        final futures = batch.map((t) => titleService.updateTitleProviders(t));
        final updated = await Future.wait(futures);

        await repository.updateTitlesMetadata(updated.cast<TmdbTitle>());
        await Future.delayed(const Duration(milliseconds: 50));
      }

      await notificationService
          .cancelNotification(AppConstants.updateProvidersNotificationId);
      onFinished.add(null);
    } catch (e, stack) {
      ErrorService.log(
        e.toString(),
        stackTrace: stack,
        userMessage: 'Error in UpdateProvidersWorker',
      );
      await NotificationService()
          .cancelNotification(AppConstants.updateProvidersNotificationId);
    } finally {
      _isRunning = false;
    }
  }
}
