class AppConstants {
  // List Names
  static const String watchlist = 'watchlist';
  static const String rateslist = 'rateslist';
  static const String discoverlist = 'discoverlist';
  static const String importImdb = 'importImdb';
  static const String searchProvider = 'searchProvider';
  static const double seenRating = 0.5;

  // Preference Keys
  static const String lastUpdateSuffix = '_last_update';
  static const String searchHistory = 'search_history';
  static const String themeMode = 'theme_mode';
  static const String themeScheme = 'ThemeScheme';
  static const String language = 'language';
  static const String region = 'region';
  static const String lastBackgroundRun = 'last_background_run';
  static const String watchlistUpdateLogs = 'watchlist_update_logs';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String notificationsAsked = 'notifications_asked';
  static const String debugShowLastUpdate = 'debug_show_last_update';

  static const String catalan = 'ca-ES';
  static const String spanish = 'es-ES';
  static const String english = 'en-US';

  static const List<String> supportedLanguages = [
    catalan,
    spanish,
    english,
  ];

  // Other
  static const String anonymousAccountId = 'anonymous';
  static const int titleUpToDateDays = 3;
  static const int watchlistTitleUpdateFrequencyDays = 7;
  static const int watchlistProvidersUpdateFrequencyDays = 1;
}
