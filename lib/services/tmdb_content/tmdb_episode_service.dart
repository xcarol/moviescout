import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';

class TmdbEpisodeService extends TmdbBaseService {
  final _repository = TmdbTitleRepository();

  Future<dynamic> _retrieveEpisodeDetails(
    int id,
    int seasonNumber,
    int episodeNumber,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbEpisodeDetailsEndpoint
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{EPISODE_NUMBER}', episodeNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<dynamic> _retrieveEpisodeBrief(
    int id,
    int seasonNumber,
    int episodeNumber,
    String locale,
  ) async {
    return get(
      UrlConstants.tmdbEpisodeBriefEndpoint
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{EPISODE_NUMBER}', episodeNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<TmdbEpisode?> getEpisodeDetails(
      int tvId, int seasonNumber, int episodeNumber,
      {bool isPrefetch = false}) async {
    final dbEpisode =
        await _repository.getEpisode(tvId, seasonNumber, episodeNumber);

    if (dbEpisode != null && TmdbTitleService.isUpToDate(dbEpisode)) {
      if (!isPrefetch) {
        _prefetchAdjacents(tvId, seasonNumber, episodeNumber);
      }
      return dbEpisode;
    }

    final result = await _retrieveEpisodeDetails(
      tvId,
      seasonNumber,
      episodeNumber,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      if (result.statusCode != 404) {
        ErrorService.log(
          'Failed to retrieve episode details for $tvId season $seasonNumber episode $episodeNumber - ${result.statusCode} - ${result.body}',
          userMessage: 'Failed to retrieve episode details',
        );
      }
      return null;
    }

    final Map<String, dynamic> details = body(result);

    _mergeMediaFallback(details, details);

    final hasOverview = (details[TmdbTitleFields.overview] ?? '').isNotEmpty;
    final hasMedia = (details[TmdbTitleFields.images] is List &&
            (details[TmdbTitleFields.images] as List).isNotEmpty) ||
        (details[TmdbTitleFields.videos] is List &&
            (details[TmdbTitleFields.videos] as List).isNotEmpty);

    if (!hasOverview || !hasMedia) {
      final fallbackResult = await _retrieveEpisodeBrief(
        tvId,
        seasonNumber,
        episodeNumber,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        _mergeFallback(details, body(fallbackResult));
      }
    }

    final hasOverviewFinal =
        (details[TmdbTitleFields.overview] ?? '').isNotEmpty;
    final hasMediaFinal = (details[TmdbTitleFields.images] is List &&
            (details[TmdbTitleFields.images] as List).isNotEmpty) ||
        (details[TmdbTitleFields.videos] is List &&
            (details[TmdbTitleFields.videos] as List).isNotEmpty);

    if (!hasOverviewFinal || !hasMediaFinal) {
      final enResult = await _retrieveEpisodeBrief(
        tvId,
        seasonNumber,
        episodeNumber,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        _mergeFallback(details, body(enResult));
      }
    }

    final episode = TmdbEpisode.fromMap(details, tvId: tvId);
    episode.lastUpdated = DateTime.now().toIso8601String();

    await _repository.putEpisode(episode);

    if (!isPrefetch) {
      _prefetchAdjacents(tvId, seasonNumber, episodeNumber);
    }

    return episode;
  }

  Future<void> _prefetchAdjacents(
      int tvId, int seasonNumber, int episodeNumber) async {
    if (episodeNumber > 1) {
      getEpisodeDetails(tvId, seasonNumber, episodeNumber - 1,
          isPrefetch: true);
    }

    final season = await _repository.getSeason(tvId, seasonNumber);
    if (season != null && episodeNumber + 1 <= season.episodes.length) {
      getEpisodeDetails(tvId, seasonNumber, episodeNumber + 1,
          isPrefetch: true);
    }
  }

  void _mergeFallback(
      Map<String, dynamic> target, Map<String, dynamic> fallback) {
    final String fallbackOverview = fallback[TmdbTitleFields.overview] ?? '';

    if (fallbackOverview.isNotEmpty) {
      target[TmdbTitleFields.overview] = fallbackOverview;

      if (fallback[TmdbTitleFields.name] != null) {
        target[TmdbTitleFields.name] = fallback[TmdbTitleFields.name];
      }
    }

    _mergeMediaFallback(target, fallback, overwriteIfEmpty: true);
  }

  void _mergeMediaFallback(
      Map<String, dynamic> target, Map<String, dynamic> source,
      {bool overwriteIfEmpty = false}) {
    if (source['images'] != null && source['images']['stills'] != null) {
      List<dynamic> stills = List.from(source['images']['stills']);
      if (stills.isNotEmpty || overwriteIfEmpty) {
        stills.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            stills.take(10).map((b) => b['file_path']).toList();
      }
    }

    if (target[TmdbTitleFields.images] is! List) {
      target[TmdbTitleFields.images] = [];
    }

    if (source['videos'] != null && source['videos']['results'] != null) {
      List<dynamic> videos = List.from(source['videos']['results']);

      videos = videos
          .where((v) => (v['site'] ?? '').toString().toLowerCase() == 'youtube')
          .toList();

      if (videos.isNotEmpty || overwriteIfEmpty) {
        videos.sort((a, b) {
          final aOfficial = a['official'] == true ? 1 : 0;
          final bOfficial = b['official'] == true ? 1 : 0;
          if (aOfficial != bOfficial) return bOfficial.compareTo(aOfficial);

          final aTrailer = a['type'] == 'Trailer' ? 1 : 0;
          final bTrailer = b['type'] == 'Trailer' ? 1 : 0;
          return bTrailer.compareTo(aTrailer);
        });

        target[TmdbTitleFields.videos] = videos
            .take(5)
            .map((v) => {
                  TmdbTitleFields.key: v['key'],
                  TmdbTitleFields.site: v['site'],
                  TmdbTitleFields.name: v['name'],
                  TmdbTitleFields.iso6391: v['iso_639_1'],
                  TmdbTitleFields.isSearchResult:
                      v[TmdbTitleFields.isSearchResult] ?? false,
                })
            .toList();
      }
    }

    if (target[TmdbTitleFields.videos] is! List) {
      target[TmdbTitleFields.videos] = [];
    }
  }
}
