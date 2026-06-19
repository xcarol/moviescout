import 'dart:convert';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/person_translator.dart';

// ignore_for_file: constant_identifier_names, unused_element

class PersonAttributes {
  static const id = 'id';
  static const last_updated = 'last_updated';
  static const name = 'name';
  static const known_for_department = 'known_for_department';
  static const gender = 'gender';
  static const original_name = 'original_name';
  static const profile_path = 'profile_path';
  static const character = 'character';
  static const job = 'job';
  static const biography = 'biography';
  static const birthday = 'birthday';
  static const deathday = 'deathday';
  static const imdb_id = 'imdb_id';
  static const place_of_birth = 'place_of_birth';
  static const homepage = 'homepage';
  static const combined_credits = 'combined_credits';
  static const cast = 'cast';
  static const crew = 'crew';
  static const roles = 'roles';
  static const jobs = 'jobs';
}

class CombinedCredits {
  final List<TmdbTitle> cast;
  final List<TmdbTitle> crew;

  CombinedCredits({required this.cast, required this.crew});

  factory CombinedCredits.fromMap(Map<String, dynamic> map) {
    final castList = (map[PersonAttributes.cast] as List?)
            ?.map((c) => TmdbTitle.fromMap(title: c))
            .toList() ??
        [];
    final crewList = (map[PersonAttributes.crew] as List?)
            ?.map((c) => TmdbTitle.fromMap(title: c))
            .toList() ??
        [];
    return CombinedCredits(cast: castList, crew: crewList);
  }

  Map<String, dynamic> toMap() {
    return {
      PersonAttributes.cast: cast.map((x) => x.toMap()).toList(),
      PersonAttributes.crew: crew.map((x) => x.toMap()).toList(),
    };
  }
}

class TmdbPerson implements TmdbItem {

  @override
  late int tmdbId;

  late String name;
  late String lastUpdated;
  late String knownForDepartment;
  late int gender;
  late String originalName;
  late String profilePath;
  late String character;
  late String job;
  late String biography;
  late String birthday;
  late String deathday;
  late String imdbId;
  late String placeOfBirth;
  late String homepage;

  late String? combinedCreditsJson;

  CombinedCredits get combinedCredits {
    if (combinedCreditsJson == null) return CombinedCredits(cast: [], crew: []);
    return CombinedCredits.fromMap(jsonDecode(combinedCreditsJson!));
  }

  set combinedCredits(CombinedCredits value) {
    combinedCreditsJson = jsonEncode(value.toMap());
  }

  TmdbPerson({
    required this.tmdbId,
    required this.name,
    required this.lastUpdated,
    required this.knownForDepartment,
    required this.gender,
    required this.originalName,
    required this.profilePath,
    required this.character,
    required this.job,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.imdbId,
    required this.placeOfBirth,
    required this.homepage,
    this.combinedCreditsJson,
    CombinedCredits? combinedCredits,
  }) {
    if (combinedCredits != null) {
      combinedCreditsJson = jsonEncode(combinedCredits.toMap());
    }
  }

  factory TmdbPerson.fromMap({required Map<dynamic, dynamic> person}) {
    return TmdbPerson(
        tmdbId: person[PersonAttributes.id] ?? 0,
        name: person[PersonAttributes.name],
        lastUpdated:
            person[PersonAttributes.last_updated] ?? AppConstants.defaultDate,
        knownForDepartment: person[PersonAttributes.known_for_department],
        gender: person[PersonAttributes.gender],
        originalName: person[PersonAttributes.original_name],
        profilePath: person[PersonAttributes.profile_path] ?? '',
        character: person[PersonAttributes.character] ?? '',
        job: person[PersonAttributes.job] ?? '',
        biography: person[PersonAttributes.biography] ?? '',
        birthday: person[PersonAttributes.birthday] ?? '',
        deathday: person[PersonAttributes.deathday] ?? '',
        imdbId: person[PersonAttributes.imdb_id] ?? '',
        placeOfBirth: person[PersonAttributes.place_of_birth] ?? '',
        homepage: person[PersonAttributes.homepage] ?? '',
        combinedCreditsJson: person[PersonAttributes.combined_credits] != null 
            ? jsonEncode(person[PersonAttributes.combined_credits])
            : null);
  }

