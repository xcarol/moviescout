import 'dart:isolate';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class NluInferenceRequest {
  final String query;
  final String modelPath;
  final String dbPath;
  final String tokenizerPath;
  final RootIsolateToken rootIsolateToken;

  NluInferenceRequest({
    required this.query,
    required this.modelPath,
    required this.dbPath,
    required this.tokenizerPath,
    required this.rootIsolateToken,
  });
}

class NluInferenceService {
  static Future<List<int>> search(String query) async {
    final directory = await getApplicationSupportDirectory();
    final modelPath =
        '${directory.path}/nlu_assets/${AppConstants.nluModelFilename}';
    final dbPath = '${directory.path}/nlu_assets/${AppConstants.nluDbFilename}';
    final tokenizerPath =
        '${directory.path}/nlu_assets/${AppConstants.nluTokenizerFilename}';

    if (!File(modelPath).existsSync() ||
        !File(dbPath).existsSync() ||
        !File(tokenizerPath).existsSync()) {
      return [];
    }

    final rootToken = RootIsolateToken.instance!;
    final request = NluInferenceRequest(
      query: query,
      modelPath: modelPath,
      dbPath: dbPath,
      tokenizerPath: tokenizerPath,
      rootIsolateToken: rootToken,
    );

    // Run ONNX in an isolate to avoid blocking the UI
    final queryEmbedding = await Isolate.run(() => _performInference(request));

    if (queryEmbedding.isEmpty) return [];

    // Run SQLite query on the main isolate to avoid native channel issues
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final db = await openDatabase(dbPath);

      final List<Map<String, dynamic>> records =
          await db.query(AppConstants.movieEmbeddings, columns: [
        AppConstants.tmdbId,
        AppConstants.embedding,
        TmdbTitleFields.voteAverage,
        TmdbTitleFields.voteCount
      ]);

      List<Map<String, dynamic>> results = [];
      for (var record in records) {
        List<double> dbEmbedding =
            _parseEmbedding(record[AppConstants.embedding]);
        double similarity = _cosineSimilarity(queryEmbedding, dbEmbedding);

        double voteAverage =
            (record[TmdbTitleFields.voteAverage] as num?)?.toDouble() ?? 0.0;
        int voteCount =
            (record[TmdbTitleFields.voteCount] as num?)?.toInt() ?? 0;

        // Hybrid score: 80% neural similarity, 20% quality/popularity.
        double popularityWeight = (voteCount > 100) ? 1.0 : (voteCount / 100);
        double normalizedRating = (voteAverage / 10.0) * popularityWeight;

        double hybridScore = (similarity * 0.8) + (normalizedRating * 0.2);

        results.add({
          AppConstants.tmdbId: record[AppConstants.tmdbId],
          AppConstants.similarity: hybridScore,
        });
      }

      await db.close();

      results.sort((a, b) =>
          b[AppConstants.similarity].compareTo(a[AppConstants.similarity]));

      return results
          .take(20)
          .map((r) => r[AppConstants.tmdbId] as int)
          .toList();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error in SQL search',
      );
      return [];
    }
  }

  static Future<List<double>> _performInference(
      NluInferenceRequest request) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
        request.rootIsolateToken);

    try {
      OrtEnv.instance.init();

      final sessionOptions = OrtSessionOptions();
      final session =
          OrtSession.fromFile(File(request.modelPath), sessionOptions);

      final tokenizer =
          TokenizerJsonLoader.fromJsonFileSync(request.tokenizerPath);
      tokenizer.enablePadding(length: 128);
      tokenizer.enableTruncation(maxLength: 128);

      // XLM-RoBERTa / SentencePiece models require spaces to be replaced with U+2581
      final String processedQuery =
          ' ${request.query}'.replaceAll(' ', '\u2581');

      final encoding = tokenizer.encode(processedQuery);

      final inputIds = encoding.ids.toList();
      final attentionMask = encoding.attentionMask.toList();
      final tokenTypeIds = encoding.typeIds.toList();

      final inputIdsTensor =
          OrtValueTensor.createTensorWithDataList(inputIds, [1, 128]);
      final attentionMaskTensor =
          OrtValueTensor.createTensorWithDataList(attentionMask, [1, 128]);
      final tokenTypeIdsTensor =
          OrtValueTensor.createTensorWithDataList(tokenTypeIds, [1, 128]);

      final inputs = {
        'input_ids': inputIdsTensor,
        'attention_mask': attentionMaskTensor,
        'token_type_ids': tokenTypeIdsTensor,
      };

      final runOptions = OrtRunOptions();
      final outputs = session.run(runOptions, inputs);

      List<double> queryEmbedding = List.filled(384, 0.0);
      final outputTensor = outputs[0]?.value as List<List<List<double>>>?;

      if (outputTensor != null &&
          outputTensor.isNotEmpty &&
          outputTensor[0].isNotEmpty) {
        final sequenceEmbeddings = outputTensor[0];
        List<double> sumEmbeddings = List.filled(384, 0.0);
        int validTokens = 0;

        // Mean pooling with attention mask
        for (int i = 0; i < sequenceEmbeddings.length; i++) {
          if (attentionMask[i] == 1) {
            for (int j = 0; j < 384; j++) {
              sumEmbeddings[j] += sequenceEmbeddings[i][j];
            }
            validTokens++;
          }
        }

        if (validTokens > 0) {
          for (int j = 0; j < 384; j++) {
            queryEmbedding[j] = sumEmbeddings[j] / validTokens;
          }
        }
      }

      inputIdsTensor.release();
      attentionMaskTensor.release();
      tokenTypeIdsTensor.release();
      runOptions.release();
      for (var element in outputs) {
        element?.release();
      }
      session.release();
      sessionOptions.release();
      OrtEnv.instance.release();

      return queryEmbedding;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error in NLU Isolate',
      );
      return [];
    }
  }

  static double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length || a.isEmpty) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0 || normB == 0) return 0.0;
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  static List<double> _parseEmbedding(dynamic dbValue) {
    if (dbValue is List<int>) {
      final bytes =
          dbValue is Uint8List ? dbValue : Uint8List.fromList(dbValue);
      final floatList = Float32List.view(
          bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes ~/ 4);
      return floatList.toList();
    }
    return List.filled(384, 0.0);
  }
}
