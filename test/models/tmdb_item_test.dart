import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_title.dart';

void main() {
  group('TmdbItem interface', () {
    test('all entity models implement TmdbItem polymorphic contract', () {
      final List<TmdbItem> items = [
        TmdbTitle(
          tmdbId: 1,
          name: 'Title Name',
          lastUpdated: '2026-01-01',
          dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        ),
        TmdbSeason(
          tmdbId: 2,
          tvId: 1,
          name: 'Season Name',
          overview: '',
          seasonNumber: 1,
          airDate: '',
          voteAverage: 0,
          lastUpdated: '2026-01-02',
        ),
        TmdbEpisode(
          tmdbId: 3,
          tvId: 1,
          seasonNumber: 1,
          name: 'Episode Name',
          overview: '',
          episodeNumber: 1,
          runtime: 40,
          airDate: '',
          voteAverage: 0,
          dateRated: DateTime.fromMillisecondsSinceEpoch(0),
          lastUpdated: '2026-01-03',
        ),
        TmdbPerson(
          tmdbId: 4,
          name: 'Person Name',
          lastUpdated: '2026-01-04',
          knownForDepartment: '',
          gender: 1,
          profilePath: '',
          character: '',
          job: '',
          biography: '',
          birthday: '',
          deathday: '',
          imdbId: '',
          placeOfBirth: '',
          homepage: '',
        ),
        TmdbCollection(
          tmdbId: 5,
          name: 'Collection Name',
          lastUpdated: '2026-01-05',
        ),
      ];

      expect(items.map((i) => i.tmdbId).toList(), [1, 2, 3, 4, 5]);
      expect(
        items.map((i) => i.name).toList(),
        ['Title Name', 'Season Name', 'Episode Name', 'Person Name', 'Collection Name'],
      );
      expect(
        items.map((i) => i.lastUpdated).toList(),
        ['2026-01-01', '2026-01-02', '2026-01-03', '2026-01-04', '2026-01-05'],
      );
    });
  });
}