  String get posterPath {
    return profilePath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/original$profilePath'
        : '';
  }

  Map<String, dynamic> toMap() {
    return {
      PersonAttributes.id: tmdbId,
      PersonAttributes.name: name,
      PersonAttributes.last_updated: lastUpdated,
      PersonAttributes.known_for_department: knownForDepartment,
      PersonAttributes.gender: gender,
      PersonAttributes.original_name: originalName,
      PersonAttributes.profile_path: profilePath,
      PersonAttributes.character: character,
      PersonAttributes.job: job,
      PersonAttributes.biography: biography,
      PersonAttributes.birthday: birthday,
      PersonAttributes.deathday: deathday,
      PersonAttributes.imdb_id: imdbId,
      PersonAttributes.place_of_birth: placeOfBirth,
      PersonAttributes.homepage: homepage,
      PersonAttributes.combined_credits: combinedCreditsJson != null ? jsonDecode(combinedCreditsJson!) : null,
    };
  }

  static List<TmdbPerson> parsePersonList(List<dynamic>? jsonList, String roleType) {
    if (jsonList == null) return [];

    List<TmdbPerson> people = [];
    for (dynamic person in jsonList) {
      if (person is! Map) continue;

      String character = '';
      String job = '';

      if (roleType == PersonAttributes.cast) {
        if (person[PersonAttributes.roles] is List) {
          character = (person[PersonAttributes.roles] as List)
              .map((r) => r[PersonAttributes.character] ?? '')
              .where((c) => c.toString().isNotEmpty)
              .join(', ');
        } else {
          character = person[PersonAttributes.character] ?? '';
        }
      } else if (roleType == PersonAttributes.crew) {
        if (person[PersonAttributes.jobs] is List) {
          job = (person[PersonAttributes.jobs] as List)
              .map((j) => j[PersonAttributes.job] ?? '')
              .where((j) => j.toString().isNotEmpty)
              .join(', ');
        } else {
          job = person[PersonAttributes.job] ?? '';
        }
      }

      int tmdbId = person[PersonAttributes.id] ?? 0;
      int existingIndex = people.indexWhere((p) => p.tmdbId == tmdbId);

      if (existingIndex != -1) {
        if (roleType == PersonAttributes.cast) {
          if (people[existingIndex].character.isNotEmpty && character.isNotEmpty && !people[existingIndex].character.contains(character)) {
            people[existingIndex].character += ', $character';
          } else if (people[existingIndex].character.isEmpty && character.isNotEmpty) {
            people[existingIndex].character = character;
          }
        } else {
          if (people[existingIndex].job.isNotEmpty && job.isNotEmpty && !people[existingIndex].job.contains(job)) {
            people[existingIndex].job += ', $job';
          } else if (people[existingIndex].job.isEmpty && job.isNotEmpty) {
            people[existingIndex].job = job;
          }
        }
        continue;
      }

      people.add(TmdbPerson(
        tmdbId: tmdbId,
        name: person[PersonAttributes.name] ?? '',
        lastUpdated: AppConstants.defaultDate,
        knownForDepartment: person[PersonAttributes.known_for_department] ?? '',
        gender: person[PersonAttributes.gender] ?? 0,
        originalName: person[PersonAttributes.original_name] ?? '',
        profilePath: person[PersonAttributes.profile_path] ?? '',
        character: character,
        job: job,
        biography: person[PersonAttributes.biography] ?? '',
        birthday: person[PersonAttributes.birthday] ?? '',
        deathday: person[PersonAttributes.deathday] ?? '',
        imdbId: person[PersonAttributes.imdb_id] ?? '',
        placeOfBirth: person[PersonAttributes.place_of_birth] ?? '',
        combinedCredits: CombinedCredits.fromMap(
            person[PersonAttributes.combined_credits] ?? {}),
        homepage: person[PersonAttributes.homepage] ?? '',
      ));
    }
    return people;
  }
}

extension TmdbPersonTranslation on TmdbPerson {
  String localizedJob(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return PersonTranslator.translateJob(job, locale);
  }

  String localizedDepartment(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return PersonTranslator.translateDepartment(knownForDepartment, locale);
  }
}
