// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserListEntriesTable extends UserListEntries
    with TableInfo<$UserListEntriesTable, UserListEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserListEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _listNameMeta =
      const VerificationMeta('listName');
  @override
  late final GeneratedColumn<String> listName = GeneratedColumn<String>(
      'list_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mediaTypeMeta =
      const VerificationMeta('mediaType');
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
      'media_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addedOrderMeta =
      const VerificationMeta('addedOrder');
  @override
  late final GeneratedColumn<int> addedOrder = GeneratedColumn<int>(
      'added_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, listName, tmdbId, mediaType, addedOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_list_entries';
  @override
  VerificationContext validateIntegrity(Insertable<UserListEntryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_name')) {
      context.handle(_listNameMeta,
          listName.isAcceptableOrUnknown(data['list_name']!, _listNameMeta));
    } else if (isInserting) {
      context.missing(_listNameMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(_mediaTypeMeta,
          mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta));
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('added_order')) {
      context.handle(
          _addedOrderMeta,
          addedOrder.isAcceptableOrUnknown(
              data['added_order']!, _addedOrderMeta));
    } else if (isInserting) {
      context.missing(_addedOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserListEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserListEntryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      listName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}list_name'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      mediaType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_type'])!,
      addedOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}added_order'])!,
    );
  }

  @override
  $UserListEntriesTable createAlias(String alias) {
    return $UserListEntriesTable(attachedDatabase, alias);
  }
}

