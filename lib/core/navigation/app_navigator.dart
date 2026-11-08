import 'package:flutter/material.dart';
import 'package:moviescout/features/discovery/models/tmdb_collection.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/features/auth/models/user_profile.dart';
import 'package:moviescout/features/settings/screens/ai_settings.dart';
import 'package:moviescout/features/discovery/screens/collection_details.dart';
import 'package:moviescout/features/seasons/screens/episode_details.dart';
import 'package:moviescout/features/discovery/screens/genres.dart';
import 'package:moviescout/features/import/screens/import_imdb.dart';
import 'package:moviescout/features/import/screens/import_tmdb.dart';
import 'package:moviescout/features/auth/screens/login.dart';
import 'package:moviescout/features/settings/screens/logs_screen.dart';
import 'package:moviescout/features/notifications/screens/notifications_screen.dart';
import 'package:moviescout/features/people/screens/person_details.dart';
import 'package:moviescout/features/people/screens/person_titles.dart';
import 'package:moviescout/features/settings/screens/providers.dart';
import 'package:moviescout/features/seasons/screens/season_details.dart';
import 'package:moviescout/features/settings/screens/settings.dart';
import 'package:moviescout/features/titles/screens/title_details.dart';
import 'package:moviescout/features/titles/screens/title_people_list.dart';
import 'package:moviescout/features/titles/screens/translations.dart';
import 'package:moviescout/features/auth/screens/user_details.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(builder: (_) => screen),
    );
  }
}

extension AppNavigatorExtension on BuildContext {
  Future<T?> toTitleDetails<T>(
    TmdbTitle title,
    TmdbTitleListService tmdbListService,
  ) {
    return AppNavigator.push<T>(
      this,
      TitleDetails(
        title: title,
        tmdbListService: tmdbListService,
      ),
    );
  }

  Future<T?> toPersonDetails<T>(
    TmdbPerson person,
    TmdbTitleListService tmdbListService, {
    TmdbTitle? titleContext,
    TmdbSeason? seasonContext,
    TmdbEpisode? episodeContext,
  }) {
    return AppNavigator.push<T>(
      this,
      PersonDetails(
        person: person,
        tmdbListService: tmdbListService,
        titleContext: titleContext,
        seasonContext: seasonContext,
        episodeContext: episodeContext,
      ),
    );
  }

  Future<T?> toSeasonDetails<T>(
    TmdbTitle title,
    int seasonNumber,
    TmdbTitleListService tmdbListService,
  ) {
    return AppNavigator.push<T>(
      this,
      SeasonDetails(
        title: title,
        seasonNumber: seasonNumber,
        tmdbListService: tmdbListService,
      ),
    );
  }

  Future<T?> toEpisodeDetails<T>({
    required TmdbTitle title,
    required int seasonNumber,
    required int episodeNumber,
    required TmdbTitleListService tmdbListService,
    TmdbEpisode? initialEpisode,
    int totalEpisodes = 0,
  }) {
    return AppNavigator.push<T>(
      this,
      EpisodeDetails(
        title: title,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
        tmdbListService: tmdbListService,
        initialEpisode: initialEpisode,
        totalEpisodes: totalEpisodes,
      ),
    );
  }

  Future<T?> toCollectionDetails<T>(
    TmdbCollection collection,
    TmdbTitleListService tmdbListService,
  ) {
    return AppNavigator.push<T>(
      this,
      CollectionDetails(
        collection: collection,
        tmdbListService: tmdbListService,
      ),
    );
  }

  Future<T?> toTitlePeopleList<T>(
    TmdbTitle title,
    String type,
    TmdbTitleListService tmdbListService,
  ) {
    return AppNavigator.push<T>(
      this,
      TitlePeopleList(
        title: title,
        type: type,
        tmdbListService: tmdbListService,
      ),
    );
  }

  Future<T?> toUserDetails<T>(UserProfile user) {
    return AppNavigator.push<T>(
      this,
      UserDetails(user: user),
    );
  }

  Future<T?> toSettings<T>() {
    return AppNavigator.push<T>(this, const SettingsScreen());
  }

  Future<T?> toNotifications<T>() {
    return AppNavigator.push<T>(this, const NotificationsScreen());
  }

  Future<T?> toAiSettings<T>() {
    return AppNavigator.push<T>(this, const AiSettingsScreen());
  }

  Future<T?> toLogs<T>() {
    return AppNavigator.push<T>(this, const LogsScreen());
  }

  Future<T?> toProviders<T>() {
    return AppNavigator.push<T>(this, const ProvidersScreen());
  }

  Future<T?> toGenres<T>({
    required List<String> genresList,
    required List<String> selectedGenres,
    required bool excludeGenres,
    required void Function(List<String>, bool) onGenresChanged,
  }) {
    return AppNavigator.push<T>(
      this,
      GenresScreen(
        genresList: genresList,
        selectedGenres: selectedGenres,
        excludeGenres: excludeGenres,
        onGenresChanged: onGenresChanged,
      ),
    );
  }

  Future<T?> toLogin<T>() {
    return AppNavigator.push<T>(this, const Login());
  }

  Future<T?> toPersonTitles<T>(
    TmdbPerson person, {
    PersonTitleRole role = PersonTitleRole.character,
  }) {
    return AppNavigator.push<T>(
      this,
      PersonTitles(
        person: person,
        role: role,
      ),
    );
  }

  Future<T?> toTranslations<T>({
    required List<TmdbTranslation> translations,
    required String originalTitle,
    required String originalDescription,
    required String editUrl,
  }) {
    return AppNavigator.push<T>(
      this,
      TranslationsScreen(
        translations: translations,
        originalTitle: originalTitle,
        originalDescription: originalDescription,
        editUrl: editUrl,
      ),
    );
  }

  Future<T?> toImportTmdb<T>() {
    return AppNavigator.push<T>(this, const ImportTmdbScreen());
  }

  Future<T?> toImportImdb<T>() {
    return AppNavigator.push<T>(this, const ImportIMDB());
  }
}
