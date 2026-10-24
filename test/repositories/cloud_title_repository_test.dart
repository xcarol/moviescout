import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class FakePostgrestMapFilterBuilder extends Fake
    implements PostgrestTransformBuilder<PostgrestMap?> {
  final PostgrestMap? _data;
  FakePostgrestMapFilterBuilder(this._data);

  @override
  Future<R> then<R>(FutureOr<R> Function(PostgrestMap? value) onValue,
      {Function? onError}) {
    return Future.value(_data).then(onValue, onError: onError);
  }
}

class FakePostgrestSingleBuilder extends Fake
    implements PostgrestTransformBuilder<PostgrestMap> {
  final PostgrestMap _data;
  FakePostgrestSingleBuilder(this._data);

  @override
  Future<R> then<R>(FutureOr<R> Function(PostgrestMap value) onValue,
      {Function? onError}) {
    return Future.value(_data).then(onValue, onError: onError);
  }
}

class FakePostgrestListFilterBuilder extends Fake
    implements PostgrestFilterBuilder<PostgrestList> {
  final PostgrestList _data;
  FakePostgrestListFilterBuilder([this._data = const <Map<String, dynamic>>[]]);

  @override
  PostgrestFilterBuilder<PostgrestList> eq(String column, Object value) => this;

  @override
  PostgrestFilterBuilder<PostgrestList> order(String column,
          {bool ascending = false,
          bool nullsFirst = false,
          String? referencedTable}) =>
      this;

  @override
  PostgrestTransformBuilder<PostgrestList> range(int from, int to,
          {String? referencedTable}) =>
      this;

  @override
  PostgrestTransformBuilder<PostgrestMap?> maybeSingle() =>
      FakePostgrestMapFilterBuilder(_data.isNotEmpty ? _data.first : null);

  @override
  PostgrestTransformBuilder<PostgrestMap> single() =>
      FakePostgrestSingleBuilder(_data.isNotEmpty ? _data.first : {});

  @override
  Future<R> then<R>(FutureOr<R> Function(PostgrestList value) onValue,
      {Function? onError}) {
    return Future.value(_data).then(onValue, onError: onError);
  }
}

class FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  final Map<String, dynamic>? _singleData;
  FakePostgrestFilterBuilder([this._singleData]);

  @override
  PostgrestFilterBuilder<dynamic> eq(String column, Object value) => this;

  @override
  PostgrestTransformBuilder<PostgrestList> select([String columns = '*']) =>
      FakePostgrestListFilterBuilder(_singleData != null ? [_singleData] : []);

  @override
  Future<R> then<R>(FutureOr<R> Function(dynamic value) onValue,
      {Function? onError}) {
    return Future.value(_singleData).then(onValue, onError: onError);
  }
}

