import 'dart:convert';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_person.dart';

class TmdbSeason {
  late int tmdbId;
  late String name;
  late String overview;
  late int seasonNumber;
  late String airDate;
  late String? posterPathSuffix;
  late double voteAverage;

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
  });

  factory TmdbSeason.fromMap(Map<String, dynamic> data) {
    return TmdbSeason(
      tmdbId: data['id'] ?? 0,
      name: data['name'] ?? '',
      overview: data['overview'] ?? '',
      seasonNumber: data['season_number'] ?? 0,
      airDate: data['air_date'] ?? '',
      posterPathSuffix: data['poster_path'],
      voteAverage: (data['vote_average'] ?? 0.0).toDouble(),
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
          ? 'https://image.tmdb.org/t/p/original$posterPathSuffix'
          : '';

  List<TmdbEpisode> get episodes {
    List<TmdbEpisode> epList = [];
    try {
      final decoded = jsonDecode(episodesJson);
      if (decoded is List) {
        for (var ep in decoded) {
          epList.add(TmdbEpisode.fromMap(ep as Map<String, dynamic>));
        }
      }
    } catch (_) {}
    return epList;
  }

  List<String> get images {
    if (imagesJson == null) return [];
    try {
      final decoded = jsonDecode(imagesJson!);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  List<Map<String, dynamic>> get videos {
    if (videosJson == null) return [];
    try {
      final decoded = jsonDecode(videosJson!);
      if (decoded is List) {
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }

  List<TmdbPerson> get cast {
    if (creditsJson == null) return [];
    final creditsMap = jsonDecode(creditsJson!);
    return TmdbPerson.parsePersonList(
        creditsMap[PersonAttributes.cast] is List
            ? creditsMap[PersonAttributes.cast]
            : null,
        PersonAttributes.cast);
  }

  List<TmdbPerson> get crew {
    if (creditsJson == null) return [];
    final creditsMap = jsonDecode(creditsJson!);
    return TmdbPerson.parsePersonList(
        creditsMap[PersonAttributes.crew] is List
            ? creditsMap[PersonAttributes.crew]
            : null,
        PersonAttributes.crew);
  }
}
