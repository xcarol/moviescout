import 'dart:convert';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbEpisode {
  late int id;
  late int showId;
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

  TmdbEpisode({
    required this.id,
    required this.showId,
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
  });

  factory TmdbEpisode.fromMap(Map<String, dynamic> data) {
    return TmdbEpisode(
      id: data['id'] ?? 0,
      showId: data['show_id'] ?? 0,
      seasonNumber: data['season_number'] ?? 0,
      name: data['name'] ?? '',
      overview: data['overview'] ?? '',
      episodeNumber: data['episode_number'] ?? 0,
      runtime: data['runtime'] ?? 0,
      airDate: data['air_date'] ?? '',
      voteAverage: (data['vote_average'] ?? 0.0).toDouble(),
      stillPathSuffix: data['still_path'],
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

  String get stillPath =>
      stillPathSuffix != null && stillPathSuffix!.isNotEmpty
          ? 'https://image.tmdb.org/t/p/original$stillPathSuffix'
          : '';

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
    if (guestStarsJson == null) return [];

    final guestStarsList = jsonDecode(guestStarsJson!);
    if (guestStarsList is! List) return [];

    List<TmdbPerson> castPeople = [];
    for (dynamic person in guestStarsList) {
      String character = person['character'] ?? '';

      castPeople.add(TmdbPerson(
        tmdbId: person['id'] ?? 0,
        name: person['name'] ?? '',
        lastUpdated: AppConstants.defaultDate,
        knownForDepartment: person['known_for_department'] ?? '',
        gender: person['gender'] ?? 0,
        originalName: person['original_name'] ?? '',
        profilePath: person['profile_path'] ?? '',
        character: character,
        job: person['job'] ?? '',
        biography: person['biography'] ?? '',
        birthday: person['birthday'] ?? '',
        deathday: person['deathday'] ?? '',
        imdbId: person['imdb_id'] ?? '',
        placeOfBirth: person['place_of_birth'] ?? '',
        combinedCredits: CombinedCredits.fromMap(
            person['combined_credits'] ?? {}),
        homepage: person['homepage'] ?? '',
      ));
    }
    return castPeople;
  }

  List<TmdbPerson> get crew {
    if (crewJson == null) return [];

    final crewList = jsonDecode(crewJson!);
    if (crewList is! List) return [];

    List<TmdbPerson> crewPeople = [];
    for (dynamic person in crewList) {
      String job = person['job'] ?? '';

      crewPeople.add(TmdbPerson(
        tmdbId: person['id'] ?? 0,
        name: person['name'] ?? '',
        lastUpdated: AppConstants.defaultDate,
        knownForDepartment: person['known_for_department'] ?? '',
        gender: person['gender'] ?? 0,
        originalName: person['original_name'] ?? '',
        profilePath: person['profile_path'] ?? '',
        character: person['character'] ?? '',
        job: job,
        biography: person['biography'] ?? '',
        birthday: person['birthday'] ?? '',
        deathday: person['deathday'] ?? '',
        imdbId: person['imdb_id'] ?? '',
        placeOfBirth: person['place_of_birth'] ?? '',
        combinedCredits: CombinedCredits.fromMap(
            person['combined_credits'] ?? {}),
        homepage: person['homepage'] ?? '',
      ));
    }
    return crewPeople;
  }
}
