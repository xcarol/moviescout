import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PinnedService with ChangeNotifier {
  final TitleRepository repository;
  final SupabaseClient _supabase;

  PinnedService(this.repository, {SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  void clearPinnedStatus() {
    notifyListeners();
  }

  Future<bool> addPinnedToServer(TmdbTitle title) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase
          .from('user_titles')
          .update({'is_pinned': true})
          .eq('user_id', user.id)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.watchlist);
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> removePinnedFromServer(TmdbTitle title) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase
          .from('user_titles')
          .update({'is_pinned': false})
          .eq('user_id', user.id)
          .eq('tmdb_id', title.tmdbId)
          .eq('media_type', title.mediaType)
          .eq('list_name', AppConstants.watchlist);
      return true;
    } catch (e, stackTrace) {
      ErrorService.log(e, stackTrace: stackTrace);
      return false;
    }
  }
}
