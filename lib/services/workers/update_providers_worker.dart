import 'dart:async';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/notifications/notification_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';

class UpdateProvidersWorker {
  static bool _isRunning = false;
  static final StreamController<void> onFinished =
      StreamController<void>.broadcast();

  static void dispatch(String listName) {
    if (_isRunning) return;
    _runAsync(listName);
  }

  static void dispatchAll() {
    if (_isRunning) return;
    _runAllAsync();
  }

  static Future<void> _runAsync(String listName) async {
    _isRunning = true;
    try {
      final repository = LocalTitleRepository();
      final titles = await repository.getAllTitlesInList(listName);
      if (titles.isEmpty) return;
      await _processTitles(titles, repository);
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

  static Future<void> _runAllAsync() async {
    _isRunning = true;
    try {
      final repository = LocalTitleRepository();
      final titles = await repository.getAllTitles();
      if (titles.isEmpty) return;
      await _processTitles(titles, repository);
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

  static Future<void> _processTitles(
      List<TmdbTitle> titles, LocalTitleRepository repository) async {
    final titleService = TmdbTitleService();
    final notificationService = NotificationService();

    final totalCount = titles.length;
    final localeStr =
        PreferencesService().prefs.getString(AppConstants.language) ?? 'ca';
    final locale = LanguageService.parseLocale(localeStr);
    final localizations = await AppLocalizations.delegate.load(locale);

    const batchSize = AppConstants.defaultBatchSize;

    for (var i = 0; i < totalCount; i += batchSize) {
      final end = (i + batchSize < totalCount) ? i + batchSize : totalCount;

      await notificationService.showProgressNotification(
        id: AppConstants.updateProvidersNotificationId,
        title: localizations.notificationUpdatingProviders,
        body: localizations.notificationCheckingAvailability(i, totalCount),
        progress: i,
        maxProgress: totalCount,
      );

      final batch = titles.sublist(i, end);
      final futures = batch.map((t) => titleService.updateTitleProviders(t));
      final updated = await Future.wait(futures);

      await repository.updateTitlesMetadata(updated.cast<TmdbTitle>());
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await notificationService
        .cancelNotification(AppConstants.updateProvidersNotificationId);
    onFinished.add(null);
  }
}
