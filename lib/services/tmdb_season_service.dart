import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/youtube_service.dart';

const String _tmdbSeasonDetails =
    '/tv/{ID}/season/{SEASON_NUMBER}?append_to_response=images%2Cvideos%2Ccredits&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

const String _tmdbSeasonBrief =
    '/tv/{ID}/season/{SEASON_NUMBER}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

class TmdbSeasonService extends TmdbBaseService {
  Future<dynamic> _retrieveSeasonDetails(
    int id,
    int seasonNumber,
    String locale,
  ) async {
    return get(
      _tmdbSeasonDetails
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<dynamic> _retrieveSeasonBrief(
    int id,
    int seasonNumber,
    String locale,
  ) async {
    return get(
      _tmdbSeasonBrief
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<TmdbSeason?> getSeasonDetails(int tvId, int seasonNumber,
      {bool includeYoutubeSearch = false, String? seriesName}) async {
    final result = await _retrieveSeasonDetails(
      tvId,
      seasonNumber,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      ErrorService.log(
        'Failed to retrieve season details for $tvId season $seasonNumber - ${result.statusCode} - ${result.body}',
        userMessage: 'Failed to retrieve season details',
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
      final fallbackResult = await _retrieveSeasonBrief(
        tvId,
        seasonNumber,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        _mergeFallback(details, body(fallbackResult), ApiConstants.tv);
      }
    }

    final hasOverviewFinal =
        (details[TmdbTitleFields.overview] ?? '').isNotEmpty;
    final hasMediaFinal = (details[TmdbTitleFields.images] is List &&
            (details[TmdbTitleFields.images] as List).isNotEmpty) ||
        (details[TmdbTitleFields.videos] is List &&
            (details[TmdbTitleFields.videos] as List).isNotEmpty);

    if (!hasOverviewFinal || !hasMediaFinal) {
      final enResult = await _retrieveSeasonBrief(
        tvId,
        seasonNumber,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        _mergeFallback(details, body(enResult), ApiConstants.tv);
      }
    }

    if (includeYoutubeSearch && seriesName != null) {
      final lang = getLanguageCode();
      final country = getCountryCode();
      final query = '$seriesName season $seasonNumber';
      final youtubeVideos = await YoutubeExplodeService()
          .searchTrailers(query, '$lang-$country');

      if (youtubeVideos.isNotEmpty) {
        final List videos = details[TmdbTitleFields.videos] ?? [];
        final Set<String> existingKeys =
            videos.map((v) => v[TmdbTitleFields.key] as String).toSet();

        final List<Map<String, dynamic>> newVideos = youtubeVideos
            .where((v) => !existingKeys.contains(v[TmdbTitleFields.key]))
            .toList();

        if (newVideos.isNotEmpty) {
          details[TmdbTitleFields.videos] = [...videos, ...newVideos];
        }
      }
    }

    return TmdbSeason.fromMap(details);
  }

  void _mergeFallback(Map<String, dynamic> target,
      Map<String, dynamic> fallback, String mediaType) {
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
    if (source['images'] != null && source['images']['posters'] != null) {
      List<dynamic> posters = List.from(source['images']['posters']);
      if (posters.isNotEmpty || overwriteIfEmpty) {
        posters.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            posters.take(10).map((b) => b['file_path']).toList();
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
