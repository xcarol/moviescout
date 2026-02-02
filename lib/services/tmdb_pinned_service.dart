import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/utils/app_constants.dart';

const String _pinnedListName = 'pinned';
const String _tmdbLists = '/list/{LIST_ID}';
const String _pinnedListIdKey = 'pinnedListId';

class TmdbPinnedService extends TmdbBaseService with ChangeNotifier {
  final TmdbTitleRepository repository;
  final PreferencesService preferencesService;

  String _accessToken = '';
  String _accountId = '';
  String _sessionId = '';

  TmdbPinnedService(this.repository, this.preferencesService);

  void clearPinnedStatus() {
    preferencesService.prefs.setString(_pinnedListIdKey, '');
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    _accountId = accountId;
    _sessionId = sessionId;
    _accessToken = accessToken;
  }

  Future<String?> _getListId() async {
    String listId = preferencesService.prefs.getString(_pinnedListIdKey) ?? '';
    if (listId.isEmpty) {
      listId = await _retrieveServerPinnedListId() ?? '';
    }
    return listId.isNotEmpty ? listId : null;
  }

  Future<void> fetchAndApplyPinnedTitles() async {
    if (_accountId.isEmpty || _sessionId.isEmpty || _accessToken.isEmpty) {
      return;
    }

    try {
      final String? listId = await _getListId();
      if (listId == null) return;

      final response = await get(_tmdbLists.replaceFirst('{LIST_ID}', listId),
          accessToken: _accessToken);

      if (response.statusCode != 200) {
        preferencesService.prefs.setString(_pinnedListIdKey, '');
        return;
      }

      final data = jsonDecode(response.body);
      final String? pinnedString = data['description'];

      if (pinnedString == null || pinnedString.isEmpty) {
        await _applyPinnedIds([]);
        return;
      }

      final pinnedIds =
          pinnedString.split(',').where((s) => s.isNotEmpty).toList();

      await _applyPinnedIds(pinnedIds);
    } catch (e) {
      debugPrint('Error in fetchAndApplyPinnedTitles: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _applyPinnedIds(List<String> pinnedIds) async {
    final currentPinned = await repository.getTitles(
      listName: AppConstants.watchlist,
      pinned: true,
    );

    final Map<int, TmdbTitle> toUpdate = {};

    // 1. Reset current pins in map
    for (var title in currentPinned) {
      title.isPinned = false;
      toUpdate[title.id] = title;
    }

    // 2. Set new pins from server
    for (var item in pinnedIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          final title = repository.getTitleByTmdbId(
              AppConstants.watchlist, tmdbId, mediaType);
          if (title != null) {
            title.isPinned = true;
            toUpdate[title.id] = title;
          }
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.saveTitles(toUpdate.values.toList());
    }
  }

  Future<String?> _retrieveServerPinnedListId() async {
    final response =
        await get('/account/$_accountId/lists?session_id=$_sessionId');
    if (response.statusCode == 200) {
      final List<dynamic> lists = jsonDecode(response.body)['results'];
      final pinnedList = lists.firstWhere(
        (dynamic list) => list['name'] == _pinnedListName,
        orElse: () => null,
      );
      if (pinnedList != null) {
        final String listId = pinnedList['id'].toString();
        preferencesService.prefs.setString(_pinnedListIdKey, listId);
        return listId;
      }
    }
    return null;
  }

  Future<String?> _createServerPinnedList(
      {String? existingId, bool forced = false}) async {
    if (existingId != null && existingId.isNotEmpty && !forced) {
      return existingId;
    }

    const String url = 'list';
    final Map<String, dynamic> body = {
      'name': _pinnedListName,
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
        final String listId = json['id'].toString();
        preferencesService.prefs.setString(_pinnedListIdKey, listId);
        return listId;
      }
    } catch (e) {
      debugPrint('Error creating pinned list: $e');
    }
    return null;
  }

  Future<String> _pinnedToString() async {
    final pinnedTitles = await repository.getTitles(
      listName: AppConstants.watchlist,
      pinned: true,
    );
    return pinnedTitles.map((t) => '${t.mediaType}:${t.tmdbId}').join(',');
  }

  Future<bool> updatePinnedToServer() async {
    if (_accountId.isEmpty) return false;

    String? listId = await _getListId();
    listId = await _createServerPinnedList(existingId: listId);

    if (listId == null) return false;

    final url = 'list/$listId';
    final description = await _pinnedToString();
    final Map<String, dynamic> body = {
      'description': description,
    };

    try {
      final response = await put(
        url,
        body,
        version: ApiVersion.v4,
        accessToken: _accessToken,
      );

      if (response.statusCode == 404) {
        listId = await _createServerPinnedList(forced: true);
        if (listId == null) return false;

        final retryResponse = await put(
          'list/$listId',
          body,
          version: ApiVersion.v4,
          accessToken: _accessToken,
        );
        return retryResponse.statusCode == 201;
      }

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error updating pinned to server: $e');
      return false;
    }
  }
}
