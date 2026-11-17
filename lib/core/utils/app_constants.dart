import 'package:moviescout/core/models/translation_content_type.dart';

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
  static const String pendingNotificationSyncs = 'pending_notification_syncs';
  static const String showEditContent = 'show_edit_content';
  static const String showCommunityTab = 'show_community_tab';
  static const String personListIsGridView = 'person_list_is_grid_view';
  static const String aiProviderKey = 'ai_provider';
  static const String aiProviderGoogle = 'google_ai';
  static const String aiProviderOpenRouter = 'openrouter';
  static const String aiConfigCacheKey = 'ai_models_config';
  static const String aiPromptsCacheKey = 'ai_prompts_config';

  static const String aiGoogleApiKey = 'ai_google_api_key';
  static const String aiGoogleModelKey = 'ai_google_model';
  static const String aiGoogleCustomModelKey = 'ai_google_custom_model';
  static const String aiGoogleModelIsCustomKey = 'ai_google_model_is_custom';
  static const String aiGoogleThinkingKey = 'ai_google_thinking';
  static const String aiGoogleModelFlash = 'gemini-flash-latest';
  static const String aiGoogleModelFlashLite = 'gemini-flash-lite-latest';
  static const String defaultAiGoogleModel = aiGoogleModelFlash;
  static const List<String> availableAiGoogleModels = [
    aiGoogleModelFlash,
    aiGoogleModelFlashLite,
  ];

  static const String aiOpenRouterApiKey = 'ai_api_key';
  static const String aiOpenRouterModelKey = 'ai_model';
  static const String aiOpenRouterCustomModelKey = 'ai_openrouter_custom_model';
  static const String aiOpenRouterModelIsCustomKey =
      'ai_openrouter_model_is_custom';
  static const String aiOpenRouterThinkingKey = 'ai_openrouter_thinking';
  static const String aiOpenRouterModelFree = 'openrouter/free';
  static const String aiOpenRouterModelAuto = 'openrouter/auto';
  static const String defaultAiOpenRouterModel = aiOpenRouterModelFree;
  static const List<String> availableAiOpenRouterModels = [
    aiOpenRouterModelFree,
    aiOpenRouterModelAuto,
  ];

  static const String aiModelCustom = 'custom';
  static const String aiTranslationEnabled = 'ai_translation_enabled';
  static const double aiTemperature = 0.5;
  static const int aiMaxSuggestions = 10;
  static const int aiMaxTokens = 4096;
  static const String aiThinkingLevel = 'low';
  static const String aiMimeTypeJson = 'application/json';
  static const String aiSearchUserPromptPrefix = 'Movies or TV shows about: ';
  static const String aiSchemaInstructionPrefix = 'Schema: ';
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

  static const String aiTemplateTargetLanguagePlaceholder = '{TARGET_LANGUAGE}';
  static const String aiTemplateContentTypePlaceholder = '{CONTENT_TYPE}';
  static const String aiTemplateTaskPlaceholder = '{TASK}';

  static const String aiTranslateFallbackSystemTemplate =
      'You are an expert audiovisual translator for a movie and TV streaming guide. '
      'Translate the provided $aiTemplateContentTypePlaceholder metadata into $aiTemplateTargetLanguagePlaceholder.\n\n'
      'Task: $aiTemplateTaskPlaceholder\n\n'
      'Rules:\n'
      '1. Adapt idioms, tone, and cultural or historical references naturally to $aiTemplateTargetLanguagePlaceholder; '
      'strictly avoid literal calques from English or third-party languages.\n'
      '2. Match the register to the provided content type ($aiTemplateContentTypePlaceholder) and genres.\n'
      '3. Keep proper character names unchanged, but adapt established historical terms, institutions, or official titles when appropriate.\n'
      '4. Preserve the original meaning and facts without adding commentary or spoilers.\n'
      '5. Output strictly valid JSON matching the requested schema.';

  static const Map<TranslationContentType, String> aiTranslateTypeLabels = {
    TranslationContentType.movie: 'Movie',
    TranslationContentType.tvSeries: 'TV Series',
    TranslationContentType.tvSeason: 'TV Series Season',
    TranslationContentType.tvEpisode: 'TV Series Episode',
    TranslationContentType.collection: 'Movie Collection',
    TranslationContentType.person: 'Person Biography',
  };

  static const Map<TranslationContentType, String> aiTranslateTypeInstructions =
      {
    TranslationContentType.movie: 'Translate a feature film title and/or synopsis. '
        'If an official localized release title is well-established in $aiTemplateTargetLanguagePlaceholder, use it; '
        'otherwise adapt the title naturally or keep untranslatable proper-noun titles intact.',
    TranslationContentType.tvSeries: 'Translate a TV series title and/or overview. '
        'If an official localized release title is well-established in $aiTemplateTargetLanguagePlaceholder, use it; '
        'otherwise adapt the title naturally or keep untranslatable proper-noun titles intact.',
    TranslationContentType.tvSeason:
        'Translate a TV series season title and/or overview using the provided series title and season number as context. '
            'Adapt standard season labels naturally to $aiTemplateTargetLanguagePlaceholder or translate themed season subtitles consistently with the series tone.',
    TranslationContentType.tvEpisode:
        'Translate a TV series episode title and/or synopsis using the provided series title, season/episode numbers, and genres as context. '
            'Translate episode titles idiomatically in the tone of the series rather than word-for-word, and keep recurring character names and series terminology consistent.',
    TranslationContentType.collection:
        'Translate a movie collection or franchise name and/or overview. '
            'Adapt collection descriptors (such as Collection, Trilogy, or Saga) naturally to $aiTemplateTargetLanguagePlaceholder while preserving recognizable franchise names.',
    TranslationContentType.person:
        'Translate a film/TV person\'s biography using their name as context. '
            'Do NOT translate the person\'s proper name. Produce a natural biographical text in $aiTemplateTargetLanguagePlaceholder, '
            'preserving credits, awards, institutions, and work titles accurately.',
  };

  static const String aiInputSourceLanguageLabel = 'Source language';
  static const String aiInputTargetLanguageLabel = 'Target language';
  static const String aiInputTypeLabel = 'Type';
  static const String aiInputSeriesLabel = 'Series';
  static const String aiInputSeasonLabel = 'Season';
  static const String aiInputEpisodeLabel = 'Episode';
  static const String aiInputGenresLabel = 'Genres';
  static const String aiInputPersonLabel = 'Person';
  static const String aiInputTitleLabel = 'Title';
  static const String aiInputSynopsisLabel = 'Synopsis';
  static const String aiInputBiographyLabel = 'Biography';

  static const String aiSchemaTitleKey = 'title';
  static const String aiSchemaSynopsisKey = 'synopsis';
  static const String aiSchemaBiographyKey = 'biography';
  static const String aiSchemaDescriptionKey = 'description';

  static const Map<TranslationContentType, String>
      aiTranslateTitleSchemaDescriptions = {
    TranslationContentType.movie: 'Translated movie title',
    TranslationContentType.tvSeries: 'Translated TV series title',
    TranslationContentType.tvSeason: 'Translated season title',
    TranslationContentType.tvEpisode: 'Translated episode title',
    TranslationContentType.collection: 'Translated movie collection name',
  };

  static const Map<TranslationContentType, String>
      aiTranslateSynopsisSchemaDescriptions = {
    TranslationContentType.movie:
        'Natural, idiomatic translation of the movie synopsis',
    TranslationContentType.tvSeries:
        'Natural, idiomatic translation of the TV series overview',
    TranslationContentType.tvSeason:
        'Natural, idiomatic translation of the season overview',
    TranslationContentType.tvEpisode:
        'Natural, idiomatic translation of the episode synopsis',
    TranslationContentType.collection:
        'Natural, idiomatic translation of the movie collection overview',
  };

  static const String aiTranslateBiographySchemaDescription =
      'Natural, idiomatic translation of the person biography';
  static const String aiTranslateDefaultTitleSchemaDescription =
      'Translated media title';
  static const String aiTranslateDefaultSynopsisSchemaDescription =
      'Natural, idiomatic translation of the synopsis';

  static const String catalan = 'ca-ES';
  static const String spanish = 'es-ES';
  static const String spanishLatam = 'es-419';
  static const String english = 'en-US';
  static const String french = 'fr-FR';
  static const String german = 'de-DE';
  static const String italian = 'it-IT';
  static const String portugueseBr = 'pt-BR';
  static const String portuguesePt = 'pt-PT';
  static const String basque = 'eu-ES';
  static const String galician = 'gl-ES';

  // Background Tasks
  static const String taskUpdateWatchlist = 'updateWatchlistProviders';
  static const String workerWatchlistUpdate = 'watchlistUpdateTask';

  static const List<String> supportedLanguages = [
    basque,
    catalan,
    english,
    french,
    galician,
    german,
    italian,
    portugueseBr,
    portuguesePt,
    spanish,
    spanishLatam,
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
  static const int defaultBatchSize = 20;

  static const String notificationProgressChannelId = 'progress_channel';
  static const String notificationProgressChannelName = 'Background Tasks';
  static const String notificationProgressChannelDesc =
      'Notifications for background processes';
  static const int uninitializedTitlesNotificationId = 9991;
  static const int updateProvidersNotificationId = 9992;

  static const String defaultDate = '1970-01-01';

  static const String tmdbApiRat = 'TMDB_API_RAT';
  static const String omdbApiKey = 'OMDB_API_KEY';
  static const String aiKeyEncryptionSecret = 'AI_KEY_ENCRYPTION_SECRET';
  static const String enableLogs = 'ENABLE_LOGS';

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
