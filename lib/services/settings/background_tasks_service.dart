import 'package:flutter/widgets.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/settings/nlu_service.dart';
import 'package:moviescout/services/workers/watchlist_update_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundTasksService with ChangeNotifier {
  static final BackgroundTasksService _instance =
      BackgroundTasksService._internal();

  factory BackgroundTasksService() {
    return _instance;
  }

  BackgroundTasksService._internal();

  bool get wifiOnly =>
      PreferencesService()
          .prefs
          .getBool(AppConstants.backgroundTasksWifiOnly) ??
      true;

  void setWifiOnly(bool value) {
    PreferencesService()
        .prefs
        .setBool(AppConstants.backgroundTasksWifiOnly, value);
    _updateTasksConstraints();
    notifyListeners();
  }

  void _updateTasksConstraints() {
    WatchlistUpdateService().setupWorker();
    NluService().setupWorker();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (task == AppConstants.taskUpdateNluAssets) {
      await NluService().checkForUpdates();
      return Future.value(true);
    }

    if (task == AppConstants.taskUpdateWatchlist) {
      await WatchlistUpdateService().checkForUpdates();
      return Future.value(true);
    }

    return Future.value(false);
  });
}