class UserListEntryData extends DataClass
    implements Insertable<UserListEntryData> {
  final String id;
  final String listName;
  final int tmdbId;
  final String mediaType;
  final int addedOrder;
  const UserListEntryData(
      {required this.id,
      required this.listName,
      required this.tmdbId,
      required this.mediaType,
      required this.addedOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_name'] = Variable<String>(listName);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['media_type'] = Variable<String>(mediaType);
    map['added_order'] = Variable<int>(addedOrder);
    return map;
  }

  UserListEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserListEntriesCompanion(
      id: Value(id),
      listName: Value(listName),
      tmdbId: Value(tmdbId),
      mediaType: Value(mediaType),
      addedOrder: Value(addedOrder),
    );
  }

  factory UserListEntryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserListEntryData(
      id: serializer.fromJson<String>(json['id']),
      listName: serializer.fromJson<String>(json['listName']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      addedOrder: serializer.fromJson<int>(json['addedOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listName': serializer.toJson<String>(listName),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'mediaType': serializer.toJson<String>(mediaType),
      'addedOrder': serializer.toJson<int>(addedOrder),
    };
  }

  UserListEntryData copyWith(
          {String? id,
          String? listName,
          int? tmdbId,
          String? mediaType,
          int? addedOrder}) =>
      UserListEntryData(
        id: id ?? this.id,
        listName: listName ?? this.listName,
        tmdbId: tmdbId ?? this.tmdbId,
        mediaType: mediaType ?? this.mediaType,
        addedOrder: addedOrder ?? this.addedOrder,
      );
  UserListEntryData copyWithCompanion(UserListEntriesCompanion data) {
    return UserListEntryData(
      id: data.id.present ? data.id.value : this.id,
      listName: data.listName.present ? data.listName.value : this.listName,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      addedOrder:
          data.addedOrder.present ? data.addedOrder.value : this.addedOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserListEntryData(')
          ..write('id: $id, ')
          ..write('listName: $listName, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('mediaType: $mediaType, ')
          ..write('addedOrder: $addedOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listName, tmdbId, mediaType, addedOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserListEntryData &&
          other.id == this.id &&
          other.listName == this.listName &&
          other.tmdbId == this.tmdbId &&
          other.mediaType == this.mediaType &&
          other.addedOrder == this.addedOrder);
}

class UserListEntriesCompanion extends UpdateCompanion<UserListEntryData> {
  final Value<String> id;
  final Value<String> listName;
  final Value<int> tmdbId;
  final Value<String> mediaType;
  final Value<int> addedOrder;
  final Value<int> rowid;
  const UserListEntriesCompanion({
    this.id = const Value.absent(),
    this.listName = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.addedOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserListEntriesCompanion.insert({
    required String id,
    required String listName,
    required int tmdbId,
    required String mediaType,
    required int addedOrder,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        listName = Value(listName),
        tmdbId = Value(tmdbId),
        mediaType = Value(mediaType),
        addedOrder = Value(addedOrder);
  static Insertable<UserListEntryData> custom({
    Expression<String>? id,
    Expression<String>? listName,
    Expression<int>? tmdbId,
    Expression<String>? mediaType,
    Expression<int>? addedOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listName != null) 'list_name': listName,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (mediaType != null) 'media_type': mediaType,
      if (addedOrder != null) 'added_order': addedOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserListEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? listName,
      Value<int>? tmdbId,
      Value<String>? mediaType,
      Value<int>? addedOrder,
      Value<int>? rowid}) {
    return UserListEntriesCompanion(
      id: id ?? this.id,
      listName: listName ?? this.listName,
      tmdbId: tmdbId ?? this.tmdbId,
      mediaType: mediaType ?? this.mediaType,
      addedOrder: addedOrder ?? this.addedOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listName.present) {
      map['list_name'] = Variable<String>(listName.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (addedOrder.present) {
      map['added_order'] = Variable<int>(addedOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserListEntriesCompanion(')
          ..write('id: $id, ')
          ..write('listName: $listName, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('mediaType: $mediaType, ')
          ..write('addedOrder: $addedOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TmdbTitlesTable extends TmdbTitles
    with TableInfo<$TmdbTitlesTable, TmdbTitleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TmdbTitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalNameMeta =
      const VerificationMeta('originalName');
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
      'original_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalLanguageMeta =
      const VerificationMeta('originalLanguage');
  @override
  late final GeneratedColumn<String> originalLanguage = GeneratedColumn<String>(
      'original_language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taglineMeta =
      const VerificationMeta('tagline');
  @override
  late final GeneratedColumn<String> tagline = GeneratedColumn<String>(
      'tagline', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mediaTypeMeta =
      const VerificationMeta('mediaType');
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
      'media_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imdbIdMeta = const VerificationMeta('imdbId');
  @override
  late final GeneratedColumn<String> imdbId = GeneratedColumn<String>(
      'imdb_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _homepageMeta =
      const VerificationMeta('homepage');
  @override
  late final GeneratedColumn<String> homepage = GeneratedColumn<String>(
      'homepage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _certificationMeta =
      const VerificationMeta('certification');
  @override
  late final GeneratedColumn<String> certification = GeneratedColumn<String>(
      'certification', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _posterPathSuffixMeta =
      const VerificationMeta('posterPathSuffix');
  @override
  late final GeneratedColumn<String> posterPathSuffix = GeneratedColumn<String>(
      'poster_path_suffix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backdropPathSuffixMeta =
      const VerificationMeta('backdropPathSuffix');
  @override
  late final GeneratedColumn<String> backdropPathSuffix =
      GeneratedColumn<String>('backdrop_path_suffix', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
      'release_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstAirDateMeta =
      const VerificationMeta('firstAirDate');
  @override
  late final GeneratedColumn<String> firstAirDate = GeneratedColumn<String>(
      'first_air_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastAirDateMeta =
      const VerificationMeta('lastAirDate');
  @override
  late final GeneratedColumn<String> lastAirDate = GeneratedColumn<String>(
      'last_air_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<String> lastUpdated = GeneratedColumn<String>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _externalIdsJsonMeta =
      const VerificationMeta('externalIdsJson');
  @override
  late final GeneratedColumn<String> externalIdsJson = GeneratedColumn<String>(
      'external_ids_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voteAverageMeta =
      const VerificationMeta('voteAverage');
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
      'vote_average', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _voteCountMeta =
      const VerificationMeta('voteCount');
  @override
  late final GeneratedColumn<int> voteCount = GeneratedColumn<int>(
      'vote_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateRatedMeta =
      const VerificationMeta('dateRated');
  @override
  late final GeneratedColumn<DateTime> dateRated = GeneratedColumn<DateTime>(
      'date_rated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _runtimeMeta =
      const VerificationMeta('runtime');
  @override
  late final GeneratedColumn<int> runtime = GeneratedColumn<int>(
      'runtime', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberOfEpisodesMeta =
      const VerificationMeta('numberOfEpisodes');
  @override
  late final GeneratedColumn<int> numberOfEpisodes = GeneratedColumn<int>(
      'number_of_episodes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberOfSeasonsMeta =
      const VerificationMeta('numberOfSeasons');
  @override
  late final GeneratedColumn<int> numberOfSeasons = GeneratedColumn<int>(
      'number_of_seasons', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _popularityMeta =
      const VerificationMeta('popularity');
  @override
  late final GeneratedColumn<double> popularity = GeneratedColumn<double>(
      'popularity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<int> budget = GeneratedColumn<int>(
      'budget', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _revenueMeta =
      const VerificationMeta('revenue');
  @override
  late final GeneratedColumn<int> revenue = GeneratedColumn<int>(
      'revenue', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _effectiveRuntimeMeta =
      const VerificationMeta('effectiveRuntime');
  @override
  late final GeneratedColumn<int> effectiveRuntime = GeneratedColumn<int>(
      'effective_runtime', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _effectiveReleaseDateMeta =
      const VerificationMeta('effectiveReleaseDate');
  @override
  late final GeneratedColumn<String> effectiveReleaseDate =
      GeneratedColumn<String>('effective_release_date', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notifyNewSeasonsMeta =
      const VerificationMeta('notifyNewSeasons');
  @override
  late final GeneratedColumn<bool> notifyNewSeasons = GeneratedColumn<bool>(
      'notify_new_seasons', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notify_new_seasons" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _imagesJsonMeta =
      const VerificationMeta('imagesJson');
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
      'images_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _videosJsonMeta =
      const VerificationMeta('videosJson');
  @override
  late final GeneratedColumn<String> videosJson = GeneratedColumn<String>(
      'videos_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recommendationsJsonMeta =
      const VerificationMeta('recommendationsJson');
  @override
  late final GeneratedColumn<String> recommendationsJson =
      GeneratedColumn<String>('recommendations_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextEpisodeToAirJsonMeta =
      const VerificationMeta('nextEpisodeToAirJson');
  @override
  late final GeneratedColumn<String> nextEpisodeToAirJson =
      GeneratedColumn<String>('next_episode_to_air_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastEpisodeToAirJsonMeta =
      const VerificationMeta('lastEpisodeToAirJson');
  @override
  late final GeneratedColumn<String> lastEpisodeToAirJson =
      GeneratedColumn<String>('last_episode_to_air_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _providersJsonMeta =
      const VerificationMeta('providersJson');
  @override
  late final GeneratedColumn<String> providersJson = GeneratedColumn<String>(
      'providers_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditsJsonMeta =
      const VerificationMeta('creditsJson');
  @override
  late final GeneratedColumn<String> creditsJson = GeneratedColumn<String>(
      'credits_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _seasonsJsonMeta =
      const VerificationMeta('seasonsJson');
  @override
  late final GeneratedColumn<String> seasonsJson = GeneratedColumn<String>(
      'seasons_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> genreIds =
      GeneratedColumn<String>('genre_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<int>>($TmdbTitlesTable.$convertergenreIds);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> keywordIds =
      GeneratedColumn<String>('keyword_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<int>>($TmdbTitlesTable.$converterkeywordIds);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String>
      flatrateProviderIds = GeneratedColumn<String>(
              'flatrate_provider_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<int>>(
              $TmdbTitlesTable.$converterflatrateProviderIds);
  static const VerificationMeta _lastNotifiedSeasonMeta =
      const VerificationMeta('lastNotifiedSeason');
  @override
  late final GeneratedColumn<int> lastNotifiedSeason = GeneratedColumn<int>(
      'last_notified_season', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _characterMeta =
      const VerificationMeta('character');
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
      'character', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jobMeta = const VerificationMeta('job');
  @override
  late final GeneratedColumn<String> job = GeneratedColumn<String>(
      'job', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _departmentMeta =
      const VerificationMeta('department');
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
      'department', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tmdbId,
        name,
        originalName,
        originalLanguage,
        overview,
        tagline,
        status,
        mediaType,
        imdbId,
        homepage,
        certification,
        type,
        posterPathSuffix,
        backdropPathSuffix,
        releaseDate,
        firstAirDate,
        lastAirDate,
        lastUpdated,
        externalIdsJson,
        voteAverage,
        voteCount,
        rating,
        dateRated,
        runtime,
        numberOfEpisodes,
        numberOfSeasons,
        popularity,
        budget,
        revenue,
        effectiveRuntime,
        effectiveReleaseDate,
        isPinned,
        notifyNewSeasons,
        imagesJson,
        videosJson,
        recommendationsJson,
        nextEpisodeToAirJson,
        lastEpisodeToAirJson,
        providersJson,
        creditsJson,
        seasonsJson,
        genreIds,
        keywordIds,
        flatrateProviderIds,
        lastNotifiedSeason,
        character,
        job,
        department
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tmdb_titles';
  @override
  VerificationContext validateIntegrity(Insertable<TmdbTitleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
          _originalNameMeta,
          originalName.isAcceptableOrUnknown(
              data['original_name']!, _originalNameMeta));
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('original_language')) {
      context.handle(
          _originalLanguageMeta,
          originalLanguage.isAcceptableOrUnknown(
              data['original_language']!, _originalLanguageMeta));
    } else if (isInserting) {
      context.missing(_originalLanguageMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('tagline')) {
      context.handle(_taglineMeta,
          tagline.isAcceptableOrUnknown(data['tagline']!, _taglineMeta));
    } else if (isInserting) {
      context.missing(_taglineMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(_mediaTypeMeta,
          mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta));
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('imdb_id')) {
      context.handle(_imdbIdMeta,
          imdbId.isAcceptableOrUnknown(data['imdb_id']!, _imdbIdMeta));
    } else if (isInserting) {
      context.missing(_imdbIdMeta);
    }
    if (data.containsKey('homepage')) {
      context.handle(_homepageMeta,
          homepage.isAcceptableOrUnknown(data['homepage']!, _homepageMeta));
    } else if (isInserting) {
      context.missing(_homepageMeta);
    }
    if (data.containsKey('certification')) {
      context.handle(
          _certificationMeta,
          certification.isAcceptableOrUnknown(
              data['certification']!, _certificationMeta));
    } else if (isInserting) {
      context.missing(_certificationMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('poster_path_suffix')) {
      context.handle(
          _posterPathSuffixMeta,
          posterPathSuffix.isAcceptableOrUnknown(
              data['poster_path_suffix']!, _posterPathSuffixMeta));
    }
    if (data.containsKey('backdrop_path_suffix')) {
      context.handle(
          _backdropPathSuffixMeta,
          backdropPathSuffix.isAcceptableOrUnknown(
              data['backdrop_path_suffix']!, _backdropPathSuffixMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    } else if (isInserting) {
      context.missing(_releaseDateMeta);
    }
    if (data.containsKey('first_air_date')) {
      context.handle(
          _firstAirDateMeta,
          firstAirDate.isAcceptableOrUnknown(
              data['first_air_date']!, _firstAirDateMeta));
    } else if (isInserting) {
      context.missing(_firstAirDateMeta);
    }
    if (data.containsKey('last_air_date')) {
      context.handle(
          _lastAirDateMeta,
          lastAirDate.isAcceptableOrUnknown(
              data['last_air_date']!, _lastAirDateMeta));
    } else if (isInserting) {
      context.missing(_lastAirDateMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('external_ids_json')) {
      context.handle(
          _externalIdsJsonMeta,
          externalIdsJson.isAcceptableOrUnknown(
              data['external_ids_json']!, _externalIdsJsonMeta));
    }
    if (data.containsKey('vote_average')) {
      context.handle(
          _voteAverageMeta,
          voteAverage.isAcceptableOrUnknown(
              data['vote_average']!, _voteAverageMeta));
    } else if (isInserting) {
      context.missing(_voteAverageMeta);
    }
    if (data.containsKey('vote_count')) {
      context.handle(_voteCountMeta,
          voteCount.isAcceptableOrUnknown(data['vote_count']!, _voteCountMeta));
    } else if (isInserting) {
      context.missing(_voteCountMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('date_rated')) {
      context.handle(_dateRatedMeta,
          dateRated.isAcceptableOrUnknown(data['date_rated']!, _dateRatedMeta));
    } else if (isInserting) {
      context.missing(_dateRatedMeta);
    }
    if (data.containsKey('runtime')) {
      context.handle(_runtimeMeta,
          runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta));
    } else if (isInserting) {
      context.missing(_runtimeMeta);
    }
    if (data.containsKey('number_of_episodes')) {
      context.handle(
          _numberOfEpisodesMeta,
          numberOfEpisodes.isAcceptableOrUnknown(
              data['number_of_episodes']!, _numberOfEpisodesMeta));
    } else if (isInserting) {
      context.missing(_numberOfEpisodesMeta);
    }
    if (data.containsKey('number_of_seasons')) {
      context.handle(
          _numberOfSeasonsMeta,
          numberOfSeasons.isAcceptableOrUnknown(
              data['number_of_seasons']!, _numberOfSeasonsMeta));
    } else if (isInserting) {
      context.missing(_numberOfSeasonsMeta);
    }
    if (data.containsKey('popularity')) {
      context.handle(
          _popularityMeta,
          popularity.isAcceptableOrUnknown(
              data['popularity']!, _popularityMeta));
    } else if (isInserting) {
      context.missing(_popularityMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('revenue')) {
      context.handle(_revenueMeta,
          revenue.isAcceptableOrUnknown(data['revenue']!, _revenueMeta));
    } else if (isInserting) {
      context.missing(_revenueMeta);
    }
    if (data.containsKey('effective_runtime')) {
      context.handle(
          _effectiveRuntimeMeta,
          effectiveRuntime.isAcceptableOrUnknown(
              data['effective_runtime']!, _effectiveRuntimeMeta));
    } else if (isInserting) {
      context.missing(_effectiveRuntimeMeta);
    }
    if (data.containsKey('effective_release_date')) {
      context.handle(
          _effectiveReleaseDateMeta,
          effectiveReleaseDate.isAcceptableOrUnknown(
              data['effective_release_date']!, _effectiveReleaseDateMeta));
    } else if (isInserting) {
      context.missing(_effectiveReleaseDateMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('notify_new_seasons')) {
      context.handle(
          _notifyNewSeasonsMeta,
          notifyNewSeasons.isAcceptableOrUnknown(
              data['notify_new_seasons']!, _notifyNewSeasonsMeta));
    }
    if (data.containsKey('images_json')) {
      context.handle(
          _imagesJsonMeta,
          imagesJson.isAcceptableOrUnknown(
              data['images_json']!, _imagesJsonMeta));
    }
    if (data.containsKey('videos_json')) {
      context.handle(
          _videosJsonMeta,
          videosJson.isAcceptableOrUnknown(
              data['videos_json']!, _videosJsonMeta));
    }
    if (data.containsKey('recommendations_json')) {
      context.handle(
          _recommendationsJsonMeta,
          recommendationsJson.isAcceptableOrUnknown(
              data['recommendations_json']!, _recommendationsJsonMeta));
    }
    if (data.containsKey('next_episode_to_air_json')) {
      context.handle(
          _nextEpisodeToAirJsonMeta,
          nextEpisodeToAirJson.isAcceptableOrUnknown(
              data['next_episode_to_air_json']!, _nextEpisodeToAirJsonMeta));
    }
    if (data.containsKey('last_episode_to_air_json')) {
      context.handle(
          _lastEpisodeToAirJsonMeta,
          lastEpisodeToAirJson.isAcceptableOrUnknown(
              data['last_episode_to_air_json']!, _lastEpisodeToAirJsonMeta));
    }
    if (data.containsKey('providers_json')) {
      context.handle(
          _providersJsonMeta,
          providersJson.isAcceptableOrUnknown(
              data['providers_json']!, _providersJsonMeta));
    }
    if (data.containsKey('credits_json')) {
      context.handle(
          _creditsJsonMeta,
          creditsJson.isAcceptableOrUnknown(
              data['credits_json']!, _creditsJsonMeta));
    }
    if (data.containsKey('seasons_json')) {
      context.handle(
          _seasonsJsonMeta,
          seasonsJson.isAcceptableOrUnknown(
              data['seasons_json']!, _seasonsJsonMeta));
    }
    if (data.containsKey('last_notified_season')) {
      context.handle(
          _lastNotifiedSeasonMeta,
          lastNotifiedSeason.isAcceptableOrUnknown(
              data['last_notified_season']!, _lastNotifiedSeasonMeta));
    }
    if (data.containsKey('character')) {
      context.handle(_characterMeta,
          character.isAcceptableOrUnknown(data['character']!, _characterMeta));
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('job')) {
      context.handle(
          _jobMeta, job.isAcceptableOrUnknown(data['job']!, _jobMeta));
    } else if (isInserting) {
      context.missing(_jobMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
          _departmentMeta,
          department.isAcceptableOrUnknown(
              data['department']!, _departmentMeta));
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TmdbTitleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TmdbTitleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      originalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_name'])!,
      originalLanguage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}original_language'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview'])!,
      tagline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tagline'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      mediaType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_type'])!,
      imdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imdb_id'])!,
      homepage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}homepage'])!,
      certification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}certification'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      posterPathSuffix: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}poster_path_suffix']),
      backdropPathSuffix: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}backdrop_path_suffix']),
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}release_date'])!,
      firstAirDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_air_date'])!,
      lastAirDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_air_date'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated'])!,
      externalIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_ids_json']),
      voteAverage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vote_average'])!,
      voteCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vote_count'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating'])!,
      dateRated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_rated'])!,
      runtime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}runtime'])!,
      numberOfEpisodes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}number_of_episodes'])!,
      numberOfSeasons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_of_seasons'])!,
      popularity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}popularity'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget'])!,
      revenue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revenue'])!,
      effectiveRuntime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}effective_runtime'])!,
      effectiveReleaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effective_release_date'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      notifyNewSeasons: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notify_new_seasons'])!,
      imagesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images_json']),
      videosJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}videos_json']),
      recommendationsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recommendations_json']),
      nextEpisodeToAirJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}next_episode_to_air_json']),
      lastEpisodeToAirJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_episode_to_air_json']),
      providersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}providers_json']),
      creditsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}credits_json']),
      seasonsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}seasons_json']),
      genreIds: $TmdbTitlesTable.$convertergenreIds.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre_ids'])!),
      keywordIds: $TmdbTitlesTable.$converterkeywordIds.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keyword_ids'])!),
      flatrateProviderIds: $TmdbTitlesTable.$converterflatrateProviderIds
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}flatrate_provider_ids'])!),
      lastNotifiedSeason: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_notified_season'])!,
      character: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character'])!,
      job: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job'])!,
      department: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department'])!,
    );
  }

  @override
  $TmdbTitlesTable createAlias(String alias) {
    return $TmdbTitlesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<int>, String> $convertergenreIds =
      const IntListConverter();
  static TypeConverter<List<int>, String> $converterkeywordIds =
      const IntListConverter();
  static TypeConverter<List<int>, String> $converterflatrateProviderIds =
      const IntListConverter();
}

class TmdbTitleData extends DataClass implements Insertable<TmdbTitleData> {
  final String id;
  final int tmdbId;
  final String name;
  final String originalName;
  final String originalLanguage;
  final String overview;
  final String tagline;
  final String status;
  final String mediaType;
  final String imdbId;
  final String homepage;
  final String certification;
  final String type;
  final String? posterPathSuffix;
  final String? backdropPathSuffix;
  final String releaseDate;
  final String firstAirDate;
  final String lastAirDate;
  final String lastUpdated;
  final String? externalIdsJson;
  final double voteAverage;
  final int voteCount;
  final double rating;
  final DateTime dateRated;
  final int runtime;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double popularity;
  final int budget;
  final int revenue;
  final int effectiveRuntime;
  final String effectiveReleaseDate;
  final bool isPinned;
  final bool notifyNewSeasons;
  final String? imagesJson;
  final String? videosJson;
  final String? recommendationsJson;
  final String? nextEpisodeToAirJson;
  final String? lastEpisodeToAirJson;
  final String? providersJson;
  final String? creditsJson;
  final String? seasonsJson;
  final List<int> genreIds;
  final List<int> keywordIds;
  final List<int> flatrateProviderIds;
  final int lastNotifiedSeason;
  final String character;
  final String job;
  final String department;
  const TmdbTitleData(
      {required this.id,
      required this.tmdbId,
      required this.name,
      required this.originalName,
      required this.originalLanguage,
      required this.overview,
      required this.tagline,
      required this.status,
      required this.mediaType,
      required this.imdbId,
      required this.homepage,
      required this.certification,
      required this.type,
      this.posterPathSuffix,
      this.backdropPathSuffix,
      required this.releaseDate,
      required this.firstAirDate,
      required this.lastAirDate,
      required this.lastUpdated,
      this.externalIdsJson,
      required this.voteAverage,
      required this.voteCount,
      required this.rating,
      required this.dateRated,
      required this.runtime,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.popularity,
      required this.budget,
      required this.revenue,
      required this.effectiveRuntime,
      required this.effectiveReleaseDate,
      required this.isPinned,
      required this.notifyNewSeasons,
      this.imagesJson,
      this.videosJson,
      this.recommendationsJson,
      this.nextEpisodeToAirJson,
      this.lastEpisodeToAirJson,
      this.providersJson,
      this.creditsJson,
      this.seasonsJson,
      required this.genreIds,
      required this.keywordIds,
      required this.flatrateProviderIds,
      required this.lastNotifiedSeason,
      required this.character,
      required this.job,
      required this.department});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['name'] = Variable<String>(name);
    map['original_name'] = Variable<String>(originalName);
    map['original_language'] = Variable<String>(originalLanguage);
    map['overview'] = Variable<String>(overview);
    map['tagline'] = Variable<String>(tagline);
    map['status'] = Variable<String>(status);
    map['media_type'] = Variable<String>(mediaType);
    map['imdb_id'] = Variable<String>(imdbId);
    map['homepage'] = Variable<String>(homepage);
    map['certification'] = Variable<String>(certification);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || posterPathSuffix != null) {
      map['poster_path_suffix'] = Variable<String>(posterPathSuffix);
    }
    if (!nullToAbsent || backdropPathSuffix != null) {
      map['backdrop_path_suffix'] = Variable<String>(backdropPathSuffix);
    }
    map['release_date'] = Variable<String>(releaseDate);
    map['first_air_date'] = Variable<String>(firstAirDate);
    map['last_air_date'] = Variable<String>(lastAirDate);
    map['last_updated'] = Variable<String>(lastUpdated);
    if (!nullToAbsent || externalIdsJson != null) {
      map['external_ids_json'] = Variable<String>(externalIdsJson);
    }
    map['vote_average'] = Variable<double>(voteAverage);
    map['vote_count'] = Variable<int>(voteCount);
    map['rating'] = Variable<double>(rating);
    map['date_rated'] = Variable<DateTime>(dateRated);
    map['runtime'] = Variable<int>(runtime);
    map['number_of_episodes'] = Variable<int>(numberOfEpisodes);
    map['number_of_seasons'] = Variable<int>(numberOfSeasons);
    map['popularity'] = Variable<double>(popularity);
    map['budget'] = Variable<int>(budget);
    map['revenue'] = Variable<int>(revenue);
    map['effective_runtime'] = Variable<int>(effectiveRuntime);
    map['effective_release_date'] = Variable<String>(effectiveReleaseDate);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['notify_new_seasons'] = Variable<bool>(notifyNewSeasons);
    if (!nullToAbsent || imagesJson != null) {
      map['images_json'] = Variable<String>(imagesJson);
    }
    if (!nullToAbsent || videosJson != null) {
      map['videos_json'] = Variable<String>(videosJson);
    }
    if (!nullToAbsent || recommendationsJson != null) {
      map['recommendations_json'] = Variable<String>(recommendationsJson);
    }
    if (!nullToAbsent || nextEpisodeToAirJson != null) {
      map['next_episode_to_air_json'] = Variable<String>(nextEpisodeToAirJson);
    }
    if (!nullToAbsent || lastEpisodeToAirJson != null) {
      map['last_episode_to_air_json'] = Variable<String>(lastEpisodeToAirJson);
    }
    if (!nullToAbsent || providersJson != null) {
      map['providers_json'] = Variable<String>(providersJson);
    }
    if (!nullToAbsent || creditsJson != null) {
      map['credits_json'] = Variable<String>(creditsJson);
    }
    if (!nullToAbsent || seasonsJson != null) {
      map['seasons_json'] = Variable<String>(seasonsJson);
    }
    {
      map['genre_ids'] =
          Variable<String>($TmdbTitlesTable.$convertergenreIds.toSql(genreIds));
    }
    {
      map['keyword_ids'] = Variable<String>(
          $TmdbTitlesTable.$converterkeywordIds.toSql(keywordIds));
    }
    {
      map['flatrate_provider_ids'] = Variable<String>($TmdbTitlesTable
          .$converterflatrateProviderIds
          .toSql(flatrateProviderIds));
    }
    map['last_notified_season'] = Variable<int>(lastNotifiedSeason);
    map['character'] = Variable<String>(character);
    map['job'] = Variable<String>(job);
    map['department'] = Variable<String>(department);
    return map;
  }

  TmdbTitlesCompanion toCompanion(bool nullToAbsent) {
    return TmdbTitlesCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      name: Value(name),
      originalName: Value(originalName),
      originalLanguage: Value(originalLanguage),
      overview: Value(overview),
      tagline: Value(tagline),
      status: Value(status),
      mediaType: Value(mediaType),
      imdbId: Value(imdbId),
      homepage: Value(homepage),
      certification: Value(certification),
      type: Value(type),
      posterPathSuffix: posterPathSuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPathSuffix),
      backdropPathSuffix: backdropPathSuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropPathSuffix),
      releaseDate: Value(releaseDate),
      firstAirDate: Value(firstAirDate),
      lastAirDate: Value(lastAirDate),
      lastUpdated: Value(lastUpdated),
      externalIdsJson: externalIdsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(externalIdsJson),
      voteAverage: Value(voteAverage),
      voteCount: Value(voteCount),
      rating: Value(rating),
      dateRated: Value(dateRated),
      runtime: Value(runtime),
      numberOfEpisodes: Value(numberOfEpisodes),
      numberOfSeasons: Value(numberOfSeasons),
      popularity: Value(popularity),
      budget: Value(budget),
      revenue: Value(revenue),
      effectiveRuntime: Value(effectiveRuntime),
      effectiveReleaseDate: Value(effectiveReleaseDate),
      isPinned: Value(isPinned),
      notifyNewSeasons: Value(notifyNewSeasons),
      imagesJson: imagesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(imagesJson),
      videosJson: videosJson == null && nullToAbsent
          ? const Value.absent()
          : Value(videosJson),
      recommendationsJson: recommendationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendationsJson),
      nextEpisodeToAirJson: nextEpisodeToAirJson == null && nullToAbsent
          ? const Value.absent()
          : Value(nextEpisodeToAirJson),
      lastEpisodeToAirJson: lastEpisodeToAirJson == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEpisodeToAirJson),
      providersJson: providersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(providersJson),
      creditsJson: creditsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(creditsJson),
      seasonsJson: seasonsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonsJson),
      genreIds: Value(genreIds),
      keywordIds: Value(keywordIds),
      flatrateProviderIds: Value(flatrateProviderIds),
      lastNotifiedSeason: Value(lastNotifiedSeason),
      character: Value(character),
      job: Value(job),
      department: Value(department),
    );
  }

  factory TmdbTitleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TmdbTitleData(
      id: serializer.fromJson<String>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      name: serializer.fromJson<String>(json['name']),
      originalName: serializer.fromJson<String>(json['originalName']),
      originalLanguage: serializer.fromJson<String>(json['originalLanguage']),
      overview: serializer.fromJson<String>(json['overview']),
      tagline: serializer.fromJson<String>(json['tagline']),
      status: serializer.fromJson<String>(json['status']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      imdbId: serializer.fromJson<String>(json['imdbId']),
      homepage: serializer.fromJson<String>(json['homepage']),
      certification: serializer.fromJson<String>(json['certification']),
      type: serializer.fromJson<String>(json['type']),
      posterPathSuffix: serializer.fromJson<String?>(json['posterPathSuffix']),
      backdropPathSuffix:
          serializer.fromJson<String?>(json['backdropPathSuffix']),
      releaseDate: serializer.fromJson<String>(json['releaseDate']),
      firstAirDate: serializer.fromJson<String>(json['firstAirDate']),
      lastAirDate: serializer.fromJson<String>(json['lastAirDate']),
      lastUpdated: serializer.fromJson<String>(json['lastUpdated']),
      externalIdsJson: serializer.fromJson<String?>(json['externalIdsJson']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      voteCount: serializer.fromJson<int>(json['voteCount']),
      rating: serializer.fromJson<double>(json['rating']),
      dateRated: serializer.fromJson<DateTime>(json['dateRated']),
      runtime: serializer.fromJson<int>(json['runtime']),
      numberOfEpisodes: serializer.fromJson<int>(json['numberOfEpisodes']),
      numberOfSeasons: serializer.fromJson<int>(json['numberOfSeasons']),
      popularity: serializer.fromJson<double>(json['popularity']),
      budget: serializer.fromJson<int>(json['budget']),
      revenue: serializer.fromJson<int>(json['revenue']),
      effectiveRuntime: serializer.fromJson<int>(json['effectiveRuntime']),
      effectiveReleaseDate:
          serializer.fromJson<String>(json['effectiveReleaseDate']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      notifyNewSeasons: serializer.fromJson<bool>(json['notifyNewSeasons']),
      imagesJson: serializer.fromJson<String?>(json['imagesJson']),
      videosJson: serializer.fromJson<String?>(json['videosJson']),
      recommendationsJson:
          serializer.fromJson<String?>(json['recommendationsJson']),
      nextEpisodeToAirJson:
          serializer.fromJson<String?>(json['nextEpisodeToAirJson']),
      lastEpisodeToAirJson:
          serializer.fromJson<String?>(json['lastEpisodeToAirJson']),
      providersJson: serializer.fromJson<String?>(json['providersJson']),
      creditsJson: serializer.fromJson<String?>(json['creditsJson']),
      seasonsJson: serializer.fromJson<String?>(json['seasonsJson']),
      genreIds: serializer.fromJson<List<int>>(json['genreIds']),
      keywordIds: serializer.fromJson<List<int>>(json['keywordIds']),
      flatrateProviderIds:
          serializer.fromJson<List<int>>(json['flatrateProviderIds']),
      lastNotifiedSeason: serializer.fromJson<int>(json['lastNotifiedSeason']),
      character: serializer.fromJson<String>(json['character']),
      job: serializer.fromJson<String>(json['job']),
      department: serializer.fromJson<String>(json['department']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'name': serializer.toJson<String>(name),
      'originalName': serializer.toJson<String>(originalName),
      'originalLanguage': serializer.toJson<String>(originalLanguage),
      'overview': serializer.toJson<String>(overview),
      'tagline': serializer.toJson<String>(tagline),
      'status': serializer.toJson<String>(status),
      'mediaType': serializer.toJson<String>(mediaType),
      'imdbId': serializer.toJson<String>(imdbId),
      'homepage': serializer.toJson<String>(homepage),
      'certification': serializer.toJson<String>(certification),
      'type': serializer.toJson<String>(type),
      'posterPathSuffix': serializer.toJson<String?>(posterPathSuffix),
      'backdropPathSuffix': serializer.toJson<String?>(backdropPathSuffix),
      'releaseDate': serializer.toJson<String>(releaseDate),
      'firstAirDate': serializer.toJson<String>(firstAirDate),
      'lastAirDate': serializer.toJson<String>(lastAirDate),
      'lastUpdated': serializer.toJson<String>(lastUpdated),
      'externalIdsJson': serializer.toJson<String?>(externalIdsJson),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'voteCount': serializer.toJson<int>(voteCount),
      'rating': serializer.toJson<double>(rating),
      'dateRated': serializer.toJson<DateTime>(dateRated),
      'runtime': serializer.toJson<int>(runtime),
      'numberOfEpisodes': serializer.toJson<int>(numberOfEpisodes),
      'numberOfSeasons': serializer.toJson<int>(numberOfSeasons),
      'popularity': serializer.toJson<double>(popularity),
      'budget': serializer.toJson<int>(budget),
      'revenue': serializer.toJson<int>(revenue),
      'effectiveRuntime': serializer.toJson<int>(effectiveRuntime),
      'effectiveReleaseDate': serializer.toJson<String>(effectiveReleaseDate),
      'isPinned': serializer.toJson<bool>(isPinned),
      'notifyNewSeasons': serializer.toJson<bool>(notifyNewSeasons),
      'imagesJson': serializer.toJson<String?>(imagesJson),
      'videosJson': serializer.toJson<String?>(videosJson),
      'recommendationsJson': serializer.toJson<String?>(recommendationsJson),
      'nextEpisodeToAirJson': serializer.toJson<String?>(nextEpisodeToAirJson),
      'lastEpisodeToAirJson': serializer.toJson<String?>(lastEpisodeToAirJson),
      'providersJson': serializer.toJson<String?>(providersJson),
      'creditsJson': serializer.toJson<String?>(creditsJson),
      'seasonsJson': serializer.toJson<String?>(seasonsJson),
      'genreIds': serializer.toJson<List<int>>(genreIds),
      'keywordIds': serializer.toJson<List<int>>(keywordIds),
      'flatrateProviderIds': serializer.toJson<List<int>>(flatrateProviderIds),
      'lastNotifiedSeason': serializer.toJson<int>(lastNotifiedSeason),
      'character': serializer.toJson<String>(character),
      'job': serializer.toJson<String>(job),
      'department': serializer.toJson<String>(department),
    };
  }

  TmdbTitleData copyWith(
          {String? id,
          int? tmdbId,
          String? name,
          String? originalName,
          String? originalLanguage,
          String? overview,
          String? tagline,
          String? status,
          String? mediaType,
          String? imdbId,
          String? homepage,
          String? certification,
          String? type,
          Value<String?> posterPathSuffix = const Value.absent(),
          Value<String?> backdropPathSuffix = const Value.absent(),
          String? releaseDate,
          String? firstAirDate,
          String? lastAirDate,
          String? lastUpdated,
          Value<String?> externalIdsJson = const Value.absent(),
          double? voteAverage,
          int? voteCount,
          double? rating,
          DateTime? dateRated,
          int? runtime,
          int? numberOfEpisodes,
          int? numberOfSeasons,
          double? popularity,
          int? budget,
          int? revenue,
          int? effectiveRuntime,
          String? effectiveReleaseDate,
          bool? isPinned,
          bool? notifyNewSeasons,
          Value<String?> imagesJson = const Value.absent(),
          Value<String?> videosJson = const Value.absent(),
          Value<String?> recommendationsJson = const Value.absent(),
          Value<String?> nextEpisodeToAirJson = const Value.absent(),
          Value<String?> lastEpisodeToAirJson = const Value.absent(),
          Value<String?> providersJson = const Value.absent(),
          Value<String?> creditsJson = const Value.absent(),
          Value<String?> seasonsJson = const Value.absent(),
          List<int>? genreIds,
          List<int>? keywordIds,
          List<int>? flatrateProviderIds,
          int? lastNotifiedSeason,
          String? character,
          String? job,
          String? department}) =>
      TmdbTitleData(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        name: name ?? this.name,
        originalName: originalName ?? this.originalName,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        overview: overview ?? this.overview,
        tagline: tagline ?? this.tagline,
        status: status ?? this.status,
        mediaType: mediaType ?? this.mediaType,
        imdbId: imdbId ?? this.imdbId,
        homepage: homepage ?? this.homepage,
        certification: certification ?? this.certification,
        type: type ?? this.type,
        posterPathSuffix: posterPathSuffix.present
            ? posterPathSuffix.value
            : this.posterPathSuffix,
        backdropPathSuffix: backdropPathSuffix.present
            ? backdropPathSuffix.value
            : this.backdropPathSuffix,
        releaseDate: releaseDate ?? this.releaseDate,
        firstAirDate: firstAirDate ?? this.firstAirDate,
        lastAirDate: lastAirDate ?? this.lastAirDate,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        externalIdsJson: externalIdsJson.present
            ? externalIdsJson.value
            : this.externalIdsJson,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
        rating: rating ?? this.rating,
        dateRated: dateRated ?? this.dateRated,
        runtime: runtime ?? this.runtime,
        numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
        numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
        popularity: popularity ?? this.popularity,
        budget: budget ?? this.budget,
        revenue: revenue ?? this.revenue,
        effectiveRuntime: effectiveRuntime ?? this.effectiveRuntime,
        effectiveReleaseDate: effectiveReleaseDate ?? this.effectiveReleaseDate,
        isPinned: isPinned ?? this.isPinned,
        notifyNewSeasons: notifyNewSeasons ?? this.notifyNewSeasons,
        imagesJson: imagesJson.present ? imagesJson.value : this.imagesJson,
        videosJson: videosJson.present ? videosJson.value : this.videosJson,
        recommendationsJson: recommendationsJson.present
            ? recommendationsJson.value
            : this.recommendationsJson,
        nextEpisodeToAirJson: nextEpisodeToAirJson.present
            ? nextEpisodeToAirJson.value
            : this.nextEpisodeToAirJson,
        lastEpisodeToAirJson: lastEpisodeToAirJson.present
            ? lastEpisodeToAirJson.value
            : this.lastEpisodeToAirJson,
        providersJson:
            providersJson.present ? providersJson.value : this.providersJson,
        creditsJson: creditsJson.present ? creditsJson.value : this.creditsJson,
        seasonsJson: seasonsJson.present ? seasonsJson.value : this.seasonsJson,
        genreIds: genreIds ?? this.genreIds,
        keywordIds: keywordIds ?? this.keywordIds,
        flatrateProviderIds: flatrateProviderIds ?? this.flatrateProviderIds,
        lastNotifiedSeason: lastNotifiedSeason ?? this.lastNotifiedSeason,
        character: character ?? this.character,
        job: job ?? this.job,
        department: department ?? this.department,
      );
  TmdbTitleData copyWithCompanion(TmdbTitlesCompanion data) {
    return TmdbTitleData(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      name: data.name.present ? data.name.value : this.name,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      originalLanguage: data.originalLanguage.present
          ? data.originalLanguage.value
          : this.originalLanguage,
      overview: data.overview.present ? data.overview.value : this.overview,
      tagline: data.tagline.present ? data.tagline.value : this.tagline,
      status: data.status.present ? data.status.value : this.status,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      imdbId: data.imdbId.present ? data.imdbId.value : this.imdbId,
      homepage: data.homepage.present ? data.homepage.value : this.homepage,
      certification: data.certification.present
          ? data.certification.value
          : this.certification,
      type: data.type.present ? data.type.value : this.type,
      posterPathSuffix: data.posterPathSuffix.present
          ? data.posterPathSuffix.value
          : this.posterPathSuffix,
      backdropPathSuffix: data.backdropPathSuffix.present
          ? data.backdropPathSuffix.value
          : this.backdropPathSuffix,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      firstAirDate: data.firstAirDate.present
          ? data.firstAirDate.value
          : this.firstAirDate,
      lastAirDate:
          data.lastAirDate.present ? data.lastAirDate.value : this.lastAirDate,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      externalIdsJson: data.externalIdsJson.present
          ? data.externalIdsJson.value
          : this.externalIdsJson,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      voteCount: data.voteCount.present ? data.voteCount.value : this.voteCount,
      rating: data.rating.present ? data.rating.value : this.rating,
      dateRated: data.dateRated.present ? data.dateRated.value : this.dateRated,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
      numberOfEpisodes: data.numberOfEpisodes.present
          ? data.numberOfEpisodes.value
          : this.numberOfEpisodes,
      numberOfSeasons: data.numberOfSeasons.present
          ? data.numberOfSeasons.value
          : this.numberOfSeasons,
      popularity:
          data.popularity.present ? data.popularity.value : this.popularity,
      budget: data.budget.present ? data.budget.value : this.budget,
      revenue: data.revenue.present ? data.revenue.value : this.revenue,
      effectiveRuntime: data.effectiveRuntime.present
          ? data.effectiveRuntime.value
          : this.effectiveRuntime,
      effectiveReleaseDate: data.effectiveReleaseDate.present
          ? data.effectiveReleaseDate.value
          : this.effectiveReleaseDate,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      notifyNewSeasons: data.notifyNewSeasons.present
          ? data.notifyNewSeasons.value
          : this.notifyNewSeasons,
      imagesJson:
          data.imagesJson.present ? data.imagesJson.value : this.imagesJson,
      videosJson:
          data.videosJson.present ? data.videosJson.value : this.videosJson,
      recommendationsJson: data.recommendationsJson.present
          ? data.recommendationsJson.value
          : this.recommendationsJson,
      nextEpisodeToAirJson: data.nextEpisodeToAirJson.present
          ? data.nextEpisodeToAirJson.value
          : this.nextEpisodeToAirJson,
      lastEpisodeToAirJson: data.lastEpisodeToAirJson.present
          ? data.lastEpisodeToAirJson.value
          : this.lastEpisodeToAirJson,
      providersJson: data.providersJson.present
          ? data.providersJson.value
          : this.providersJson,
      creditsJson:
          data.creditsJson.present ? data.creditsJson.value : this.creditsJson,
      seasonsJson:
          data.seasonsJson.present ? data.seasonsJson.value : this.seasonsJson,
      genreIds: data.genreIds.present ? data.genreIds.value : this.genreIds,
      keywordIds:
          data.keywordIds.present ? data.keywordIds.value : this.keywordIds,
      flatrateProviderIds: data.flatrateProviderIds.present
          ? data.flatrateProviderIds.value
          : this.flatrateProviderIds,
      lastNotifiedSeason: data.lastNotifiedSeason.present
          ? data.lastNotifiedSeason.value
          : this.lastNotifiedSeason,
      character: data.character.present ? data.character.value : this.character,
      job: data.job.present ? data.job.value : this.job,
      department:
          data.department.present ? data.department.value : this.department,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TmdbTitleData(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('overview: $overview, ')
          ..write('tagline: $tagline, ')
          ..write('status: $status, ')
          ..write('mediaType: $mediaType, ')
          ..write('imdbId: $imdbId, ')
          ..write('homepage: $homepage, ')
          ..write('certification: $certification, ')
          ..write('type: $type, ')
          ..write('posterPathSuffix: $posterPathSuffix, ')
          ..write('backdropPathSuffix: $backdropPathSuffix, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('lastAirDate: $lastAirDate, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('externalIdsJson: $externalIdsJson, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('rating: $rating, ')
          ..write('dateRated: $dateRated, ')
          ..write('runtime: $runtime, ')
          ..write('numberOfEpisodes: $numberOfEpisodes, ')
          ..write('numberOfSeasons: $numberOfSeasons, ')
          ..write('popularity: $popularity, ')
          ..write('budget: $budget, ')
          ..write('revenue: $revenue, ')
          ..write('effectiveRuntime: $effectiveRuntime, ')
          ..write('effectiveReleaseDate: $effectiveReleaseDate, ')
          ..write('isPinned: $isPinned, ')
          ..write('notifyNewSeasons: $notifyNewSeasons, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson, ')
          ..write('recommendationsJson: $recommendationsJson, ')
          ..write('nextEpisodeToAirJson: $nextEpisodeToAirJson, ')
          ..write('lastEpisodeToAirJson: $lastEpisodeToAirJson, ')
          ..write('providersJson: $providersJson, ')
          ..write('creditsJson: $creditsJson, ')
          ..write('seasonsJson: $seasonsJson, ')
          ..write('genreIds: $genreIds, ')
          ..write('keywordIds: $keywordIds, ')
          ..write('flatrateProviderIds: $flatrateProviderIds, ')
          ..write('lastNotifiedSeason: $lastNotifiedSeason, ')
          ..write('character: $character, ')
          ..write('job: $job, ')
          ..write('department: $department')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        tmdbId,
        name,
        originalName,
        originalLanguage,
        overview,
        tagline,
        status,
        mediaType,
        imdbId,
        homepage,
        certification,
        type,
        posterPathSuffix,
        backdropPathSuffix,
        releaseDate,
        firstAirDate,
        lastAirDate,
        lastUpdated,
        externalIdsJson,
        voteAverage,
        voteCount,
        rating,
        dateRated,
        runtime,
        numberOfEpisodes,
        numberOfSeasons,
        popularity,
        budget,
        revenue,
        effectiveRuntime,
        effectiveReleaseDate,
        isPinned,
        notifyNewSeasons,
        imagesJson,
        videosJson,
        recommendationsJson,
        nextEpisodeToAirJson,
        lastEpisodeToAirJson,
        providersJson,
        creditsJson,
        seasonsJson,
        genreIds,
        keywordIds,
        flatrateProviderIds,
        lastNotifiedSeason,
        character,
        job,
        department
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TmdbTitleData &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.name == this.name &&
          other.originalName == this.originalName &&
          other.originalLanguage == this.originalLanguage &&
          other.overview == this.overview &&
          other.tagline == this.tagline &&
          other.status == this.status &&
          other.mediaType == this.mediaType &&
          other.imdbId == this.imdbId &&
          other.homepage == this.homepage &&
          other.certification == this.certification &&
          other.type == this.type &&
          other.posterPathSuffix == this.posterPathSuffix &&
          other.backdropPathSuffix == this.backdropPathSuffix &&
          other.releaseDate == this.releaseDate &&
          other.firstAirDate == this.firstAirDate &&
          other.lastAirDate == this.lastAirDate &&
          other.lastUpdated == this.lastUpdated &&
          other.externalIdsJson == this.externalIdsJson &&
          other.voteAverage == this.voteAverage &&
          other.voteCount == this.voteCount &&
          other.rating == this.rating &&
          other.dateRated == this.dateRated &&
          other.runtime == this.runtime &&
          other.numberOfEpisodes == this.numberOfEpisodes &&
          other.numberOfSeasons == this.numberOfSeasons &&
          other.popularity == this.popularity &&
          other.budget == this.budget &&
          other.revenue == this.revenue &&
          other.effectiveRuntime == this.effectiveRuntime &&
          other.effectiveReleaseDate == this.effectiveReleaseDate &&
          other.isPinned == this.isPinned &&
          other.notifyNewSeasons == this.notifyNewSeasons &&
          other.imagesJson == this.imagesJson &&
          other.videosJson == this.videosJson &&
          other.recommendationsJson == this.recommendationsJson &&
          other.nextEpisodeToAirJson == this.nextEpisodeToAirJson &&
          other.lastEpisodeToAirJson == this.lastEpisodeToAirJson &&
          other.providersJson == this.providersJson &&
          other.creditsJson == this.creditsJson &&
          other.seasonsJson == this.seasonsJson &&
          other.genreIds == this.genreIds &&
          other.keywordIds == this.keywordIds &&
          other.flatrateProviderIds == this.flatrateProviderIds &&
          other.lastNotifiedSeason == this.lastNotifiedSeason &&
          other.character == this.character &&
          other.job == this.job &&
          other.department == this.department);
}

class TmdbTitlesCompanion extends UpdateCompanion<TmdbTitleData> {
  final Value<String> id;
  final Value<int> tmdbId;
  final Value<String> name;
  final Value<String> originalName;
  final Value<String> originalLanguage;
  final Value<String> overview;
  final Value<String> tagline;
  final Value<String> status;
  final Value<String> mediaType;
  final Value<String> imdbId;
  final Value<String> homepage;
  final Value<String> certification;
  final Value<String> type;
  final Value<String?> posterPathSuffix;
  final Value<String?> backdropPathSuffix;
  final Value<String> releaseDate;
  final Value<String> firstAirDate;
  final Value<String> lastAirDate;
  final Value<String> lastUpdated;
  final Value<String?> externalIdsJson;
  final Value<double> voteAverage;
  final Value<int> voteCount;
  final Value<double> rating;
  final Value<DateTime> dateRated;
  final Value<int> runtime;
  final Value<int> numberOfEpisodes;
  final Value<int> numberOfSeasons;
  final Value<double> popularity;
  final Value<int> budget;
  final Value<int> revenue;
  final Value<int> effectiveRuntime;
  final Value<String> effectiveReleaseDate;
  final Value<bool> isPinned;
  final Value<bool> notifyNewSeasons;
  final Value<String?> imagesJson;
  final Value<String?> videosJson;
  final Value<String?> recommendationsJson;
  final Value<String?> nextEpisodeToAirJson;
  final Value<String?> lastEpisodeToAirJson;
  final Value<String?> providersJson;
  final Value<String?> creditsJson;
  final Value<String?> seasonsJson;
  final Value<List<int>> genreIds;
  final Value<List<int>> keywordIds;
  final Value<List<int>> flatrateProviderIds;
  final Value<int> lastNotifiedSeason;
  final Value<String> character;
  final Value<String> job;
  final Value<String> department;
  final Value<int> rowid;
  const TmdbTitlesCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.name = const Value.absent(),
    this.originalName = const Value.absent(),
    this.originalLanguage = const Value.absent(),
    this.overview = const Value.absent(),
    this.tagline = const Value.absent(),
    this.status = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.imdbId = const Value.absent(),
    this.homepage = const Value.absent(),
    this.certification = const Value.absent(),
    this.type = const Value.absent(),
    this.posterPathSuffix = const Value.absent(),
    this.backdropPathSuffix = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.firstAirDate = const Value.absent(),
    this.lastAirDate = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.externalIdsJson = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.voteCount = const Value.absent(),
    this.rating = const Value.absent(),
    this.dateRated = const Value.absent(),
    this.runtime = const Value.absent(),
    this.numberOfEpisodes = const Value.absent(),
    this.numberOfSeasons = const Value.absent(),
    this.popularity = const Value.absent(),
    this.budget = const Value.absent(),
    this.revenue = const Value.absent(),
    this.effectiveRuntime = const Value.absent(),
    this.effectiveReleaseDate = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.notifyNewSeasons = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.recommendationsJson = const Value.absent(),
    this.nextEpisodeToAirJson = const Value.absent(),
    this.lastEpisodeToAirJson = const Value.absent(),
    this.providersJson = const Value.absent(),
    this.creditsJson = const Value.absent(),
    this.seasonsJson = const Value.absent(),
    this.genreIds = const Value.absent(),
    this.keywordIds = const Value.absent(),
    this.flatrateProviderIds = const Value.absent(),
    this.lastNotifiedSeason = const Value.absent(),
    this.character = const Value.absent(),
    this.job = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TmdbTitlesCompanion.insert({
    required String id,
    required int tmdbId,
    required String name,
    required String originalName,
    required String originalLanguage,
    required String overview,
    required String tagline,
    required String status,
    required String mediaType,
    required String imdbId,
    required String homepage,
    required String certification,
    required String type,
    this.posterPathSuffix = const Value.absent(),
    this.backdropPathSuffix = const Value.absent(),
    required String releaseDate,
    required String firstAirDate,
    required String lastAirDate,
    required String lastUpdated,
    this.externalIdsJson = const Value.absent(),
    required double voteAverage,
    required int voteCount,
    this.rating = const Value.absent(),
    required DateTime dateRated,
    required int runtime,
    required int numberOfEpisodes,
    required int numberOfSeasons,
    required double popularity,
    required int budget,
    required int revenue,
    required int effectiveRuntime,
    required String effectiveReleaseDate,
    this.isPinned = const Value.absent(),
    this.notifyNewSeasons = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.recommendationsJson = const Value.absent(),
    this.nextEpisodeToAirJson = const Value.absent(),
    this.lastEpisodeToAirJson = const Value.absent(),
    this.providersJson = const Value.absent(),
    this.creditsJson = const Value.absent(),
    this.seasonsJson = const Value.absent(),
    this.genreIds = const Value.absent(),
    this.keywordIds = const Value.absent(),
    this.flatrateProviderIds = const Value.absent(),
    this.lastNotifiedSeason = const Value.absent(),
    required String character,
    required String job,
    required String department,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tmdbId = Value(tmdbId),
        name = Value(name),
        originalName = Value(originalName),
        originalLanguage = Value(originalLanguage),
        overview = Value(overview),
        tagline = Value(tagline),
        status = Value(status),
        mediaType = Value(mediaType),
        imdbId = Value(imdbId),
        homepage = Value(homepage),
        certification = Value(certification),
        type = Value(type),
        releaseDate = Value(releaseDate),
        firstAirDate = Value(firstAirDate),
        lastAirDate = Value(lastAirDate),
        lastUpdated = Value(lastUpdated),
        voteAverage = Value(voteAverage),
        voteCount = Value(voteCount),
        dateRated = Value(dateRated),
        runtime = Value(runtime),
        numberOfEpisodes = Value(numberOfEpisodes),
        numberOfSeasons = Value(numberOfSeasons),
        popularity = Value(popularity),
        budget = Value(budget),
        revenue = Value(revenue),
        effectiveRuntime = Value(effectiveRuntime),
        effectiveReleaseDate = Value(effectiveReleaseDate),
        character = Value(character),
        job = Value(job),
        department = Value(department);
  static Insertable<TmdbTitleData> custom({
    Expression<String>? id,
    Expression<int>? tmdbId,
    Expression<String>? name,
    Expression<String>? originalName,
    Expression<String>? originalLanguage,
    Expression<String>? overview,
    Expression<String>? tagline,
    Expression<String>? status,
    Expression<String>? mediaType,
    Expression<String>? imdbId,
    Expression<String>? homepage,
    Expression<String>? certification,
    Expression<String>? type,
    Expression<String>? posterPathSuffix,
    Expression<String>? backdropPathSuffix,
    Expression<String>? releaseDate,
    Expression<String>? firstAirDate,
    Expression<String>? lastAirDate,
    Expression<String>? lastUpdated,
    Expression<String>? externalIdsJson,
    Expression<double>? voteAverage,
    Expression<int>? voteCount,
    Expression<double>? rating,
    Expression<DateTime>? dateRated,
    Expression<int>? runtime,
    Expression<int>? numberOfEpisodes,
    Expression<int>? numberOfSeasons,
    Expression<double>? popularity,
    Expression<int>? budget,
    Expression<int>? revenue,
    Expression<int>? effectiveRuntime,
    Expression<String>? effectiveReleaseDate,
    Expression<bool>? isPinned,
    Expression<bool>? notifyNewSeasons,
    Expression<String>? imagesJson,
    Expression<String>? videosJson,
    Expression<String>? recommendationsJson,
    Expression<String>? nextEpisodeToAirJson,
    Expression<String>? lastEpisodeToAirJson,
    Expression<String>? providersJson,
    Expression<String>? creditsJson,
    Expression<String>? seasonsJson,
    Expression<String>? genreIds,
    Expression<String>? keywordIds,
    Expression<String>? flatrateProviderIds,
    Expression<int>? lastNotifiedSeason,
    Expression<String>? character,
    Expression<String>? job,
    Expression<String>? department,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (name != null) 'name': name,
      if (originalName != null) 'original_name': originalName,
      if (originalLanguage != null) 'original_language': originalLanguage,
      if (overview != null) 'overview': overview,
      if (tagline != null) 'tagline': tagline,
      if (status != null) 'status': status,
      if (mediaType != null) 'media_type': mediaType,
      if (imdbId != null) 'imdb_id': imdbId,
      if (homepage != null) 'homepage': homepage,
      if (certification != null) 'certification': certification,
      if (type != null) 'type': type,
      if (posterPathSuffix != null) 'poster_path_suffix': posterPathSuffix,
      if (backdropPathSuffix != null)
        'backdrop_path_suffix': backdropPathSuffix,
      if (releaseDate != null) 'release_date': releaseDate,
      if (firstAirDate != null) 'first_air_date': firstAirDate,
      if (lastAirDate != null) 'last_air_date': lastAirDate,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (externalIdsJson != null) 'external_ids_json': externalIdsJson,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (voteCount != null) 'vote_count': voteCount,
      if (rating != null) 'rating': rating,
      if (dateRated != null) 'date_rated': dateRated,
      if (runtime != null) 'runtime': runtime,
      if (numberOfEpisodes != null) 'number_of_episodes': numberOfEpisodes,
      if (numberOfSeasons != null) 'number_of_seasons': numberOfSeasons,
      if (popularity != null) 'popularity': popularity,
      if (budget != null) 'budget': budget,
      if (revenue != null) 'revenue': revenue,
      if (effectiveRuntime != null) 'effective_runtime': effectiveRuntime,
      if (effectiveReleaseDate != null)
        'effective_release_date': effectiveReleaseDate,
      if (isPinned != null) 'is_pinned': isPinned,
      if (notifyNewSeasons != null) 'notify_new_seasons': notifyNewSeasons,
      if (imagesJson != null) 'images_json': imagesJson,
      if (videosJson != null) 'videos_json': videosJson,
      if (recommendationsJson != null)
        'recommendations_json': recommendationsJson,
      if (nextEpisodeToAirJson != null)
        'next_episode_to_air_json': nextEpisodeToAirJson,
      if (lastEpisodeToAirJson != null)
        'last_episode_to_air_json': lastEpisodeToAirJson,
      if (providersJson != null) 'providers_json': providersJson,
      if (creditsJson != null) 'credits_json': creditsJson,
      if (seasonsJson != null) 'seasons_json': seasonsJson,
      if (genreIds != null) 'genre_ids': genreIds,
      if (keywordIds != null) 'keyword_ids': keywordIds,
      if (flatrateProviderIds != null)
        'flatrate_provider_ids': flatrateProviderIds,
      if (lastNotifiedSeason != null)
        'last_notified_season': lastNotifiedSeason,
      if (character != null) 'character': character,
      if (job != null) 'job': job,
      if (department != null) 'department': department,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TmdbTitlesCompanion copyWith(
      {Value<String>? id,
      Value<int>? tmdbId,
      Value<String>? name,
      Value<String>? originalName,
      Value<String>? originalLanguage,
      Value<String>? overview,
      Value<String>? tagline,
      Value<String>? status,
      Value<String>? mediaType,
      Value<String>? imdbId,
      Value<String>? homepage,
      Value<String>? certification,
      Value<String>? type,
      Value<String?>? posterPathSuffix,
      Value<String?>? backdropPathSuffix,
      Value<String>? releaseDate,
      Value<String>? firstAirDate,
      Value<String>? lastAirDate,
      Value<String>? lastUpdated,
      Value<String?>? externalIdsJson,
      Value<double>? voteAverage,
      Value<int>? voteCount,
      Value<double>? rating,
      Value<DateTime>? dateRated,
      Value<int>? runtime,
      Value<int>? numberOfEpisodes,
      Value<int>? numberOfSeasons,
      Value<double>? popularity,
      Value<int>? budget,
      Value<int>? revenue,
      Value<int>? effectiveRuntime,
      Value<String>? effectiveReleaseDate,
      Value<bool>? isPinned,
      Value<bool>? notifyNewSeasons,
      Value<String?>? imagesJson,
      Value<String?>? videosJson,
      Value<String?>? recommendationsJson,
      Value<String?>? nextEpisodeToAirJson,
      Value<String?>? lastEpisodeToAirJson,
      Value<String?>? providersJson,
      Value<String?>? creditsJson,
      Value<String?>? seasonsJson,
      Value<List<int>>? genreIds,
      Value<List<int>>? keywordIds,
      Value<List<int>>? flatrateProviderIds,
      Value<int>? lastNotifiedSeason,
      Value<String>? character,
      Value<String>? job,
      Value<String>? department,
      Value<int>? rowid}) {
    return TmdbTitlesCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      overview: overview ?? this.overview,
      tagline: tagline ?? this.tagline,
      status: status ?? this.status,
      mediaType: mediaType ?? this.mediaType,
      imdbId: imdbId ?? this.imdbId,
      homepage: homepage ?? this.homepage,
      certification: certification ?? this.certification,
      type: type ?? this.type,
      posterPathSuffix: posterPathSuffix ?? this.posterPathSuffix,
      backdropPathSuffix: backdropPathSuffix ?? this.backdropPathSuffix,
      releaseDate: releaseDate ?? this.releaseDate,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      lastAirDate: lastAirDate ?? this.lastAirDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      externalIdsJson: externalIdsJson ?? this.externalIdsJson,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      rating: rating ?? this.rating,
      dateRated: dateRated ?? this.dateRated,
      runtime: runtime ?? this.runtime,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      popularity: popularity ?? this.popularity,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      effectiveRuntime: effectiveRuntime ?? this.effectiveRuntime,
      effectiveReleaseDate: effectiveReleaseDate ?? this.effectiveReleaseDate,
      isPinned: isPinned ?? this.isPinned,
      notifyNewSeasons: notifyNewSeasons ?? this.notifyNewSeasons,
      imagesJson: imagesJson ?? this.imagesJson,
      videosJson: videosJson ?? this.videosJson,
      recommendationsJson: recommendationsJson ?? this.recommendationsJson,
      nextEpisodeToAirJson: nextEpisodeToAirJson ?? this.nextEpisodeToAirJson,
      lastEpisodeToAirJson: lastEpisodeToAirJson ?? this.lastEpisodeToAirJson,
      providersJson: providersJson ?? this.providersJson,
      creditsJson: creditsJson ?? this.creditsJson,
      seasonsJson: seasonsJson ?? this.seasonsJson,
      genreIds: genreIds ?? this.genreIds,
      keywordIds: keywordIds ?? this.keywordIds,
      flatrateProviderIds: flatrateProviderIds ?? this.flatrateProviderIds,
      lastNotifiedSeason: lastNotifiedSeason ?? this.lastNotifiedSeason,
      character: character ?? this.character,
      job: job ?? this.job,
      department: department ?? this.department,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (originalLanguage.present) {
      map['original_language'] = Variable<String>(originalLanguage.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (tagline.present) {
      map['tagline'] = Variable<String>(tagline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (imdbId.present) {
      map['imdb_id'] = Variable<String>(imdbId.value);
    }
    if (homepage.present) {
      map['homepage'] = Variable<String>(homepage.value);
    }
    if (certification.present) {
      map['certification'] = Variable<String>(certification.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (posterPathSuffix.present) {
      map['poster_path_suffix'] = Variable<String>(posterPathSuffix.value);
    }
    if (backdropPathSuffix.present) {
      map['backdrop_path_suffix'] = Variable<String>(backdropPathSuffix.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (firstAirDate.present) {
      map['first_air_date'] = Variable<String>(firstAirDate.value);
    }
    if (lastAirDate.present) {
      map['last_air_date'] = Variable<String>(lastAirDate.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<String>(lastUpdated.value);
    }
    if (externalIdsJson.present) {
      map['external_ids_json'] = Variable<String>(externalIdsJson.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (voteCount.present) {
      map['vote_count'] = Variable<int>(voteCount.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (dateRated.present) {
      map['date_rated'] = Variable<DateTime>(dateRated.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<int>(runtime.value);
    }
    if (numberOfEpisodes.present) {
      map['number_of_episodes'] = Variable<int>(numberOfEpisodes.value);
    }
    if (numberOfSeasons.present) {
      map['number_of_seasons'] = Variable<int>(numberOfSeasons.value);
    }
    if (popularity.present) {
      map['popularity'] = Variable<double>(popularity.value);
    }
    if (budget.present) {
      map['budget'] = Variable<int>(budget.value);
    }
    if (revenue.present) {
      map['revenue'] = Variable<int>(revenue.value);
    }
    if (effectiveRuntime.present) {
      map['effective_runtime'] = Variable<int>(effectiveRuntime.value);
    }
    if (effectiveReleaseDate.present) {
      map['effective_release_date'] =
          Variable<String>(effectiveReleaseDate.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (notifyNewSeasons.present) {
      map['notify_new_seasons'] = Variable<bool>(notifyNewSeasons.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (videosJson.present) {
      map['videos_json'] = Variable<String>(videosJson.value);
    }
    if (recommendationsJson.present) {
      map['recommendations_json'] = Variable<String>(recommendationsJson.value);
    }
    if (nextEpisodeToAirJson.present) {
      map['next_episode_to_air_json'] =
          Variable<String>(nextEpisodeToAirJson.value);
    }
    if (lastEpisodeToAirJson.present) {
      map['last_episode_to_air_json'] =
          Variable<String>(lastEpisodeToAirJson.value);
    }
    if (providersJson.present) {
      map['providers_json'] = Variable<String>(providersJson.value);
    }
    if (creditsJson.present) {
      map['credits_json'] = Variable<String>(creditsJson.value);
    }
    if (seasonsJson.present) {
      map['seasons_json'] = Variable<String>(seasonsJson.value);
    }
    if (genreIds.present) {
      map['genre_ids'] = Variable<String>(
          $TmdbTitlesTable.$convertergenreIds.toSql(genreIds.value));
    }
    if (keywordIds.present) {
      map['keyword_ids'] = Variable<String>(
          $TmdbTitlesTable.$converterkeywordIds.toSql(keywordIds.value));
    }
    if (flatrateProviderIds.present) {
      map['flatrate_provider_ids'] = Variable<String>($TmdbTitlesTable
          .$converterflatrateProviderIds
          .toSql(flatrateProviderIds.value));
    }
    if (lastNotifiedSeason.present) {
      map['last_notified_season'] = Variable<int>(lastNotifiedSeason.value);
    }
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (job.present) {
      map['job'] = Variable<String>(job.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TmdbTitlesCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('name: $name, ')
          ..write('originalName: $originalName, ')
          ..write('originalLanguage: $originalLanguage, ')
          ..write('overview: $overview, ')
          ..write('tagline: $tagline, ')
          ..write('status: $status, ')
          ..write('mediaType: $mediaType, ')
          ..write('imdbId: $imdbId, ')
          ..write('homepage: $homepage, ')
          ..write('certification: $certification, ')
          ..write('type: $type, ')
          ..write('posterPathSuffix: $posterPathSuffix, ')
          ..write('backdropPathSuffix: $backdropPathSuffix, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('firstAirDate: $firstAirDate, ')
          ..write('lastAirDate: $lastAirDate, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('externalIdsJson: $externalIdsJson, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('voteCount: $voteCount, ')
          ..write('rating: $rating, ')
          ..write('dateRated: $dateRated, ')
          ..write('runtime: $runtime, ')
          ..write('numberOfEpisodes: $numberOfEpisodes, ')
          ..write('numberOfSeasons: $numberOfSeasons, ')
          ..write('popularity: $popularity, ')
          ..write('budget: $budget, ')
          ..write('revenue: $revenue, ')
          ..write('effectiveRuntime: $effectiveRuntime, ')
          ..write('effectiveReleaseDate: $effectiveReleaseDate, ')
          ..write('isPinned: $isPinned, ')
          ..write('notifyNewSeasons: $notifyNewSeasons, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson, ')
          ..write('recommendationsJson: $recommendationsJson, ')
          ..write('nextEpisodeToAirJson: $nextEpisodeToAirJson, ')
          ..write('lastEpisodeToAirJson: $lastEpisodeToAirJson, ')
          ..write('providersJson: $providersJson, ')
          ..write('creditsJson: $creditsJson, ')
          ..write('seasonsJson: $seasonsJson, ')
          ..write('genreIds: $genreIds, ')
          ..write('keywordIds: $keywordIds, ')
          ..write('flatrateProviderIds: $flatrateProviderIds, ')
          ..write('lastNotifiedSeason: $lastNotifiedSeason, ')
          ..write('character: $character, ')
          ..write('job: $job, ')
          ..write('department: $department, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TmdbSeasonsTable extends TmdbSeasons
    with TableInfo<$TmdbSeasonsTable, TmdbSeasonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TmdbSeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tvIdMeta = const VerificationMeta('tvId');
  @override
  late final GeneratedColumn<int> tvId = GeneratedColumn<int>(
      'tv_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _seasonNumberMeta =
      const VerificationMeta('seasonNumber');
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
      'season_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _airDateMeta =
      const VerificationMeta('airDate');
  @override
  late final GeneratedColumn<String> airDate = GeneratedColumn<String>(
      'air_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _posterPathSuffixMeta =
      const VerificationMeta('posterPathSuffix');
  @override
  late final GeneratedColumn<String> posterPathSuffix = GeneratedColumn<String>(
      'poster_path_suffix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<String> lastUpdated = GeneratedColumn<String>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voteAverageMeta =
      const VerificationMeta('voteAverage');
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
      'vote_average', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _imagesJsonMeta =
      const VerificationMeta('imagesJson');
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
      'images_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _videosJsonMeta =
      const VerificationMeta('videosJson');
  @override
  late final GeneratedColumn<String> videosJson = GeneratedColumn<String>(
      'videos_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditsJsonMeta =
      const VerificationMeta('creditsJson');
  @override
  late final GeneratedColumn<String> creditsJson = GeneratedColumn<String>(
      'credits_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _episodesJsonMeta =
      const VerificationMeta('episodesJson');
  @override
  late final GeneratedColumn<String> episodesJson = GeneratedColumn<String>(
      'episodes_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tvId,
        tmdbId,
        seasonNumber,
        name,
        overview,
        airDate,
        posterPathSuffix,
        lastUpdated,
        voteAverage,
        imagesJson,
        videosJson,
        creditsJson,
        episodesJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tmdb_seasons';
  @override
  VerificationContext validateIntegrity(Insertable<TmdbSeasonData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tv_id')) {
      context.handle(
          _tvIdMeta, tvId.isAcceptableOrUnknown(data['tv_id']!, _tvIdMeta));
    } else if (isInserting) {
      context.missing(_tvIdMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('season_number')) {
      context.handle(
          _seasonNumberMeta,
          seasonNumber.isAcceptableOrUnknown(
              data['season_number']!, _seasonNumberMeta));
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('air_date')) {
      context.handle(_airDateMeta,
          airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta));
    } else if (isInserting) {
      context.missing(_airDateMeta);
    }
    if (data.containsKey('poster_path_suffix')) {
      context.handle(
          _posterPathSuffixMeta,
          posterPathSuffix.isAcceptableOrUnknown(
              data['poster_path_suffix']!, _posterPathSuffixMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('vote_average')) {
      context.handle(
          _voteAverageMeta,
          voteAverage.isAcceptableOrUnknown(
              data['vote_average']!, _voteAverageMeta));
    } else if (isInserting) {
      context.missing(_voteAverageMeta);
    }
    if (data.containsKey('images_json')) {
      context.handle(
          _imagesJsonMeta,
          imagesJson.isAcceptableOrUnknown(
              data['images_json']!, _imagesJsonMeta));
    }
    if (data.containsKey('videos_json')) {
      context.handle(
          _videosJsonMeta,
          videosJson.isAcceptableOrUnknown(
              data['videos_json']!, _videosJsonMeta));
    }
    if (data.containsKey('credits_json')) {
      context.handle(
          _creditsJsonMeta,
          creditsJson.isAcceptableOrUnknown(
              data['credits_json']!, _creditsJsonMeta));
    }
    if (data.containsKey('episodes_json')) {
      context.handle(
          _episodesJsonMeta,
          episodesJson.isAcceptableOrUnknown(
              data['episodes_json']!, _episodesJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TmdbSeasonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TmdbSeasonData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tvId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      seasonNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview'])!,
      airDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_date'])!,
      posterPathSuffix: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}poster_path_suffix']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated'])!,
      voteAverage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vote_average'])!,
      imagesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images_json']),
      videosJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}videos_json']),
      creditsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}credits_json']),
      episodesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}episodes_json']),
    );
  }

  @override
  $TmdbSeasonsTable createAlias(String alias) {
    return $TmdbSeasonsTable(attachedDatabase, alias);
  }
}

class TmdbSeasonData extends DataClass implements Insertable<TmdbSeasonData> {
  final String id;
  final int tvId;
  final int tmdbId;
  final int seasonNumber;
  final String name;
  final String overview;
  final String airDate;
  final String? posterPathSuffix;
  final String lastUpdated;
  final double voteAverage;
  final String? imagesJson;
  final String? videosJson;
  final String? creditsJson;
  final String? episodesJson;
  const TmdbSeasonData(
      {required this.id,
      required this.tvId,
      required this.tmdbId,
      required this.seasonNumber,
      required this.name,
      required this.overview,
      required this.airDate,
      this.posterPathSuffix,
      required this.lastUpdated,
      required this.voteAverage,
      this.imagesJson,
      this.videosJson,
      this.creditsJson,
      this.episodesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tv_id'] = Variable<int>(tvId);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['season_number'] = Variable<int>(seasonNumber);
    map['name'] = Variable<String>(name);
    map['overview'] = Variable<String>(overview);
    map['air_date'] = Variable<String>(airDate);
    if (!nullToAbsent || posterPathSuffix != null) {
      map['poster_path_suffix'] = Variable<String>(posterPathSuffix);
    }
    map['last_updated'] = Variable<String>(lastUpdated);
    map['vote_average'] = Variable<double>(voteAverage);
    if (!nullToAbsent || imagesJson != null) {
      map['images_json'] = Variable<String>(imagesJson);
    }
    if (!nullToAbsent || videosJson != null) {
      map['videos_json'] = Variable<String>(videosJson);
    }
    if (!nullToAbsent || creditsJson != null) {
      map['credits_json'] = Variable<String>(creditsJson);
    }
    if (!nullToAbsent || episodesJson != null) {
      map['episodes_json'] = Variable<String>(episodesJson);
    }
    return map;
  }

  TmdbSeasonsCompanion toCompanion(bool nullToAbsent) {
    return TmdbSeasonsCompanion(
      id: Value(id),
      tvId: Value(tvId),
      tmdbId: Value(tmdbId),
      seasonNumber: Value(seasonNumber),
      name: Value(name),
      overview: Value(overview),
      airDate: Value(airDate),
      posterPathSuffix: posterPathSuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPathSuffix),
      lastUpdated: Value(lastUpdated),
      voteAverage: Value(voteAverage),
      imagesJson: imagesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(imagesJson),
      videosJson: videosJson == null && nullToAbsent
          ? const Value.absent()
          : Value(videosJson),
      creditsJson: creditsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(creditsJson),
      episodesJson: episodesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(episodesJson),
    );
  }

  factory TmdbSeasonData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TmdbSeasonData(
      id: serializer.fromJson<String>(json['id']),
      tvId: serializer.fromJson<int>(json['tvId']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      name: serializer.fromJson<String>(json['name']),
      overview: serializer.fromJson<String>(json['overview']),
      airDate: serializer.fromJson<String>(json['airDate']),
      posterPathSuffix: serializer.fromJson<String?>(json['posterPathSuffix']),
      lastUpdated: serializer.fromJson<String>(json['lastUpdated']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      imagesJson: serializer.fromJson<String?>(json['imagesJson']),
      videosJson: serializer.fromJson<String?>(json['videosJson']),
      creditsJson: serializer.fromJson<String?>(json['creditsJson']),
      episodesJson: serializer.fromJson<String?>(json['episodesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tvId': serializer.toJson<int>(tvId),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'name': serializer.toJson<String>(name),
      'overview': serializer.toJson<String>(overview),
      'airDate': serializer.toJson<String>(airDate),
      'posterPathSuffix': serializer.toJson<String?>(posterPathSuffix),
      'lastUpdated': serializer.toJson<String>(lastUpdated),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'imagesJson': serializer.toJson<String?>(imagesJson),
      'videosJson': serializer.toJson<String?>(videosJson),
      'creditsJson': serializer.toJson<String?>(creditsJson),
      'episodesJson': serializer.toJson<String?>(episodesJson),
    };
  }

  TmdbSeasonData copyWith(
          {String? id,
          int? tvId,
          int? tmdbId,
          int? seasonNumber,
          String? name,
          String? overview,
          String? airDate,
          Value<String?> posterPathSuffix = const Value.absent(),
          String? lastUpdated,
          double? voteAverage,
          Value<String?> imagesJson = const Value.absent(),
          Value<String?> videosJson = const Value.absent(),
          Value<String?> creditsJson = const Value.absent(),
          Value<String?> episodesJson = const Value.absent()}) =>
      TmdbSeasonData(
        id: id ?? this.id,
        tvId: tvId ?? this.tvId,
        tmdbId: tmdbId ?? this.tmdbId,
        seasonNumber: seasonNumber ?? this.seasonNumber,
        name: name ?? this.name,
        overview: overview ?? this.overview,
        airDate: airDate ?? this.airDate,
        posterPathSuffix: posterPathSuffix.present
            ? posterPathSuffix.value
            : this.posterPathSuffix,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        voteAverage: voteAverage ?? this.voteAverage,
        imagesJson: imagesJson.present ? imagesJson.value : this.imagesJson,
        videosJson: videosJson.present ? videosJson.value : this.videosJson,
        creditsJson: creditsJson.present ? creditsJson.value : this.creditsJson,
        episodesJson:
            episodesJson.present ? episodesJson.value : this.episodesJson,
      );
  TmdbSeasonData copyWithCompanion(TmdbSeasonsCompanion data) {
    return TmdbSeasonData(
      id: data.id.present ? data.id.value : this.id,
      tvId: data.tvId.present ? data.tvId.value : this.tvId,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      posterPathSuffix: data.posterPathSuffix.present
          ? data.posterPathSuffix.value
          : this.posterPathSuffix,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      imagesJson:
          data.imagesJson.present ? data.imagesJson.value : this.imagesJson,
      videosJson:
          data.videosJson.present ? data.videosJson.value : this.videosJson,
      creditsJson:
          data.creditsJson.present ? data.creditsJson.value : this.creditsJson,
      episodesJson: data.episodesJson.present
          ? data.episodesJson.value
          : this.episodesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TmdbSeasonData(')
          ..write('id: $id, ')
          ..write('tvId: $tvId, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('posterPathSuffix: $posterPathSuffix, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson, ')
          ..write('creditsJson: $creditsJson, ')
          ..write('episodesJson: $episodesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tvId,
      tmdbId,
      seasonNumber,
      name,
      overview,
      airDate,
      posterPathSuffix,
      lastUpdated,
      voteAverage,
      imagesJson,
      videosJson,
      creditsJson,
      episodesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TmdbSeasonData &&
          other.id == this.id &&
          other.tvId == this.tvId &&
          other.tmdbId == this.tmdbId &&
          other.seasonNumber == this.seasonNumber &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.airDate == this.airDate &&
          other.posterPathSuffix == this.posterPathSuffix &&
          other.lastUpdated == this.lastUpdated &&
          other.voteAverage == this.voteAverage &&
          other.imagesJson == this.imagesJson &&
          other.videosJson == this.videosJson &&
          other.creditsJson == this.creditsJson &&
          other.episodesJson == this.episodesJson);
}

class TmdbSeasonsCompanion extends UpdateCompanion<TmdbSeasonData> {
  final Value<String> id;
  final Value<int> tvId;
  final Value<int> tmdbId;
  final Value<int> seasonNumber;
  final Value<String> name;
  final Value<String> overview;
  final Value<String> airDate;
  final Value<String?> posterPathSuffix;
  final Value<String> lastUpdated;
  final Value<double> voteAverage;
  final Value<String?> imagesJson;
  final Value<String?> videosJson;
  final Value<String?> creditsJson;
  final Value<String?> episodesJson;
  final Value<int> rowid;
  const TmdbSeasonsCompanion({
    this.id = const Value.absent(),
    this.tvId = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.posterPathSuffix = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.creditsJson = const Value.absent(),
    this.episodesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TmdbSeasonsCompanion.insert({
    required String id,
    required int tvId,
    required int tmdbId,
    required int seasonNumber,
    required String name,
    required String overview,
    required String airDate,
    this.posterPathSuffix = const Value.absent(),
    required String lastUpdated,
    required double voteAverage,
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.creditsJson = const Value.absent(),
    this.episodesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tvId = Value(tvId),
        tmdbId = Value(tmdbId),
        seasonNumber = Value(seasonNumber),
        name = Value(name),
        overview = Value(overview),
        airDate = Value(airDate),
        lastUpdated = Value(lastUpdated),
        voteAverage = Value(voteAverage);
  static Insertable<TmdbSeasonData> custom({
    Expression<String>? id,
    Expression<int>? tvId,
    Expression<int>? tmdbId,
    Expression<int>? seasonNumber,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? airDate,
    Expression<String>? posterPathSuffix,
    Expression<String>? lastUpdated,
    Expression<double>? voteAverage,
    Expression<String>? imagesJson,
    Expression<String>? videosJson,
    Expression<String>? creditsJson,
    Expression<String>? episodesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tvId != null) 'tv_id': tvId,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (airDate != null) 'air_date': airDate,
      if (posterPathSuffix != null) 'poster_path_suffix': posterPathSuffix,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (imagesJson != null) 'images_json': imagesJson,
      if (videosJson != null) 'videos_json': videosJson,
      if (creditsJson != null) 'credits_json': creditsJson,
      if (episodesJson != null) 'episodes_json': episodesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TmdbSeasonsCompanion copyWith(
      {Value<String>? id,
      Value<int>? tvId,
      Value<int>? tmdbId,
      Value<int>? seasonNumber,
      Value<String>? name,
      Value<String>? overview,
      Value<String>? airDate,
      Value<String?>? posterPathSuffix,
      Value<String>? lastUpdated,
      Value<double>? voteAverage,
      Value<String?>? imagesJson,
      Value<String?>? videosJson,
      Value<String?>? creditsJson,
      Value<String?>? episodesJson,
      Value<int>? rowid}) {
    return TmdbSeasonsCompanion(
      id: id ?? this.id,
      tvId: tvId ?? this.tvId,
      tmdbId: tmdbId ?? this.tmdbId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      airDate: airDate ?? this.airDate,
      posterPathSuffix: posterPathSuffix ?? this.posterPathSuffix,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      voteAverage: voteAverage ?? this.voteAverage,
      imagesJson: imagesJson ?? this.imagesJson,
      videosJson: videosJson ?? this.videosJson,
      creditsJson: creditsJson ?? this.creditsJson,
      episodesJson: episodesJson ?? this.episodesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tvId.present) {
      map['tv_id'] = Variable<int>(tvId.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<String>(airDate.value);
    }
    if (posterPathSuffix.present) {
      map['poster_path_suffix'] = Variable<String>(posterPathSuffix.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<String>(lastUpdated.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (videosJson.present) {
      map['videos_json'] = Variable<String>(videosJson.value);
    }
    if (creditsJson.present) {
      map['credits_json'] = Variable<String>(creditsJson.value);
    }
    if (episodesJson.present) {
      map['episodes_json'] = Variable<String>(episodesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TmdbSeasonsCompanion(')
          ..write('id: $id, ')
          ..write('tvId: $tvId, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('posterPathSuffix: $posterPathSuffix, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson, ')
          ..write('creditsJson: $creditsJson, ')
          ..write('episodesJson: $episodesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TmdbEpisodesTable extends TmdbEpisodes
    with TableInfo<$TmdbEpisodesTable, TmdbEpisodeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TmdbEpisodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tmdbIdMeta = const VerificationMeta('tmdbId');
  @override
  late final GeneratedColumn<int> tmdbId = GeneratedColumn<int>(
      'tmdb_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tvIdMeta = const VerificationMeta('tvId');
  @override
  late final GeneratedColumn<int> tvId = GeneratedColumn<int>(
      'tv_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _seasonNumberMeta =
      const VerificationMeta('seasonNumber');
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
      'season_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _episodeNumberMeta =
      const VerificationMeta('episodeNumber');
  @override
  late final GeneratedColumn<int> episodeNumber = GeneratedColumn<int>(
      'episode_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _overviewMeta =
      const VerificationMeta('overview');
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
      'overview', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _airDateMeta =
      const VerificationMeta('airDate');
  @override
  late final GeneratedColumn<String> airDate = GeneratedColumn<String>(
      'air_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _runtimeMeta =
      const VerificationMeta('runtime');
  @override
  late final GeneratedColumn<int> runtime = GeneratedColumn<int>(
      'runtime', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<String> lastUpdated = GeneratedColumn<String>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voteAverageMeta =
      const VerificationMeta('voteAverage');
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
      'vote_average', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateRatedMeta =
      const VerificationMeta('dateRated');
  @override
  late final GeneratedColumn<DateTime> dateRated = GeneratedColumn<DateTime>(
      'date_rated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _stillPathSuffixMeta =
      const VerificationMeta('stillPathSuffix');
  @override
  late final GeneratedColumn<String> stillPathSuffix = GeneratedColumn<String>(
      'still_path_suffix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guestStarsJsonMeta =
      const VerificationMeta('guestStarsJson');
  @override
  late final GeneratedColumn<String> guestStarsJson = GeneratedColumn<String>(
      'guest_stars_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _crewJsonMeta =
      const VerificationMeta('crewJson');
  @override
  late final GeneratedColumn<String> crewJson = GeneratedColumn<String>(
      'crew_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagesJsonMeta =
      const VerificationMeta('imagesJson');
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
      'images_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _videosJsonMeta =
      const VerificationMeta('videosJson');
  @override
  late final GeneratedColumn<String> videosJson = GeneratedColumn<String>(
      'videos_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tmdbId,
        tvId,
        seasonNumber,
        episodeNumber,
        name,
        overview,
        airDate,
        runtime,
        lastUpdated,
        voteAverage,
        rating,
        dateRated,
        stillPathSuffix,
        guestStarsJson,
        crewJson,
        imagesJson,
        videosJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tmdb_episodes';
  @override
  VerificationContext validateIntegrity(Insertable<TmdbEpisodeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tmdb_id')) {
      context.handle(_tmdbIdMeta,
          tmdbId.isAcceptableOrUnknown(data['tmdb_id']!, _tmdbIdMeta));
    } else if (isInserting) {
      context.missing(_tmdbIdMeta);
    }
    if (data.containsKey('tv_id')) {
      context.handle(
          _tvIdMeta, tvId.isAcceptableOrUnknown(data['tv_id']!, _tvIdMeta));
    } else if (isInserting) {
      context.missing(_tvIdMeta);
    }
    if (data.containsKey('season_number')) {
      context.handle(
          _seasonNumberMeta,
          seasonNumber.isAcceptableOrUnknown(
              data['season_number']!, _seasonNumberMeta));
    } else if (isInserting) {
      context.missing(_seasonNumberMeta);
    }
    if (data.containsKey('episode_number')) {
      context.handle(
          _episodeNumberMeta,
          episodeNumber.isAcceptableOrUnknown(
              data['episode_number']!, _episodeNumberMeta));
    } else if (isInserting) {
      context.missing(_episodeNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(_overviewMeta,
          overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta));
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('air_date')) {
      context.handle(_airDateMeta,
          airDate.isAcceptableOrUnknown(data['air_date']!, _airDateMeta));
    } else if (isInserting) {
      context.missing(_airDateMeta);
    }
    if (data.containsKey('runtime')) {
      context.handle(_runtimeMeta,
          runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta));
    } else if (isInserting) {
      context.missing(_runtimeMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('vote_average')) {
      context.handle(
          _voteAverageMeta,
          voteAverage.isAcceptableOrUnknown(
              data['vote_average']!, _voteAverageMeta));
    } else if (isInserting) {
      context.missing(_voteAverageMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('date_rated')) {
      context.handle(_dateRatedMeta,
          dateRated.isAcceptableOrUnknown(data['date_rated']!, _dateRatedMeta));
    } else if (isInserting) {
      context.missing(_dateRatedMeta);
    }
    if (data.containsKey('still_path_suffix')) {
      context.handle(
          _stillPathSuffixMeta,
          stillPathSuffix.isAcceptableOrUnknown(
              data['still_path_suffix']!, _stillPathSuffixMeta));
    }
    if (data.containsKey('guest_stars_json')) {
      context.handle(
          _guestStarsJsonMeta,
          guestStarsJson.isAcceptableOrUnknown(
              data['guest_stars_json']!, _guestStarsJsonMeta));
    }
    if (data.containsKey('crew_json')) {
      context.handle(_crewJsonMeta,
          crewJson.isAcceptableOrUnknown(data['crew_json']!, _crewJsonMeta));
    }
    if (data.containsKey('images_json')) {
      context.handle(
          _imagesJsonMeta,
          imagesJson.isAcceptableOrUnknown(
              data['images_json']!, _imagesJsonMeta));
    }
    if (data.containsKey('videos_json')) {
      context.handle(
          _videosJsonMeta,
          videosJson.isAcceptableOrUnknown(
              data['videos_json']!, _videosJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TmdbEpisodeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TmdbEpisodeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tmdbId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tmdb_id'])!,
      tvId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tv_id'])!,
      seasonNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_number'])!,
      episodeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}episode_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      overview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overview'])!,
      airDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}air_date'])!,
      runtime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}runtime'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated'])!,
      voteAverage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vote_average'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating'])!,
      dateRated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_rated'])!,
      stillPathSuffix: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}still_path_suffix']),
      guestStarsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}guest_stars_json']),
      crewJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crew_json']),
      imagesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images_json']),
      videosJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}videos_json']),
    );
  }

  @override
  $TmdbEpisodesTable createAlias(String alias) {
    return $TmdbEpisodesTable(attachedDatabase, alias);
  }
}

class TmdbEpisodeData extends DataClass implements Insertable<TmdbEpisodeData> {
  final String id;
  final int tmdbId;
  final int tvId;
  final int seasonNumber;
  final int episodeNumber;
  final String name;
  final String overview;
  final String airDate;
  final int runtime;
  final String lastUpdated;
  final double voteAverage;
  final double rating;
  final DateTime dateRated;
  final String? stillPathSuffix;
  final String? guestStarsJson;
  final String? crewJson;
  final String? imagesJson;
  final String? videosJson;
  const TmdbEpisodeData(
      {required this.id,
      required this.tmdbId,
      required this.tvId,
      required this.seasonNumber,
      required this.episodeNumber,
      required this.name,
      required this.overview,
      required this.airDate,
      required this.runtime,
      required this.lastUpdated,
      required this.voteAverage,
      required this.rating,
      required this.dateRated,
      this.stillPathSuffix,
      this.guestStarsJson,
      this.crewJson,
      this.imagesJson,
      this.videosJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tmdb_id'] = Variable<int>(tmdbId);
    map['tv_id'] = Variable<int>(tvId);
    map['season_number'] = Variable<int>(seasonNumber);
    map['episode_number'] = Variable<int>(episodeNumber);
    map['name'] = Variable<String>(name);
    map['overview'] = Variable<String>(overview);
    map['air_date'] = Variable<String>(airDate);
    map['runtime'] = Variable<int>(runtime);
    map['last_updated'] = Variable<String>(lastUpdated);
    map['vote_average'] = Variable<double>(voteAverage);
    map['rating'] = Variable<double>(rating);
    map['date_rated'] = Variable<DateTime>(dateRated);
    if (!nullToAbsent || stillPathSuffix != null) {
      map['still_path_suffix'] = Variable<String>(stillPathSuffix);
    }
    if (!nullToAbsent || guestStarsJson != null) {
      map['guest_stars_json'] = Variable<String>(guestStarsJson);
    }
    if (!nullToAbsent || crewJson != null) {
      map['crew_json'] = Variable<String>(crewJson);
    }
    if (!nullToAbsent || imagesJson != null) {
      map['images_json'] = Variable<String>(imagesJson);
    }
    if (!nullToAbsent || videosJson != null) {
      map['videos_json'] = Variable<String>(videosJson);
    }
    return map;
  }

  TmdbEpisodesCompanion toCompanion(bool nullToAbsent) {
    return TmdbEpisodesCompanion(
      id: Value(id),
      tmdbId: Value(tmdbId),
      tvId: Value(tvId),
      seasonNumber: Value(seasonNumber),
      episodeNumber: Value(episodeNumber),
      name: Value(name),
      overview: Value(overview),
      airDate: Value(airDate),
      runtime: Value(runtime),
      lastUpdated: Value(lastUpdated),
      voteAverage: Value(voteAverage),
      rating: Value(rating),
      dateRated: Value(dateRated),
      stillPathSuffix: stillPathSuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(stillPathSuffix),
      guestStarsJson: guestStarsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(guestStarsJson),
      crewJson: crewJson == null && nullToAbsent
          ? const Value.absent()
          : Value(crewJson),
      imagesJson: imagesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(imagesJson),
      videosJson: videosJson == null && nullToAbsent
          ? const Value.absent()
          : Value(videosJson),
    );
  }

  factory TmdbEpisodeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TmdbEpisodeData(
      id: serializer.fromJson<String>(json['id']),
      tmdbId: serializer.fromJson<int>(json['tmdbId']),
      tvId: serializer.fromJson<int>(json['tvId']),
      seasonNumber: serializer.fromJson<int>(json['seasonNumber']),
      episodeNumber: serializer.fromJson<int>(json['episodeNumber']),
      name: serializer.fromJson<String>(json['name']),
      overview: serializer.fromJson<String>(json['overview']),
      airDate: serializer.fromJson<String>(json['airDate']),
      runtime: serializer.fromJson<int>(json['runtime']),
      lastUpdated: serializer.fromJson<String>(json['lastUpdated']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      rating: serializer.fromJson<double>(json['rating']),
      dateRated: serializer.fromJson<DateTime>(json['dateRated']),
      stillPathSuffix: serializer.fromJson<String?>(json['stillPathSuffix']),
      guestStarsJson: serializer.fromJson<String?>(json['guestStarsJson']),
      crewJson: serializer.fromJson<String?>(json['crewJson']),
      imagesJson: serializer.fromJson<String?>(json['imagesJson']),
      videosJson: serializer.fromJson<String?>(json['videosJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tmdbId': serializer.toJson<int>(tmdbId),
      'tvId': serializer.toJson<int>(tvId),
      'seasonNumber': serializer.toJson<int>(seasonNumber),
      'episodeNumber': serializer.toJson<int>(episodeNumber),
      'name': serializer.toJson<String>(name),
      'overview': serializer.toJson<String>(overview),
      'airDate': serializer.toJson<String>(airDate),
      'runtime': serializer.toJson<int>(runtime),
      'lastUpdated': serializer.toJson<String>(lastUpdated),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'rating': serializer.toJson<double>(rating),
      'dateRated': serializer.toJson<DateTime>(dateRated),
      'stillPathSuffix': serializer.toJson<String?>(stillPathSuffix),
      'guestStarsJson': serializer.toJson<String?>(guestStarsJson),
      'crewJson': serializer.toJson<String?>(crewJson),
      'imagesJson': serializer.toJson<String?>(imagesJson),
      'videosJson': serializer.toJson<String?>(videosJson),
    };
  }

  TmdbEpisodeData copyWith(
          {String? id,
          int? tmdbId,
          int? tvId,
          int? seasonNumber,
          int? episodeNumber,
          String? name,
          String? overview,
          String? airDate,
          int? runtime,
          String? lastUpdated,
          double? voteAverage,
          double? rating,
          DateTime? dateRated,
          Value<String?> stillPathSuffix = const Value.absent(),
          Value<String?> guestStarsJson = const Value.absent(),
          Value<String?> crewJson = const Value.absent(),
          Value<String?> imagesJson = const Value.absent(),
          Value<String?> videosJson = const Value.absent()}) =>
      TmdbEpisodeData(
        id: id ?? this.id,
        tmdbId: tmdbId ?? this.tmdbId,
        tvId: tvId ?? this.tvId,
        seasonNumber: seasonNumber ?? this.seasonNumber,
        episodeNumber: episodeNumber ?? this.episodeNumber,
        name: name ?? this.name,
        overview: overview ?? this.overview,
        airDate: airDate ?? this.airDate,
        runtime: runtime ?? this.runtime,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        voteAverage: voteAverage ?? this.voteAverage,
        rating: rating ?? this.rating,
        dateRated: dateRated ?? this.dateRated,
        stillPathSuffix: stillPathSuffix.present
            ? stillPathSuffix.value
            : this.stillPathSuffix,
        guestStarsJson:
            guestStarsJson.present ? guestStarsJson.value : this.guestStarsJson,
        crewJson: crewJson.present ? crewJson.value : this.crewJson,
        imagesJson: imagesJson.present ? imagesJson.value : this.imagesJson,
        videosJson: videosJson.present ? videosJson.value : this.videosJson,
      );
  TmdbEpisodeData copyWithCompanion(TmdbEpisodesCompanion data) {
    return TmdbEpisodeData(
      id: data.id.present ? data.id.value : this.id,
      tmdbId: data.tmdbId.present ? data.tmdbId.value : this.tmdbId,
      tvId: data.tvId.present ? data.tvId.value : this.tvId,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      episodeNumber: data.episodeNumber.present
          ? data.episodeNumber.value
          : this.episodeNumber,
      name: data.name.present ? data.name.value : this.name,
      overview: data.overview.present ? data.overview.value : this.overview,
      airDate: data.airDate.present ? data.airDate.value : this.airDate,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      rating: data.rating.present ? data.rating.value : this.rating,
      dateRated: data.dateRated.present ? data.dateRated.value : this.dateRated,
      stillPathSuffix: data.stillPathSuffix.present
          ? data.stillPathSuffix.value
          : this.stillPathSuffix,
      guestStarsJson: data.guestStarsJson.present
          ? data.guestStarsJson.value
          : this.guestStarsJson,
      crewJson: data.crewJson.present ? data.crewJson.value : this.crewJson,
      imagesJson:
          data.imagesJson.present ? data.imagesJson.value : this.imagesJson,
      videosJson:
          data.videosJson.present ? data.videosJson.value : this.videosJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TmdbEpisodeData(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('tvId: $tvId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('runtime: $runtime, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('rating: $rating, ')
          ..write('dateRated: $dateRated, ')
          ..write('stillPathSuffix: $stillPathSuffix, ')
          ..write('guestStarsJson: $guestStarsJson, ')
          ..write('crewJson: $crewJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tmdbId,
      tvId,
      seasonNumber,
      episodeNumber,
      name,
      overview,
      airDate,
      runtime,
      lastUpdated,
      voteAverage,
      rating,
      dateRated,
      stillPathSuffix,
      guestStarsJson,
      crewJson,
      imagesJson,
      videosJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TmdbEpisodeData &&
          other.id == this.id &&
          other.tmdbId == this.tmdbId &&
          other.tvId == this.tvId &&
          other.seasonNumber == this.seasonNumber &&
          other.episodeNumber == this.episodeNumber &&
          other.name == this.name &&
          other.overview == this.overview &&
          other.airDate == this.airDate &&
          other.runtime == this.runtime &&
          other.lastUpdated == this.lastUpdated &&
          other.voteAverage == this.voteAverage &&
          other.rating == this.rating &&
          other.dateRated == this.dateRated &&
          other.stillPathSuffix == this.stillPathSuffix &&
          other.guestStarsJson == this.guestStarsJson &&
          other.crewJson == this.crewJson &&
          other.imagesJson == this.imagesJson &&
          other.videosJson == this.videosJson);
}

class TmdbEpisodesCompanion extends UpdateCompanion<TmdbEpisodeData> {
  final Value<String> id;
  final Value<int> tmdbId;
  final Value<int> tvId;
  final Value<int> seasonNumber;
  final Value<int> episodeNumber;
  final Value<String> name;
  final Value<String> overview;
  final Value<String> airDate;
  final Value<int> runtime;
  final Value<String> lastUpdated;
  final Value<double> voteAverage;
  final Value<double> rating;
  final Value<DateTime> dateRated;
  final Value<String?> stillPathSuffix;
  final Value<String?> guestStarsJson;
  final Value<String?> crewJson;
  final Value<String?> imagesJson;
  final Value<String?> videosJson;
  final Value<int> rowid;
  const TmdbEpisodesCompanion({
    this.id = const Value.absent(),
    this.tmdbId = const Value.absent(),
    this.tvId = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.overview = const Value.absent(),
    this.airDate = const Value.absent(),
    this.runtime = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.rating = const Value.absent(),
    this.dateRated = const Value.absent(),
    this.stillPathSuffix = const Value.absent(),
    this.guestStarsJson = const Value.absent(),
    this.crewJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TmdbEpisodesCompanion.insert({
    required String id,
    required int tmdbId,
    required int tvId,
    required int seasonNumber,
    required int episodeNumber,
    required String name,
    required String overview,
    required String airDate,
    required int runtime,
    required String lastUpdated,
    required double voteAverage,
    this.rating = const Value.absent(),
    required DateTime dateRated,
    this.stillPathSuffix = const Value.absent(),
    this.guestStarsJson = const Value.absent(),
    this.crewJson = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.videosJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tmdbId = Value(tmdbId),
        tvId = Value(tvId),
        seasonNumber = Value(seasonNumber),
        episodeNumber = Value(episodeNumber),
        name = Value(name),
        overview = Value(overview),
        airDate = Value(airDate),
        runtime = Value(runtime),
        lastUpdated = Value(lastUpdated),
        voteAverage = Value(voteAverage),
        dateRated = Value(dateRated);
  static Insertable<TmdbEpisodeData> custom({
    Expression<String>? id,
    Expression<int>? tmdbId,
    Expression<int>? tvId,
    Expression<int>? seasonNumber,
    Expression<int>? episodeNumber,
    Expression<String>? name,
    Expression<String>? overview,
    Expression<String>? airDate,
    Expression<int>? runtime,
    Expression<String>? lastUpdated,
    Expression<double>? voteAverage,
    Expression<double>? rating,
    Expression<DateTime>? dateRated,
    Expression<String>? stillPathSuffix,
    Expression<String>? guestStarsJson,
    Expression<String>? crewJson,
    Expression<String>? imagesJson,
    Expression<String>? videosJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tmdbId != null) 'tmdb_id': tmdbId,
      if (tvId != null) 'tv_id': tvId,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (episodeNumber != null) 'episode_number': episodeNumber,
      if (name != null) 'name': name,
      if (overview != null) 'overview': overview,
      if (airDate != null) 'air_date': airDate,
      if (runtime != null) 'runtime': runtime,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (rating != null) 'rating': rating,
      if (dateRated != null) 'date_rated': dateRated,
      if (stillPathSuffix != null) 'still_path_suffix': stillPathSuffix,
      if (guestStarsJson != null) 'guest_stars_json': guestStarsJson,
      if (crewJson != null) 'crew_json': crewJson,
      if (imagesJson != null) 'images_json': imagesJson,
      if (videosJson != null) 'videos_json': videosJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TmdbEpisodesCompanion copyWith(
      {Value<String>? id,
      Value<int>? tmdbId,
      Value<int>? tvId,
      Value<int>? seasonNumber,
      Value<int>? episodeNumber,
      Value<String>? name,
      Value<String>? overview,
      Value<String>? airDate,
      Value<int>? runtime,
      Value<String>? lastUpdated,
      Value<double>? voteAverage,
      Value<double>? rating,
      Value<DateTime>? dateRated,
      Value<String?>? stillPathSuffix,
      Value<String?>? guestStarsJson,
      Value<String?>? crewJson,
      Value<String?>? imagesJson,
      Value<String?>? videosJson,
      Value<int>? rowid}) {
    return TmdbEpisodesCompanion(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      tvId: tvId ?? this.tvId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      airDate: airDate ?? this.airDate,
      runtime: runtime ?? this.runtime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      voteAverage: voteAverage ?? this.voteAverage,
      rating: rating ?? this.rating,
      dateRated: dateRated ?? this.dateRated,
      stillPathSuffix: stillPathSuffix ?? this.stillPathSuffix,
      guestStarsJson: guestStarsJson ?? this.guestStarsJson,
      crewJson: crewJson ?? this.crewJson,
      imagesJson: imagesJson ?? this.imagesJson,
      videosJson: videosJson ?? this.videosJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tmdbId.present) {
      map['tmdb_id'] = Variable<int>(tmdbId.value);
    }
    if (tvId.present) {
      map['tv_id'] = Variable<int>(tvId.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (episodeNumber.present) {
      map['episode_number'] = Variable<int>(episodeNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (airDate.present) {
      map['air_date'] = Variable<String>(airDate.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<int>(runtime.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<String>(lastUpdated.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (dateRated.present) {
      map['date_rated'] = Variable<DateTime>(dateRated.value);
    }
    if (stillPathSuffix.present) {
      map['still_path_suffix'] = Variable<String>(stillPathSuffix.value);
    }
    if (guestStarsJson.present) {
      map['guest_stars_json'] = Variable<String>(guestStarsJson.value);
    }
    if (crewJson.present) {
      map['crew_json'] = Variable<String>(crewJson.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (videosJson.present) {
      map['videos_json'] = Variable<String>(videosJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TmdbEpisodesCompanion(')
          ..write('id: $id, ')
          ..write('tmdbId: $tmdbId, ')
          ..write('tvId: $tvId, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('name: $name, ')
          ..write('overview: $overview, ')
          ..write('airDate: $airDate, ')
          ..write('runtime: $runtime, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('rating: $rating, ')
          ..write('dateRated: $dateRated, ')
          ..write('stillPathSuffix: $stillPathSuffix, ')
          ..write('guestStarsJson: $guestStarsJson, ')
          ..write('crewJson: $crewJson, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('videosJson: $videosJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserListEntriesTable userListEntries =
      $UserListEntriesTable(this);
  late final $TmdbTitlesTable tmdbTitles = $TmdbTitlesTable(this);
  late final $TmdbSeasonsTable tmdbSeasons = $TmdbSeasonsTable(this);
  late final $TmdbEpisodesTable tmdbEpisodes = $TmdbEpisodesTable(this);
  late final Index idxUserListEntriesListOrder = Index(
      'idx_user_list_entries_list_order',
      'CREATE INDEX idx_user_list_entries_list_order ON user_list_entries (list_name, added_order)');
  late final Index idxUserListEntriesLookup = Index(
      'idx_user_list_entries_lookup',
      'CREATE INDEX idx_user_list_entries_lookup ON user_list_entries (list_name, tmdb_id, media_type)');
  late final Index idxTmdbTitlesLookup = Index('idx_tmdb_titles_lookup',
      'CREATE INDEX idx_tmdb_titles_lookup ON tmdb_titles (tmdb_id, media_type)');
  late final Index idxSeasonsTvId = Index('idx_seasons_tv_id',
      'CREATE INDEX idx_seasons_tv_id ON tmdb_seasons (tv_id)');
  late final Index idxEpisodesTvId = Index('idx_episodes_tv_id',
      'CREATE INDEX idx_episodes_tv_id ON tmdb_episodes (tv_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userListEntries,
        tmdbTitles,
        tmdbSeasons,
        tmdbEpisodes,
        idxUserListEntriesListOrder,
        idxUserListEntriesLookup,
        idxTmdbTitlesLookup,
        idxSeasonsTvId,
        idxEpisodesTvId
      ];
}

typedef $$UserListEntriesTableCreateCompanionBuilder = UserListEntriesCompanion
    Function({
  required String id,
  required String listName,
  required int tmdbId,
  required String mediaType,
  required int addedOrder,
  Value<int> rowid,
});
typedef $$UserListEntriesTableUpdateCompanionBuilder = UserListEntriesCompanion
    Function({
  Value<String> id,
  Value<String> listName,
  Value<int> tmdbId,
  Value<String> mediaType,
  Value<int> addedOrder,
  Value<int> rowid,
});

class $$UserListEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UserListEntriesTable> {
  $$UserListEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get listName => $composableBuilder(
      column: $table.listName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get addedOrder => $composableBuilder(
      column: $table.addedOrder, builder: (column) => ColumnFilters(column));
}

class $$UserListEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserListEntriesTable> {
  $$UserListEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get listName => $composableBuilder(
      column: $table.listName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get addedOrder => $composableBuilder(
      column: $table.addedOrder, builder: (column) => ColumnOrderings(column));
}

class $$UserListEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserListEntriesTable> {
  $$UserListEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listName =>
      $composableBuilder(column: $table.listName, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<int> get addedOrder => $composableBuilder(
      column: $table.addedOrder, builder: (column) => column);
}

class $$UserListEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserListEntriesTable,
    UserListEntryData,
    $$UserListEntriesTableFilterComposer,
    $$UserListEntriesTableOrderingComposer,
    $$UserListEntriesTableAnnotationComposer,
    $$UserListEntriesTableCreateCompanionBuilder,
    $$UserListEntriesTableUpdateCompanionBuilder,
    (
      UserListEntryData,
      BaseReferences<_$AppDatabase, $UserListEntriesTable, UserListEntryData>
    ),
    UserListEntryData,
    PrefetchHooks Function()> {
  $$UserListEntriesTableTableManager(
      _$AppDatabase db, $UserListEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserListEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserListEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserListEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> listName = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<String> mediaType = const Value.absent(),
            Value<int> addedOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserListEntriesCompanion(
            id: id,
            listName: listName,
            tmdbId: tmdbId,
            mediaType: mediaType,
            addedOrder: addedOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String listName,
            required int tmdbId,
            required String mediaType,
            required int addedOrder,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserListEntriesCompanion.insert(
            id: id,
            listName: listName,
            tmdbId: tmdbId,
            mediaType: mediaType,
            addedOrder: addedOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserListEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserListEntriesTable,
    UserListEntryData,
    $$UserListEntriesTableFilterComposer,
    $$UserListEntriesTableOrderingComposer,
    $$UserListEntriesTableAnnotationComposer,
    $$UserListEntriesTableCreateCompanionBuilder,
    $$UserListEntriesTableUpdateCompanionBuilder,
    (
      UserListEntryData,
      BaseReferences<_$AppDatabase, $UserListEntriesTable, UserListEntryData>
    ),
    UserListEntryData,
    PrefetchHooks Function()>;
typedef $$TmdbTitlesTableCreateCompanionBuilder = TmdbTitlesCompanion Function({
  required String id,
  required int tmdbId,
  required String name,
  required String originalName,
  required String originalLanguage,
  required String overview,
  required String tagline,
  required String status,
  required String mediaType,
  required String imdbId,
  required String homepage,
  required String certification,
  required String type,
  Value<String?> posterPathSuffix,
  Value<String?> backdropPathSuffix,
  required String releaseDate,
  required String firstAirDate,
  required String lastAirDate,
  required String lastUpdated,
  Value<String?> externalIdsJson,
  required double voteAverage,
  required int voteCount,
  Value<double> rating,
  required DateTime dateRated,
  required int runtime,
  required int numberOfEpisodes,
  required int numberOfSeasons,
  required double popularity,
  required int budget,
  required int revenue,
  required int effectiveRuntime,
  required String effectiveReleaseDate,
  Value<bool> isPinned,
  Value<bool> notifyNewSeasons,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<String?> recommendationsJson,
  Value<String?> nextEpisodeToAirJson,
  Value<String?> lastEpisodeToAirJson,
  Value<String?> providersJson,
  Value<String?> creditsJson,
  Value<String?> seasonsJson,
  Value<List<int>> genreIds,
  Value<List<int>> keywordIds,
  Value<List<int>> flatrateProviderIds,
  Value<int> lastNotifiedSeason,
  required String character,
  required String job,
  required String department,
  Value<int> rowid,
});
typedef $$TmdbTitlesTableUpdateCompanionBuilder = TmdbTitlesCompanion Function({
  Value<String> id,
  Value<int> tmdbId,
  Value<String> name,
  Value<String> originalName,
  Value<String> originalLanguage,
  Value<String> overview,
  Value<String> tagline,
  Value<String> status,
  Value<String> mediaType,
  Value<String> imdbId,
  Value<String> homepage,
  Value<String> certification,
  Value<String> type,
  Value<String?> posterPathSuffix,
  Value<String?> backdropPathSuffix,
  Value<String> releaseDate,
  Value<String> firstAirDate,
  Value<String> lastAirDate,
  Value<String> lastUpdated,
  Value<String?> externalIdsJson,
  Value<double> voteAverage,
  Value<int> voteCount,
  Value<double> rating,
  Value<DateTime> dateRated,
  Value<int> runtime,
  Value<int> numberOfEpisodes,
  Value<int> numberOfSeasons,
  Value<double> popularity,
  Value<int> budget,
  Value<int> revenue,
  Value<int> effectiveRuntime,
  Value<String> effectiveReleaseDate,
  Value<bool> isPinned,
  Value<bool> notifyNewSeasons,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<String?> recommendationsJson,
  Value<String?> nextEpisodeToAirJson,
  Value<String?> lastEpisodeToAirJson,
  Value<String?> providersJson,
  Value<String?> creditsJson,
  Value<String?> seasonsJson,
  Value<List<int>> genreIds,
  Value<List<int>> keywordIds,
  Value<List<int>> flatrateProviderIds,
  Value<int> lastNotifiedSeason,
  Value<String> character,
  Value<String> job,
  Value<String> department,
  Value<int> rowid,
});

class $$TmdbTitlesTableFilterComposer
    extends Composer<_$AppDatabase, $TmdbTitlesTable> {
  $$TmdbTitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalLanguage => $composableBuilder(
      column: $table.originalLanguage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imdbId => $composableBuilder(
      column: $table.imdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get homepage => $composableBuilder(
      column: $table.homepage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certification => $composableBuilder(
      column: $table.certification, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backdropPathSuffix => $composableBuilder(
      column: $table.backdropPathSuffix,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastAirDate => $composableBuilder(
      column: $table.lastAirDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalIdsJson => $composableBuilder(
      column: $table.externalIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateRated => $composableBuilder(
      column: $table.dateRated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberOfEpisodes => $composableBuilder(
      column: $table.numberOfEpisodes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberOfSeasons => $composableBuilder(
      column: $table.numberOfSeasons,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revenue => $composableBuilder(
      column: $table.revenue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get effectiveRuntime => $composableBuilder(
      column: $table.effectiveRuntime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get effectiveReleaseDate => $composableBuilder(
      column: $table.effectiveReleaseDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notifyNewSeasons => $composableBuilder(
      column: $table.notifyNewSeasons,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recommendationsJson => $composableBuilder(
      column: $table.recommendationsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nextEpisodeToAirJson => $composableBuilder(
      column: $table.nextEpisodeToAirJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastEpisodeToAirJson => $composableBuilder(
      column: $table.lastEpisodeToAirJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get providersJson => $composableBuilder(
      column: $table.providersJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get seasonsJson => $composableBuilder(
      column: $table.seasonsJson, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get genreIds =>
      $composableBuilder(
          column: $table.genreIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get keywordIds =>
      $composableBuilder(
          column: $table.keywordIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<int>, List<int>, String>
      get flatrateProviderIds => $composableBuilder(
          column: $table.flatrateProviderIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get lastNotifiedSeason => $composableBuilder(
      column: $table.lastNotifiedSeason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get job => $composableBuilder(
      column: $table.job, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnFilters(column));
}

class $$TmdbTitlesTableOrderingComposer
    extends Composer<_$AppDatabase, $TmdbTitlesTable> {
  $$TmdbTitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalName => $composableBuilder(
      column: $table.originalName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalLanguage => $composableBuilder(
      column: $table.originalLanguage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imdbId => $composableBuilder(
      column: $table.imdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get homepage => $composableBuilder(
      column: $table.homepage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certification => $composableBuilder(
      column: $table.certification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backdropPathSuffix => $composableBuilder(
      column: $table.backdropPathSuffix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastAirDate => $composableBuilder(
      column: $table.lastAirDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalIdsJson => $composableBuilder(
      column: $table.externalIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get voteCount => $composableBuilder(
      column: $table.voteCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateRated => $composableBuilder(
      column: $table.dateRated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberOfEpisodes => $composableBuilder(
      column: $table.numberOfEpisodes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberOfSeasons => $composableBuilder(
      column: $table.numberOfSeasons,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revenue => $composableBuilder(
      column: $table.revenue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get effectiveRuntime => $composableBuilder(
      column: $table.effectiveRuntime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get effectiveReleaseDate => $composableBuilder(
      column: $table.effectiveReleaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notifyNewSeasons => $composableBuilder(
      column: $table.notifyNewSeasons,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recommendationsJson => $composableBuilder(
      column: $table.recommendationsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nextEpisodeToAirJson => $composableBuilder(
      column: $table.nextEpisodeToAirJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastEpisodeToAirJson => $composableBuilder(
      column: $table.lastEpisodeToAirJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get providersJson => $composableBuilder(
      column: $table.providersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get seasonsJson => $composableBuilder(
      column: $table.seasonsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genreIds => $composableBuilder(
      column: $table.genreIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywordIds => $composableBuilder(
      column: $table.keywordIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flatrateProviderIds => $composableBuilder(
      column: $table.flatrateProviderIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastNotifiedSeason => $composableBuilder(
      column: $table.lastNotifiedSeason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get character => $composableBuilder(
      column: $table.character, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get job => $composableBuilder(
      column: $table.job, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnOrderings(column));
}

class $$TmdbTitlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TmdbTitlesTable> {
  $$TmdbTitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => column);

  GeneratedColumn<String> get originalLanguage => $composableBuilder(
      column: $table.originalLanguage, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get tagline =>
      $composableBuilder(column: $table.tagline, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get imdbId =>
      $composableBuilder(column: $table.imdbId, builder: (column) => column);

  GeneratedColumn<String> get homepage =>
      $composableBuilder(column: $table.homepage, builder: (column) => column);

  GeneratedColumn<String> get certification => $composableBuilder(
      column: $table.certification, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix, builder: (column) => column);

  GeneratedColumn<String> get backdropPathSuffix => $composableBuilder(
      column: $table.backdropPathSuffix, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<String> get firstAirDate => $composableBuilder(
      column: $table.firstAirDate, builder: (column) => column);

  GeneratedColumn<String> get lastAirDate => $composableBuilder(
      column: $table.lastAirDate, builder: (column) => column);

  GeneratedColumn<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<String> get externalIdsJson => $composableBuilder(
      column: $table.externalIdsJson, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => column);

  GeneratedColumn<int> get voteCount =>
      $composableBuilder(column: $table.voteCount, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get dateRated =>
      $composableBuilder(column: $table.dateRated, builder: (column) => column);

  GeneratedColumn<int> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  GeneratedColumn<int> get numberOfEpisodes => $composableBuilder(
      column: $table.numberOfEpisodes, builder: (column) => column);

  GeneratedColumn<int> get numberOfSeasons => $composableBuilder(
      column: $table.numberOfSeasons, builder: (column) => column);

  GeneratedColumn<double> get popularity => $composableBuilder(
      column: $table.popularity, builder: (column) => column);

  GeneratedColumn<int> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<int> get revenue =>
      $composableBuilder(column: $table.revenue, builder: (column) => column);

  GeneratedColumn<int> get effectiveRuntime => $composableBuilder(
      column: $table.effectiveRuntime, builder: (column) => column);

  GeneratedColumn<String> get effectiveReleaseDate => $composableBuilder(
      column: $table.effectiveReleaseDate, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get notifyNewSeasons => $composableBuilder(
      column: $table.notifyNewSeasons, builder: (column) => column);

  GeneratedColumn<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => column);

  GeneratedColumn<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => column);

  GeneratedColumn<String> get recommendationsJson => $composableBuilder(
      column: $table.recommendationsJson, builder: (column) => column);

  GeneratedColumn<String> get nextEpisodeToAirJson => $composableBuilder(
      column: $table.nextEpisodeToAirJson, builder: (column) => column);

  GeneratedColumn<String> get lastEpisodeToAirJson => $composableBuilder(
      column: $table.lastEpisodeToAirJson, builder: (column) => column);

  GeneratedColumn<String> get providersJson => $composableBuilder(
      column: $table.providersJson, builder: (column) => column);

  GeneratedColumn<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => column);

  GeneratedColumn<String> get seasonsJson => $composableBuilder(
      column: $table.seasonsJson, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get genreIds =>
      $composableBuilder(column: $table.genreIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get keywordIds =>
      $composableBuilder(
          column: $table.keywordIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get flatrateProviderIds =>
      $composableBuilder(
          column: $table.flatrateProviderIds, builder: (column) => column);

  GeneratedColumn<int> get lastNotifiedSeason => $composableBuilder(
      column: $table.lastNotifiedSeason, builder: (column) => column);

  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<String> get job =>
      $composableBuilder(column: $table.job, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => column);
}

class $$TmdbTitlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TmdbTitlesTable,
    TmdbTitleData,
    $$TmdbTitlesTableFilterComposer,
    $$TmdbTitlesTableOrderingComposer,
    $$TmdbTitlesTableAnnotationComposer,
    $$TmdbTitlesTableCreateCompanionBuilder,
    $$TmdbTitlesTableUpdateCompanionBuilder,
    (
      TmdbTitleData,
      BaseReferences<_$AppDatabase, $TmdbTitlesTable, TmdbTitleData>
    ),
    TmdbTitleData,
    PrefetchHooks Function()> {
  $$TmdbTitlesTableTableManager(_$AppDatabase db, $TmdbTitlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TmdbTitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TmdbTitlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TmdbTitlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> originalName = const Value.absent(),
            Value<String> originalLanguage = const Value.absent(),
            Value<String> overview = const Value.absent(),
            Value<String> tagline = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> mediaType = const Value.absent(),
            Value<String> imdbId = const Value.absent(),
            Value<String> homepage = const Value.absent(),
            Value<String> certification = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> posterPathSuffix = const Value.absent(),
            Value<String?> backdropPathSuffix = const Value.absent(),
            Value<String> releaseDate = const Value.absent(),
            Value<String> firstAirDate = const Value.absent(),
            Value<String> lastAirDate = const Value.absent(),
            Value<String> lastUpdated = const Value.absent(),
            Value<String?> externalIdsJson = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<int> voteCount = const Value.absent(),
            Value<double> rating = const Value.absent(),
            Value<DateTime> dateRated = const Value.absent(),
            Value<int> runtime = const Value.absent(),
            Value<int> numberOfEpisodes = const Value.absent(),
            Value<int> numberOfSeasons = const Value.absent(),
            Value<double> popularity = const Value.absent(),
            Value<int> budget = const Value.absent(),
            Value<int> revenue = const Value.absent(),
            Value<int> effectiveRuntime = const Value.absent(),
            Value<String> effectiveReleaseDate = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> notifyNewSeasons = const Value.absent(),
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<String?> recommendationsJson = const Value.absent(),
            Value<String?> nextEpisodeToAirJson = const Value.absent(),
            Value<String?> lastEpisodeToAirJson = const Value.absent(),
            Value<String?> providersJson = const Value.absent(),
            Value<String?> creditsJson = const Value.absent(),
            Value<String?> seasonsJson = const Value.absent(),
            Value<List<int>> genreIds = const Value.absent(),
            Value<List<int>> keywordIds = const Value.absent(),
            Value<List<int>> flatrateProviderIds = const Value.absent(),
            Value<int> lastNotifiedSeason = const Value.absent(),
            Value<String> character = const Value.absent(),
            Value<String> job = const Value.absent(),
            Value<String> department = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbTitlesCompanion(
            id: id,
            tmdbId: tmdbId,
            name: name,
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            tagline: tagline,
            status: status,
            mediaType: mediaType,
            imdbId: imdbId,
            homepage: homepage,
            certification: certification,
            type: type,
            posterPathSuffix: posterPathSuffix,
            backdropPathSuffix: backdropPathSuffix,
            releaseDate: releaseDate,
            firstAirDate: firstAirDate,
            lastAirDate: lastAirDate,
            lastUpdated: lastUpdated,
            externalIdsJson: externalIdsJson,
            voteAverage: voteAverage,
            voteCount: voteCount,
            rating: rating,
            dateRated: dateRated,
            runtime: runtime,
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            popularity: popularity,
            budget: budget,
            revenue: revenue,
            effectiveRuntime: effectiveRuntime,
            effectiveReleaseDate: effectiveReleaseDate,
            isPinned: isPinned,
            notifyNewSeasons: notifyNewSeasons,
            imagesJson: imagesJson,
            videosJson: videosJson,
            recommendationsJson: recommendationsJson,
            nextEpisodeToAirJson: nextEpisodeToAirJson,
            lastEpisodeToAirJson: lastEpisodeToAirJson,
            providersJson: providersJson,
            creditsJson: creditsJson,
            seasonsJson: seasonsJson,
            genreIds: genreIds,
            keywordIds: keywordIds,
            flatrateProviderIds: flatrateProviderIds,
            lastNotifiedSeason: lastNotifiedSeason,
            character: character,
            job: job,
            department: department,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int tmdbId,
            required String name,
            required String originalName,
            required String originalLanguage,
            required String overview,
            required String tagline,
            required String status,
            required String mediaType,
            required String imdbId,
            required String homepage,
            required String certification,
            required String type,
            Value<String?> posterPathSuffix = const Value.absent(),
            Value<String?> backdropPathSuffix = const Value.absent(),
            required String releaseDate,
            required String firstAirDate,
            required String lastAirDate,
            required String lastUpdated,
            Value<String?> externalIdsJson = const Value.absent(),
            required double voteAverage,
            required int voteCount,
            Value<double> rating = const Value.absent(),
            required DateTime dateRated,
            required int runtime,
            required int numberOfEpisodes,
            required int numberOfSeasons,
            required double popularity,
            required int budget,
            required int revenue,
            required int effectiveRuntime,
            required String effectiveReleaseDate,
            Value<bool> isPinned = const Value.absent(),
            Value<bool> notifyNewSeasons = const Value.absent(),
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<String?> recommendationsJson = const Value.absent(),
            Value<String?> nextEpisodeToAirJson = const Value.absent(),
            Value<String?> lastEpisodeToAirJson = const Value.absent(),
            Value<String?> providersJson = const Value.absent(),
            Value<String?> creditsJson = const Value.absent(),
            Value<String?> seasonsJson = const Value.absent(),
            Value<List<int>> genreIds = const Value.absent(),
            Value<List<int>> keywordIds = const Value.absent(),
            Value<List<int>> flatrateProviderIds = const Value.absent(),
            Value<int> lastNotifiedSeason = const Value.absent(),
            required String character,
            required String job,
            required String department,
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbTitlesCompanion.insert(
            id: id,
            tmdbId: tmdbId,
            name: name,
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            tagline: tagline,
            status: status,
            mediaType: mediaType,
            imdbId: imdbId,
            homepage: homepage,
            certification: certification,
            type: type,
            posterPathSuffix: posterPathSuffix,
            backdropPathSuffix: backdropPathSuffix,
            releaseDate: releaseDate,
            firstAirDate: firstAirDate,
            lastAirDate: lastAirDate,
            lastUpdated: lastUpdated,
            externalIdsJson: externalIdsJson,
            voteAverage: voteAverage,
            voteCount: voteCount,
            rating: rating,
            dateRated: dateRated,
            runtime: runtime,
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            popularity: popularity,
            budget: budget,
            revenue: revenue,
            effectiveRuntime: effectiveRuntime,
            effectiveReleaseDate: effectiveReleaseDate,
            isPinned: isPinned,
            notifyNewSeasons: notifyNewSeasons,
            imagesJson: imagesJson,
            videosJson: videosJson,
            recommendationsJson: recommendationsJson,
            nextEpisodeToAirJson: nextEpisodeToAirJson,
            lastEpisodeToAirJson: lastEpisodeToAirJson,
            providersJson: providersJson,
            creditsJson: creditsJson,
            seasonsJson: seasonsJson,
            genreIds: genreIds,
            keywordIds: keywordIds,
            flatrateProviderIds: flatrateProviderIds,
            lastNotifiedSeason: lastNotifiedSeason,
            character: character,
            job: job,
            department: department,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TmdbTitlesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TmdbTitlesTable,
    TmdbTitleData,
    $$TmdbTitlesTableFilterComposer,
    $$TmdbTitlesTableOrderingComposer,
    $$TmdbTitlesTableAnnotationComposer,
    $$TmdbTitlesTableCreateCompanionBuilder,
    $$TmdbTitlesTableUpdateCompanionBuilder,
    (
      TmdbTitleData,
      BaseReferences<_$AppDatabase, $TmdbTitlesTable, TmdbTitleData>
    ),
    TmdbTitleData,
    PrefetchHooks Function()>;
typedef $$TmdbSeasonsTableCreateCompanionBuilder = TmdbSeasonsCompanion
    Function({
  required String id,
  required int tvId,
  required int tmdbId,
  required int seasonNumber,
  required String name,
  required String overview,
  required String airDate,
  Value<String?> posterPathSuffix,
  required String lastUpdated,
  required double voteAverage,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<String?> creditsJson,
  Value<String?> episodesJson,
  Value<int> rowid,
});
typedef $$TmdbSeasonsTableUpdateCompanionBuilder = TmdbSeasonsCompanion
    Function({
  Value<String> id,
  Value<int> tvId,
  Value<int> tmdbId,
  Value<int> seasonNumber,
  Value<String> name,
  Value<String> overview,
  Value<String> airDate,
  Value<String?> posterPathSuffix,
  Value<String> lastUpdated,
  Value<double> voteAverage,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<String?> creditsJson,
  Value<String?> episodesJson,
  Value<int> rowid,
});

class $$TmdbSeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $TmdbSeasonsTable> {
  $$TmdbSeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tvId => $composableBuilder(
      column: $table.tvId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodesJson => $composableBuilder(
      column: $table.episodesJson, builder: (column) => ColumnFilters(column));
}

class $$TmdbSeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $TmdbSeasonsTable> {
  $$TmdbSeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tvId => $composableBuilder(
      column: $table.tvId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodesJson => $composableBuilder(
      column: $table.episodesJson,
      builder: (column) => ColumnOrderings(column));
}

class $$TmdbSeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TmdbSeasonsTable> {
  $$TmdbSeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tvId =>
      $composableBuilder(column: $table.tvId, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<String> get posterPathSuffix => $composableBuilder(
      column: $table.posterPathSuffix, builder: (column) => column);

  GeneratedColumn<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => column);

  GeneratedColumn<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => column);

  GeneratedColumn<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => column);

  GeneratedColumn<String> get creditsJson => $composableBuilder(
      column: $table.creditsJson, builder: (column) => column);

  GeneratedColumn<String> get episodesJson => $composableBuilder(
      column: $table.episodesJson, builder: (column) => column);
}

class $$TmdbSeasonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TmdbSeasonsTable,
    TmdbSeasonData,
    $$TmdbSeasonsTableFilterComposer,
    $$TmdbSeasonsTableOrderingComposer,
    $$TmdbSeasonsTableAnnotationComposer,
    $$TmdbSeasonsTableCreateCompanionBuilder,
    $$TmdbSeasonsTableUpdateCompanionBuilder,
    (
      TmdbSeasonData,
      BaseReferences<_$AppDatabase, $TmdbSeasonsTable, TmdbSeasonData>
    ),
    TmdbSeasonData,
    PrefetchHooks Function()> {
  $$TmdbSeasonsTableTableManager(_$AppDatabase db, $TmdbSeasonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TmdbSeasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TmdbSeasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TmdbSeasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> tvId = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<int> seasonNumber = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> overview = const Value.absent(),
            Value<String> airDate = const Value.absent(),
            Value<String?> posterPathSuffix = const Value.absent(),
            Value<String> lastUpdated = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<String?> creditsJson = const Value.absent(),
            Value<String?> episodesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbSeasonsCompanion(
            id: id,
            tvId: tvId,
            tmdbId: tmdbId,
            seasonNumber: seasonNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            posterPathSuffix: posterPathSuffix,
            lastUpdated: lastUpdated,
            voteAverage: voteAverage,
            imagesJson: imagesJson,
            videosJson: videosJson,
            creditsJson: creditsJson,
            episodesJson: episodesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int tvId,
            required int tmdbId,
            required int seasonNumber,
            required String name,
            required String overview,
            required String airDate,
            Value<String?> posterPathSuffix = const Value.absent(),
            required String lastUpdated,
            required double voteAverage,
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<String?> creditsJson = const Value.absent(),
            Value<String?> episodesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbSeasonsCompanion.insert(
            id: id,
            tvId: tvId,
            tmdbId: tmdbId,
            seasonNumber: seasonNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            posterPathSuffix: posterPathSuffix,
            lastUpdated: lastUpdated,
            voteAverage: voteAverage,
            imagesJson: imagesJson,
            videosJson: videosJson,
            creditsJson: creditsJson,
            episodesJson: episodesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TmdbSeasonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TmdbSeasonsTable,
    TmdbSeasonData,
    $$TmdbSeasonsTableFilterComposer,
    $$TmdbSeasonsTableOrderingComposer,
    $$TmdbSeasonsTableAnnotationComposer,
    $$TmdbSeasonsTableCreateCompanionBuilder,
    $$TmdbSeasonsTableUpdateCompanionBuilder,
    (
      TmdbSeasonData,
      BaseReferences<_$AppDatabase, $TmdbSeasonsTable, TmdbSeasonData>
    ),
    TmdbSeasonData,
    PrefetchHooks Function()>;
typedef $$TmdbEpisodesTableCreateCompanionBuilder = TmdbEpisodesCompanion
    Function({
  required String id,
  required int tmdbId,
  required int tvId,
  required int seasonNumber,
  required int episodeNumber,
  required String name,
  required String overview,
  required String airDate,
  required int runtime,
  required String lastUpdated,
  required double voteAverage,
  Value<double> rating,
  required DateTime dateRated,
  Value<String?> stillPathSuffix,
  Value<String?> guestStarsJson,
  Value<String?> crewJson,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<int> rowid,
});
typedef $$TmdbEpisodesTableUpdateCompanionBuilder = TmdbEpisodesCompanion
    Function({
  Value<String> id,
  Value<int> tmdbId,
  Value<int> tvId,
  Value<int> seasonNumber,
  Value<int> episodeNumber,
  Value<String> name,
  Value<String> overview,
  Value<String> airDate,
  Value<int> runtime,
  Value<String> lastUpdated,
  Value<double> voteAverage,
  Value<double> rating,
  Value<DateTime> dateRated,
  Value<String?> stillPathSuffix,
  Value<String?> guestStarsJson,
  Value<String?> crewJson,
  Value<String?> imagesJson,
  Value<String?> videosJson,
  Value<int> rowid,
});

class $$TmdbEpisodesTableFilterComposer
    extends Composer<_$AppDatabase, $TmdbEpisodesTable> {
  $$TmdbEpisodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tvId => $composableBuilder(
      column: $table.tvId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateRated => $composableBuilder(
      column: $table.dateRated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stillPathSuffix => $composableBuilder(
      column: $table.stillPathSuffix,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestStarsJson => $composableBuilder(
      column: $table.guestStarsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get crewJson => $composableBuilder(
      column: $table.crewJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnFilters(column));
}

class $$TmdbEpisodesTableOrderingComposer
    extends Composer<_$AppDatabase, $TmdbEpisodesTable> {
  $$TmdbEpisodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tmdbId => $composableBuilder(
      column: $table.tmdbId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tvId => $composableBuilder(
      column: $table.tvId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overview => $composableBuilder(
      column: $table.overview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get airDate => $composableBuilder(
      column: $table.airDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runtime => $composableBuilder(
      column: $table.runtime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateRated => $composableBuilder(
      column: $table.dateRated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stillPathSuffix => $composableBuilder(
      column: $table.stillPathSuffix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestStarsJson => $composableBuilder(
      column: $table.guestStarsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get crewJson => $composableBuilder(
      column: $table.crewJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => ColumnOrderings(column));
}

class $$TmdbEpisodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TmdbEpisodesTable> {
  $$TmdbEpisodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tmdbId =>
      $composableBuilder(column: $table.tmdbId, builder: (column) => column);

  GeneratedColumn<int> get tvId =>
      $composableBuilder(column: $table.tvId, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
      column: $table.seasonNumber, builder: (column) => column);

  GeneratedColumn<int> get episodeNumber => $composableBuilder(
      column: $table.episodeNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get airDate =>
      $composableBuilder(column: $table.airDate, builder: (column) => column);

  GeneratedColumn<int> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  GeneratedColumn<String> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
      column: $table.voteAverage, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get dateRated =>
      $composableBuilder(column: $table.dateRated, builder: (column) => column);

  GeneratedColumn<String> get stillPathSuffix => $composableBuilder(
      column: $table.stillPathSuffix, builder: (column) => column);

  GeneratedColumn<String> get guestStarsJson => $composableBuilder(
      column: $table.guestStarsJson, builder: (column) => column);

  GeneratedColumn<String> get crewJson =>
      $composableBuilder(column: $table.crewJson, builder: (column) => column);

  GeneratedColumn<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => column);

  GeneratedColumn<String> get videosJson => $composableBuilder(
      column: $table.videosJson, builder: (column) => column);
}

class $$TmdbEpisodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TmdbEpisodesTable,
    TmdbEpisodeData,
    $$TmdbEpisodesTableFilterComposer,
    $$TmdbEpisodesTableOrderingComposer,
    $$TmdbEpisodesTableAnnotationComposer,
    $$TmdbEpisodesTableCreateCompanionBuilder,
    $$TmdbEpisodesTableUpdateCompanionBuilder,
    (
      TmdbEpisodeData,
      BaseReferences<_$AppDatabase, $TmdbEpisodesTable, TmdbEpisodeData>
    ),
    TmdbEpisodeData,
    PrefetchHooks Function()> {
  $$TmdbEpisodesTableTableManager(_$AppDatabase db, $TmdbEpisodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TmdbEpisodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TmdbEpisodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TmdbEpisodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> tmdbId = const Value.absent(),
            Value<int> tvId = const Value.absent(),
            Value<int> seasonNumber = const Value.absent(),
            Value<int> episodeNumber = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> overview = const Value.absent(),
            Value<String> airDate = const Value.absent(),
            Value<int> runtime = const Value.absent(),
            Value<String> lastUpdated = const Value.absent(),
            Value<double> voteAverage = const Value.absent(),
            Value<double> rating = const Value.absent(),
            Value<DateTime> dateRated = const Value.absent(),
            Value<String?> stillPathSuffix = const Value.absent(),
            Value<String?> guestStarsJson = const Value.absent(),
            Value<String?> crewJson = const Value.absent(),
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbEpisodesCompanion(
            id: id,
            tmdbId: tmdbId,
            tvId: tvId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            runtime: runtime,
            lastUpdated: lastUpdated,
            voteAverage: voteAverage,
            rating: rating,
            dateRated: dateRated,
            stillPathSuffix: stillPathSuffix,
            guestStarsJson: guestStarsJson,
            crewJson: crewJson,
            imagesJson: imagesJson,
            videosJson: videosJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int tmdbId,
            required int tvId,
            required int seasonNumber,
            required int episodeNumber,
            required String name,
            required String overview,
            required String airDate,
            required int runtime,
            required String lastUpdated,
            required double voteAverage,
            Value<double> rating = const Value.absent(),
            required DateTime dateRated,
            Value<String?> stillPathSuffix = const Value.absent(),
            Value<String?> guestStarsJson = const Value.absent(),
            Value<String?> crewJson = const Value.absent(),
            Value<String?> imagesJson = const Value.absent(),
            Value<String?> videosJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TmdbEpisodesCompanion.insert(
            id: id,
            tmdbId: tmdbId,
            tvId: tvId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            name: name,
            overview: overview,
            airDate: airDate,
            runtime: runtime,
            lastUpdated: lastUpdated,
            voteAverage: voteAverage,
            rating: rating,
            dateRated: dateRated,
            stillPathSuffix: stillPathSuffix,
            guestStarsJson: guestStarsJson,
            crewJson: crewJson,
            imagesJson: imagesJson,
            videosJson: videosJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TmdbEpisodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TmdbEpisodesTable,
    TmdbEpisodeData,
    $$TmdbEpisodesTableFilterComposer,
    $$TmdbEpisodesTableOrderingComposer,
    $$TmdbEpisodesTableAnnotationComposer,
    $$TmdbEpisodesTableCreateCompanionBuilder,
    $$TmdbEpisodesTableUpdateCompanionBuilder,
    (
      TmdbEpisodeData,
      BaseReferences<_$AppDatabase, $TmdbEpisodesTable, TmdbEpisodeData>
    ),
    TmdbEpisodeData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserListEntriesTableTableManager get userListEntries =>
      $$UserListEntriesTableTableManager(_db, _db.userListEntries);
  $$TmdbTitlesTableTableManager get tmdbTitles =>
      $$TmdbTitlesTableTableManager(_db, _db.tmdbTitles);
  $$TmdbSeasonsTableTableManager get tmdbSeasons =>
      $$TmdbSeasonsTableTableManager(_db, _db.tmdbSeasons);
  $$TmdbEpisodesTableTableManager get tmdbEpisodes =>
      $$TmdbEpisodesTableTableManager(_db, _db.tmdbEpisodes);
}
