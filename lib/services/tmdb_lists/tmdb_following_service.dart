import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class TmdbFollowingService extends TmdbTitleListService {
  TmdbFollowingService(TmdbTitleRepository repository)
      : super(AppConstants.followinglist, repository);

  void clearFollowingStatus() {
    clearLoadedItems(resetCount: true);
  }

  Future<void> fetchAndApplyFollowingTitles() async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await SupabaseService()
          .client
          .from('user_list_items')
          .select('tmdb_id, media_type, created_at')
          .eq('user_id', userId)
          .eq('list_name', AppConstants.followinglist);

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
        title.inLists = [...title.inLists, AppConstants.followinglist];

        titles.add(title);
        dates.add(addedDate);
      }

      if (titles.isNotEmpty) {
        await repository.saveTitles(titles, AppConstants.followinglist,
            addedDates: dates);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error retrieving following list from Supabase',
      );
    }

    await filterItems();
  }

  Future<bool> addFollowingToDatabase(TmdbTitle title) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final now = DateTime.now();
      await SupabaseService().client.from('user_list_items').upsert({
        'user_id': userId,
        'list_name': AppConstants.followinglist,
        'tmdb_id': title.tmdbId,
        'media_type': title.mediaType,
        'created_at': now.toUtc().toIso8601String(),
      }, onConflict: 'user_id, list_name, tmdb_id');

      if (!title.inLists.contains(AppConstants.followinglist)) {
        title.inLists = [...title.inLists, AppConstants.followinglist];
      }
      await repository.saveTitle(title, AppConstants.followinglist, now);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error adding to following to Supabase',
      );
    }
    return false;
  }

  Future<bool> removeFollowingFromDatabase(TmdbTitle title) async {
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      await SupabaseService().client.from('user_list_items').delete().match({
        'user_id': userId,
        'list_name': AppConstants.followinglist,
        'tmdb_id': title.tmdbId,
      });

      title.inLists =
          title.inLists.where((l) => l != AppConstants.followinglist).toList();
      await repository.deleteTitle(
          AppConstants.followinglist, title.tmdbId, title.mediaType);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error removing from following from Supabase',
      );
    }
    return false;
  }
}
