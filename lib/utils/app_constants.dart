class AppConstants {
  // List Names
  static const String watchlist = 'watchlist';
  static const String rateslist = 'rateslist';
  static const String discoverlist = 'discoverlist';
  static const String importImdb = 'importImdb';
  static const String searchProvider = 'searchProvider';
  static const String miniseries = 'miniseries';
  static const double seenRating = 0.5;

  // Preference Keys
  static const String lastUpdateSuffix = '_last_update';
  static const String searchHistory = 'search_history';
  static const String themeMode = 'theme_mode';
  static const String themeScheme = 'ThemeScheme';
  static const String language = 'language';
  static const String region = 'region';
  static const String translationSource = 'translation_source';
  static const String translationTarget = 'translation_target';
  static const String lastBackgroundRun = 'last_background_run';
  static const String updateLogs = 'update_logs';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String notifyCompleteSeason = 'notify_complete_season';
  static const String notificationsAsked = 'notifications_asked';
  static const String savedNotifications = 'saved_notifications';
  static const String debugShowLastUpdate = 'debug_show_last_update';
  static const String showEditContent = 'show_edit_content';
  static const String personListIsGridView = 'person_list_is_grid_view';

  static const String catalan = 'ca-ES';
  static const String spanish = 'es-ES';
  static const String english = 'en-US';

  static const List<String> supportedLanguages = [
    catalan,
    spanish,
    english,
  ];

  // Other
  static const String saveLogsMessage = 'saveLogs';
  static const String anonymousAccountId = 'anonymous';
  static const int titleUpToDateDays = 3;
  static const int watchlistTitleUpdateFrequencyDays = 7;
  static const int watchlistProvidersUpdateFrequencyDays = 1;
  static const int watchlistMaxUpdatesPerRun = 50;
  static const int watchlistNewSeasonNotificationWindowDays = 14;
  static const int defaultBatchSize = 25;

  static const String defaultDate = '1970-01-01';

  static const String tmdbApiRat = 'TMDB_API_RAT';
  static const String omdbApiKey = 'OMDB_API_KEY';
  static const String enableLogs = 'ENABLE_LOGS';
  static const String firebaseAuthUrl = 'FIREBASE_AUTH_URL';

  static const String iso3166_1 = 'iso_3166_1';
  static const String iso639_1 = 'iso_639_1';
  static const String name = 'name';
  static const String englishName = 'english_name';
  static const String data = 'data';
  static const String title = 'title';
  static const String biography = 'biography';
  static const String overview = 'overview';
  static const String nativeName = 'native_name';

  static const String sessionId = 'session_id';
  static const String accessToken = 'access_token';
  static const String accountId = 'account_id';
  static const String requestToken = 'request_token';
  static const String success = 'success';
  static const String message = 'message';
  static const String token = 'token';
}
