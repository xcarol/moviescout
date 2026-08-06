import 'package:flutter/widgets.dart';
import 'package:moviescout/services/workers/watchlist_update_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (task == AppConstants.taskUpdateWatchlist) {
      await WatchlistUpdateService().checkForUpdates();
      return Future.value(true);
    }

    return Future.value(false);
  });
}
