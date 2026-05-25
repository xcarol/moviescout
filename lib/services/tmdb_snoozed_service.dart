import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_config_list_service.dart';
import 'package:moviescout/services/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/tmdb_list_service.dart';

class TmdbSnoozedService extends TmdbConfigListService {
  final TmdbTitleRepository repository;

  TmdbSnoozedService(this.repository)
      : super(
          configListName: 'snoozed',
          listIdPrefKey: 'snoozedListId',
        );

  void clearSnoozedStatus() {
    clearConfig();
  }

  Future<void> setup(
      String accountId, String sessionId, String accessToken) async {
    setupBase(accountId, sessionId, accessToken);
  }

  Future<void> fetchAndApplySnoozedTitles() async {
    final currentListId = await getOrFetchListId();
    if (currentListId == null || currentListId.isEmpty) return;

    try {
      final response = await get('/list/$currentListId?page=1',
          version: ApiVersion.v4, accessToken: accessToken);

      if (response.statusCode == 200) {
        final data = body(response);
        final results = data['results'] as List<dynamic>? ?? [];

        final List<String> snoozedIds = [];
        for (var item in results) {
          final mediaType = item['media_type'];
          final id = item['id'];
          snoozedIds.add('$mediaType:$id');
        }

        await _applySnoozedIds(snoozedIds);
        notifyListeners();
      } else if (response.statusCode == 404) {
        listId = ''; // Reset if not found
        await _applySnoozedIds([]);
        notifyListeners();
      } else {
        ErrorService.log(
          'TMDB API Error: ${response.statusCode} - ${response.body}',
          userMessage: 'Error fetching snoozed configuration',
          showSnackBar: false,
          reportToCrashlytics: true,
        );
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error fetching snoozed titles',
        showSnackBar: false,
        reportToCrashlytics: true,
      );
    }
  }

  Future<void> _applySnoozedIds(List<String> snoozedIds) async {
    final currentSnoozed = await repository.getTitles(
      listName: AppConstants.rateslist,
      filterRating: RatingFilter.snoozedOnly,
    );

    final Map<int, TmdbTitle> toUpdate = {};

    // Reset current snoozes
    for (var title in currentSnoozed) {
      title.isSnoozed = false;
      toUpdate[title.id] = title;
    }

    // Set new snoozes
    for (var item in snoozedIds) {
      final parts = item.split(':');
      if (parts.length == 2) {
        final mediaType = parts[0];
        final tmdbId = int.tryParse(parts[1]);
        if (tmdbId != null) {
          final title = await repository.getTitleByTmdbId(
              AppConstants.rateslist, tmdbId, mediaType);
          if (title != null) {
            title.isSnoozed = true;
            toUpdate[title.id] = title;
          }
        }
      }
    }

    if (toUpdate.isNotEmpty) {
      await repository.updateTitlesMetadata(toUpdate.values.toList());
    }
  }

  Future<bool> addSnoozedToServer(TmdbTitle title) async {
    String? currentListId = await getOrFetchListId();
    // ensure list exists
    currentListId ??= await createServerList(forced: true);

    if (currentListId == null) return false;

    final requestBody = {
      'items': [
        {
          'media_type': title.mediaType,
          'media_id': title.tmdbId,
        }
      ]
    };

    try {
      final response = await post('list/$currentListId/items', requestBody,
          version: ApiVersion.v4, accessToken: accessToken);
      if (response.statusCode == 200) {
        return true;
      } else {
        ErrorService.log(
          'TMDB API Error: ${response.statusCode} - ${response.body}',
          userMessage: 'Error adding snoozed to server',
          showSnackBar: false,
          reportToCrashlytics: true,
        );
        return false;
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Exception adding snoozed to server',
        showSnackBar: false,
        reportToCrashlytics: true,
      );
      return false;
    }
  }

  Future<bool> removeSnoozedFromServer(TmdbTitle title) async {
    final currentListId = await getOrFetchListId();
    if (currentListId == null || currentListId.isEmpty) return false;

    final requestBody = {
      'items': [
        {
          'media_type': title.mediaType,
          'media_id': title.tmdbId,
        }
      ]
    };

    try {
      final response = await delete('list/$currentListId/items',
          body: requestBody, version: ApiVersion.v4, accessToken: accessToken);
      if (response.statusCode == 200) {
        return true;
      } else {
        ErrorService.log(
          'TMDB API Error: ${response.statusCode} - ${response.body}',
          userMessage: 'Error removing snoozed from server',
          showSnackBar: false,
          reportToCrashlytics: true,
        );
        return false;
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Exception removing snoozed from server',
        showSnackBar: false,
        reportToCrashlytics: true,
      );
      return false;
    }
  }
}
