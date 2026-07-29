import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moviescout/services/settings/preferences_service.dart';

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
  String _downloadedSize = '0 MB';

  bool _wifiOnly = PreferencesService().prefs.getBool('nlu_wifi_only') ?? true;
  bool _autoUpdate = PreferencesService().prefs.getBool('nlu_auto_update') ?? false;

  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  bool get assetsDownloaded => _assetsDownloaded;
  String get downloadedSize => _downloadedSize;
  bool get wifiOnly => _wifiOnly;
  bool get autoUpdate => _autoUpdate;

  Future<void> _init() async {
    await checkAssets();
  }

  void setWifiOnly(bool value) {
    _wifiOnly = value;
    PreferencesService().prefs.setBool('nlu_wifi_only', value);
    notifyListeners();
  }

  void setAutoUpdate(bool value) {
    _autoUpdate = value;
    PreferencesService().prefs.setBool('nlu_auto_update', value);
    notifyListeners();
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
    final modelFile = File('$dirPath/model_quantized.onnx');
    final dbFile = File('$dirPath/movies_embeddings.db');
    final metadataFile = File('$dirPath/movies_metadata.json');
    final tokenizerFile = File('$dirPath/tokenizer.json');

    if (await modelFile.exists() && await dbFile.exists() && await tokenizerFile.exists()) {
      _assetsDownloaded = true;
      int totalSize = await modelFile.length() + await dbFile.length() + await tokenizerFile.length();
      if (await metadataFile.exists()) {
        totalSize += await metadataFile.length();
      }
      _downloadedSize = '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      _assetsDownloaded = false;
      _downloadedSize = '0 MB';
    }
    notifyListeners();
  }

  Future<void> downloadAssets({bool onlyDataset = false}) async {
    if (_isDownloading) return;
    _isDownloading = true;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      final dirPath = await _nluDirectory;
      final dio = Dio();
      
      final dbUrl = 'https://github.com/xcarol/moviescout/releases/download/embeddings-data/movies_embeddings.db';
      final metadataUrl = 'https://github.com/xcarol/moviescout/releases/download/embeddings-data/movies_metadata.json';
      final tokenizerUrl = 'https://huggingface.co/Xenova/paraphrase-multilingual-MiniLM-L12-v2/resolve/main/tokenizer.json';
      final modelUrl = 'https://huggingface.co/Xenova/paraphrase-multilingual-MiniLM-L12-v2/resolve/main/onnx/model_quantized.onnx';
      
      final List<Map<String, String>> filesToDownload = [
        {'url': dbUrl, 'path': '$dirPath/movies_embeddings.db'},
      ];

      if (!onlyDataset) {
        filesToDownload.add({'url': metadataUrl, 'path': '$dirPath/movies_metadata.json'});
        filesToDownload.add({'url': tokenizerUrl, 'path': '$dirPath/tokenizer.json'});
        filesToDownload.add({'url': modelUrl, 'path': '$dirPath/model_quantized.onnx'});
      }

      double totalFiles = filesToDownload.length.toDouble();
      int completedFiles = 0;

      for (var file in filesToDownload) {
        await dio.download(
          file['url']!,
          file['path']!,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              double currentFileProgress = received / total;
              _downloadProgress = (completedFiles + currentFileProgress) / totalFiles;
              notifyListeners();
            }
          },
        );
        completedFiles++;
      }

      _downloadProgress = 1.0;
      notifyListeners();

      await checkAssets();
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading assets: $e');
      }
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> checkForUpdates() async {
    if (!_autoUpdate || !_assetsDownloaded) return;

    try {
      final dio = Dio();
      final url = 'https://github.com/xcarol/moviescout/releases/download/embeddings-data/movies_metadata.json';
      final response = await dio.get(url);
      
      // Si el codi de resposta és correcte, comparem amb el fitxer local
      if (response.statusCode == 200) {
        final dirPath = await _nluDirectory;
        final localMetadataFile = File('$dirPath/movies_metadata.json');
        
        bool needsUpdate = false;
        if (await localMetadataFile.exists()) {
          final localData = jsonDecode(await localMetadataFile.readAsString());
          final remoteData = response.data is String ? jsonDecode(response.data) : response.data;
          
          // Exemple: si la data (o versió) ha canviat, descarreguem de nou
          if (remoteData['version'] != localData['version'] || 
              remoteData['updated_at'] != localData['updated_at']) {
            needsUpdate = true;
          }
        } else {
          needsUpdate = true;
        }

        if (needsUpdate) {
          if (kDebugMode) {
            print('NLU: Nova versió trobada, començant descàrrega automàtica.');
          }
          // Guardem el metadata localment abans de descarregar el DB per tenir-lo actualitzat
          final newMetadataString = response.data is String ? response.data as String : jsonEncode(response.data);
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
