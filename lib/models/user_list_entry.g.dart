// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserListEntryCollection on Isar {
  IsarCollection<UserListEntry> get userListEntrys => this.collection();
}

const UserListEntrySchema = CollectionSchema(
  name: r'UserListEntry',
  id: -6345057179667481926,
  properties: {
    r'addedOrder': PropertySchema(
      id: 0,
      name: r'addedOrder',
      type: IsarType.long,
    ),
    r'listName': PropertySchema(
      id: 1,
      name: r'listName',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 2,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(
      id: 3,
      name: r'tmdbId',
      type: IsarType.long,
    )
  },
  estimateSize: _userListEntryEstimateSize,
  serialize: _userListEntrySerialize,
  deserialize: _userListEntryDeserialize,
  deserializeProp: _userListEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'listName_tmdbId_mediaType': IndexSchema(
      id: -4085083028181888544,
      name: r'listName_tmdbId_mediaType',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'listName',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'tmdbId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'mediaType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'addedOrder': IndexSchema(
      id: 510594138678657050,
      name: r'addedOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'addedOrder',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userListEntryGetId,
  getLinks: _userListEntryGetLinks,
  attach: _userListEntryAttach,
  version: '3.3.0',
);

int _userListEntryEstimateSize(
  UserListEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.listName.length * 3;
  bytesCount += 3 + object.mediaType.length * 3;
  return bytesCount;
}

void _userListEntrySerialize(
  UserListEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.addedOrder);
  writer.writeString(offsets[1], object.listName);
  writer.writeString(offsets[2], object.mediaType);
  writer.writeLong(offsets[3], object.tmdbId);
}

UserListEntry _userListEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserListEntry(
    addedOrder: reader.readLong(offsets[0]),
    listName: reader.readString(offsets[1]),
    mediaType: reader.readString(offsets[2]),
    tmdbId: reader.readLong(offsets[3]),
  );
  object.id = id;
  return object;
}

P _userListEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userListEntryGetId(UserListEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userListEntryGetLinks(UserListEntry object) {
  return [];
}

void _userListEntryAttach(
    IsarCollection<dynamic> col, Id id, UserListEntry object) {
  object.id = id;
}

extension UserListEntryByIndex on IsarCollection<UserListEntry> {
  Future<UserListEntry?> getByListNameTmdbIdMediaType(
      String listName, int tmdbId, String mediaType) {
    return getByIndex(
        r'listName_tmdbId_mediaType', [listName, tmdbId, mediaType]);
  }

  UserListEntry? getByListNameTmdbIdMediaTypeSync(
      String listName, int tmdbId, String mediaType) {
    return getByIndexSync(
        r'listName_tmdbId_mediaType', [listName, tmdbId, mediaType]);
  }

  Future<bool> deleteByListNameTmdbIdMediaType(
      String listName, int tmdbId, String mediaType) {
    return deleteByIndex(
        r'listName_tmdbId_mediaType', [listName, tmdbId, mediaType]);
  }

  bool deleteByListNameTmdbIdMediaTypeSync(
      String listName, int tmdbId, String mediaType) {
    return deleteByIndexSync(
        r'listName_tmdbId_mediaType', [listName, tmdbId, mediaType]);
  }

  Future<List<UserListEntry?>> getAllByListNameTmdbIdMediaType(
      List<String> listNameValues,
      List<int> tmdbIdValues,
      List<String> mediaTypeValues) {
    final len = listNameValues.length;
    assert(tmdbIdValues.length == len && mediaTypeValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([listNameValues[i], tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return getAllByIndex(r'listName_tmdbId_mediaType', values);
  }

  List<UserListEntry?> getAllByListNameTmdbIdMediaTypeSync(
      List<String> listNameValues,
      List<int> tmdbIdValues,
      List<String> mediaTypeValues) {
    final len = listNameValues.length;
    assert(tmdbIdValues.length == len && mediaTypeValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([listNameValues[i], tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return getAllByIndexSync(r'listName_tmdbId_mediaType', values);
  }

  Future<int> deleteAllByListNameTmdbIdMediaType(List<String> listNameValues,
      List<int> tmdbIdValues, List<String> mediaTypeValues) {
    final len = listNameValues.length;
    assert(tmdbIdValues.length == len && mediaTypeValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([listNameValues[i], tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return deleteAllByIndex(r'listName_tmdbId_mediaType', values);
  }

  int deleteAllByListNameTmdbIdMediaTypeSync(List<String> listNameValues,
      List<int> tmdbIdValues, List<String> mediaTypeValues) {
    final len = listNameValues.length;
    assert(tmdbIdValues.length == len && mediaTypeValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([listNameValues[i], tmdbIdValues[i], mediaTypeValues[i]]);
    }

    return deleteAllByIndexSync(r'listName_tmdbId_mediaType', values);
  }

  Future<Id> putByListNameTmdbIdMediaType(UserListEntry object) {
    return putByIndex(r'listName_tmdbId_mediaType', object);
  }

  Id putByListNameTmdbIdMediaTypeSync(UserListEntry object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'listName_tmdbId_mediaType', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByListNameTmdbIdMediaType(
      List<UserListEntry> objects) {
    return putAllByIndex(r'listName_tmdbId_mediaType', objects);
  }

  List<Id> putAllByListNameTmdbIdMediaTypeSync(List<UserListEntry> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'listName_tmdbId_mediaType', objects,
        saveLinks: saveLinks);
  }
}

extension UserListEntryQueryWhereSort
    on QueryBuilder<UserListEntry, UserListEntry, QWhere> {
  QueryBuilder<UserListEntry, UserListEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhere> anyAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'addedOrder'),
      );
    });
  }
}

extension UserListEntryQueryWhere
    on QueryBuilder<UserListEntry, UserListEntry, QWhereClause> {
  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameEqualToAnyTmdbIdMediaType(String listName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listName_tmdbId_mediaType',
        value: [listName],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameNotEqualToAnyTmdbIdMediaType(String listName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [],
              upper: [listName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [],
              upper: [listName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameTmdbIdEqualToAnyMediaType(String listName, int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listName_tmdbId_mediaType',
        value: [listName, tmdbId],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameEqualToTmdbIdNotEqualToAnyMediaType(String listName, int tmdbId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName],
              upper: [listName, tmdbId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId],
              includeLower: false,
              upper: [listName],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId],
              includeLower: false,
              upper: [listName],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName],
              upper: [listName, tmdbId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameEqualToTmdbIdGreaterThanAnyMediaType(
    String listName,
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listName_tmdbId_mediaType',
        lower: [listName, tmdbId],
        includeLower: include,
        upper: [listName],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameEqualToTmdbIdLessThanAnyMediaType(
    String listName,
    int tmdbId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listName_tmdbId_mediaType',
        lower: [listName],
        upper: [listName, tmdbId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameEqualToTmdbIdBetweenAnyMediaType(
    String listName,
    int lowerTmdbId,
    int upperTmdbId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listName_tmdbId_mediaType',
        lower: [listName, lowerTmdbId],
        includeLower: includeLower,
        upper: [listName, upperTmdbId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameTmdbIdMediaTypeEqualTo(
          String listName, int tmdbId, String mediaType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listName_tmdbId_mediaType',
        value: [listName, tmdbId, mediaType],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      listNameTmdbIdEqualToMediaTypeNotEqualTo(
          String listName, int tmdbId, String mediaType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId],
              upper: [listName, tmdbId, mediaType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId, mediaType],
              includeLower: false,
              upper: [listName, tmdbId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId, mediaType],
              includeLower: false,
              upper: [listName, tmdbId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listName_tmdbId_mediaType',
              lower: [listName, tmdbId],
              upper: [listName, tmdbId, mediaType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      addedOrderEqualTo(int addedOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'addedOrder',
        value: [addedOrder],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      addedOrderNotEqualTo(int addedOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedOrder',
              lower: [],
              upper: [addedOrder],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedOrder',
              lower: [addedOrder],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedOrder',
              lower: [addedOrder],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'addedOrder',
              lower: [],
              upper: [addedOrder],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      addedOrderGreaterThan(
    int addedOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedOrder',
        lower: [addedOrder],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      addedOrderLessThan(
    int addedOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedOrder',
        lower: [],
        upper: [addedOrder],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterWhereClause>
      addedOrderBetween(
    int lowerAddedOrder,
    int upperAddedOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'addedOrder',
        lower: [lowerAddedOrder],
        includeLower: includeLower,
        upper: [upperAddedOrder],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserListEntryQueryFilter
    on QueryBuilder<UserListEntry, UserListEntry, QFilterCondition> {
  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      addedOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      addedOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      addedOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      addedOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'listName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'listName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      listNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'listName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      tmdbIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      tmdbIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      tmdbIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tmdbId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterFilterCondition>
      tmdbIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tmdbId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserListEntryQueryObject
    on QueryBuilder<UserListEntry, UserListEntry, QFilterCondition> {}

extension UserListEntryQueryLinks
    on QueryBuilder<UserListEntry, UserListEntry, QFilterCondition> {}

extension UserListEntryQuerySortBy
    on QueryBuilder<UserListEntry, UserListEntry, QSortBy> {
  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> sortByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      sortByAddedOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> sortByListName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      sortByListNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }
}

extension UserListEntryQuerySortThenBy
    on QueryBuilder<UserListEntry, UserListEntry, QSortThenBy> {
  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      thenByAddedOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedOrder', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByListName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      thenByListNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listName', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy>
      thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }
}

extension UserListEntryQueryWhereDistinct
    on QueryBuilder<UserListEntry, UserListEntry, QDistinct> {
  QueryBuilder<UserListEntry, UserListEntry, QDistinct> distinctByAddedOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedOrder');
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QDistinct> distinctByListName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QDistinct> distinctByMediaType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserListEntry, UserListEntry, QDistinct> distinctByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId');
    });
  }
}

extension UserListEntryQueryProperty
    on QueryBuilder<UserListEntry, UserListEntry, QQueryProperty> {
  QueryBuilder<UserListEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserListEntry, int, QQueryOperations> addedOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedOrder');
    });
  }

  QueryBuilder<UserListEntry, String, QQueryOperations> listNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listName');
    });
  }

  QueryBuilder<UserListEntry, String, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<UserListEntry, int, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }
}
