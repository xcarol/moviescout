import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('TmdbEpisode', () {
    test('instantiates with constructor and handles NaN voteAverage', () {
      final episode = TmdbEpisode(
        tmdbId: 101,
        tvId: 10,
        seasonNumber: 1,
        name: 'Pilot',
        overview: 'The pilot episode.',
        episodeNumber: 1,
        runtime: 45,
        airDate: '2026-01-10',
        voteAverage: double.nan,
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        lastUpdated: '2026-01-01',
      );

      expect(episode, isA<TmdbItem>());
      expect(episode.tmdbId, 101);
      expect(episode.tvId, 10);
      expect(episode.seasonNumber, 1);
      expect(episode.name, 'Pilot');
      expect(episode.overview, 'The pilot episode.');
      expect(episode.episodeNumber, 1);
      expect(episode.runtime, 45);
      expect(episode.airDate, '2026-01-10');
      expect(episode.voteAverage, 0.0);
      expect(episode.rating, 0.0);
      expect(episode.dateRated, DateTime.fromMillisecondsSinceEpoch(0));
      expect(episode.lastUpdated, '2026-01-01');
    });

    test('fromMap parses map and fills nested json data', () {
      final data = {
        'id': 202,
        'season_number': 2,
        'name': 'Episode Two',
        'overview': 'Overview of episode 2',
        'episode_number': 2,
        'runtime': 50,
        'air_date': '2026-02-15',
        'vote_average': 8.5,
        'still_path': '/still_202.jpg',
        'guest_stars': [
          {'id': 1001, 'name': 'Guest Star 1', 'character': 'Detective'}
        ],
        'crew': [
          {'id': 2001, 'name': 'Director Name', 'job': 'Director'}
        ],
        'images': ['/img1.jpg', '/img2.jpg'],
        'videos': [
          {'id': 'v1', 'key': 'xyz'}
        ],
      };

      final episode = TmdbEpisode.fromMap(data, tvId: 50);

      expect(episode.tmdbId, 202);
      expect(episode.tvId, 50);
      expect(episode.seasonNumber, 2);
      expect(episode.name, 'Episode Two');
      expect(episode.overview, 'Overview of episode 2');
      expect(episode.episodeNumber, 2);
      expect(episode.runtime, 50);
      expect(episode.airDate, '2026-02-15');
      expect(episode.voteAverage, 8.5);
      expect(episode.stillPathSuffix, '/still_202.jpg');
      expect(episode.lastUpdated, AppConstants.defaultDate);
      expect(episode.dateRated, DateTime.fromMillisecondsSinceEpoch(0));

      expect(episode.stillPath, UrlConstants.tmdbImageOriginalTemplate.replaceFirst('{PATH}', '/still_202.jpg'));
      expect(episode.images, ['/img1.jpg', '/img2.jpg']);
      expect(episode.images, same(episode.images));
      expect(episode.videos, [
        {'id': 'v1', 'key': 'xyz'}
      ]);
      expect(episode.videos, same(episode.videos));

      expect(episode.cast.length, 1);
      expect(episode.cast.first.name, 'Guest Star 1');
      expect(episode.cast.first.character, 'Detective');
      expect(episode.cast, same(episode.cast));

      expect(episode.crew.length, 1);
      expect(episode.crew.first.name, 'Director Name');
      expect(episode.crew.first.job, 'Director');
      expect(episode.crew, same(episode.crew));
    });

    test('fromMap with missing fields provides defaults', () {
      final episode = TmdbEpisode.fromMap({});

      expect(episode.tmdbId, 0);
      expect(episode.tvId, 0);
      expect(episode.seasonNumber, 0);
      expect(episode.name, '');
      expect(episode.overview, '');
      expect(episode.episodeNumber, 0);
      expect(episode.runtime, 0);
      expect(episode.airDate, '');
      expect(episode.voteAverage, 0.0);
      expect(episode.stillPathSuffix, isNull);
      expect(episode.stillPath, '');
      expect(episode.images, isEmpty);
      expect(episode.videos, isEmpty);
      expect(episode.cast, isEmpty);
      expect(episode.crew, isEmpty);
    });

    test('images and videos handle invalid json or non-list decoded objects', () {
      final episode = TmdbEpisode(
        tmdbId: 303,
        tvId: 1,
        seasonNumber: 1,
        name: 'Invalid JSON test',
        overview: '',
        episodeNumber: 1,
        runtime: 40,
        airDate: '',
        voteAverage: 5.0,
        dateRated: DateTime.now(),
        lastUpdated: '',
        imagesJson: 'not-valid-json',
        videosJson: '{"not": "a list"}',
      );

      expect(episode.images, isEmpty);
      expect(episode.videos, isEmpty);
    });

    test('stillPath returns empty string if stillPathSuffix is empty', () {
      final episode = TmdbEpisode(
        tmdbId: 304,
        tvId: 1,
        seasonNumber: 1,
        name: 'Empty Still',
        overview: '',
        episodeNumber: 1,
        runtime: 40,
        airDate: '',
        voteAverage: 5.0,
        stillPathSuffix: '',
        dateRated: DateTime.now(),
        lastUpdated: '',
      );

      expect(episode.stillPath, '');
    });
  });
}
