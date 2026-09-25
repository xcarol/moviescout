import 'dart:convert';
import 'package:drift/drift.dart';

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.map((e) => (e as num).toInt()).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  String toSql(List<int> value) => jsonEncode(value);
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

@DataClassName('UserListEntryData')
@TableIndex(
    name: 'idx_user_list_entries_list_order', columns: {#listName, #addedOrder})
@TableIndex(
    name: 'idx_user_list_entries_lookup',
    columns: {#listName, #tmdbId, #mediaType})
class UserListEntries extends Table {
  TextColumn get id => text()();
  TextColumn get listName => text()();
  IntColumn get tmdbId => integer()();
  TextColumn get mediaType => text()();
  IntColumn get addedOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TmdbTitleData')
@TableIndex(name: 'idx_tmdb_titles_lookup', columns: {#tmdbId, #mediaType})
class TmdbTitles extends Table {
  TextColumn get id => text()();
  IntColumn get tmdbId => integer()();
  TextColumn get name => text()();
  TextColumn get originalName => text()();
  TextColumn get originalLanguage => text()();
  TextColumn get overview => text()();
  TextColumn get tagline => text()();
  TextColumn get status => text()();
  TextColumn get mediaType => text()();
  TextColumn get imdbId => text()();
  TextColumn get homepage => text()();
  TextColumn get certification => text()();
  TextColumn get type => text()();

  TextColumn get posterPathSuffix => text().nullable()();
  TextColumn get backdropPathSuffix => text().nullable()();

  TextColumn get releaseDate => text()();
  TextColumn get firstAirDate => text()();
  TextColumn get lastAirDate => text()();
  TextColumn get lastUpdated => text()();

  TextColumn get externalIdsJson => text().nullable()();

  RealColumn get voteAverage => real()();
  IntColumn get voteCount => integer()();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dateRated => dateTime()();
  IntColumn get runtime => integer()();
  IntColumn get numberOfEpisodes => integer()();
  IntColumn get numberOfSeasons => integer()();
  RealColumn get popularity => real()();
  IntColumn get budget => integer()();
  IntColumn get revenue => integer()();

  IntColumn get effectiveRuntime => integer()();
  TextColumn get effectiveReleaseDate => text()();
  IntColumn get addedOrder => integer()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get notifyNewSeasons =>
      boolean().withDefault(const Constant(false))();

  TextColumn get imagesJson => text().nullable()();
  TextColumn get videosJson => text().nullable()();
  TextColumn get recommendationsJson => text().nullable()();
  TextColumn get nextEpisodeToAirJson => text().nullable()();
  TextColumn get lastEpisodeToAirJson => text().nullable()();
  TextColumn get providersJson => text().nullable()();
  TextColumn get creditsJson => text().nullable()();
  TextColumn get seasonsJson => text().nullable()();

  TextColumn get inLists => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get genreIds =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  TextColumn get keywordIds =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  TextColumn get flatrateProviderIds =>
      text().map(const IntListConverter()).withDefault(const Constant('[]'))();
  IntColumn get lastNotifiedSeason =>
      integer().withDefault(const Constant(0))();

  TextColumn get character => text()();
  TextColumn get job => text()();
  TextColumn get department => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TmdbSeasonData')
@TableIndex(name: 'idx_seasons_tv_id', columns: {#tvId})
class TmdbSeasons extends Table {
  TextColumn get id => text()();
  IntColumn get tvId => integer()();
  IntColumn get tmdbId => integer()();
  IntColumn get seasonNumber => integer()();
  TextColumn get name => text()();
  TextColumn get overview => text()();
  TextColumn get airDate => text()();
  TextColumn get posterPathSuffix => text().nullable()();
  TextColumn get lastUpdated => text()();
  RealColumn get voteAverage => real()();

  TextColumn get imagesJson => text().nullable()();
  TextColumn get videosJson => text().nullable()();
  TextColumn get creditsJson => text().nullable()();
  TextColumn get episodesJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TmdbEpisodeData')
@TableIndex(name: 'idx_episodes_tv_id', columns: {#tvId})
class TmdbEpisodes extends Table {
  TextColumn get id => text()();
  IntColumn get tmdbId => integer()();
  IntColumn get tvId => integer()();
  IntColumn get seasonNumber => integer()();
  IntColumn get episodeNumber => integer()();
  TextColumn get name => text()();
  TextColumn get overview => text()();
  TextColumn get airDate => text()();
  IntColumn get runtime => integer()();
  TextColumn get lastUpdated => text()();

  RealColumn get voteAverage => real()();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  DateTimeColumn get dateRated => dateTime()();

  TextColumn get stillPathSuffix => text().nullable()();
  TextColumn get guestStarsJson => text().nullable()();
  TextColumn get crewJson => text().nullable()();
  TextColumn get imagesJson => text().nullable()();
  TextColumn get videosJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
