import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

abstract class TmdbConfigListService extends TmdbBaseService
    with ChangeNotifier {
  final String configListName;
  final String listIdPrefKey;
  final String firestoreFieldName;

  String _accessToken = '';
  String _accountId = '';
  String _sessionId = '';
  String _listId = '';
  DocumentReference? _docRef;

  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;
  bool _isMigrating = false;

  TmdbConfigListService({
    required this.configListName,
    required this.listIdPrefKey,
    required this.firestoreFieldName,
  });

  @protected
  String get accessToken => _accessToken;
  @protected
  String get accountId => _accountId;
  @protected
  String get sessionId => _sessionId;

  String get listId {
    if (_listId.isEmpty) {
      _listId = PreferencesService().prefs.getString(listIdPrefKey) ?? '';
    }
    return _listId;
  }

  @protected
  set listId(String value) {
    _listId = value;
    PreferencesService().prefs.setString(listIdPrefKey, value);
  }

  void clearConfig() {
    listId = '';
    _firestoreSubscription?.cancel();
    _firestoreSubscription = null;
    _docRef = null;
  }

  @protected
  void setupBase(String accountId, String sessionId, String accessToken) {
    _accountId = accountId;
    _sessionId = sessionId;
    _accessToken = accessToken;
    if (accountId.isNotEmpty && Firebase.apps.isNotEmpty) {
      _docRef = FirebaseFirestore.instance.collection('users').doc(accountId);
    }
  }

  // Abstract methods to be implemented by child classes
  @protected
  Future<dynamic> migrateDataFromTmdb();

  @protected
  Future<void> applyData(dynamic data);

  Future<void> fetchAndListen() async {
    if (_docRef == null || Firebase.apps.isEmpty) return;

    try {
      final snapshot =
          await _docRef!.get(const GetOptions(source: Source.serverAndCache));
      if (snapshot.exists &&
          snapshot.data() != null &&
          (snapshot.data() as Map<String, dynamic>)
              .containsKey(firestoreFieldName)) {
        final data =
            (snapshot.data() as Map<String, dynamic>)[firestoreFieldName];
        await applyData(data);
      } else {
        if (!_isMigrating) {
          _isMigrating = true;
          final legacyData = await migrateDataFromTmdb();
          if (legacyData != null) {
            await _docRef!
                .set({firestoreFieldName: legacyData}, SetOptions(merge: true));
            await applyData(legacyData);
          }
          _isMigrating = false;
        }
      }
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error fetching config $firestoreFieldName');
    }

    _firestoreSubscription ??= _docRef!.snapshots().listen((snapshot) async {
      if (snapshot.exists &&
          snapshot.data() != null &&
          (snapshot.data() as Map<String, dynamic>)
              .containsKey(firestoreFieldName)) {
        final data =
            (snapshot.data() as Map<String, dynamic>)[firestoreFieldName];
        await applyData(data);
      }
    }, onError: (error, stackTrace) {
      ErrorService.log(error,
          stackTrace: stackTrace,
          userMessage: 'Error listening to config $firestoreFieldName');
    });
  }

  @protected
  Future<bool> updateToFirebase(dynamic data) async {
    if (_docRef == null || Firebase.apps.isEmpty) return false;
    try {
      await _docRef!.set({firestoreFieldName: data}, SetOptions(merge: true));
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error saving config $firestoreFieldName');
      return false;
    }
  }

  @protected
  Future<bool> updateArrayInFirebase(String item, bool add) async {
    if (_docRef == null || Firebase.apps.isEmpty) return false;
    try {
      await _docRef!.set({
        firestoreFieldName:
            add ? FieldValue.arrayUnion([item]) : FieldValue.arrayRemove([item])
      }, SetOptions(merge: true));
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e,
          stackTrace: stackTrace,
          userMessage: 'Error updating array $firestoreFieldName');
      return false;
    }
  }

  // --- LEGACY TMDB METHODS (used only for migration) ---

  @protected
  Future<String?> getOrFetchListId() async {
    if (listId.isEmpty) {
      await retrieveServerListId();
    }
    return listId.isNotEmpty ? listId : null;
  }

  Future<void> retrieveServerListId() async {
    if (_accountId.isEmpty) return;
    try {
      final response =
          await get('/account/$_accountId/lists?session_id=$_sessionId');
      if (response.statusCode == 200) {
        final List<dynamic> lists = jsonDecode(response.body)['results'];
        final list = lists.firstWhere(
          (dynamic l) => l['name'] == configListName,
          orElse: () => null,
        );
        if (list != null) {
          listId = list['id'].toString();
        }
      }
    } catch (error, stackTrace) {
      ErrorService.log(
        error,
        stackTrace: stackTrace,
        userMessage: 'Error retrieving list ID for $configListName',
      );
    }
  }

  @protected
  Future<String?> fetchConfigFromServer() async {
    if (_accountId.isEmpty || _accessToken.isEmpty) return null;

    try {
      final String? currentListId = await getOrFetchListId();
      if (currentListId == null) return null;

      final response = await get('/list/$currentListId',
          version: ApiVersion.v4, accessToken: _accessToken);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['description'] as String?;
      } else if (response.statusCode == 404) {
        listId = ''; // Reset if not found
        return '';
      }
    } catch (e) {
      // Silent catch for migration
    }
    return null;
  }
}
