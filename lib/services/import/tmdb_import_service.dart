import 'dart:ui';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

enum ImportProgressStage {
  fetchingWatchlist,
  fetchingRateslist,
  fetchingEpisodes,
  uploadingCloud,
}

typedef ImportProgressCallback = void Function({
  required ImportProgressStage stage,
  int? count,
  int? current,
  int? total,
  double? progress,
});

class TmdbImportService extends TmdbBaseService {
  final LocalTitleRepository _repository;
  final CloudTitleRepository _cloudRepository;

  TmdbImportService(
    this._repository, {
    CloudTitleRepository? cloudRepository,
  }) : _cloudRepository = cloudRepository ?? CloudTitleRepository();

  Future<void> importFromTmdb({
    required String accountId,
    required String sessionId,
    required Locale locale,
    ImportProgressCallback? onProgress,
  }) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) {
      throw Exception('Supabase session not initialized for import.');
    }

    try {
      onProgress?.call(stage: ImportProgressStage.fetchingWatchlist);
      final watchlistTitles = await _fetchWatchlist(
        accountId: accountId,
        sessionId: sessionId,
        locale: locale,
      );
      onProgress?.call(
        stage: ImportProgressStage.fetchingWatchlist,
        count: watchlistTitles.length,
      );

      onProgress?.call(stage: ImportProgressStage.fetchingRateslist);
      final rateslistTitles = await _fetchRateslist(
        accountId: accountId,
        sessionId: sessionId,
        locale: locale,
      );
      onProgress?.call(
        stage: ImportProgressStage.fetchingRateslist,
        count: rateslistTitles.length,
      );

      onProgress?.call(stage: ImportProgressStage.fetchingEpisodes);
      final ratedEpisodes = await _fetchRatedEpisodes(
        accountId: accountId,
        sessionId: sessionId,
        locale: locale,
      );
      onProgress?.call(
        stage: ImportProgressStage.fetchingEpisodes,
        count: ratedEpisodes.length,
      );

      int index = 0;
      final baseTime = DateTime.now().toUtc();

      for (var j = 0; j < watchlistTitles.length; j++) {
        watchlistTitles[j].createdAt ??=
            baseTime.add(Duration(milliseconds: index++));
      }

      for (var j = 0; j < rateslistTitles.length; j++) {
        final title = rateslistTitles[j];
        if (title.rating > 0 && title.dateRated.year >= 2000) {
          title.createdAt = title.dateRated.toUtc();
        } else {
          title.createdAt = baseTime.add(Duration(milliseconds: index++));
        }
      }

      await _repository.saveTitles(watchlistTitles, AppConstants.watchlist);
      await _repository.saveTitles(rateslistTitles, AppConstants.rateslist);
      for (final episode in ratedEpisodes) {
        await _repository.putEpisode(episode);
      }

      final watchlistRecords = watchlistTitles.map((title) {
        return <String, dynamic>{
          'user_id': user.id,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'list_name': AppConstants.watchlist,
          'rating': title.rating,
          'is_pinned': title.isPinned,
          'notify_new_seasons': title.notifyNewSeasons,
          'name': title.name,
          'poster_path': title.posterPathSuffix,
          'vote_average': title.voteAverage,
          'created_at': (title.createdAt ?? baseTime).toIso8601String(),
        };
      }).toList();

      final rateslistRecords = rateslistTitles.map((title) {
        final record = <String, dynamic>{
          'user_id': user.id,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'list_name': AppConstants.rateslist,
          'rating': title.rating,
          'is_pinned': title.isPinned,
          'notify_new_seasons': title.notifyNewSeasons,
          'name': title.name,
          'poster_path': title.posterPathSuffix,
          'vote_average': title.voteAverage,
          'created_at': (title.createdAt ?? baseTime).toIso8601String(),
        };
        if (title.rating > 0 && title.dateRated.year >= 2000) {
          record['rated_date'] = title.dateRated.toUtc().toIso8601String();
        }
        return record;
      }).toList();

      int epIndex = 0;
      final episodeRecords = ratedEpisodes.map((episode) {
        return <String, dynamic>{
          'user_id': user.id,
          'show_tmdb_id': episode.tvId,
          'season_number': episode.seasonNumber,
          'episode_number': episode.episodeNumber,
          'episode_tmdb_id': episode.tmdbId,
          'rating': episode.rating,
          'rated_date': episode.lastUpdated,
          'created_at':
              baseTime.add(Duration(milliseconds: epIndex++)).toIso8601String(),
        };
      }).toList();

      final allRecords = [...watchlistRecords, ...rateslistRecords];
      final total = allRecords.length + episodeRecords.length;

      if (total == 0) {
        onProgress?.call(
          stage: ImportProgressStage.uploadingCloud,
          current: 0,
          total: 0,
          progress: 1.0,
        );
        return;
      }

      onProgress?.call(
        stage: ImportProgressStage.uploadingCloud,
        current: 0,
        total: total,
        progress: 0.0,
      );

      final chunkSize = 50;
      int processed = 0;

      for (var i = 0; i < allRecords.length; i += chunkSize) {
        final chunk = allRecords.sublist(
          i,
          i + chunkSize > allRecords.length ? allRecords.length : i + chunkSize,
        );

        await _cloudRepository.bulkUpsertUserTitles(chunk);

        processed += chunk.length;
        onProgress?.call(
          stage: ImportProgressStage.uploadingCloud,
          current: processed,
          total: total,
          progress: processed / total,
        );
      }

      for (var i = 0; i < episodeRecords.length; i += chunkSize) {
        final chunk = episodeRecords.sublist(
          i,
          i + chunkSize > episodeRecords.length
              ? episodeRecords.length
              : i + chunkSize,
        );

        await _cloudRepository.bulkUpsertEpisodeRatings(chunk);

        processed += chunk.length;
        onProgress?.call(
          stage: ImportProgressStage.uploadingCloud,
          current: processed,
          total: total,
          progress: processed / total,
        );
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Import from TMDb failed.',
      );
      rethrow;
    }
  }

  Future<List<TmdbTitle>> _fetchWatchlist({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final localeStr = '${locale.languageCode}-${locale.countryCode}';
    final moviesUrl = UrlConstants.tmdbWatchlistMoviesEndpoint
        .replaceFirst('{ACCOUNT_ID}', accountId)
        .replaceFirst('{SESSION_ID}', sessionId)
        .replaceFirst('{LOCALE}', localeStr);

    final tvUrl = UrlConstants.tmdbWatchlistTvEndpoint
        .replaceFirst('{ACCOUNT_ID}', accountId)
        .replaceFirst('{SESSION_ID}', sessionId)
        .replaceFirst('{LOCALE}', localeStr);

    final moviesRaw = await _fetchPagedResults(moviesUrl);
    final tvRaw = await _fetchPagedResults(tvUrl);

    final List<TmdbTitle> titles = [];
    for (final item in moviesRaw) {
      item[TmdbTitleFields.mediaType] = ApiConstants.movie;
      titles.add(TmdbTitle.fromMap(title: item));
    }
    for (final item in tvRaw) {
      item[TmdbTitleFields.mediaType] = ApiConstants.tv;
      titles.add(TmdbTitle.fromMap(title: item));
    }
    return titles;
  }

  Future<List<TmdbTitle>> _fetchRateslist({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final localeStr = '${locale.languageCode}-${locale.countryCode}';
    final moviesUrl = UrlConstants.tmdbRateslistMoviesEndpoint
        .replaceFirst('{ACCOUNT_ID}', accountId)
        .replaceFirst('{SESSION_ID}', sessionId)
        .replaceFirst('{LOCALE}', localeStr);

    final tvUrl = UrlConstants.tmdbRateslistTvEndpoint
        .replaceFirst('{ACCOUNT_ID}', accountId)
        .replaceFirst('{SESSION_ID}', sessionId)
        .replaceFirst('{LOCALE}', localeStr);

    final moviesRaw =
        await _fetchPagedResults(moviesUrl, version: ApiVersion.v4);
    final tvRaw = await _fetchPagedResults(tvUrl, version: ApiVersion.v4);

    final List<TmdbTitle> titles = [];
    for (final item in moviesRaw) {
      item[TmdbTitleFields.mediaType] = ApiConstants.movie;
      titles.add(TmdbTitle.fromMap(title: item));
    }
    for (final item in tvRaw) {
      item[TmdbTitleFields.mediaType] = ApiConstants.tv;
      titles.add(TmdbTitle.fromMap(title: item));
    }
    return titles;
  }

  Future<List<TmdbEpisode>> _fetchRatedEpisodes({
    required String accountId,
    required String sessionId,
    required Locale locale,
  }) async {
    final localeStr = '${locale.languageCode}-${locale.countryCode}';
    final episodesUrl = UrlConstants.tmdbRatedEpisodesEndpoint
        .replaceFirst('{ACCOUNT_ID}', accountId)
        .replaceFirst('{SESSION_ID}', sessionId)
        .replaceFirst('{LOCALE}', localeStr);

    final rawResults = await _fetchPagedResults(episodesUrl);
    final List<TmdbEpisode> episodes = [];

    for (final item in rawResults) {
      final tvId = item['show_id'] ?? 0;
      final episode = TmdbEpisode.fromMap(item, tvId: tvId);
      episode.rating = (item['rating'] ?? 0.0).toDouble();
      episode.lastUpdated = DateTime.now().toIso8601String();
      episodes.add(episode);
    }

    return episodes;
  }

  Future<List<Map<String, dynamic>>> _fetchPagedResults(
    String endpointTemplate, {
    ApiVersion version = ApiVersion.v3,
  }) async {
    int page = 1;
    int totalPages = 1;
    final List<Map<String, dynamic>> results = [];

    while (page <= totalPages) {
      final endpoint = endpointTemplate.replaceFirst('{PAGE}', page.toString());
      final response = await get(endpoint, version: version);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = body(response);
        totalPages = data['total_pages'] ?? 1;
        final list = data['results'] as List<dynamic>? ?? [];
        for (final item in list) {
          if (item is Map) {
            results.add(Map<String, dynamic>.from(item));
          }
        }
      } else {
        break;
      }
      page++;
    }
    return results;
  }
}
