import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/tmdb_content/search_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';

enum ImdbTitleStatus { pending, success, failed }

class ImdbCsvData {
  final List<String> headers;
  final List<List<dynamic>> rows;
  final int imdbIdColumn;
  final int imdbTitleColumn;
  final int imdbRateColumn;
  final bool isRateList;

  const ImdbCsvData({
    required this.headers,
    required this.rows,
    required this.imdbIdColumn,
    required this.imdbTitleColumn,
    required this.imdbRateColumn,
    required this.isRateList,
  });

  bool get isEmpty => rows.isEmpty;
  int get length => rows.length;
}

class ImdbImportService {
  final SearchService _searchService;
  final TmdbBaseService _tmdbBaseService;

  ImdbImportService({
    SearchService? searchService,
    TmdbBaseService? tmdbBaseService,
  })  : _searchService = searchService ??
            SearchService(
              'importImdb',
              LocalTitleRepository.instance,
            ),
        _tmdbBaseService = tmdbBaseService ?? TmdbBaseService();

  static ImdbCsvData parseCsvBytes(Uint8List bytes) {
    String rawData;
    try {
      rawData = utf8.decode(bytes);
    } catch (_) {
      rawData = latin1.decode(bytes);
    }

    final normalizedData = rawData.replaceAll('\r\n', '\n');
    final List<List<dynamic>> csvData =
        const CsvDecoder().convert(normalizedData);
    if (csvData.isEmpty) {
      return const ImdbCsvData(
        headers: [],
        rows: [],
        imdbIdColumn: -1,
        imdbTitleColumn: -1,
        imdbRateColumn: -1,
        isRateList: false,
      );
    }

    final headers =
        csvData.first.map((e) => e.toString().toLowerCase()).toList();
    final imdbIdColumn = headers.indexOf('const');
    final imdbTitleColumn = headers.indexOf('title');
    final imdbRateColumn = headers.indexOf('your rating');

    final rows = csvData
        .where((row) =>
            row.length > imdbIdColumn &&
            row.length > imdbTitleColumn &&
            (imdbRateColumn == -1 || row.length > imdbRateColumn))
        .toList();

    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    final isRateList = imdbRateColumn != -1 &&
        rows.isNotEmpty &&
        rows[0][imdbRateColumn].toString().isNotEmpty;

    return ImdbCsvData(
      headers: headers,
      rows: rows,
      imdbIdColumn: imdbIdColumn,
      imdbTitleColumn: imdbTitleColumn,
      imdbRateColumn: imdbRateColumn,
      isRateList: isRateList,
    );
  }

  Future<ImdbTitleStatus> importWatchlistEntry({
    required String imdbId,
    required Locale locale,
    required WatchlistService watchlistService,
  }) async {
    final searchResult = await _searchService.searchImdbTitle(imdbId, locale);
    if (searchResult.statusCode != 200) return ImdbTitleStatus.failed;

    final List titlesFromId =
        _searchService.fromImdbIdToTitle(_tmdbBaseService.body(searchResult));
    if (titlesFromId.isEmpty) return ImdbTitleStatus.failed;

    if (await watchlistService.contains(titlesFromId.first)) {
      return ImdbTitleStatus.success;
    }

    final TmdbTitle updatedTitle =
        await TmdbTitleService().updateTitleDetails(titlesFromId.first);
    await watchlistService.updateWatchlistTitle(updatedTitle, true);

    final isSuccess = await watchlistService.contains(titlesFromId.first);
    return isSuccess ? ImdbTitleStatus.success : ImdbTitleStatus.failed;
  }

  Future<ImdbTitleStatus> importRateslistEntry({
    required String imdbId,
    required dynamic rawRating,
    required Locale locale,
    required RateslistService rateslistService,
  }) async {
    final searchResult = await _searchService.searchImdbTitle(imdbId, locale);
    if (searchResult.statusCode != 200) return ImdbTitleStatus.failed;

    final List titlesFromId =
        _searchService.fromImdbIdToTitle(_tmdbBaseService.body(searchResult));
    if (titlesFromId.isEmpty) return ImdbTitleStatus.failed;

    if (await rateslistService.contains(titlesFromId.first)) {
      return ImdbTitleStatus.success;
    }

    final TmdbTitle updatedTitle =
        await TmdbTitleService().updateTitleDetails(titlesFromId.first);

    final double parsedRating = (rawRating is num)
        ? rawRating.toDouble()
        : double.tryParse(rawRating.toString()) ?? 0.0;

    await rateslistService.updateTitleRate(updatedTitle, parsedRating);

    final isSuccess = await rateslistService.contains(titlesFromId.first);
    return isSuccess ? ImdbTitleStatus.success : ImdbTitleStatus.failed;
  }
}
