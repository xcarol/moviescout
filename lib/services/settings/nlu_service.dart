import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/settings/background_tasks_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

class NluService with ChangeNotifier {
  static final NluService _instance = NluService._internal();

  factory NluService() {
    return _instance;
  }

  NluService._internal() {
    _init();
  }

  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _assetsDownloaded = false;
  int _downloadedFilesCount = 0;
  CancelToken? _cancelToken;

  bool _autoUpdate =
      PreferencesService().prefs.getBool(AppConstants.nluAutoUpdate) ?? false;

  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  bool get assetsDownloaded => _assetsDownloaded;
  int get downloadedFilesCount => _downloadedFilesCount;
  int get totalFilesCount => 4;
  bool get autoUpdate => _autoUpdate;

  Future<void> _init() async {
    await checkAssets();
  }

  void setAutoUpdate(bool value) {
    _autoUpdate = value;
    PreferencesService().prefs.setBool(AppConstants.nluAutoUpdate, value);
    setupWorker();
    notifyListeners();
  }

  void setupWorker() {
    if (_autoUpdate) {
      Workmanager().registerPeriodicTask(
        AppConstants.workerNluUpdate,
        AppConstants.taskUpdateNluAssets,
        frequency: const Duration(days: 1),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: BackgroundTasksService().wifiOnly
              ? NetworkType.unmetered
              : NetworkType.connected,
        ),
      );
    } else {
      Workmanager().cancelByUniqueName(AppConstants.workerNluUpdate);
    }
  }

  Future<String> get _nluDirectory async {
    final directory = await getApplicationSupportDirectory();
    final path = '${directory.path}/nlu_assets';
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  Future<void> checkAssets() async {
    final dirPath = await _nluDirectory;
    final modelFile = File('$dirPath/${AppConstants.nluModelFilename}');
    final dbFile = File('$dirPath/${AppConstants.nluDbFilename}');
    final metadataFile = File('$dirPath/${AppConstants.nluMetadataFilename}');
    final tokenizerFile = File('$dirPath/${AppConstants.nluTokenizerFilename}');

    int count = 0;
    if (await modelFile.exists()) count++;
    if (await dbFile.exists()) count++;
    if (await metadataFile.exists()) count++;
    if (await tokenizerFile.exists()) count++;

    _downloadedFilesCount = count;

    if (await modelFile.exists() &&
        await dbFile.exists() &&
        await tokenizerFile.exists()) {
      _assetsDownloaded = true;
    } else {
      _assetsDownloaded = false;
    }
    notifyListeners();
  }

  Future<void> downloadAssets({bool onlyDataset = false}) async {
    if (_isDownloading) return;
    _isDownloading = true;
    _downloadProgress = 0.0;
    _cancelToken = CancelToken();
    notifyListeners();

    try {
      final dirPath = await _nluDirectory;
      final dio = Dio();

      final List<Map<String, String>> filesToDownload = [
        {
          'url': UrlConstants.nluDbUrl,
          'path': '$dirPath/${AppConstants.nluDbFilename}'
        },
      ];

      if (!onlyDataset) {
        filesToDownload.add({
          'url': UrlConstants.nluMetadataUrl,
          'path': '$dirPath/${AppConstants.nluMetadataFilename}'
        });
        filesToDownload.add({
          'url': UrlConstants.nluTokenizerUrl,
          'path': '$dirPath/${AppConstants.nluTokenizerFilename}'
        });
        filesToDownload.add({
          'url': UrlConstants.nluModelUrl,
          'path': '$dirPath/${AppConstants.nluModelFilename}'
        });
      }

      double totalFiles = filesToDownload.length.toDouble();
      int completedFiles = 0;

      for (var file in filesToDownload) {
        if (_cancelToken?.isCancelled ?? false) break;
        await dio.download(
          file['url']!,
          file['path']!,
          cancelToken: _cancelToken,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              double currentFileProgress = received / total;
              _downloadProgress =
                  (completedFiles + currentFileProgress) / totalFiles;
              notifyListeners();
            }
          },
        );
        completedFiles++;
        await checkAssets();
      }

      if (!(_cancelToken?.isCancelled ?? false)) {
        _downloadProgress = 1.0;
        notifyListeners();
      }

      await checkAssets();
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading assets: $e');
      }
    } finally {
      bool wasCancelled = _cancelToken?.isCancelled ?? false;
      _isDownloading = false;
      _cancelToken = null;

      if (wasCancelled) {
        await deleteAssets();
      } else {
        await checkAssets();
      }
      notifyListeners();
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('User cancelled');
  }

  Future<void> checkForUpdates() async {
    if (!_autoUpdate || !_assetsDownloaded) return;

    try {
      final dio = Dio();
      final url = UrlConstants.nluMetadataUrl;
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final dirPath = await _nluDirectory;
        final localMetadataFile =
            File('$dirPath/${AppConstants.nluMetadataFilename}');

        bool needsUpdate = false;
        if (await localMetadataFile.exists()) {
          final localData = jsonDecode(await localMetadataFile.readAsString());
          final remoteData = response.data is String
              ? jsonDecode(response.data)
              : response.data;

          if (remoteData['version'] != localData['version'] ||
              remoteData['updated_at'] != localData['updated_at']) {
            needsUpdate = true;
          }
        } else {
          needsUpdate = true;
        }

        if (needsUpdate) {
          if (kDebugMode) {
            print('NLU: New version found, starting automatic download.');
          }
          // Save metadata locally before downloading the DB
          final newMetadataString = response.data is String
              ? response.data as String
              : jsonEncode(response.data);
          await localMetadataFile.writeAsString(newMetadataString);

          await downloadAssets(onlyDataset: true);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking NLU updates: $e');
      }
    }
  }

  Future<void> deleteAssets() async {
    final dirPath = await _nluDirectory;
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await checkAssets();
  }
}
