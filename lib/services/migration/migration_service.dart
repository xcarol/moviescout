import 'package:flutter/material.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/services/core/supabase_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_watchlist_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_rateslist_service.dart';

class MigrationService with ChangeNotifier {
  final TmdbTitleRepository repository;

  MigrationService(this.repository);

  bool get hasMigrated =>
      PreferencesService().prefs.getBool('hasMigratedToSupabase') ?? false;
  bool _isMigrating = false;
  bool get isMigrating => _isMigrating;

  Future<void> migrateToSupabase(BuildContext context) async {
    if (hasMigrated) return;
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return;

    _isMigrating = true;
    notifyListeners();

    try {
      // Migrate Watchlist from local repository to Supabase
      final watchlist = await repository.getTitles(
        listName: AppConstants.watchlist,
        sortOption: SortOption.addedDate,
        sortAscending: true,
        limit: 10000,
      );
      for (final title in watchlist) {
        await SupabaseService().client.from('user_list_items').upsert({
          'user_id': userId,
          'list_name': AppConstants.watchlist,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'created_at': title.addedDate?.toUtc().toIso8601String(),
        }, onConflict: 'user_id, list_name, tmdb_id');
      }

      // Migrate Rateslist from local repository to Supabase
      final rateslist = await repository.getTitles(
        listName: AppConstants.rateslist,
        sortOption: SortOption.addedDate,
        sortAscending: true,
        limit: 10000,
      );
      for (final title in rateslist) {
        await SupabaseService().client.from('user_list_items').upsert({
          'user_id': userId,
          'list_name': AppConstants.rateslist,
          'tmdb_id': title.tmdbId,
          'media_type': title.mediaType,
          'rate': title.rating,
          'created_at': title.addedDate?.toUtc().toIso8601String(),
          'date_rated': title.dateRated.year > 2000
              ? title.dateRated.toUtc().toIso8601String()
              : null,
        }, onConflict: 'user_id, list_name, tmdb_id');
      }

      // Set migration flag to true
      await PreferencesService().prefs.setBool('hasMigratedToSupabase', true);

      // We can also trigger a re-sync of the providers and configuration lists
      // as they have their own migration logic when they fetch from Supabase.
      if (context.mounted) {
        final watchlistService =
            Provider.of<TmdbWatchlistService>(context, listen: false);
        final rateslistService =
            Provider.of<TmdbRateslistService>(context, listen: false);
        // Force refresh from Supabase to ensure everything is in sync
        final locale = Localizations.localeOf(context);
        await watchlistService.retrieveWatchlist('', '', locale,
            forceUpdate: true);
        await rateslistService.retrieveRateslist('', '', locale,
            forceUpdate: true);
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error during data migration to Supabase',
      );
    } finally {
      _isMigrating = false;
      notifyListeners();
    }
  }

  bool get hasMigratedPinnedFollowing =>
      PreferencesService().prefs.getBool('hasMigratedPinnedFollowing') ?? false;

  Future<void> migratePinnedAndFollowing(BuildContext context) async {
    if (hasMigratedPinnedFollowing) return;
    final userId = SupabaseService().client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Migrate Pinned
      final pinnedEntries = await repository.getAllEntries(AppConstants.pinnedlist);
      for (var entry in pinnedEntries) {
        await SupabaseService().client.from('user_list_items').upsert({
          'user_id': userId,
          'list_name': AppConstants.pinnedlist,
          'media_type': entry.mediaType,
          'tmdb_id': entry.tmdbId,
          'created_at': entry.addedDate.toUtc().toIso8601String(),
        }, onConflict: 'user_id, list_name, tmdb_id');
      }

      // Migrate Following
      final followingEntries = await repository.getAllEntries(AppConstants.followinglist);
      for (var entry in followingEntries) {
        await SupabaseService().client.from('user_list_items').upsert({
          'user_id': userId,
          'list_name': AppConstants.followinglist,
          'media_type': entry.mediaType,
          'tmdb_id': entry.tmdbId,
          'created_at': entry.addedDate.toUtc().toIso8601String(),
        }, onConflict: 'user_id, list_name, tmdb_id');
      }

      await PreferencesService()
          .prefs
          .setBool('hasMigratedPinnedFollowing', true);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error during pinned/following migration to Supabase',
      );
    }
  }
}
