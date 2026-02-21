import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

abstract class TmdbConfigListService extends TmdbBaseService
    with ChangeNotifier {
  final String configListName;
  final String listIdPrefKey;

  String _accessToken = '';
  String _accountId = '';
  String _sessionId = '';
  String _listId = '';

  TmdbConfigListService({
    required this.configListName,
    required this.listIdPrefKey,
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
  }

  @protected
  void setupBase(String accountId, String sessionId, String accessToken) {
    _accountId = accountId;
    _sessionId = sessionId;
    _accessToken = accessToken;
  }

  @protected
  Future<String?> _getOrFetchListId() async {
    if (listId.isEmpty) {
      await _retrieveServerListId();
    }
    return listId.isNotEmpty ? listId : null;
  }

  Future<void> _retrieveServerListId() async {
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
        showSnackBar: false,
      );
    }
  }

  @protected
  Future<String?> _createServerList({bool forced = false}) async {
    if (listId.isNotEmpty && !forced) {
      return listId;
    }

    const String url = 'list';
    final Map<String, dynamic> body = {
      'name': configListName,
      'iso_639_1': 'ca',
      'description': '',
      'public': false,
    };

    try {
      final response = await post(
        url,
        body,
        version: ApiVersion.v4,
        accessToken: _accessToken,
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        listId = json['id'].toString();
        return listId;
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error creating configuration list: $configListName',
        showSnackBar: false,
      );
    }
    return null;
  }

  @protected
  Future<bool> updateConfigToServer(String configuration,
      {String? userErrorMessage}) async {
    if (_accountId.isEmpty) return false;

    String? currentListId = await _getOrFetchListId();
    currentListId = await _createServerList(forced: currentListId == null);

    if (currentListId == null) return false;

    final url = 'list/$currentListId';
    final Map<String, dynamic> body = {
      'description': configuration,
    };

    try {
      final response = await put(
        url,
        body,
        version: ApiVersion.v4,
        accessToken: _accessToken,
      );

      if (response.statusCode == 404) {
        // List missing on server, retry once with creation
        currentListId = await _createServerList(forced: true);
        if (currentListId == null) return false;

        final retryResponse = await put(
          'list/$currentListId',
          body,
          version: ApiVersion.v4,
          accessToken: _accessToken,
        );

        if (retryResponse.statusCode == 201 ||
            retryResponse.statusCode == 200) {
          return true;
        }

        ErrorService.log(
          'TMDB API Retry Error: ${retryResponse.statusCode} - ${retryResponse.body}',
          userMessage:
              userErrorMessage ?? 'Error updating server configuration',
        );
        return false;
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }

      ErrorService.log(
        'TMDB API Error: ${response.statusCode} - ${response.body}',
        userMessage: userErrorMessage ?? 'Error updating server configuration',
      );
      return false;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: userErrorMessage ?? 'Error updating server configuration',
      );
      return false;
    }
  }

  @protected
  Future<String?> fetchConfigFromServer() async {
    if (_accountId.isEmpty || _accessToken.isEmpty) return null;

    try {
      final String? currentListId = await _getOrFetchListId();
      if (currentListId == null) return null;

      final response = await get('/list/$currentListId',
          version: ApiVersion.v4, accessToken: _accessToken);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['description'] as String?;
      } else if (response.statusCode == 404) {
        listId = ''; // Reset if not found
        return '';
      } else {
        ErrorService.log(
          'TMDB API Error: ${response.statusCode} - ${response.body}',
          userMessage: 'Error fetching configuration',
          showSnackBar: false,
        );
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error fetching configuration',
        showSnackBar: false,
      );
    }
    return null;
  }
}
