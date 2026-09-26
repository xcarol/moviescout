import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('TmdbSeason', () {
    test('instantiates with constructor and handles NaN voteAverage', () {
      final season = TmdbSeason(
        tmdbId: 10,
        tvId: 1,
        name: 'Season 1',
        overview: 'First season overview',
        seasonNumber: 1,
        airDate: '2026-01-01',
        posterPathSuffix: '/season1.jpg',
        voteAverage: double.nan,
        lastUpdated: '2026-01-02',
      );

      expect(season, isA<TmdbItem>());
      expect(season.tmdbId, 10);
      expect(season.tvId, 1);
      expect(season.name, 'Season 1');
      expect(season.overview, 'First season overview');
      expect(season.seasonNumber, 1);
      expect(season.airDate, '2026-01-01');
      expect(season.posterPathSuffix, '/season1.jpg');
      expect(season.voteAverage, 0.0);
      expect(season.lastUpdated, '2026-01-02');
      expect(season.episodesJson, '[]');
      expect(
        season.posterPath,
        UrlConstants.tmdbImageOriginalTemplate
            .replaceFirst('{PATH}', '/season1.jpg'),
      );
    });

    test('fromMap parses map and fills nested json data', () {
      final data = {
        'id': 500,
        'name': 'Season 2',
        'overview': 'Season 2 details',
        'season_number': 2,
        'air_date': '2026-05-01',
        'poster_path': '/s2.jpg',
        'vote_average': 8.2,
        'episodes': [
          {'id': 501, 'name': 'Ep 1', 'episode_number': 1},
          {'id': 502, 'name': 'Ep 2', 'episode_number': 2},
        ],
        'images': ['/s2_img1.jpg'],
        'videos': [
          {'id': 'vid1', 'key': 'abc'}
        ],
        'credits': {
          'cast': [
            {'id': 1, 'name': 'Cast Member 1', 'character': 'Hero'}
          ],
          'crew': [
            {'id': 2, 'name': 'Crew Member 1', 'job': 'Director'}
          ],
        },
      };

      final season = TmdbSeason.fromMap(data, tvId: 100);

      expect(season.tmdbId, 500);
      expect(season.tvId, 100);
      expect(season.name, 'Season 2');
      expect(season.overview, 'Season 2 details');
      expect(season.seasonNumber, 2);
      expect(season.airDate, '2026-05-01');
      expect(season.posterPathSuffix, '/s2.jpg');
      expect(season.voteAverage, 8.2);
      expect(season.lastUpdated, AppConstants.defaultDate);

      expect(season.episodes.length, 2);
      expect(season.episodes.first.tmdbId, 501);
      expect(season.episodes.last.tmdbId, 502);
      expect(season.episodes, same(season.episodes));

      expect(season.images, ['/s2_img1.jpg']);
      expect(season.images, same(season.images));

      expect(season.videos, [
        {'id': 'vid1', 'key': 'abc'}
      ]);
      expect(season.videos, same(season.videos));

      expect(season.cast.length, 1);
      expect(season.cast.first.name, 'Cast Member 1');
      expect(season.cast, same(season.cast));

      expect(season.crew.length, 1);
      expect(season.crew.first.name, 'Crew Member 1');
      expect(season.crew, same(season.crew));
    });

    test('fromMap with missing fields provides defaults', () {
      final season = TmdbSeason.fromMap({});

      expect(season.tmdbId, 0);
      expect(season.tvId, 0);
      expect(season.name, '');
      expect(season.overview, '');
      expect(season.seasonNumber, 0);
      expect(season.airDate, '');
      expect(season.posterPathSuffix, isNull);
      expect(season.posterPath, '');
      expect(season.voteAverage, 0.0);
      expect(season.episodes, isEmpty);
      expect(season.images, isEmpty);
      expect(season.videos, isEmpty);
      expect(season.cast, isEmpty);
      expect(season.crew, isEmpty);
    });

    test('fromMap handles aggregate_credits when credits is missing', () {
      final data = {
        'id': 600,
        'aggregate_credits': {
          'cast': [
            {'id': 11, 'name': 'Aggregate Cast', 'character': 'Lead'}
          ],
        },
      };

      final season = TmdbSeason.fromMap(data);
      expect(season.cast.length, 1);
      expect(season.cast.first.name, 'Aggregate Cast');
    });

    test('handles malformed json gracefully in getters', () {
      final season = TmdbSeason(
        tmdbId: 1,
        tvId: 1,
        name: 'Invalid',
        overview: '',
        seasonNumber: 1,
        airDate: '',
        voteAverage: 0,
        episodesJson: 'not a list',
        imagesJson: 'not a json',
        videosJson: '{"not": "list"}',
        creditsJson: '{}',
        lastUpdated: '',
      );

      expect(season.episodes, isEmpty);
      expect(season.images, isEmpty);
      expect(season.videos, isEmpty);
      expect(season.cast, isEmpty);
      expect(season.crew, isEmpty);
    });

    test('posterPath returns empty string if posterPathSuffix is empty string',
        () {
      final season = TmdbSeason(
        tmdbId: 1,
        tvId: 1,
        name: 'Empty Suffix',
        overview: '',
        seasonNumber: 1,
        airDate: '',
        voteAverage: 0,
        posterPathSuffix: '',
        lastUpdated: '',
      );

      expect(season.posterPath, '');
    });
  });
}
