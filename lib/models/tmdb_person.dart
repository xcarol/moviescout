import 'dart:convert';

// ignore_for_file: constant_identifier_names, unused_element

// Used fields
//
// "id": 17697
// "name": "John Krasinski"
// "known_for_department": "Acting",
// "gender": 2,
// "original_name": "John Krasinski"
// "profile_path": "/pmVGDb6Yl6OyFcHVGbu1EYNfyFK.jpg"
// "character": "Jack Silva"
// "biography": ""
// "birthday": "1979-10-20"
// "deathday": null
// "imdb_id": "nm1024677"
// "place_of_birth": "Boston, Massachusetts, USA"
// "homepage": null
//
// Unused fields
// "adult": false
// "cast_id": 0
// "credit_id": "554d6669c3a36824310033be"
// "order": 0
// "popularity": 5.0091
// "also_known_as": List (7 items)

class PersonAttributes {
  static const id = 'id';
  static const last_updated = 'last_updated';
  static const name = 'name';
  static const known_for_department = 'known_for_department';
  static const gender = 'gender';
  static const original_name = 'original_name';
  static const profile_path = 'profile_path';
  static const character = 'character';
  static const biography = 'biography';
  static const birthday = 'birthday';
  static const deathday = 'deathday';
  static const imdb_id = 'imdb_id';
  static const place_of_birth = 'place_of_birth';
  static const homepage = 'homepage';
  static const combined_credits = 'combined_credits';
  static const cast = 'cast';
}

class Credit {
  final int id;

  Credit({required this.id});

  factory Credit.fromMap(Map<String, dynamic> map) {
    return Credit(
      id: map[PersonAttributes.id] ?? 0,
    );
  }
}

class CombinedCredits {
  final List<Credit> cast;

  CombinedCredits({required this.cast});

  factory CombinedCredits.fromMap(Map<String, dynamic> map) {
    final castList = (map[PersonAttributes.cast] as List?)
            ?.map((c) => Credit.fromMap(c))
            .toList() ??
        [];
    return CombinedCredits(cast: castList);
  }
}

class TmdbPerson {
  late String tmdbJson;
  late int tmdbId;
  late String name;
  late String lastUpdated;
  late String knownForDepartment;
  late int gender;
  late String originalName;
  late String profilePath;
  late String character;
  late String biography;
  late String birthday;
  late String deathday;
  late String imdbId;
  late String placeOfBirth;
  late String homepage;
  late CombinedCredits combinedCredits;

  TmdbPerson({
    required this.tmdbJson,
    required this.tmdbId,
    required this.name,
    required this.lastUpdated,
    required this.knownForDepartment,
    required this.gender,
    required this.originalName,
    required this.profilePath,
    required this.character,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.imdbId,
    required this.placeOfBirth,
    required this.homepage,
    required this.combinedCredits,
  });

  factory TmdbPerson.fromMap({required Map<dynamic, dynamic> person}) {
    return TmdbPerson(
        tmdbJson: jsonEncode(person),
        tmdbId: person[PersonAttributes.id] ?? 0,
        name: person[PersonAttributes.name],
        lastUpdated: person[PersonAttributes.last_updated] ?? '1970-01-01',
        knownForDepartment: person[PersonAttributes.known_for_department],
        gender: person[PersonAttributes.gender],
        originalName: person[PersonAttributes.original_name],
        profilePath: person[PersonAttributes.profile_path],
        character: person[PersonAttributes.character],
        biography: person[PersonAttributes.biography] ?? '',
        birthday: person[PersonAttributes.birthday] ?? '',
        deathday: person[PersonAttributes.deathday] ?? '',
        imdbId: person[PersonAttributes.imdb_id] ?? '',
        placeOfBirth: person[PersonAttributes.place_of_birth] ?? '',
        homepage: person[PersonAttributes.homepage] ?? '',
        combinedCredits: CombinedCredits.fromMap(
            person[PersonAttributes.combined_credits] ?? {}));
  }

  String get posterPath {
    return profilePath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/original$profilePath'
        : '';
  }

  Map get map {
    return jsonDecode(tmdbJson);
  }
}
