// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realm_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class UserListEntryRealm extends _UserListEntryRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  UserListEntryRealm(
    String id,
    String listName,
    int tmdbId,
    String mediaType,
    int addedOrder,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'listName', listName);
    RealmObjectBase.set(this, 'tmdbId', tmdbId);
    RealmObjectBase.set(this, 'mediaType', mediaType);
    RealmObjectBase.set(this, 'addedOrder', addedOrder);
  }

  UserListEntryRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get listName =>
      RealmObjectBase.get<String>(this, 'listName') as String;
  @override
  set listName(String value) => RealmObjectBase.set(this, 'listName', value);

  @override
  int get tmdbId => RealmObjectBase.get<int>(this, 'tmdbId') as int;
  @override
  set tmdbId(int value) => RealmObjectBase.set(this, 'tmdbId', value);

  @override
  String get mediaType =>
      RealmObjectBase.get<String>(this, 'mediaType') as String;
  @override
  set mediaType(String value) => RealmObjectBase.set(this, 'mediaType', value);

  @override
  int get addedOrder => RealmObjectBase.get<int>(this, 'addedOrder') as int;
  @override
  set addedOrder(int value) => RealmObjectBase.set(this, 'addedOrder', value);

  @override
  Stream<RealmObjectChanges<UserListEntryRealm>> get changes =>
      RealmObjectBase.getChanges<UserListEntryRealm>(this);

  @override
  Stream<RealmObjectChanges<UserListEntryRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserListEntryRealm>(this, keyPaths);

  @override
  UserListEntryRealm freeze() =>
      RealmObjectBase.freezeObject<UserListEntryRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'listName': listName.toEJson(),
      'tmdbId': tmdbId.toEJson(),
      'mediaType': mediaType.toEJson(),
      'addedOrder': addedOrder.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserListEntryRealm value) => value.toEJson();
  static UserListEntryRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'listName': EJsonValue listName,
        'tmdbId': EJsonValue tmdbId,
        'mediaType': EJsonValue mediaType,
        'addedOrder': EJsonValue addedOrder,
      } =>
        UserListEntryRealm(
          fromEJson(id),
          fromEJson(listName),
          fromEJson(tmdbId),
          fromEJson(mediaType),
          fromEJson(addedOrder),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserListEntryRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, UserListEntryRealm, 'UserListEntryRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('listName', RealmPropertyType.string),
      SchemaProperty('tmdbId', RealmPropertyType.int),
      SchemaProperty('mediaType', RealmPropertyType.string),
      SchemaProperty('addedOrder', RealmPropertyType.int,
          indexType: RealmIndexType.regular),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class TmdbTitleRealm extends _TmdbTitleRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  TmdbTitleRealm(
    String id,
    int tmdbId,
    String name,
    String originalName,
    String originalLanguage,
    String overview,
    String tagline,
    String status,
    String mediaType,
    String imdbId,
    String homepage,
    String releaseDate,
    String firstAirDate,
    String lastAirDate,
    String lastUpdated,
    double voteAverage,
    int voteCount,
    double rating,
    DateTime dateRated,
    int runtime,
    int numberOfEpisodes,
    int numberOfSeasons,
    double popularity,
    int budget,
    int revenue,
    int effectiveRuntime,
    String effectiveReleaseDate,
    int addedOrder,
    bool isPinned,
    bool notifyNewSeasons,
    int lastNotifiedSeason,
    String lastProvidersUpdate,
    String character,
    String job,
    String department, {
    Iterable<String> inLists = const [],
    String? posterPathSuffix,
    String? backdropPathSuffix,
    String? imagesJson,
    String? videosJson,
    String? recommendationsJson,
    String? nextEpisodeToAirJson,
    String? lastEpisodeToAirJson,
    String? providersJson,
    String? creditsJson,
    String? seasonsJson,
    Iterable<int> genreIds = const [],
    Iterable<int> keywordIds = const [],
    Iterable<int> flatrateProviderIds = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'tmdbId', tmdbId);
    RealmObjectBase.set<RealmList<String>>(
        this, 'inLists', RealmList<String>(inLists));
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'originalName', originalName);
    RealmObjectBase.set(this, 'originalLanguage', originalLanguage);
    RealmObjectBase.set(this, 'overview', overview);
    RealmObjectBase.set(this, 'tagline', tagline);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'mediaType', mediaType);
    RealmObjectBase.set(this, 'imdbId', imdbId);
    RealmObjectBase.set(this, 'homepage', homepage);
    RealmObjectBase.set(this, 'posterPathSuffix', posterPathSuffix);
    RealmObjectBase.set(this, 'backdropPathSuffix', backdropPathSuffix);
    RealmObjectBase.set(this, 'releaseDate', releaseDate);
    RealmObjectBase.set(this, 'firstAirDate', firstAirDate);
    RealmObjectBase.set(this, 'lastAirDate', lastAirDate);
    RealmObjectBase.set(this, 'lastUpdated', lastUpdated);
    RealmObjectBase.set(this, 'voteAverage', voteAverage);
    RealmObjectBase.set(this, 'voteCount', voteCount);
    RealmObjectBase.set(this, 'rating', rating);
    RealmObjectBase.set(this, 'dateRated', dateRated);
    RealmObjectBase.set(this, 'runtime', runtime);
    RealmObjectBase.set(this, 'numberOfEpisodes', numberOfEpisodes);
    RealmObjectBase.set(this, 'numberOfSeasons', numberOfSeasons);
    RealmObjectBase.set(this, 'popularity', popularity);
    RealmObjectBase.set(this, 'budget', budget);
    RealmObjectBase.set(this, 'revenue', revenue);
    RealmObjectBase.set(this, 'effectiveRuntime', effectiveRuntime);
    RealmObjectBase.set(this, 'effectiveReleaseDate', effectiveReleaseDate);
    RealmObjectBase.set(this, 'addedOrder', addedOrder);
    RealmObjectBase.set(this, 'isPinned', isPinned);
    RealmObjectBase.set(this, 'notifyNewSeasons', notifyNewSeasons);
    RealmObjectBase.set(this, 'imagesJson', imagesJson);
    RealmObjectBase.set(this, 'videosJson', videosJson);
    RealmObjectBase.set(this, 'recommendationsJson', recommendationsJson);
    RealmObjectBase.set(this, 'nextEpisodeToAirJson', nextEpisodeToAirJson);
    RealmObjectBase.set(this, 'lastEpisodeToAirJson', lastEpisodeToAirJson);
    RealmObjectBase.set(this, 'providersJson', providersJson);
    RealmObjectBase.set(this, 'creditsJson', creditsJson);
    RealmObjectBase.set(this, 'seasonsJson', seasonsJson);
    RealmObjectBase.set<RealmList<int>>(
        this, 'genreIds', RealmList<int>(genreIds));
    RealmObjectBase.set<RealmList<int>>(
        this, 'keywordIds', RealmList<int>(keywordIds));
    RealmObjectBase.set<RealmList<int>>(
        this, 'flatrateProviderIds', RealmList<int>(flatrateProviderIds));
    RealmObjectBase.set(this, 'lastNotifiedSeason', lastNotifiedSeason);
    RealmObjectBase.set(this, 'lastProvidersUpdate', lastProvidersUpdate);
    RealmObjectBase.set(this, 'character', character);
    RealmObjectBase.set(this, 'job', job);
    RealmObjectBase.set(this, 'department', department);
  }

  TmdbTitleRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get tmdbId => RealmObjectBase.get<int>(this, 'tmdbId') as int;
  @override
  set tmdbId(int value) => RealmObjectBase.set(this, 'tmdbId', value);

  @override
  RealmList<String> get inLists =>
      RealmObjectBase.get<String>(this, 'inLists') as RealmList<String>;
  @override
  set inLists(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get originalName =>
      RealmObjectBase.get<String>(this, 'originalName') as String;
  @override
  set originalName(String value) =>
      RealmObjectBase.set(this, 'originalName', value);

  @override
  String get originalLanguage =>
      RealmObjectBase.get<String>(this, 'originalLanguage') as String;
  @override
  set originalLanguage(String value) =>
      RealmObjectBase.set(this, 'originalLanguage', value);

  @override
  String get overview =>
      RealmObjectBase.get<String>(this, 'overview') as String;
  @override
  set overview(String value) => RealmObjectBase.set(this, 'overview', value);

  @override
  String get tagline => RealmObjectBase.get<String>(this, 'tagline') as String;
  @override
  set tagline(String value) => RealmObjectBase.set(this, 'tagline', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String get mediaType =>
      RealmObjectBase.get<String>(this, 'mediaType') as String;
  @override
  set mediaType(String value) => RealmObjectBase.set(this, 'mediaType', value);

  @override
  String get imdbId => RealmObjectBase.get<String>(this, 'imdbId') as String;
  @override
  set imdbId(String value) => RealmObjectBase.set(this, 'imdbId', value);

  @override
  String get homepage =>
      RealmObjectBase.get<String>(this, 'homepage') as String;
  @override
  set homepage(String value) => RealmObjectBase.set(this, 'homepage', value);

  @override
  String? get posterPathSuffix =>
      RealmObjectBase.get<String>(this, 'posterPathSuffix') as String?;
  @override
  set posterPathSuffix(String? value) =>
      RealmObjectBase.set(this, 'posterPathSuffix', value);

  @override
  String? get backdropPathSuffix =>
      RealmObjectBase.get<String>(this, 'backdropPathSuffix') as String?;
  @override
  set backdropPathSuffix(String? value) =>
      RealmObjectBase.set(this, 'backdropPathSuffix', value);

  @override
  String get releaseDate =>
      RealmObjectBase.get<String>(this, 'releaseDate') as String;
  @override
  set releaseDate(String value) =>
      RealmObjectBase.set(this, 'releaseDate', value);

  @override
  String get firstAirDate =>
      RealmObjectBase.get<String>(this, 'firstAirDate') as String;
  @override
  set firstAirDate(String value) =>
      RealmObjectBase.set(this, 'firstAirDate', value);

  @override
  String get lastAirDate =>
      RealmObjectBase.get<String>(this, 'lastAirDate') as String;
  @override
  set lastAirDate(String value) =>
      RealmObjectBase.set(this, 'lastAirDate', value);

  @override
  String get lastUpdated =>
      RealmObjectBase.get<String>(this, 'lastUpdated') as String;
  @override
  set lastUpdated(String value) =>
      RealmObjectBase.set(this, 'lastUpdated', value);

  @override
  double get voteAverage =>
      RealmObjectBase.get<double>(this, 'voteAverage') as double;
  @override
  set voteAverage(double value) =>
      RealmObjectBase.set(this, 'voteAverage', value);

  @override
  int get voteCount => RealmObjectBase.get<int>(this, 'voteCount') as int;
  @override
  set voteCount(int value) => RealmObjectBase.set(this, 'voteCount', value);

  @override
  double get rating => RealmObjectBase.get<double>(this, 'rating') as double;
  @override
  set rating(double value) => RealmObjectBase.set(this, 'rating', value);

  @override
  DateTime get dateRated =>
      RealmObjectBase.get<DateTime>(this, 'dateRated') as DateTime;
  @override
  set dateRated(DateTime value) =>
      RealmObjectBase.set(this, 'dateRated', value);

  @override
  int get runtime => RealmObjectBase.get<int>(this, 'runtime') as int;
  @override
  set runtime(int value) => RealmObjectBase.set(this, 'runtime', value);

  @override
  int get numberOfEpisodes =>
      RealmObjectBase.get<int>(this, 'numberOfEpisodes') as int;
  @override
  set numberOfEpisodes(int value) =>
      RealmObjectBase.set(this, 'numberOfEpisodes', value);

  @override
  int get numberOfSeasons =>
      RealmObjectBase.get<int>(this, 'numberOfSeasons') as int;
  @override
  set numberOfSeasons(int value) =>
      RealmObjectBase.set(this, 'numberOfSeasons', value);

  @override
  double get popularity =>
      RealmObjectBase.get<double>(this, 'popularity') as double;
  @override
  set popularity(double value) =>
      RealmObjectBase.set(this, 'popularity', value);

  @override
  int get budget => RealmObjectBase.get<int>(this, 'budget') as int;
  @override
  set budget(int value) => RealmObjectBase.set(this, 'budget', value);

  @override
  int get revenue => RealmObjectBase.get<int>(this, 'revenue') as int;
  @override
  set revenue(int value) => RealmObjectBase.set(this, 'revenue', value);

  @override
  int get effectiveRuntime =>
      RealmObjectBase.get<int>(this, 'effectiveRuntime') as int;
  @override
  set effectiveRuntime(int value) =>
      RealmObjectBase.set(this, 'effectiveRuntime', value);

  @override
  String get effectiveReleaseDate =>
      RealmObjectBase.get<String>(this, 'effectiveReleaseDate') as String;
  @override
  set effectiveReleaseDate(String value) =>
      RealmObjectBase.set(this, 'effectiveReleaseDate', value);

  @override
  int get addedOrder => RealmObjectBase.get<int>(this, 'addedOrder') as int;
  @override
  set addedOrder(int value) => RealmObjectBase.set(this, 'addedOrder', value);

  @override
  bool get isPinned => RealmObjectBase.get<bool>(this, 'isPinned') as bool;
  @override
  set isPinned(bool value) => RealmObjectBase.set(this, 'isPinned', value);

  @override
  bool get notifyNewSeasons =>
      RealmObjectBase.get<bool>(this, 'notifyNewSeasons') as bool;
  @override
  set notifyNewSeasons(bool value) =>
      RealmObjectBase.set(this, 'notifyNewSeasons', value);

  @override
  String? get imagesJson =>
      RealmObjectBase.get<String>(this, 'imagesJson') as String?;
  @override
  set imagesJson(String? value) =>
      RealmObjectBase.set(this, 'imagesJson', value);

  @override
  String? get videosJson =>
      RealmObjectBase.get<String>(this, 'videosJson') as String?;
  @override
  set videosJson(String? value) =>
      RealmObjectBase.set(this, 'videosJson', value);

  @override
  String? get recommendationsJson =>
      RealmObjectBase.get<String>(this, 'recommendationsJson') as String?;
  @override
  set recommendationsJson(String? value) =>
      RealmObjectBase.set(this, 'recommendationsJson', value);

  @override
  String? get nextEpisodeToAirJson =>
      RealmObjectBase.get<String>(this, 'nextEpisodeToAirJson') as String?;
  @override
  set nextEpisodeToAirJson(String? value) =>
      RealmObjectBase.set(this, 'nextEpisodeToAirJson', value);

  @override
  String? get lastEpisodeToAirJson =>
      RealmObjectBase.get<String>(this, 'lastEpisodeToAirJson') as String?;
  @override
  set lastEpisodeToAirJson(String? value) =>
      RealmObjectBase.set(this, 'lastEpisodeToAirJson', value);

  @override
  String? get providersJson =>
      RealmObjectBase.get<String>(this, 'providersJson') as String?;
  @override
  set providersJson(String? value) =>
      RealmObjectBase.set(this, 'providersJson', value);

  @override
  String? get creditsJson =>
      RealmObjectBase.get<String>(this, 'creditsJson') as String?;
  @override
  set creditsJson(String? value) =>
      RealmObjectBase.set(this, 'creditsJson', value);

  @override
  String? get seasonsJson =>
      RealmObjectBase.get<String>(this, 'seasonsJson') as String?;
  @override
  set seasonsJson(String? value) =>
      RealmObjectBase.set(this, 'seasonsJson', value);

  @override
  RealmList<int> get genreIds =>
      RealmObjectBase.get<int>(this, 'genreIds') as RealmList<int>;
  @override
  set genreIds(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<int> get keywordIds =>
      RealmObjectBase.get<int>(this, 'keywordIds') as RealmList<int>;
  @override
  set keywordIds(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<int> get flatrateProviderIds =>
      RealmObjectBase.get<int>(this, 'flatrateProviderIds') as RealmList<int>;
  @override
  set flatrateProviderIds(covariant RealmList<int> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get lastNotifiedSeason =>
      RealmObjectBase.get<int>(this, 'lastNotifiedSeason') as int;
  @override
  set lastNotifiedSeason(int value) =>
      RealmObjectBase.set(this, 'lastNotifiedSeason', value);

  @override
  String get lastProvidersUpdate =>
      RealmObjectBase.get<String>(this, 'lastProvidersUpdate') as String;
  @override
  set lastProvidersUpdate(String value) =>
      RealmObjectBase.set(this, 'lastProvidersUpdate', value);

  @override
  String get character =>
      RealmObjectBase.get<String>(this, 'character') as String;
  @override
  set character(String value) => RealmObjectBase.set(this, 'character', value);

  @override
  String get job => RealmObjectBase.get<String>(this, 'job') as String;
  @override
  set job(String value) => RealmObjectBase.set(this, 'job', value);

  @override
  String get department =>
      RealmObjectBase.get<String>(this, 'department') as String;
  @override
  set department(String value) =>
      RealmObjectBase.set(this, 'department', value);

  @override
  Stream<RealmObjectChanges<TmdbTitleRealm>> get changes =>
      RealmObjectBase.getChanges<TmdbTitleRealm>(this);

  @override
  Stream<RealmObjectChanges<TmdbTitleRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TmdbTitleRealm>(this, keyPaths);

  @override
  TmdbTitleRealm freeze() => RealmObjectBase.freezeObject<TmdbTitleRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'tmdbId': tmdbId.toEJson(),
      'inLists': inLists.toEJson(),
      'name': name.toEJson(),
      'originalName': originalName.toEJson(),
      'originalLanguage': originalLanguage.toEJson(),
      'overview': overview.toEJson(),
      'tagline': tagline.toEJson(),
      'status': status.toEJson(),
      'mediaType': mediaType.toEJson(),
      'imdbId': imdbId.toEJson(),
      'homepage': homepage.toEJson(),
      'posterPathSuffix': posterPathSuffix.toEJson(),
      'backdropPathSuffix': backdropPathSuffix.toEJson(),
      'releaseDate': releaseDate.toEJson(),
      'firstAirDate': firstAirDate.toEJson(),
      'lastAirDate': lastAirDate.toEJson(),
      'lastUpdated': lastUpdated.toEJson(),
      'voteAverage': voteAverage.toEJson(),
      'voteCount': voteCount.toEJson(),
      'rating': rating.toEJson(),
      'dateRated': dateRated.toEJson(),
      'runtime': runtime.toEJson(),
      'numberOfEpisodes': numberOfEpisodes.toEJson(),
      'numberOfSeasons': numberOfSeasons.toEJson(),
      'popularity': popularity.toEJson(),
      'budget': budget.toEJson(),
      'revenue': revenue.toEJson(),
      'effectiveRuntime': effectiveRuntime.toEJson(),
      'effectiveReleaseDate': effectiveReleaseDate.toEJson(),
      'addedOrder': addedOrder.toEJson(),
      'isPinned': isPinned.toEJson(),
      'notifyNewSeasons': notifyNewSeasons.toEJson(),
      'imagesJson': imagesJson.toEJson(),
      'videosJson': videosJson.toEJson(),
      'recommendationsJson': recommendationsJson.toEJson(),
      'nextEpisodeToAirJson': nextEpisodeToAirJson.toEJson(),
      'lastEpisodeToAirJson': lastEpisodeToAirJson.toEJson(),
      'providersJson': providersJson.toEJson(),
      'creditsJson': creditsJson.toEJson(),
      'seasonsJson': seasonsJson.toEJson(),
      'genreIds': genreIds.toEJson(),
      'keywordIds': keywordIds.toEJson(),
      'flatrateProviderIds': flatrateProviderIds.toEJson(),
      'lastNotifiedSeason': lastNotifiedSeason.toEJson(),
      'lastProvidersUpdate': lastProvidersUpdate.toEJson(),
      'character': character.toEJson(),
      'job': job.toEJson(),
      'department': department.toEJson(),
    };
  }

  static EJsonValue _toEJson(TmdbTitleRealm value) => value.toEJson();
  static TmdbTitleRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'tmdbId': EJsonValue tmdbId,
        'name': EJsonValue name,
        'originalName': EJsonValue originalName,
        'originalLanguage': EJsonValue originalLanguage,
        'overview': EJsonValue overview,
        'tagline': EJsonValue tagline,
        'status': EJsonValue status,
        'mediaType': EJsonValue mediaType,
        'imdbId': EJsonValue imdbId,
        'homepage': EJsonValue homepage,
        'releaseDate': EJsonValue releaseDate,
        'firstAirDate': EJsonValue firstAirDate,
        'lastAirDate': EJsonValue lastAirDate,
        'lastUpdated': EJsonValue lastUpdated,
        'voteAverage': EJsonValue voteAverage,
        'voteCount': EJsonValue voteCount,
        'rating': EJsonValue rating,
        'dateRated': EJsonValue dateRated,
        'runtime': EJsonValue runtime,
        'numberOfEpisodes': EJsonValue numberOfEpisodes,
        'numberOfSeasons': EJsonValue numberOfSeasons,
        'popularity': EJsonValue popularity,
        'budget': EJsonValue budget,
        'revenue': EJsonValue revenue,
        'effectiveRuntime': EJsonValue effectiveRuntime,
        'effectiveReleaseDate': EJsonValue effectiveReleaseDate,
        'addedOrder': EJsonValue addedOrder,
        'isPinned': EJsonValue isPinned,
        'notifyNewSeasons': EJsonValue notifyNewSeasons,
        'lastNotifiedSeason': EJsonValue lastNotifiedSeason,
        'lastProvidersUpdate': EJsonValue lastProvidersUpdate,
        'character': EJsonValue character,
        'job': EJsonValue job,
        'department': EJsonValue department,
      } =>
        TmdbTitleRealm(
          fromEJson(id),
          fromEJson(tmdbId),
          fromEJson(name),
          fromEJson(originalName),
          fromEJson(originalLanguage),
          fromEJson(overview),
          fromEJson(tagline),
          fromEJson(status),
          fromEJson(mediaType),
          fromEJson(imdbId),
          fromEJson(homepage),
          fromEJson(releaseDate),
          fromEJson(firstAirDate),
          fromEJson(lastAirDate),
          fromEJson(lastUpdated),
          fromEJson(voteAverage),
          fromEJson(voteCount),
          fromEJson(rating),
          fromEJson(dateRated),
          fromEJson(runtime),
          fromEJson(numberOfEpisodes),
          fromEJson(numberOfSeasons),
          fromEJson(popularity),
          fromEJson(budget),
          fromEJson(revenue),
          fromEJson(effectiveRuntime),
          fromEJson(effectiveReleaseDate),
          fromEJson(addedOrder),
          fromEJson(isPinned),
          fromEJson(notifyNewSeasons),
          fromEJson(lastNotifiedSeason),
          fromEJson(lastProvidersUpdate),
          fromEJson(character),
          fromEJson(job),
          fromEJson(department),
          inLists: fromEJson(ejson['inLists']),
          posterPathSuffix: fromEJson(ejson['posterPathSuffix']),
          backdropPathSuffix: fromEJson(ejson['backdropPathSuffix']),
          imagesJson: fromEJson(ejson['imagesJson']),
          videosJson: fromEJson(ejson['videosJson']),
          recommendationsJson: fromEJson(ejson['recommendationsJson']),
          nextEpisodeToAirJson: fromEJson(ejson['nextEpisodeToAirJson']),
          lastEpisodeToAirJson: fromEJson(ejson['lastEpisodeToAirJson']),
          providersJson: fromEJson(ejson['providersJson']),
          creditsJson: fromEJson(ejson['creditsJson']),
          seasonsJson: fromEJson(ejson['seasonsJson']),
          genreIds: fromEJson(ejson['genreIds']),
          keywordIds: fromEJson(ejson['keywordIds']),
          flatrateProviderIds: fromEJson(ejson['flatrateProviderIds']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TmdbTitleRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, TmdbTitleRealm, 'TmdbTitleRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('tmdbId', RealmPropertyType.int),
      SchemaProperty('inLists', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('originalName', RealmPropertyType.string),
      SchemaProperty('originalLanguage', RealmPropertyType.string),
      SchemaProperty('overview', RealmPropertyType.string),
      SchemaProperty('tagline', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('mediaType', RealmPropertyType.string),
      SchemaProperty('imdbId', RealmPropertyType.string),
      SchemaProperty('homepage', RealmPropertyType.string),
      SchemaProperty('posterPathSuffix', RealmPropertyType.string,
          optional: true),
      SchemaProperty('backdropPathSuffix', RealmPropertyType.string,
          optional: true),
      SchemaProperty('releaseDate', RealmPropertyType.string),
      SchemaProperty('firstAirDate', RealmPropertyType.string),
      SchemaProperty('lastAirDate', RealmPropertyType.string),
      SchemaProperty('lastUpdated', RealmPropertyType.string),
      SchemaProperty('voteAverage', RealmPropertyType.double),
      SchemaProperty('voteCount', RealmPropertyType.int),
      SchemaProperty('rating', RealmPropertyType.double),
      SchemaProperty('dateRated', RealmPropertyType.timestamp),
      SchemaProperty('runtime', RealmPropertyType.int),
      SchemaProperty('numberOfEpisodes', RealmPropertyType.int),
      SchemaProperty('numberOfSeasons', RealmPropertyType.int),
      SchemaProperty('popularity', RealmPropertyType.double),
      SchemaProperty('budget', RealmPropertyType.int),
      SchemaProperty('revenue', RealmPropertyType.int),
      SchemaProperty('effectiveRuntime', RealmPropertyType.int),
      SchemaProperty('effectiveReleaseDate', RealmPropertyType.string),
      SchemaProperty('addedOrder', RealmPropertyType.int),
      SchemaProperty('isPinned', RealmPropertyType.bool),
      SchemaProperty('notifyNewSeasons', RealmPropertyType.bool),
      SchemaProperty('imagesJson', RealmPropertyType.string, optional: true),
      SchemaProperty('videosJson', RealmPropertyType.string, optional: true),
      SchemaProperty('recommendationsJson', RealmPropertyType.string,
          optional: true),
      SchemaProperty('nextEpisodeToAirJson', RealmPropertyType.string,
          optional: true),
      SchemaProperty('lastEpisodeToAirJson', RealmPropertyType.string,
          optional: true),
      SchemaProperty('providersJson', RealmPropertyType.string, optional: true),
      SchemaProperty('creditsJson', RealmPropertyType.string, optional: true),
      SchemaProperty('seasonsJson', RealmPropertyType.string, optional: true),
      SchemaProperty('genreIds', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
      SchemaProperty('keywordIds', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
      SchemaProperty('flatrateProviderIds', RealmPropertyType.int,
          collectionType: RealmCollectionType.list),
      SchemaProperty('lastNotifiedSeason', RealmPropertyType.int),
      SchemaProperty('lastProvidersUpdate', RealmPropertyType.string),
      SchemaProperty('character', RealmPropertyType.string),
      SchemaProperty('job', RealmPropertyType.string),
      SchemaProperty('department', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class TmdbSeasonRealm extends _TmdbSeasonRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  TmdbSeasonRealm(
    String id,
    int tvId,
    int tmdbId,
    int seasonNumber,
    String name,
    String overview,
    String airDate,
    String lastUpdated, {
    String? posterPathSuffix,
    String? creditsJson,
    String? episodesJson,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'tvId', tvId);
    RealmObjectBase.set(this, 'tmdbId', tmdbId);
    RealmObjectBase.set(this, 'seasonNumber', seasonNumber);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'overview', overview);
    RealmObjectBase.set(this, 'airDate', airDate);
    RealmObjectBase.set(this, 'posterPathSuffix', posterPathSuffix);
    RealmObjectBase.set(this, 'lastUpdated', lastUpdated);
    RealmObjectBase.set(this, 'creditsJson', creditsJson);
    RealmObjectBase.set(this, 'episodesJson', episodesJson);
  }

  TmdbSeasonRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get tvId => RealmObjectBase.get<int>(this, 'tvId') as int;
  @override
  set tvId(int value) => RealmObjectBase.set(this, 'tvId', value);

  @override
  int get tmdbId => RealmObjectBase.get<int>(this, 'tmdbId') as int;
  @override
  set tmdbId(int value) => RealmObjectBase.set(this, 'tmdbId', value);

  @override
  int get seasonNumber => RealmObjectBase.get<int>(this, 'seasonNumber') as int;
  @override
  set seasonNumber(int value) =>
      RealmObjectBase.set(this, 'seasonNumber', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get overview =>
      RealmObjectBase.get<String>(this, 'overview') as String;
  @override
  set overview(String value) => RealmObjectBase.set(this, 'overview', value);

  @override
  String get airDate => RealmObjectBase.get<String>(this, 'airDate') as String;
  @override
  set airDate(String value) => RealmObjectBase.set(this, 'airDate', value);

  @override
  String? get posterPathSuffix =>
      RealmObjectBase.get<String>(this, 'posterPathSuffix') as String?;
  @override
  set posterPathSuffix(String? value) =>
      RealmObjectBase.set(this, 'posterPathSuffix', value);

  @override
  String get lastUpdated =>
      RealmObjectBase.get<String>(this, 'lastUpdated') as String;
  @override
  set lastUpdated(String value) =>
      RealmObjectBase.set(this, 'lastUpdated', value);

  @override
  String? get creditsJson =>
      RealmObjectBase.get<String>(this, 'creditsJson') as String?;
  @override
  set creditsJson(String? value) =>
      RealmObjectBase.set(this, 'creditsJson', value);

  @override
  String? get episodesJson =>
      RealmObjectBase.get<String>(this, 'episodesJson') as String?;
  @override
  set episodesJson(String? value) =>
      RealmObjectBase.set(this, 'episodesJson', value);

  @override
  Stream<RealmObjectChanges<TmdbSeasonRealm>> get changes =>
      RealmObjectBase.getChanges<TmdbSeasonRealm>(this);

  @override
  Stream<RealmObjectChanges<TmdbSeasonRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TmdbSeasonRealm>(this, keyPaths);

  @override
  TmdbSeasonRealm freeze() =>
      RealmObjectBase.freezeObject<TmdbSeasonRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'tvId': tvId.toEJson(),
      'tmdbId': tmdbId.toEJson(),
      'seasonNumber': seasonNumber.toEJson(),
      'name': name.toEJson(),
      'overview': overview.toEJson(),
      'airDate': airDate.toEJson(),
      'posterPathSuffix': posterPathSuffix.toEJson(),
      'lastUpdated': lastUpdated.toEJson(),
      'creditsJson': creditsJson.toEJson(),
      'episodesJson': episodesJson.toEJson(),
    };
  }

  static EJsonValue _toEJson(TmdbSeasonRealm value) => value.toEJson();
  static TmdbSeasonRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'tvId': EJsonValue tvId,
        'tmdbId': EJsonValue tmdbId,
        'seasonNumber': EJsonValue seasonNumber,
        'name': EJsonValue name,
        'overview': EJsonValue overview,
        'airDate': EJsonValue airDate,
        'lastUpdated': EJsonValue lastUpdated,
      } =>
        TmdbSeasonRealm(
          fromEJson(id),
          fromEJson(tvId),
          fromEJson(tmdbId),
          fromEJson(seasonNumber),
          fromEJson(name),
          fromEJson(overview),
          fromEJson(airDate),
          fromEJson(lastUpdated),
          posterPathSuffix: fromEJson(ejson['posterPathSuffix']),
          creditsJson: fromEJson(ejson['creditsJson']),
          episodesJson: fromEJson(ejson['episodesJson']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TmdbSeasonRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, TmdbSeasonRealm, 'TmdbSeasonRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('tvId', RealmPropertyType.int),
      SchemaProperty('tmdbId', RealmPropertyType.int),
      SchemaProperty('seasonNumber', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('overview', RealmPropertyType.string),
      SchemaProperty('airDate', RealmPropertyType.string),
      SchemaProperty('posterPathSuffix', RealmPropertyType.string,
          optional: true),
      SchemaProperty('lastUpdated', RealmPropertyType.string),
      SchemaProperty('creditsJson', RealmPropertyType.string, optional: true),
      SchemaProperty('episodesJson', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class TmdbEpisodeRealm extends _TmdbEpisodeRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  TmdbEpisodeRealm(
    String id,
    int tmdbId,
    int tvId,
    int seasonNumber,
    String name,
    String overview,
    String airDate,
    int runtime,
    int episodeNumber,
    String lastUpdated,
    double voteAverage, {
    String? stillPathSuffix,
    String? guestStarsJson,
    String? crewJson,
    String? imagesJson,
    String? videosJson,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'tmdbId', tmdbId);
    RealmObjectBase.set(this, 'tvId', tvId);
    RealmObjectBase.set(this, 'seasonNumber', seasonNumber);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'overview', overview);
    RealmObjectBase.set(this, 'airDate', airDate);
    RealmObjectBase.set(this, 'runtime', runtime);
    RealmObjectBase.set(this, 'episodeNumber', episodeNumber);
    RealmObjectBase.set(this, 'lastUpdated', lastUpdated);
    RealmObjectBase.set(this, 'voteAverage', voteAverage);
    RealmObjectBase.set(this, 'stillPathSuffix', stillPathSuffix);
    RealmObjectBase.set(this, 'guestStarsJson', guestStarsJson);
    RealmObjectBase.set(this, 'crewJson', crewJson);
    RealmObjectBase.set(this, 'imagesJson', imagesJson);
    RealmObjectBase.set(this, 'videosJson', videosJson);
  }

  TmdbEpisodeRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get tmdbId => RealmObjectBase.get<int>(this, 'tmdbId') as int;
  @override
  set tmdbId(int value) => RealmObjectBase.set(this, 'tmdbId', value);

  @override
  int get tvId => RealmObjectBase.get<int>(this, 'tvId') as int;
  @override
  set tvId(int value) => RealmObjectBase.set(this, 'tvId', value);

  @override
  int get seasonNumber => RealmObjectBase.get<int>(this, 'seasonNumber') as int;
  @override
  set seasonNumber(int value) =>
      RealmObjectBase.set(this, 'seasonNumber', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get overview =>
      RealmObjectBase.get<String>(this, 'overview') as String;
  @override
  set overview(String value) => RealmObjectBase.set(this, 'overview', value);

  @override
  String get airDate => RealmObjectBase.get<String>(this, 'airDate') as String;
  @override
  set airDate(String value) => RealmObjectBase.set(this, 'airDate', value);

  @override
  int get runtime => RealmObjectBase.get<int>(this, 'runtime') as int;
  @override
  set runtime(int value) => RealmObjectBase.set(this, 'runtime', value);

  @override
  int get episodeNumber =>
      RealmObjectBase.get<int>(this, 'episodeNumber') as int;
  @override
  set episodeNumber(int value) =>
      RealmObjectBase.set(this, 'episodeNumber', value);

  @override
  String get lastUpdated =>
      RealmObjectBase.get<String>(this, 'lastUpdated') as String;
  @override
  set lastUpdated(String value) =>
      RealmObjectBase.set(this, 'lastUpdated', value);

  @override
  double get voteAverage =>
      RealmObjectBase.get<double>(this, 'voteAverage') as double;
  @override
  set voteAverage(double value) =>
      RealmObjectBase.set(this, 'voteAverage', value);

  @override
  String? get stillPathSuffix =>
      RealmObjectBase.get<String>(this, 'stillPathSuffix') as String?;
  @override
  set stillPathSuffix(String? value) =>
      RealmObjectBase.set(this, 'stillPathSuffix', value);

  @override
  String? get guestStarsJson =>
      RealmObjectBase.get<String>(this, 'guestStarsJson') as String?;
  @override
  set guestStarsJson(String? value) =>
      RealmObjectBase.set(this, 'guestStarsJson', value);

  @override
  String? get crewJson =>
      RealmObjectBase.get<String>(this, 'crewJson') as String?;
  @override
  set crewJson(String? value) => RealmObjectBase.set(this, 'crewJson', value);

  @override
  String? get imagesJson =>
      RealmObjectBase.get<String>(this, 'imagesJson') as String?;
  @override
  set imagesJson(String? value) =>
      RealmObjectBase.set(this, 'imagesJson', value);

  @override
  String? get videosJson =>
      RealmObjectBase.get<String>(this, 'videosJson') as String?;
  @override
  set videosJson(String? value) =>
      RealmObjectBase.set(this, 'videosJson', value);

  @override
  Stream<RealmObjectChanges<TmdbEpisodeRealm>> get changes =>
      RealmObjectBase.getChanges<TmdbEpisodeRealm>(this);

  @override
  Stream<RealmObjectChanges<TmdbEpisodeRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TmdbEpisodeRealm>(this, keyPaths);

  @override
  TmdbEpisodeRealm freeze() =>
      RealmObjectBase.freezeObject<TmdbEpisodeRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'tmdbId': tmdbId.toEJson(),
      'tvId': tvId.toEJson(),
      'seasonNumber': seasonNumber.toEJson(),
      'name': name.toEJson(),
      'overview': overview.toEJson(),
      'airDate': airDate.toEJson(),
      'runtime': runtime.toEJson(),
      'episodeNumber': episodeNumber.toEJson(),
      'lastUpdated': lastUpdated.toEJson(),
      'voteAverage': voteAverage.toEJson(),
      'stillPathSuffix': stillPathSuffix.toEJson(),
      'guestStarsJson': guestStarsJson.toEJson(),
      'crewJson': crewJson.toEJson(),
      'imagesJson': imagesJson.toEJson(),
      'videosJson': videosJson.toEJson(),
    };
  }

  static EJsonValue _toEJson(TmdbEpisodeRealm value) => value.toEJson();
  static TmdbEpisodeRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'tmdbId': EJsonValue tmdbId,
        'tvId': EJsonValue tvId,
        'seasonNumber': EJsonValue seasonNumber,
        'name': EJsonValue name,
        'overview': EJsonValue overview,
        'airDate': EJsonValue airDate,
        'runtime': EJsonValue runtime,
        'episodeNumber': EJsonValue episodeNumber,
        'lastUpdated': EJsonValue lastUpdated,
        'voteAverage': EJsonValue voteAverage,
      } =>
        TmdbEpisodeRealm(
          fromEJson(id),
          fromEJson(tmdbId),
          fromEJson(tvId),
          fromEJson(seasonNumber),
          fromEJson(name),
          fromEJson(overview),
          fromEJson(airDate),
          fromEJson(runtime),
          fromEJson(episodeNumber),
          fromEJson(lastUpdated),
          fromEJson(voteAverage),
          stillPathSuffix: fromEJson(ejson['stillPathSuffix']),
          guestStarsJson: fromEJson(ejson['guestStarsJson']),
          crewJson: fromEJson(ejson['crewJson']),
          imagesJson: fromEJson(ejson['imagesJson']),
          videosJson: fromEJson(ejson['videosJson']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TmdbEpisodeRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, TmdbEpisodeRealm, 'TmdbEpisodeRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('tmdbId', RealmPropertyType.int),
      SchemaProperty('tvId', RealmPropertyType.int),
      SchemaProperty('seasonNumber', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('overview', RealmPropertyType.string),
      SchemaProperty('airDate', RealmPropertyType.string),
      SchemaProperty('runtime', RealmPropertyType.int),
      SchemaProperty('episodeNumber', RealmPropertyType.int),
      SchemaProperty('lastUpdated', RealmPropertyType.string),
      SchemaProperty('voteAverage', RealmPropertyType.double),
      SchemaProperty('stillPathSuffix', RealmPropertyType.string,
          optional: true),
      SchemaProperty('guestStarsJson', RealmPropertyType.string,
          optional: true),
      SchemaProperty('crewJson', RealmPropertyType.string, optional: true),
      SchemaProperty('imagesJson', RealmPropertyType.string, optional: true),
      SchemaProperty('videosJson', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
