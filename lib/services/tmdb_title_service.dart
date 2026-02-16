import 'dart:convert';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

const String _tmdbDetails =
    '/{MEDIA_TYPE}/{ID}?append_to_response=external_ids%2Cwatch%2Fproviders%2Crecommendations%2Cimages%2Cvideos%2C{CREDITS_TYPE}&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

const String _tmdbBrief =
    '/{MEDIA_TYPE}/{ID}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

const String _tmdbProviders = '/{MEDIA_TYPE}/{ID}/watch/providers';

class TmdbTitleService extends TmdbBaseService {
  Future<dynamic> _retrieveTitleDetails(
    int id,
    String mediaType,
    String locale,
  ) async {
    final creditsType = mediaType == ApiConstants.movie
        ? TmdbTitleFields.credits
        : TmdbTitleFields.aggregateCredits;

    return get(
      _tmdbDetails
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale)
          .replaceFirst('{CREDITS_TYPE}', creditsType),
    );
  }

  Future<dynamic> _retrieveTitleBrief(
    int id,
    String mediaType,
    String locale,
  ) async {
    return get(
      _tmdbBrief
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }

  Future<dynamic> _retrieveTitleProviders(
    int id,
    String mediaType,
  ) async {
    return get(
      _tmdbProviders
          .replaceFirst('{MEDIA_TYPE}', mediaType)
          .replaceFirst('{ID}', id.toString()),
    );
  }

  static bool isUpToDate(TmdbTitle title) {
    return DateTime.now()
            .difference(
              DateTime.parse(title.lastUpdated),
            )
            .inDays <
        3;
  }

  Future<TmdbTitle> updateTitleDetails(TmdbTitle title,
      {bool force = false}) async {
    if (!force && isUpToDate(title)) {
      return title;
    }

    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleDetails(
      title.tmdbId,
      mediaType,
      '${getLanguageCode()}-${getCountryCode()}',
    );

    if (result.statusCode != 200) {
      ErrorService.log(
        'Failed to retrieve title details for ${title.tmdbId} - ${result.statusCode} - ${result.body}',
        userMessage: 'Failed to retrieve title details',
      );
      return title;
    }

    final Map<String, dynamic> details = body(result);

    details[TmdbTitleFields.providers] =
        details['watch/providers']?['results']?[getCountryCode()] ?? {};

    if (details['recommendations'] != null &&
        details['recommendations']['results'] != null) {
      details[TmdbTitleFields.recommendations] =
          details['recommendations']['results'];
    }

    if (mediaType == ApiConstants.tv) {
      final externalIds = details['external_ids'];
      if (externalIds != null && externalIds['imdb_id'] != null) {
        details[TmdbTitleFields.imdbId] = externalIds['imdb_id'];
      }
    }

    _mergeMediaFallback(details, details);

    details[TmdbTitleFields.homepage] = details['homepage'];

    final hasOverview = (details[TmdbTitleFields.overview] ?? '').isNotEmpty;
    final hasMedia = (details[TmdbTitleFields.images] as List).isNotEmpty ||
        (details[TmdbTitleFields.videos] as List).isNotEmpty;

    if (!hasOverview || !hasMedia) {
      final fallbackResult = await _retrieveTitleBrief(
        title.tmdbId,
        mediaType,
        getCountryCode().toLowerCase(),
      );

      if (fallbackResult.statusCode == 200) {
        _mergeFallback(details, body(fallbackResult), mediaType);
      }
    }

    final hasOverviewFinal =
        (details[TmdbTitleFields.overview] ?? '').isNotEmpty;
    final hasMediaFinal =
        (details[TmdbTitleFields.images] as List).isNotEmpty ||
            (details[TmdbTitleFields.videos] as List).isNotEmpty;

    if (!hasOverviewFinal || !hasMediaFinal) {
      final enResult = await _retrieveTitleBrief(
        title.tmdbId,
        mediaType,
        'en-US',
      );

      if (enResult.statusCode == 200) {
        _mergeFallback(details, body(enResult), mediaType);
      }
    }

    details[TmdbTitleFields.mediaType] = mediaType;
    details[TmdbTitleFields.lastUpdated] = DateTime.now().toIso8601String();

    title.fillFromMap(details);

    return title;
  }

  Future<TmdbTitle> updateTitleProviders(TmdbTitle title) async {
    String mediaType = title.mediaType;
    if (mediaType == '') {
      mediaType = title.isMovie ? ApiConstants.movie : ApiConstants.tv;
    }

    final result = await _retrieveTitleProviders(title.tmdbId, mediaType);

    if (result.statusCode != 200) {
      return title;
    }

    final Map<String, dynamic> results = body(result);
    final Map<String, dynamic> providers =
        results['results']?[getCountryCode()] ?? {};

    title.providersJson = jsonEncode(providers);
    TmdbTitle.updateProviderIds(title, providers);

    return title;
  }

  void _mergeFallback(Map<String, dynamic> target,
      Map<String, dynamic> fallback, String mediaType) {
    final String fallbackOverview = fallback[TmdbTitleFields.overview] ?? '';

    if (fallbackOverview.isNotEmpty) {
      target[TmdbTitleFields.overview] = fallbackOverview;

      if (mediaType == ApiConstants.movie) {
        if (fallback[TmdbTitleFields.title] != null) {
          target[TmdbTitleFields.title] = fallback[TmdbTitleFields.title];
        }
        if (fallback[TmdbTitleFields.originalTitle] != null) {
          target[TmdbTitleFields.originalTitle] =
              fallback[TmdbTitleFields.originalTitle];
        }
      } else {
        if (fallback[TmdbTitleFields.name] != null) {
          target[TmdbTitleFields.name] = fallback[TmdbTitleFields.name];
        }
        if (fallback[TmdbTitleFields.originalName] != null) {
          target[TmdbTitleFields.originalName] =
              fallback[TmdbTitleFields.originalName];
        }
      }
    }

    _mergeMediaFallback(target, fallback, overwriteIfEmpty: true);
  }

  void _mergeMediaFallback(
      Map<String, dynamic> target, Map<String, dynamic> source,
      {bool overwriteIfEmpty = false}) {
    if (source['images'] != null && source['images']['backdrops'] != null) {
      List<dynamic> backdrops = List.from(source['images']['backdrops']);
      if (backdrops.isNotEmpty || overwriteIfEmpty) {
        backdrops.sort((a, b) =>
            (b['vote_average'] ?? 0).compareTo(a['vote_average'] ?? 0));
        target[TmdbTitleFields.images] =
            backdrops.take(10).map((b) => b['file_path']).toList();
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
                })
            .toList();
      }
    }

    if (target[TmdbTitleFields.videos] is! List) {
      target[TmdbTitleFields.videos] = [];
    }
  }
}
