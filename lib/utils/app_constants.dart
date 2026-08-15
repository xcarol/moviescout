class AppConstants {
  // List Names
  static const String watchlist = 'watchlist';
  static const String rateslist = 'rateslist';
  static const String discoverlist = 'discoverlist';
  static const String importImdb = 'importImdb';
  static const String searchList = 'searchlist';
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
  static const String showEditContent = 'show_edit_content';
  static const String personListIsGridView = 'person_list_is_grid_view';
  static const String aiApiKey = 'ai_api_key';
  static const String aiTranslationEnabled = 'ai_translation_enabled';
  static const String aiModel = 'openrouter/free';
  static const double aiTemperature = 0.2;
  static const int aiMaxSuggestions = 10;
  static const String aiSearchSystemPrompt =
      'You are an expert movie and TV show search assistant for the MovieScout app.\n'
      'Suggest 1 to $aiMaxSuggestions movies or TV shows that best match the user\'s description.\n'
      'Prioritize accuracy and relevance over quantity; only include titles that truly match.\n'
      'Return EXCLUSIVELY a JSON list of objects (no text before or after, only raw JSON). Each object must contain exactly:\n'
      '- "title": the official original or English title as it appears on TMDb.\n'
      '- "year": release year (4-digit integer) or null.\n'
      '- "media_type": "movie" or "tv".\n'
      'Example:\n'
      '[{"title": "Inception", "year": 2010, "media_type": "movie"}]';
  static const String aiTranslateSystemPrompt =
      'You are a professional translator. Translate the given text to the target language. '
      'Return ONLY the translated text without any quotes, formatting, or additional comments.';

  static const String catalan = 'ca-ES';
  static const String spanish = 'es-ES';
  static const String english = 'en-US';

  // Background Tasks
  static const String taskUpdateWatchlist = 'updateWatchlistProviders';
  static const String workerWatchlistUpdate = 'watchlistUpdateTask';

  static const List<String> supportedLanguages = [
    catalan,
    spanish,
    english,
  ];

  // Other
  static const String saveLogsMessage = 'saveLogs';
  static const String anonymousAccountId = 'anonymous';
  static const int titleUpToDateDays = 3;
  static const int watchlistProvidersUpdateFrequencyDays = 1;
  static const int watchlistMaxUpdatesPerRun = 50;
  static const int watchlistNewSeasonNotificationWindowDays = 14;
  static const int maxSearchMovies = 20;
  static const int maxSearchTvShows = 20;
  static const int maxSearchPersons = 20;
  static const int maxSearchCollections = 20;
  static const int defaultBatchSize = 25;

  static const String notificationProgressChannelId = 'progress_channel';
  static const String notificationProgressChannelName = 'Background Tasks';
  static const String notificationProgressChannelDesc =
      'Notifications for background processes';
  static const int uninitializedTitlesNotificationId = 9991;
  static const int updateProvidersNotificationId = 9992;

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
