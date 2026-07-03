import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/models/tmdb_item.dart';

class TmdbSeason implements TmdbItem {
  late int tvId;
  @override
  late int tmdbId;
  late String name;
  late String overview;
  late int seasonNumber;
  late String airDate;
  late String? posterPathSuffix;
  late double voteAverage;
  @override
  late String lastUpdated;

  late String episodesJson;
  late String? imagesJson;
  late String? videosJson;
  late String? creditsJson;

  TmdbSeason({
    required this.tmdbId,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.airDate,
    this.posterPathSuffix,
    required this.voteAverage,
    this.episodesJson = '[]',
    this.imagesJson,
    this.videosJson,
    this.creditsJson,
    required this.tvId,
    required this.lastUpdated,
  }) {
    if (voteAverage.isNaN) voteAverage = 0.0;
  }

  factory TmdbSeason.fromMap(Map<String, dynamic> data, {int tvId = 0}) {
    return TmdbSeason(
      tmdbId: data['id'] ?? 0,
      name: data['name'] ?? '',
      overview: data['overview'] ?? '',
      seasonNumber: data['season_number'] ?? 0,
      airDate: data['air_date'] ?? '',
      posterPathSuffix: data['poster_path'],
      voteAverage: (data['vote_average'] ?? 0.0).toDouble().isNaN
          ? 0.0
          : (data['vote_average'] ?? 0.0).toDouble(),
      tvId: tvId,
      lastUpdated: AppConstants.defaultDate,
    )..fillFromMap(data);
  }

  void fillFromMap(Map<String, dynamic> data) {
    if (data['episodes'] != null) {
      episodesJson = jsonEncode(data['episodes']);
    }
    if (data['images'] != null) {
      imagesJson = jsonEncode(data['images']);
    }
    if (data['videos'] != null) {
      videosJson = jsonEncode(data['videos']);
    }
    if (data['credits'] != null || data['aggregate_credits'] != null) {
      creditsJson = jsonEncode(data['credits'] ?? data['aggregate_credits']);
    }

    if (data['overview'] != null && data['overview'].toString().isNotEmpty) {
      overview = data['overview'];
    }
    if (data['name'] != null && data['name'].toString().isNotEmpty) {
      name = data['name'];
    }
  }

  String get posterPath =>
      posterPathSuffix != null && posterPathSuffix!.isNotEmpty
          ? UrlConstants.tmdbImageOriginalTemplate
              .replaceFirst('{PATH}', posterPathSuffix!)
          : '';

  List<TmdbEpisode>? _episodesCache;
  List<TmdbEpisode> get episodes {
    if (_episodesCache != null) return _episodesCache!;
    List<TmdbEpisode> epList = [];
    try {
      final decoded = jsonDecode(episodesJson);
      if (decoded is List) {
        for (var ep in decoded) {
          epList.add(TmdbEpisode.fromMap(ep as Map<String, dynamic>));
        }
      }
    } catch (_) {}
    _episodesCache = epList;
    return epList;
  }

  List<String>? _imagesCache;
  List<String> get images {
    if (_imagesCache != null) return _imagesCache!;
    if (imagesJson == null) return [];
    try {
      final decoded = jsonDecode(imagesJson!);
      if (decoded is List) {
        _imagesCache = decoded.map((e) => e.toString()).toList();
        return _imagesCache!;
      }
    } catch (_) {}
    return [];
  }

  List<Map<String, dynamic>>? _videosCache;
  List<Map<String, dynamic>> get videos {
    if (_videosCache != null) return _videosCache!;
    if (videosJson == null) return [];
    try {
      final decoded = jsonDecode(videosJson!);
      if (decoded is List) {
        _videosCache = decoded.map((e) => e as Map<String, dynamic>).toList();
        return _videosCache!;
      }
    } catch (_) {}
    return [];
  }

  Map<String, dynamic>? _creditsMapCache;

  List<TmdbPerson>? _castCache;
  List<TmdbPerson> get cast {
    if (_castCache != null) return _castCache!;
    if (creditsJson == null) return [];
    _creditsMapCache ??= jsonDecode(creditsJson!);
    _castCache = TmdbPerson.parsePersonList(
        _creditsMapCache![PersonAttributes.cast] is List
            ? _creditsMapCache![PersonAttributes.cast]
            : null,
        PersonAttributes.cast);
    return _castCache!;
  }

  List<TmdbPerson>? _crewCache;
  List<TmdbPerson> get crew {
    if (_crewCache != null) return _crewCache!;
    if (creditsJson == null) return [];
    _creditsMapCache ??= jsonDecode(creditsJson!);
    _crewCache = TmdbPerson.parsePersonList(
        _creditsMapCache![PersonAttributes.crew] is List
            ? _creditsMapCache![PersonAttributes.crew]
            : null,
        PersonAttributes.crew);
    return _crewCache!;
  }
}
