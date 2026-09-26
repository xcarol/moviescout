import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('TmdbCollection', () {
    test('instantiates with constructor and implements TmdbItem', () {
      final collection = TmdbCollection(
        tmdbId: 10,
        name: 'Star Wars Collection',
        overview: 'An epic space-opera collection.',
        posterPathSuffix: '/starwars_poster.jpg',
        backdropPathSuffix: '/starwars_backdrop.jpg',
        lastUpdated: '2026-01-01T00:00:00.000',
      );

      expect(collection, isA<TmdbItem>());
      expect(collection.tmdbId, 10);
      expect(collection.name, 'Star Wars Collection');
      expect(collection.overview, 'An epic space-opera collection.');
      expect(collection.posterPathSuffix, '/starwars_poster.jpg');
      expect(collection.backdropPathSuffix, '/starwars_backdrop.jpg');
      expect(collection.lastUpdated, '2026-01-01T00:00:00.000');
    });

    test('fromMap parses map and populates fields and default values', () {
      final map = {
        'id': 20,
        'name': 'Avengers Collection',
        'overview': 'Superheroes assembling.',
        'poster_path': '/avengers_poster.jpg',
        'backdrop_path': '/avengers_backdrop.jpg',
      };

      final collection = TmdbCollection.fromMap(collection: map);

      expect(collection.tmdbId, 20);
      expect(collection.name, 'Avengers Collection');
      expect(collection.overview, 'Superheroes assembling.');
      expect(collection.posterPathSuffix, '/avengers_poster.jpg');
      expect(collection.backdropPathSuffix, '/avengers_backdrop.jpg');
      expect(collection.lastUpdated, isNotEmpty);
      expect(DateTime.tryParse(collection.lastUpdated), isNotNull);
    });

    test('fromMap falls back to defaults when map fields are missing', () {
      final collection = TmdbCollection.fromMap(collection: {});

      expect(collection.tmdbId, 0);
      expect(collection.name, '');
      expect(collection.overview, '');
      expect(collection.posterPathSuffix, isNull);
      expect(collection.backdropPathSuffix, isNull);
      expect(collection.lastUpdated, isNotEmpty);
    });

    test('posterPath returns formatted url when suffix present, empty string otherwise', () {
      final withPoster = TmdbCollection(
        tmdbId: 1,
        name: 'Test',
        posterPathSuffix: '/sample.jpg',
        lastUpdated: '2026-01-01',
      );
      final expectedUrl = UrlConstants.tmdbImageOriginalTemplate.replaceFirst('{PATH}', '/sample.jpg');
      expect(withPoster.posterPath, expectedUrl);

      final withNullPoster = TmdbCollection(
        tmdbId: 2,
        name: 'Test 2',
        posterPathSuffix: null,
        lastUpdated: '2026-01-01',
      );
      expect(withNullPoster.posterPath, '');

      final withEmptyPoster = TmdbCollection(
        tmdbId: 3,
        name: 'Test 3',
        posterPathSuffix: '',
        lastUpdated: '2026-01-01',
      );
      expect(withEmptyPoster.posterPath, '');
    });

    test('backdropPath returns formatted url when suffix present, empty string otherwise', () {
      final withBackdrop = TmdbCollection(
        tmdbId: 1,
        name: 'Test',
        backdropPathSuffix: '/sample_bg.jpg',
        lastUpdated: '2026-01-01',
      );
      final expectedUrl = UrlConstants.tmdbImageOriginalTemplate.replaceFirst('{PATH}', '/sample_bg.jpg');
      expect(withBackdrop.backdropPath, expectedUrl);

      final withNullBackdrop = TmdbCollection(
        tmdbId: 2,
        name: 'Test 2',
        backdropPathSuffix: null,
        lastUpdated: '2026-01-01',
      );
      expect(withNullBackdrop.backdropPath, '');

      final withEmptyBackdrop = TmdbCollection(
        tmdbId: 3,
        name: 'Test 3',
        backdropPathSuffix: '',
        lastUpdated: '2026-01-01',
      );
      expect(withEmptyBackdrop.backdropPath, '');
    });
  });
}
