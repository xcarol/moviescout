import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_title_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await dotenv.load(fileName: ".env");
      await PreferencesService().init();
      await IsarService.init();

      final repository = TmdbTitleRepository();
      final titleService = TmdbTitleService();

      final watchlistTitles = await repository.getTitles(
        listName: AppConstants.watchlist,
        limit: 1000,
      );

      for (final title in watchlistTitles) {
        if (!TmdbTitleService.isUpToDate(title)) {
          await titleService.updateTitleDetails(title);
          await repository.saveTitle(title);
        }
      }

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
