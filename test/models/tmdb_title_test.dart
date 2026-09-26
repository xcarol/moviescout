import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_item.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('TmdbTitle', () {
    test('instantiates with constructor and implements TmdbItem', () {
      final title = TmdbTitle(
        tmdbId: 100,
        name: 'Inception',
        originalName: 'Inception',
        mediaType: ApiConstants.movie,
        releaseDate: '2010-07-16',
        runtime: 148,
        voteAverage: 8.4,
        rating: 9.0,
        popularity: 120.5,
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
      );

      expect(title, isA<TmdbItem>());
      expect(title.tmdbId, 100);
      expect(title.name, 'Inception');
      expect(title.mediaType, ApiConstants.movie);
      expect(title.releaseDate, '2010-07-16');
      expect(title.effectiveReleaseDate, '2010-07-16');
      expect(title.effectiveRuntime, 148);
      expect(title.voteAverage, 8.4);
      expect(title.rating, 9.0);
      expect(title.popularity, 120.5);
      expect(title.isPinned, isFalse);
      expect(title.notifyNewSeasons, isFalse);
      expect(title.lastNotifiedSeason, 0);
    });

    test(
        'constructor computes effective release date and runtime for TV series',
        () {
      final tvTitle = TmdbTitle(
        tmdbId: 200,
        name: 'Dark',
        mediaType: ApiConstants.tv,
        firstAirDate: '2017-12-01',
        numberOfEpisodes: 26,
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
      );

      expect(tvTitle.effectiveReleaseDate, '2017-12-01');
      expect(tvTitle.effectiveRuntime, 26);
    });

    test(
        'constructor handles NaN values in voteAverage, rating, and popularity',
        () {
      final title = TmdbTitle(
        tmdbId: 300,
        name: 'NaN Test',
        voteAverage: double.nan,
        rating: double.nan,
        popularity: double.nan,
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
      );

      expect(title.voteAverage, 0.0);
      expect(title.rating, 0.0);
      expect(title.popularity, 0.0);
    });

    test('equality and hashCode are based on tmdbId', () {
      final title1 = TmdbTitle(
        tmdbId: 50,
        name: 'Title A',
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
      );
      final title2 = TmdbTitle(
        tmdbId: 50,
        name: 'Title B',
        lastUpdated: '2026-02-02',
        dateRated: DateTime(2026, 2, 2),
      );
      final title3 = TmdbTitle(
        tmdbId: 51,
        name: 'Title A',
        lastUpdated: '2026-01-01',
        dateRated: DateTime(2026, 1, 1),
      );

      expect(title1 == title2, isTrue);
      expect(title1.hashCode, title2.hashCode);
      expect(title1 == title3, isFalse);
      expect(title1 == Object(), isFalse);
    });

    test('fromMap and fillFromMap parse all fields from raw TMDB map', () {
      final raw = {
        TmdbTitleFields.id: 550,
        TmdbTitleFields.name: 'Fight Club',
        TmdbTitleFields.originalName: 'Fight Club',
        TmdbTitleFields.originalLanguage: 'en',
        TmdbTitleFields.overview: 'An insomniac office worker...',
        TmdbTitleFields.tagline: 'Mischief. Mayhem. Soap.',
        TmdbTitleFields.status: TitleStatus.released,
        TmdbTitleFields.mediaType: ApiConstants.movie,
        TmdbTitleFields.imdbId: 'tt0137523',
        TmdbTitleFields.homepage: 'http://www.foxmovies.com/fightclub',
        TmdbTitleFields.certification: 'R',
        TmdbTitleFields.type: '',
        TmdbTitleFields.posterPath: '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
        TmdbTitleFields.backdropPath: '/hZkgoQYus5vegHoetLkCJzb17zJ.jpg',
        TmdbTitleFields.releaseDate: '1999-10-15',
        TmdbTitleFields.firstAirDate: '',
        TmdbTitleFields.lastAirDate: '',
        TmdbTitleFields.lastUpdated: '2026-01-01T00:00:00.000',
        TmdbTitleFields.voteAverage: 8.4,
        TmdbTitleFields.voteCount: 28000,
        TmdbTitleFields.accountRating: {
          TmdbTitleFields.accountRatingValue: 9.5,
          TmdbTitleFields.accountRatingDate: '2026-01-10T12:00:00.000',
        },
        TmdbTitleFields.runtime: 139,
        TmdbTitleFields.numberOfEpisodes: 0,
        TmdbTitleFields.numberOfSeasons: 0,
        TmdbTitleFields.popularity: 85.3,
        TmdbTitleFields.budget: 63000000,
        TmdbTitleFields.revenue: 100853753,
        TmdbTitleFields.isPinned: true,
        TmdbTitleFields.notifyNewSeasons: false,
        TmdbTitleFields.lastNotifiedSeason: 0,
        TmdbTitleFields.originCountry: ['US'],
        TmdbTitleFields.genres: [
          {'id': 18, 'name': 'Drama'},
        ],
        TmdbTitleFields.keywordIds: [100, 101],
        TmdbTitleFields.providers: {
          'flatrate': [
            {'provider_id': 8, 'provider_name': 'Netflix'}
          ]
        },
        TmdbTitleFields.credits: {
          'cast': [
            {'id': 287, 'name': 'Brad Pitt', 'character': 'Tyler Durden'}
          ],
          'crew': [
            {'id': 7467, 'name': 'David Fincher', 'job': 'Director'}
          ]
        },
        TmdbTitleFields.images: ['/img1.jpg'],
        TmdbTitleFields.videos: [
          {'id': 'v1', 'key': 'test_video'}
        ],
        TmdbTitleFields.omdbRatings: {'imdb': '8.8'},
        TmdbTitleFields.externalIds: {'imdb_id': 'tt0137523'},
        TmdbTitleFields.belongsToCollection: {
          'id': 999,
          'name': 'Collection A'
        },
        TmdbTitleFields.character: 'Narrator',
        TmdbTitleFields.job: 'Producer',
        TmdbTitleFields.department: 'Production',
      };

      final title = TmdbTitle.fromMap(title: raw);

      expect(title.tmdbId, 550);
      expect(title.name, 'Fight Club');
      expect(title.originalName, 'Fight Club');
      expect(title.originalLanguage, 'en');
      expect(title.overview, 'An insomniac office worker...');
      expect(title.tagline, 'Mischief. Mayhem. Soap.');
      expect(title.status, TitleStatus.released);
      expect(title.mediaType, ApiConstants.movie);
      expect(title.imdbId, 'tt0137523');
      expect(title.homepage, 'http://www.foxmovies.com/fightclub');
      expect(title.certification, 'R');
      expect(title.posterPathSuffix, '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg');
      expect(title.backdropPathSuffix, '/hZkgoQYus5vegHoetLkCJzb17zJ.jpg');
      expect(title.releaseDate, '1999-10-15');
      expect(title.voteAverage, 8.4);
      expect(title.voteCount, 28000);
      expect(title.rating, 9.5);
      expect(title.dateRated, DateTime.parse('2026-01-10T12:00:00.000'));
      expect(title.runtime, 139);
      expect(title.popularity, 85.3);
      expect(title.budget, 63000000);
      expect(title.revenue, 100853753);
      expect(title.isPinned, isTrue);
      expect(title.originCountry, ['US']);
      expect(title.genreIds, [18]);
      expect(title.keywordIds, [100, 101]);
      expect(title.flatrateProviderIds, [8]);
      expect(title.character, 'Narrator');
      expect(title.job, 'Producer');
      expect(title.department, 'Production');

      expect(title.cast.length, 1);
      expect(title.cast.first.name, 'Brad Pitt');
      expect(title.crew.length, 1);
      expect(title.crew.first.name, 'David Fincher');
      expect(title.images, ['/img1.jpg']);
      expect(title.videos, [
        {'id': 'v1', 'key': 'test_video'}
      ]);
      expect(title.externalIds['imdb_id'], 'tt0137523');
      expect(title.belongsToCollection?['name'], 'Collection A');

      final serialized = title.toMap();
      expect(serialized[TmdbTitleFields.id], 550);
      expect(serialized[TmdbTitleFields.name], 'Fight Club');
      expect(
          serialized[TmdbTitleFields.accountRating]
              [TmdbTitleFields.accountRatingValue],
          9.5);
      expect(serialized[TmdbTitleFields.belongsToCollection]['id'], 999);
      expect(serialized[TmdbTitleFields.character], 'Narrator');
    });

    test('accountRating parsing handles numeric rating and direct rating field',
        () {
      final titleWithNum = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 1,
        TmdbTitleFields.accountRating: 7.5,
      });
      expect(titleWithNum.rating, 7.5);
      expect(titleWithNum.dateRated.year, greaterThanOrEqualTo(2000));

      final titleWithDirectRating = TmdbTitle.fromMap(title: {
        TmdbTitleFields.id: 2,
        TmdbTitleFields.rating: 8.0,
      });
      expect(titleWithDirectRating.rating, 8.0);
      expect(titleWithDirectRating.dateRated.year, greaterThanOrEqualTo(2000));
    });

    test('isMovie evaluation handles empty and non-empty name cases', () {
      final movieWithEmptyName = TmdbTitle(
        tmdbId: 1,
        name: '',
        mediaType: ApiConstants.movie,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(movieWithEmptyName.isMovie, isTrue);

      final movieWithName = TmdbTitle(
        tmdbId: 2,
        name: 'The Matrix',
        mediaType: ApiConstants.movie,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(movieWithName.isMovie, isTrue);

      final movieWithInferredType = TmdbTitle(
        tmdbId: 3,
        name: 'The Matrix',
        originalName: 'The Matrix',
        mediaType: '',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(movieWithInferredType.isMovie, isTrue);

      final serie = TmdbTitle(
        tmdbId: 4,
        name: 'Breaking Bad',
        mediaType: ApiConstants.tv,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(serie.isMovie, isFalse);
      expect(serie.isSerie, isTrue);
    });

    test('rating status flags and updateRating method', () {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'Test',
        lastUpdated: '',
        dateRated: DateTime.fromMillisecondsSinceEpoch(0),
      );

      expect(title.hasRating, isFalse);
      expect(title.isSeenOnly, isFalse);
      expect(title.isRated, isFalse);

      title.updateRating(AppConstants.seenRating);
      expect(title.hasRating, isTrue);
      expect(title.isSeenOnly, isTrue);
      expect(title.isRated, isFalse);
      expect(title.dateRated.isAfter(DateTime(2025)), isTrue);

      title.updateRating(8.5);
      expect(title.hasRating, isTrue);
      expect(title.isSeenOnly, isFalse);
      expect(title.isRated, isTrue);
    });

    test(
        'isOnAir returns true for returning series, in production, and planned',
        () {
      final returningTitle = TmdbTitle(
        tmdbId: 1,
        name: 'Show',
        status: TitleStatus.returning,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(returningTitle.isOnAir, isTrue);

      final inProdTitle = TmdbTitle(
        tmdbId: 2,
        name: 'Show 2',
        status: TitleStatus.inProduction,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(inProdTitle.isOnAir, isTrue);

      final plannedTitle = TmdbTitle(
        tmdbId: 3,
        name: 'Show 3',
        status: TitleStatus.planned,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(plannedTitle.isOnAir, isTrue);

      final endedTitle = TmdbTitle(
        tmdbId: 4,
        name: 'Show 4',
        status: TitleStatus.ended,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(endedTitle.isOnAir, isFalse);
    });

    test('isMiniSerie returns true when type is Miniseries', () {
      final miniSerie = TmdbTitle(
        tmdbId: 1,
        name: 'Chernobyl',
        type: TvShowType.miniseries,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(miniSerie.isMiniSerie, isTrue);

      final regularShow = TmdbTitle(
        tmdbId: 2,
        name: 'Show',
        type: TvShowType.scripted,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(regularShow.isMiniSerie, isFalse);
    });

    test('posterPath and backdropPath return formatted URLs or empty strings',
        () {
      final withPaths = TmdbTitle(
        tmdbId: 1,
        name: 'Paths',
        posterPathSuffix: '/poster.jpg',
        backdropPathSuffix: '/backdrop.jpg',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(
        withPaths.posterPath,
        UrlConstants.tmdbImageOriginalTemplate
            .replaceFirst('{PATH}', '/poster.jpg'),
      );
      expect(
        withPaths.backdropPath,
        UrlConstants.tmdbImageOriginalTemplate
            .replaceFirst('{PATH}', '/backdrop.jpg'),
      );

      final withoutPaths = TmdbTitle(
        tmdbId: 2,
        name: 'No Paths',
        posterPathSuffix: '',
        backdropPathSuffix: null,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(withoutPaths.posterPath, '');
      expect(withoutPaths.backdropPath, '');
    });

    test('duration formatting for movie and series', () {
      final longMovie = TmdbTitle(
        tmdbId: 1,
        name: 'Long Movie',
        mediaType: ApiConstants.movie,
        runtime: 150,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(longMovie.duration, '2h 30m');

      final shortMovie = TmdbTitle(
        tmdbId: 2,
        name: 'Short Movie',
        mediaType: ApiConstants.movie,
        runtime: 45,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(shortMovie.duration, '45m');

      final series = TmdbTitle(
        tmdbId: 3,
        name: 'TV Series',
        mediaType: ApiConstants.tv,
        numberOfEpisodes: 10,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(series.duration, '10eps');

      final zeroRuntime = TmdbTitle(
        tmdbId: 4,
        name: 'Zero Runtime',
        mediaType: ApiConstants.movie,
        runtime: 0,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(zeroRuntime.duration, '');
    });

    test('titleLink generates correct TMDB web URL for movie vs TV', () {
      final movie = TmdbTitle(
        tmdbId: 123,
        name: 'Movie',
        mediaType: ApiConstants.movie,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(
        movie.titleLink,
        UrlConstants.tmdbMovieWebTemplate.replaceFirst('{ID}', '123'),
      );

      final tv = TmdbTitle(
        tmdbId: 456,
        name: 'TV',
        mediaType: ApiConstants.tv,
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      expect(
        tv.titleLink,
        UrlConstants.tmdbTvWebTemplate.replaceFirst('{ID}', '456'),
      );
    });

    test('recommendations parses nested titles list and caches result', () {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'Parent',
        lastUpdated: '',
        dateRated: DateTime.now(),
        recommendationsJson: jsonEncode([
          {'id': 101, 'name': 'Recommended 1'},
          {'id': 102, 'name': 'Recommended 2'},
        ]),
      );

      expect(title.recommendations.length, 2);
      expect(title.recommendations.first.tmdbId, 101);
      expect(title.recommendations.last.tmdbId, 102);
      expect(title.recommendations, same(title.recommendations));
    });

    test(
        'nextEpisodeToAir and lastEpisodeToAir parse episodes and expose air dates',
        () {
      final title = TmdbTitle(
        tmdbId: 50,
        name: 'Show with Air Dates',
        lastUpdated: '',
        dateRated: DateTime.now(),
        nextEpisodeToAirJson: jsonEncode({
          'id': 1001,
          'name': 'Next Ep',
          'air_date': '2026-06-01',
          'episode_number': 5,
        }),
        lastEpisodeToAirJson: jsonEncode({
          'id': 1000,
          'name': 'Last Ep',
          'air_date': '2026-05-25',
          'episode_number': 4,
        }),
      );

      expect(title.nextEpisodeToAir?.tmdbId, 1001);
      expect(title.nextEpisodeToAir?.tvId, 50);
      expect(title.nextEpisodeAirDate, '2026-06-01');

      expect(title.lastEpisodeToAir?.tmdbId, 1000);
      expect(title.lastEpisodeToAir?.tvId, 50);
      expect(title.lastEpisodeAirDate, '2026-05-25');
    });

    test(
        'nextEpisodeAirDate and lastEpisodeAirDate return empty when json is null',
        () {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'No Air Dates',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );

      expect(title.nextEpisodeToAir, isNull);
      expect(title.nextEpisodeAirDate, '');
      expect(title.lastEpisodeToAir, isNull);
      expect(title.lastEpisodeAirDate, '');
    });

    test('videos setter updates videosJson and getter reflects changes', () {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'Videos Test',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );

      title.videos = [
        {'id': 'v10', 'key': 'test10'}
      ];
      expect(title.videos.length, 1);
      expect(title.videos.first['key'], 'test10');
    });

    test(
        'updateGenreIds static method supports both genreIdsList and genres maps',
        () {
      final title1 = TmdbTitle(
        tmdbId: 1,
        name: 'T1',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      TmdbTitle.updateGenreIds(title1, null, [28, 12]);
      expect(title1.genreIds, [28, 12]);

      final title2 = TmdbTitle(
        tmdbId: 2,
        name: 'T2',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );
      TmdbTitle.updateGenreIds(
          title2,
          [
            {'id': 35, 'name': 'Comedy'},
            {'id': 80, 'name': 'Crime'},
          ],
          null);
      expect(title2.genreIds, [35, 80]);
    });

    test('updateProviderIds static method updates flatrateProviderIds', () {
      final title = TmdbTitle(
        tmdbId: 1,
        name: 'Provider Test',
        lastUpdated: '',
        dateRated: DateTime.now(),
      );

      TmdbTitle.updateProviderIds(title, {
        'flatrate': [
          {'provider_id': 8, 'provider_name': 'Netflix'},
          {'provider_id': 337, 'provider_name': 'Disney Plus'},
        ],
      });

      expect(title.flatrateProviderIds, [8, 337]);
    });
  });
}
