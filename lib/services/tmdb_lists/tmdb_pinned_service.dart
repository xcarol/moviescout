import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbPinnedService extends TmdbTitleListService {
  TmdbPinnedService(TmdbTitleRepository repository)
      : super(AppConstants.pinnedlist, repository);

  void clearPinnedStatus() {
    clearLoadedItems(resetCount: true);
  }

  Future<void> fetchAndApplyPinnedTitles() async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await SupabaseService()
          .client
          .from('user_list_items')
          .select('tmdb_id, media_type, created_at')
          .eq('user_id', userId)
          .eq('list_name', AppConstants.pinnedlist);

      final List<TmdbTitle> titles = [];
      final List<DateTime> dates = [];

      for (var row in response) {
        final title = TmdbTitle(
          tmdbId: row['tmdb_id'],
          mediaType: row['media_type'],
          name: '',
          lastUpdated: AppConstants.defaultDate,
          dateRated: DateTime.fromMillisecondsSinceEpoch(0),
        );
        final addedDate = row['created_at'] != null
            ? DateTime.parse(row['created_at'])
            : DateTime.now();
        title.addedDate = addedDate;
        title.inLists = [...title.inLists, AppConstants.pinnedlist];

        titles.add(title);
        dates.add(addedDate);
      }

      if (titles.isNotEmpty) {
        await repository.saveTitles(titles, AppConstants.pinnedlist,
            addedDates: dates);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error retrieving pinned list from Supabase',
      );
    }

    await filterItems();
  }

  Future<bool> addPinnedToDatabase(TmdbTitle title) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final now = DateTime.now();
      await SupabaseService().client.from('user_list_items').upsert({
        'user_id': userId,
        'list_name': AppConstants.pinnedlist,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'created_at': now.toUtc().toIso8601String(),
      }, onConflict: 'user_id, list_name, tmdb_id');

      if (!title.inLists.contains(AppConstants.pinnedlist)) {
        title.inLists = [...title.inLists, AppConstants.pinnedlist];
      }
      await repository.saveTitle(title, AppConstants.pinnedlist, now);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error pinning title to Supabase',
      );
    }
    return false;
  }

  Future<bool> removePinnedFromDatabase(TmdbTitle title) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await SupabaseService().client.from('user_list_items').delete().match({
        'user_id': userId,
        'list_name': AppConstants.pinnedlist,
        'tmdb_id': title.tmdbId,
      });

      title.inLists =
          title.inLists.where((l) => l != AppConstants.pinnedlist).toList();
      await repository.deleteTitle(
          AppConstants.pinnedlist, title.tmdbId, title.mediaType);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error unpinning title from Supabase',
      );
    }
    return false;
  }
}