void main() {
  group('CloudTitleRepository', () {
    late MockSupabaseClient mockClient;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late FakePostgrestFilterBuilder fakeMutationBuilder;
    late CloudTitleRepository repository;

    setUp(() {
      mockClient = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      fakeMutationBuilder = FakePostgrestFilterBuilder();

      when(() => mockClient.from(any())).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select(any()))
          .thenAnswer((_) => FakePostgrestListFilterBuilder());
      when(() => mockQueryBuilder.upsert(any(),
              onConflict: any(named: 'onConflict')))
          .thenAnswer((_) => fakeMutationBuilder);
      when(() => mockQueryBuilder.delete())
          .thenAnswer((_) => fakeMutationBuilder);
      when(() => mockQueryBuilder.update(any()))
          .thenAnswer((_) => fakeMutationBuilder);

      repository = CloudTitleRepository(client: mockClient);
    });

    test('fetchUserTitles parses and returns list of TmdbTitle', () async {
      when(() => mockQueryBuilder.select(any())).thenAnswer(
        (_) => FakePostgrestListFilterBuilder([
          {
            'tmdb_id': 123,
            'media_type': ApiConstants.movie,
            'name': 'Test Movie',
            'poster_path': '/path.jpg',
            'vote_average': 8.5,
            'rating': 9.0,
            'is_pinned': true,
            'notify_new_seasons': false,
            'last_notified_season': 0,
            'rated_date': '2026-01-01T00:00:00.000Z',
          }
        ]),
      );

      final results = await repository.fetchUserTitles(
        userId: 'u1',
        listName: AppConstants.watchlist,
      );

      expect(results.length, 1);
      expect(results.first.tmdbId, 123);
      expect(results.first.name, 'Test Movie');
      expect(results.first.rating, 9.0);
      expect(results.first.isPinned, isTrue);
    });

    test('upsertWatchlistTitle calls upsert on user_titles', () async {
      final title = TmdbTitle(
        tmdbId: 456,
        mediaType: ApiConstants.movie,
        name: 'Watchlist Movie',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );

      await repository.upsertWatchlistTitle(userId: 'u1', title: title);

      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.upsert(
            any(that: isA<Map<String, dynamic>>()),
            onConflict: 'user_id, tmdb_id, media_type, list_name',
          )).called(1);
    });

    test('deleteWatchlistTitle calls delete on user_titles', () async {
      await repository.deleteWatchlistTitle(
        userId: 'u1',
        tmdbId: 456,
        mediaType: ApiConstants.movie,
      );

      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('upsertRateTitle upserts to rateslist and removes from watchlist',
        () async {
      final title = TmdbTitle(
        tmdbId: 789,
        mediaType: ApiConstants.tv,
        name: 'Show',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );

      await repository.upsertRateTitle(
        userId: 'u1',
        title: title,
        rating: 8.0,
      );

      verify(() => mockClient.from('user_titles')).called(2);
      verify(() => mockQueryBuilder.upsert(
            any(that: isA<Map<String, dynamic>>()),
            onConflict: 'user_id, tmdb_id, media_type, list_name',
          )).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('deleteRateTitle calls delete on rateslist', () async {
      await repository.deleteRateTitle(
        userId: 'u1',
        tmdbId: 789,
        mediaType: ApiConstants.tv,
      );

      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('updatePinned updates is_pinned in user_titles', () async {
      final result = await repository.updatePinned(
        userId: 'u1',
        tmdbId: 101,
        mediaType: ApiConstants.movie,
        isPinned: true,
      );

      expect(result, isTrue);
      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.update({'is_pinned': true})).called(1);
    });

    test('updateNotification updates notify_new_seasons in user_titles',
        () async {
      final result = await repository.updateNotification(
        userId: 'u1',
        tmdbId: 202,
        mediaType: ApiConstants.tv,
        notifyNewSeasons: true,
        lastNotifiedSeason: 3,
      );

      expect(result, isTrue);
      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.update({
            'notify_new_seasons': true,
            'last_notified_season': 3,
          })).called(1);
    });

    test('bulkUpsertUserTitles upserts list of records', () async {
      final records = [
        {'tmdb_id': 1},
        {'tmdb_id': 2},
      ];

      await repository.bulkUpsertUserTitles(records);

      verify(() => mockClient.from('user_titles')).called(1);
      verify(() => mockQueryBuilder.upsert(records,
          onConflict: 'user_id, tmdb_id, media_type, list_name')).called(1);
    });

    test('fetchEpisodeRatings queries user_episode_ratings', () async {
      when(() => mockQueryBuilder.select(any())).thenAnswer(
        (_) => FakePostgrestListFilterBuilder([
          {'show_tmdb_id': 10, 'rating': 9.0}
        ]),
      );

      final results = await repository.fetchEpisodeRatings(userId: 'u1');

      expect(results.length, 1);
      expect(results.first['rating'], 9.0);
      verify(() => mockClient.from('user_episode_ratings')).called(1);
    });

    test('upsertEpisodeRating upserts rating record', () async {
      final episode = TmdbEpisode(
        tmdbId: 999,
        tvId: 10,
        seasonNumber: 1,
        episodeNumber: 1,
        name: 'Pilot',
        overview: '',
        airDate: '',
        runtime: 45,
        voteAverage: 8.0,
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );

      await repository.upsertEpisodeRating(
        userId: 'u1',
        episode: episode,
        rating: 9.5,
      );

      verify(() => mockClient.from('user_episode_ratings')).called(1);
      verify(() => mockQueryBuilder.upsert(
            any(that: isA<Map<String, dynamic>>()),
            onConflict: 'user_id, episode_tmdb_id',
          )).called(1);
    });

    test('deleteEpisodeRating deletes episode rating', () async {
      await repository.deleteEpisodeRating(userId: 'u1', episodeTmdbId: 999);

      verify(() => mockClient.from('user_episode_ratings')).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });

    test('bulkUpsertEpisodeRatings upserts records', () async {
      final records = [
        {'episode_tmdb_id': 1},
      ];

      await repository.bulkUpsertEpisodeRatings(records);

      verify(() => mockClient.from('user_episode_ratings')).called(1);
      verify(() => mockQueryBuilder.upsert(records,
          onConflict: 'user_id, episode_tmdb_id')).called(1);
    });

    test('fetchUserProviders fetches providers string from profiles', () async {
      when(() => mockQueryBuilder.select(any())).thenAnswer(
        (_) => FakePostgrestListFilterBuilder([
          {'providers_string': '8,337'}
        ]),
      );

      final providers = await repository.fetchUserProviders('u1');

      expect(providers, '8,337');
      verify(() => mockClient.from('profiles')).called(1);
    });

    test('updateUserProviders upserts to profiles', () async {
      await repository.updateUserProviders('u1', '8,337');

      verify(() => mockClient.from('profiles')).called(1);
      verify(() => mockQueryBuilder
          .upsert({'id': 'u1', 'providers_string': '8,337'})).called(1);
    });

    test('syncNotification syncs notification and watchlist conditionally', () async {
      final title = TmdbTitle(
        tmdbId: 789,
        mediaType: ApiConstants.tv,
        name: 'Show',
        lastUpdated: '2026-01-01',
        dateRated: DateTime.now(),
      );
      title.notifyNewSeasons = true;
      title.lastNotifiedSeason = 2;

      await repository.syncNotification(
        userId: 'u1',
        title: title,
        addedToWatchlist: true,
        isInRateslist: true,
      );

      verify(() => mockClient.from('user_titles')).called(2);
    });

    test('bulkUpsertUserTitles returns early when records is empty', () async {
      await repository.bulkUpsertUserTitles([]);
      verifyNever(() => mockClient.from('user_titles'));
    });

    test('bulkUpsertEpisodeRatings returns early when records is empty', () async {
      await repository.bulkUpsertEpisodeRatings([]);
      verifyNever(() => mockClient.from('user_episode_ratings'));
    });

    test('fetchTitleComments fetches and maps comments', () async {
      when(() => mockQueryBuilder.select(any())).thenAnswer(
        (_) => FakePostgrestListFilterBuilder([
          {
            'id': 'c1',
            'user_id': 'u1',
            'tmdb_id': 100,
            'media_type': ApiConstants.movie,
            'comment': 'Awesome!',
            'created_at': '2026-10-01T12:00:00Z',
            'updated_at': '2026-10-01T12:00:00Z',
            'profiles': {'username': 'movie_buff'},
          }
        ]),
      );

      final comments = await repository.fetchTitleComments(
        tmdbId: 100,
        mediaType: ApiConstants.movie,
      );

      expect(comments.length, 1);
      expect(comments.first.id, 'c1');
      expect(comments.first.comment, 'Awesome!');
      expect(comments.first.username, 'movie_buff');
      verify(() => mockClient.from('user_comments')).called(1);
    });

    test('upsertComment upserts comment and returns TitleComment', () async {
      final fakeBuilder = FakePostgrestFilterBuilder({
        'id': 'c2',
        'user_id': 'u1',
        'tmdb_id': 100,
        'media_type': ApiConstants.movie,
        'comment': 'Updated comment',
        'created_at': '2026-10-01T12:00:00Z',
        'updated_at': '2026-10-01T12:00:00Z',
        'profiles': {'username': 'movie_buff'},
      });
      when(() => mockQueryBuilder.upsert(any(),
              onConflict: any(named: 'onConflict')))
          .thenAnswer((_) => fakeBuilder);

      final comment = await repository.upsertComment(
        userId: 'u1',
        tmdbId: 100,
        mediaType: ApiConstants.movie,
        comment: 'Updated comment',
      );

      expect(comment.id, 'c2');
      expect(comment.comment, 'Updated comment');
      verify(() => mockClient.from('user_comments')).called(1);
    });

    test('deleteComment deletes comment for user and title', () async {
      await repository.deleteComment(
        userId: 'u1',
        tmdbId: 100,
        mediaType: ApiConstants.movie,
      );

      verify(() => mockClient.from('user_comments')).called(1);
      verify(() => mockQueryBuilder.delete()).called(1);
    });
  });
}
