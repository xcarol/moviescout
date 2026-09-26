import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('CombinedCredits', () {
    test('instantiates and serializes to and from map', () {
      final title1 = TmdbTitle(
        tmdbId: 10,
        name: 'Movie 1',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final title2 = TmdbTitle(
        tmdbId: 20,
        name: 'Movie 2',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );

      final credits = CombinedCredits(cast: [title1], crew: [title2]);
      final map = credits.toMap();

      expect(map[PersonAttributes.cast], isA<List>());
      expect(map[PersonAttributes.crew], isA<List>());

      final fromMapCredits = CombinedCredits.fromMap(map);
      expect(fromMapCredits.cast.length, 1);
      expect(fromMapCredits.cast.first.tmdbId, 10);
      expect(fromMapCredits.crew.length, 1);
      expect(fromMapCredits.crew.first.tmdbId, 20);
    });

    test('fromMap handles null or empty map gracefully', () {
      final credits = CombinedCredits.fromMap({});
      expect(credits.cast, isEmpty);
      expect(credits.crew, isEmpty);
    });
  });

  group('TmdbPerson', () {
    test('instantiates with constructor and implements TmdbItem', () {
      final person = TmdbPerson(
        tmdbId: 1,
        name: 'Actor Name',
        lastUpdated: '2026-01-01',
        knownForDepartment: 'Acting',
        gender: 2,
        alsoKnownAs: ['Alias 1'],
        profilePath: '/profile.jpg',
        character: 'Hero',
        job: 'Actor',
        biography: 'Bio text',
        birthday: '1980-01-01',
        deathday: '',
        imdbId: 'nm0000001',
        placeOfBirth: 'New York',
        homepage: 'https://actor.com',
      );

      expect(person, isA<TmdbItem>());
      expect(person.tmdbId, 1);
      expect(person.name, 'Actor Name');
      expect(person.lastUpdated, '2026-01-01');
      expect(person.knownForDepartment, 'Acting');
      expect(person.gender, 2);
      expect(person.alsoKnownAs, ['Alias 1']);
      expect(person.profilePath, '/profile.jpg');
      expect(person.character, 'Hero');
      expect(person.job, 'Actor');
      expect(person.biography, 'Bio text');
      expect(person.birthday, '1980-01-01');
      expect(person.deathday, '');
      expect(person.imdbId, 'nm0000001');
      expect(person.placeOfBirth, 'New York');
      expect(person.homepage, 'https://actor.com');
      expect(
        person.posterPath,
        UrlConstants.tmdbImageOriginalTemplate.replaceFirst('{PATH}', '/profile.jpg'),
      );
    });

    test('constructor sets combinedCreditsJson when combinedCredits provided', () {
      final title = TmdbTitle(
        tmdbId: 10,
        name: 'Movie 1',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );
      final person = TmdbPerson(
        tmdbId: 1,
        name: 'Actor Name',
        lastUpdated: '2026-01-01',
        knownForDepartment: 'Acting',
        gender: 2,
        profilePath: '',
        character: '',
        job: '',
        biography: '',
        birthday: '',
        deathday: '',
        imdbId: '',
        placeOfBirth: '',
        homepage: '',
        combinedCredits: CombinedCredits(cast: [title], crew: []),
      );

      expect(person.combinedCredits.cast.length, 1);
      expect(person.combinedCredits.cast.first.tmdbId, 10);
      expect(person.combinedCreditsJson, contains('Movie 1'));

      final person2 = TmdbPerson(
        tmdbId: 2,
        name: 'Actor Name 2',
        lastUpdated: '2026-01-01',
        knownForDepartment: 'Acting',
        gender: 2,
        profilePath: '',
        character: '',
        job: '',
        biography: '',
        birthday: '',
        deathday: '',
        imdbId: '',
        placeOfBirth: '',
        homepage: '',
      );
      person2.combinedCredits = CombinedCredits(cast: [], crew: [title]);
      expect(person2.combinedCredits.cast, isEmpty);
      expect(person2.combinedCredits.crew.length, 1);
      expect(person2.combinedCredits.crew.first.tmdbId, 10);
    });

    test('fromMap and toMap serialize all attributes accurately', () {
      final map = {
        PersonAttributes.id: 50,
        PersonAttributes.name: 'Full Name',
        PersonAttributes.last_updated: '2026-03-01',
        PersonAttributes.known_for_department: 'Directing',
        PersonAttributes.gender: 1,
        PersonAttributes.also_known_as: ['Name A', 'Name B'],
        PersonAttributes.profile_path: '/path.png',
        PersonAttributes.character: 'Cameo',
        PersonAttributes.job: 'Director',
        PersonAttributes.biography: 'Long biography',
        PersonAttributes.birthday: '1970-05-10',
        PersonAttributes.deathday: '2025-01-01',
        PersonAttributes.imdb_id: 'nm1234567',
        PersonAttributes.place_of_birth: 'London',
        PersonAttributes.homepage: 'https://director.org',
        PersonAttributes.combined_credits: {
          PersonAttributes.cast: [],
          PersonAttributes.crew: [],
        },
        PersonAttributes.images: {
          'profiles': [
            {'file_path': '/profile_image.jpg'}
          ]
        },
        PersonAttributes.external_ids: {
          'imdb_id': 'nm1234567',
          'instagram_id': 'director_insta',
        },
        PersonAttributes.tagged_images: {
          'results': [
            {
              'aspect_ratio': 1.77,
              'file_path': '/tagged_wide.jpg',
              'media': {'backdrop_path': '/backdrop_media.jpg'}
            },
            {
              'aspect_ratio': 0.66,
              'file_path': '/tagged_tall.jpg',
            }
          ]
        },
      };

      final person = TmdbPerson.fromMap(person: map);
      expect(person.tmdbId, 50);
      expect(person.name, 'Full Name');
      expect(person.knownForDepartment, 'Directing');
      expect(person.gender, 1);
      expect(person.alsoKnownAs, ['Name A', 'Name B']);
      expect(person.profilePath, '/path.png');
      expect(person.character, 'Cameo');
      expect(person.job, 'Director');
      expect(person.biography, 'Long biography');
      expect(person.birthday, '1970-05-10');
      expect(person.deathday, '2025-01-01');
      expect(person.imdbId, 'nm1234567');
      expect(person.placeOfBirth, 'London');
      expect(person.homepage, 'https://director.org');

      expect(person.images, contains('/profile_image.jpg'));
      expect(person.images, contains('/tagged_tall.jpg'));
      expect(person.taggedImages, contains('/tagged_wide.jpg'));
      expect(person.taggedImages, contains('/backdrop_media.jpg'));
      expect(person.externalIds['instagram_id'], 'director_insta');

      final serialized = person.toMap();
      expect(serialized[PersonAttributes.id], 50);
      expect(serialized[PersonAttributes.name], 'Full Name');
      expect(serialized[PersonAttributes.profile_path], '/path.png');
      expect(serialized[PersonAttributes.tagged_images], isNotNull);
    });

    test('fromMap with missing values assigns safe fallbacks', () {
      final person = TmdbPerson.fromMap(person: {});
      expect(person.tmdbId, 0);
      expect(person.name, '');
      expect(person.lastUpdated, AppConstants.defaultDate);
      expect(person.knownForDepartment, '');
      expect(person.gender, 0);
      expect(person.alsoKnownAs, isEmpty);
      expect(person.profilePath, '');
      expect(person.posterPath, '');
      expect(person.combinedCredits.cast, isEmpty);
      expect(person.images, isEmpty);
      expect(person.taggedImages, isEmpty);
      expect(person.externalIds, isEmpty);
    });

    test('externalIds handles malformed json gracefully', () {
      final person = TmdbPerson(
        tmdbId: 1,
        name: 'A',
        lastUpdated: '',
        knownForDepartment: '',
        gender: 0,
        profilePath: '',
        character: '',
        job: '',
        biography: '',
        birthday: '',
        deathday: '',
        imdbId: '',
        placeOfBirth: '',
        homepage: '',
        externalIdsJson: 'not a json',
      );
      expect(person.externalIds, isEmpty);
    });

    group('parsePersonList', () {
      test('returns empty list for null input', () {
        expect(TmdbPerson.parsePersonList(null, PersonAttributes.cast), isEmpty);
      });

      test('parses cast with roles list and merges duplicate appearances', () {
        final rawCast = [
          'invalid entry',
          {
            PersonAttributes.id: 101,
            PersonAttributes.name: 'Dual Actor',
            PersonAttributes.roles: [
              {PersonAttributes.character: 'Role A'},
              {PersonAttributes.character: 'Role B'},
            ],
          },
          {
            PersonAttributes.id: 101,
            PersonAttributes.name: 'Dual Actor',
            PersonAttributes.character: 'Role C',
          },
        ];

        final parsed = TmdbPerson.parsePersonList(rawCast, PersonAttributes.cast);
        expect(parsed.length, 1);
        expect(parsed.first.tmdbId, 101);
        expect(parsed.first.name, 'Dual Actor');
        expect(parsed.first.character, 'Role A, Role B, Role C');
      });

      test('parses cast fallback character and handles initial empty character', () {
        final rawCast = [
          {
            PersonAttributes.id: 102,
            PersonAttributes.name: 'Actor 102',
            PersonAttributes.character: '',
          },
          {
            PersonAttributes.id: 102,
            PersonAttributes.name: 'Actor 102',
            PersonAttributes.character: 'New Character',
          },
        ];

        final parsed = TmdbPerson.parsePersonList(rawCast, PersonAttributes.cast);
        expect(parsed.length, 1);
        expect(parsed.first.character, 'New Character');
      });

      test('parses crew with jobs list and merges duplicates', () {
        final rawCrew = [
          {
            PersonAttributes.id: 201,
            PersonAttributes.name: 'Multi Crew',
            PersonAttributes.jobs: [
              {PersonAttributes.job: 'Director'},
              {PersonAttributes.job: 'Producer'},
            ],
          },
          {
            PersonAttributes.id: 201,
            PersonAttributes.name: 'Multi Crew',
            PersonAttributes.job: 'Writer',
          },
        ];

        final parsed = TmdbPerson.parsePersonList(rawCrew, PersonAttributes.crew);
        expect(parsed.length, 1);
        expect(parsed.first.tmdbId, 201);
        expect(parsed.first.job, 'Director, Producer, Writer');
      });

      test('parses crew fallback job and handles initial empty job', () {
        final rawCrew = [
          {
            PersonAttributes.id: 202,
            PersonAttributes.name: 'Crew 202',
            PersonAttributes.job: '',
          },
          {
            PersonAttributes.id: 202,
            PersonAttributes.name: 'Crew 202',
            PersonAttributes.job: 'Cinematographer',
          },
        ];

        final parsed = TmdbPerson.parsePersonList(rawCrew, PersonAttributes.crew);
        expect(parsed.length, 1);
        expect(parsed.first.job, 'Cinematographer');
      });
    });

    testWidgets('localizedJob and localizedDepartment extensions fallback to original without translation init', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final person = TmdbPerson(
        tmdbId: 1,
        name: 'Name',
        lastUpdated: '',
        knownForDepartment: 'Acting',
        gender: 1,
        profilePath: '',
        character: '',
        job: 'Director',
        biography: '',
        birthday: '',
        deathday: '',
        imdbId: '',
        placeOfBirth: '',
        homepage: '',
      );

      expect(person.localizedJob(capturedContext), 'Director');
      expect(person.localizedDepartment(capturedContext), 'Acting');
    });
  });
}
