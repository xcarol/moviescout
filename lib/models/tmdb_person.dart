import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:flutter/widgets.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/person_translator.dart';

// ignore_for_file: constant_identifier_names, unused_element

enum PersonTitleRole { character, crew }

class PersonAttributes {
  static const id = 'id';
  static const last_updated = 'last_updated';
  static const name = 'name';
  static const known_for_department = 'known_for_department';
  static const gender = 'gender';
  static const also_known_as = 'also_known_as';
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
  static const images = 'images';
  static const external_ids = 'external_ids';
  static const tagged_images = 'tagged_images';
}

class CrewJobs {
  static const director = 'Director';
  static const executiveProducer = 'Executive Producer';
  static const creator = 'Creator';
  static const writer = 'Writer';
  static const screenplay = 'Screenplay';
  static const author = 'Author';
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
  @override
  late String lastUpdated;
  late String knownForDepartment;
  late int gender;
  late List<String> alsoKnownAs;
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
  String? imagesJson;
  String? externalIdsJson;
  String? taggedImagesJson;

  List<String>? _taggedImagesCache;

  void _initImages() {
    if (_imagesCache != null && _taggedImagesCache != null) return;
    
    final List<String> allImages = [];
    final List<String> horizImages = [];
    
    if (imagesJson != null) {
      try {
        final decoded = jsonDecode(imagesJson!);
        if (decoded['profiles'] != null) {
          allImages.addAll((decoded['profiles'] as List)
              .map((e) => e['file_path'].toString()));
        }
      } catch (_) {}
    }

    if (taggedImagesJson != null) {
      try {
        final decoded = jsonDecode(taggedImagesJson!);
        if (decoded['results'] != null) {
          for (var item in decoded['results']) {
            final aspectRatio = (item['aspect_ratio'] as num?) ?? 1.0;
            final path = item['file_path']?.toString();
            
            if (aspectRatio >= 1.0) {
              if (path != null && !horizImages.contains(path)) {
                horizImages.add(path);
              }
            } else {
              if (path != null && !allImages.contains(path)) {
                allImages.add(path);
              }
            }
            
            if (item['media'] != null) {
              final backdropPath = item['media']['backdrop_path']?.toString();
              if (backdropPath != null && !horizImages.contains(backdropPath)) {
                horizImages.add(backdropPath);
              }
            }
          }
        }
      } catch (_) {}
    }

    _imagesCache ??= allImages;
    _taggedImagesCache ??= horizImages;
  }

  List<String> get taggedImages {
    _initImages();
    return _taggedImagesCache!;
  }

  Map<String, dynamic>? _externalIdsCache;

  Map<String, dynamic> get externalIds {
    if (_externalIdsCache != null) return _externalIdsCache!;
    if (externalIdsJson == null) return {};
    try {
      _externalIdsCache = jsonDecode(externalIdsJson!);
      return _externalIdsCache!;
    } catch (_) {
      return {};
    }
  }

  List<String>? _imagesCache;

  List<String> get images {
    _initImages();
    return _imagesCache!;
  }

  CombinedCredits? _combinedCreditsCache;

  CombinedCredits get combinedCredits {
    if (_combinedCreditsCache != null) return _combinedCreditsCache!;
    if (combinedCreditsJson == null) return CombinedCredits(cast: [], crew: []);
    _combinedCreditsCache =
        CombinedCredits.fromMap(jsonDecode(combinedCreditsJson!));
    return _combinedCreditsCache!;
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
    this.alsoKnownAs = const [],
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
    this.imagesJson,
    this.externalIdsJson,
    this.taggedImagesJson,
    CombinedCredits? combinedCredits,
  }) {
    if (combinedCredits != null) {
      combinedCreditsJson = jsonEncode(combinedCredits.toMap());
    }
  }

  factory TmdbPerson.fromMap({required Map<dynamic, dynamic> person}) {
    return TmdbPerson(
        tmdbId: person[PersonAttributes.id] ?? 0,
        name: person[PersonAttributes.name] ?? '',
        lastUpdated:
            person[PersonAttributes.last_updated] ?? AppConstants.defaultDate,
        knownForDepartment: person[PersonAttributes.known_for_department] ?? '',
        gender: person[PersonAttributes.gender] ?? 0,
        alsoKnownAs:
            List<String>.from(person[PersonAttributes.also_known_as] ?? []),
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
            : null,
        imagesJson: person[PersonAttributes.images] != null
            ? jsonEncode(person[PersonAttributes.images])
            : null,
        externalIdsJson: person[PersonAttributes.external_ids] != null
            ? jsonEncode(person[PersonAttributes.external_ids])
            : null,
        taggedImagesJson: person[PersonAttributes.tagged_images] != null
            ? jsonEncode(person[PersonAttributes.tagged_images])
            : null);
  }

  String get posterPath {
    return profilePath.isNotEmpty
        ? UrlConstants.tmdbImageOriginalTemplate
            .replaceFirst('{PATH}', profilePath)
        : '';
  }

  Map<String, dynamic> toMap() {
    return {
      PersonAttributes.id: tmdbId,
      PersonAttributes.name: name,
      PersonAttributes.last_updated: lastUpdated,
      PersonAttributes.known_for_department: knownForDepartment,
      PersonAttributes.gender: gender,
      PersonAttributes.also_known_as: alsoKnownAs,
      PersonAttributes.profile_path: profilePath,
      PersonAttributes.character: character,
      PersonAttributes.job: job,
      PersonAttributes.biography: biography,
      PersonAttributes.birthday: birthday,
      PersonAttributes.deathday: deathday,
      PersonAttributes.imdb_id: imdbId,
      PersonAttributes.place_of_birth: placeOfBirth,
      PersonAttributes.homepage: homepage,
      PersonAttributes.combined_credits:
          combinedCreditsJson != null ? jsonDecode(combinedCreditsJson!) : null,
      PersonAttributes.images:
          imagesJson != null ? jsonDecode(imagesJson!) : null,
      PersonAttributes.external_ids:
          externalIdsJson != null ? jsonDecode(externalIdsJson!) : null,
      PersonAttributes.tagged_images:
          taggedImagesJson != null ? jsonDecode(taggedImagesJson!) : null,
    };
  }

  static List<TmdbPerson> parsePersonList(
      List<dynamic>? jsonList, String roleType) {
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
          if (people[existingIndex].character.isNotEmpty &&
              character.isNotEmpty &&
              !people[existingIndex].character.contains(character)) {
            people[existingIndex].character += ', $character';
          } else if (people[existingIndex].character.isEmpty &&
              character.isNotEmpty) {
            people[existingIndex].character = character;
          }
        } else {
          if (people[existingIndex].job.isNotEmpty &&
              job.isNotEmpty &&
              !people[existingIndex].job.contains(job)) {
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
        alsoKnownAs:
            List<String>.from(person[PersonAttributes.also_known_as] ?? []),
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
