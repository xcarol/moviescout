import 'dart:convert';

// ignore_for_file: constant_identifier_names, unused_element

// Used fields
//
// "id": 18897,
// "name": "Jackie Chan",
// "known_for_department": "Acting",
// "gender": 2,
// "original_name": "成龍",
// "profile_path": "/nraZoTzwJQPHspAVsKfgl3RXKKa.jpg",
// "character": "Huang Dezhong",
//
// Unused fields
// "cast_id": 3,
// "credit_id": "678b57d08bca661d0542feab",
// "order": 0

class PersonAttributes {
  static const id = 'id';
  static const last_updated = 'last_updated';
  static const name = 'name';
  static const known_for_department = 'known_for_department';
  static const gender = 'gender';
  static const original_name = 'original_name';
  static const profile_path = 'profile_path';
  static const character = 'character';
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
    );
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
