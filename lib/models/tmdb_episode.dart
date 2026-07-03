import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/models/tmdb_item.dart';

class TmdbEpisode implements TmdbItem {
  @override
  late int tmdbId;

  late int tvId;
  late int seasonNumber;
  late String name;
  late String overview;
  late int episodeNumber;
  late int runtime;
  late String airDate;
  late double voteAverage;
  late String? stillPathSuffix;

  late String? guestStarsJson;
  late String? crewJson;
  late String? imagesJson;
  late String? videosJson;
  @override
  late String lastUpdated;

  TmdbEpisode({
    required this.tmdbId,
    required this.tvId,
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.episodeNumber,
    required this.runtime,
    required this.airDate,
    required this.voteAverage,
    this.stillPathSuffix,
    this.guestStarsJson,
    this.crewJson,
    this.imagesJson,
    this.videosJson,
    required this.lastUpdated,
  }) {
    if (voteAverage.isNaN) voteAverage = 0.0;
  }

  factory TmdbEpisode.fromMap(Map<String, dynamic> data, {int tvId = 0}) {
    return TmdbEpisode(
      tmdbId: data['id'] ?? 0,
      tvId: tvId,
      seasonNumber: data['season_number'] ?? 0,
      name: data['name'] ?? '',
      overview: data['overview'] ?? '',
      episodeNumber: data['episode_number'] ?? 0,
      runtime: data['runtime'] ?? 0,
      airDate: data['air_date'] ?? '',
      voteAverage: (data['vote_average'] ?? 0.0).toDouble().isNaN
          ? 0.0
          : (data['vote_average'] ?? 0.0).toDouble(),
      stillPathSuffix: data['still_path'],
      lastUpdated: AppConstants.defaultDate,
    )..fillFromMap(data);
  }

  void fillFromMap(Map<String, dynamic> data) {
    if (data['guest_stars'] != null) {
      guestStarsJson = jsonEncode(data['guest_stars']);
    }
    if (data['crew'] != null) {
      crewJson = jsonEncode(data['crew']);
    }
    if (data['images'] != null) {
      imagesJson = jsonEncode(data['images']);
    }
    if (data['videos'] != null) {
      videosJson = jsonEncode(data['videos']);
    }
    if (data['overview'] != null && data['overview'].toString().isNotEmpty) {
      overview = data['overview'];
    }
    if (data['name'] != null && data['name'].toString().isNotEmpty) {
      name = data['name'];
    }
  }

  String get stillPath => stillPathSuffix != null && stillPathSuffix!.isNotEmpty
      ? UrlConstants.tmdbImageOriginalTemplate
          .replaceFirst('{PATH}', stillPathSuffix!)
      : '';

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

  List<TmdbPerson>? _castCache;
  List<TmdbPerson> get cast {
    if (_castCache != null) return _castCache!;
    if (guestStarsJson == null) return [];
    final guestStarsList = jsonDecode(guestStarsJson!);
    _castCache = TmdbPerson.parsePersonList(
        guestStarsList is List ? guestStarsList : null, PersonAttributes.cast);
    return _castCache!;
  }

  List<TmdbPerson>? _crewCache;
  List<TmdbPerson> get crew {
    if (_crewCache != null) return _crewCache!;
    if (crewJson == null) return [];
    final crewList = jsonDecode(crewJson!);
    _crewCache = TmdbPerson.parsePersonList(
        crewList is List ? crewList : null, PersonAttributes.crew);
    return _crewCache!;
  }
}
