import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbEpisodeDetails =
    '/tv/{ID}/season/{SEASON_NUMBER}/episode/{EPISODE_NUMBER}?append_to_response=images%2Cvideos%2Ccredits&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

const String _tmdbEpisodeBrief =
    '/tv/{ID}/season/{SEASON_NUMBER}/episode/{EPISODE_NUMBER}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

class TmdbEpisodeService extends TmdbBaseService {
  Future<dynamic> _retrieveEpisodeDetails(
    int id,
    int seasonNumber,
    int episodeNumber,
    String locale,
  ) async {
    return get(
      _tmdbEpisodeDetails
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
      _tmdbEpisodeBrief
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{EPISODE_NUMBER}', episodeNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<TmdbEpisode?> getEpisodeDetails(
      int tvId, int seasonNumber, int episodeNumber) async {
    final result = await _retrieveEpisodeDetails(
      tvId,
      seasonNumber,
      episodeNumber,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      ErrorService.log(
        'Failed to retrieve episode details for $tvId S$seasonNumber E$episodeNumber - ${result.statusCode} - ${result.body}',
        userMessage: 'Failed to retrieve episode details',
      );
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

    // Force inject showId and seasonNumber since endpoint root might not provide or we need it mapped exactly
    details['show_id'] = tvId;
    details['season_number'] = seasonNumber;

    return TmdbEpisode.fromMap(details);
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
