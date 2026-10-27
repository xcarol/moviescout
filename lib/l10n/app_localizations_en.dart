// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Downloading Title Details';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Fetching data for titles ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Updating Providers';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Checking availability for titles ($progress/$total)...';
  }

  @override
  String get appTitle => 'MovieScout';

  @override
  String get catalan => 'Català';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get portugueseBr => 'Português (Brasil)';

  @override
  String get portuguesePt => 'Português (Portugal)';

  @override
  String get basque => 'Euskara';

  @override
  String get galician => 'Galego';

  @override
  String get selectLanguage => 'Select the language';

  @override
  String get messageEmptyList => 'No films slected yet.';

  @override
  String get messageEmptySearch => 'You can do a search by using the magnifying glass in the bottom bar.';

  @override
  String get messageEmptyOptions => 'You can also';

  @override
  String get messageEmptyLogin => 'Sign in to MovieScout';

  @override
  String get search => 'Search for a title';

  @override
  String get searchAiHint => 'Describe the movie or TV show you are looking for...';

  @override
  String get searchAiTooltip => 'Smart Search (AI)';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchPerson => 'Search for somebody';

  @override
  String get gallery => 'Gallery';

  @override
  String get searchProvider => 'Search for a provider';

  @override
  String get trailer => 'Trailer';

  @override
  String get includeGenres => 'Include';

  @override
  String get excludeGenres => 'Exclude';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get back => 'Back';

  @override
  String get username => 'User name';

  @override
  String get anonymousUser => 'Anonymous user';

  @override
  String get loginTitle => 'Login';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get loginSuccess => 'Logged in succesfully.';

  @override
  String get loginFailed => 'Username or password incorrect.';

  @override
  String get logoutSuccess => 'Logged out succesfully.';

  @override
  String get loginToTmdb => 'Sign in to TMDb';

  @override
  String get completeLoginToTmdb => 'Complete sign in process';

  @override
  String get signInToWatchlist => 'User must be logged in to add titles.';

  @override
  String get tvShow => 'Tv show';

  @override
  String get movie => 'Movie';

  @override
  String get select => 'Select';

  @override
  String get imdbImport => 'IMDB Import';

  @override
  String get imdbImportHint => 'Select an IMDB export CSV file';

  @override
  String get imdbImportWatchlist => 'Import Watchlist';

  @override
  String get imdbImportRateslist => 'Import Rates';

  @override
  String get missingDescription => 'Missing description';

  @override
  String get flatrateProviders => 'Flatrate';

  @override
  String get rentProviders => 'Rent';

  @override
  String get buyProviders => 'Buy';

  @override
  String get allTypes => 'Titles';

  @override
  String get movies => 'Movies';

  @override
  String get tvshows => 'Tv Shows';

  @override
  String get miniseries => 'Miniseries';

  @override
  String get collection => 'Collection';

  @override
  String get seeCollection => 'See collection';

  @override
  String get sortAlphabetically => 'Alphabetical';

  @override
  String get sortRating => 'Rating';

  @override
  String get sortUserRating => 'Rating (Mine)';

  @override
  String get sortReleaseDate => 'Release date';

  @override
  String get sortRuntime => 'Runtime';

  @override
  String get sortDateRated => 'Rated date';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortAddedOrder => 'Added date';

  @override
  String get genres => 'Genres';

  @override
  String get titles => 'Titles';

  @override
  String get rate_date => 'Rated date';

  @override
  String get your_rate => 'Your rating';

  @override
  String get reset_rate => 'Reset rating';

  @override
  String get emptyRates => 'You have not been rated any title yet.';

  @override
  String get seen => 'Seen';

  @override
  String get markAsSeen => 'Mark as seen';

  @override
  String get ratedOnly => 'Rated';

  @override
  String get seenOnly => 'Seen';

  @override
  String get followingOnly => 'Following';

  @override
  String get emptyList => 'Nothing here.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Rated list';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get originaTitle => 'Original title';

  @override
  String get originalLanguage => 'Original language';

  @override
  String get originCountry => 'Country';

  @override
  String get defaultScheme => 'Default';

  @override
  String get about => 'About...';

  @override
  String get aboutDescription => 'MovieScout is your movie and TV series tracker powered by TMDB, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Visit project on ';

  @override
  String get apiDisclaimer => 'This product uses the TMDB API but is not endorsed or certified by TMDB.';

  @override
  String get privacyDisclaimerPrefix => 'Read the ';

  @override
  String get privacyDisclaimer => 'privacy policy';

  @override
  String get recommended => 'Recommended';

  @override
  String get providersTitle => 'Content platforms';

  @override
  String get providers => 'Platforms';

  @override
  String get filterByProviders => 'Only available';

  @override
  String get noProvidersAvailable => 'No platforms available';

  @override
  String get discoverlistTitle => 'Discover';

  @override
  String get notReleasedYet => 'Not release yet';

  @override
  String get unknownDuration => 'Runtime not specified.';

  @override
  String get cast => 'Cast';

  @override
  String get crew => 'Crew';

  @override
  String get seeThemAll => 'See them all';

  @override
  String get ratedCredits => 'Rated credits';

  @override
  String get birthDate => 'Birthdate';

  @override
  String get deathDate => 'Deathdate';

  @override
  String get placeOfBirth => 'Place of birth';

  @override
  String get years => 'Years';

  @override
  String get job => 'Job';

  @override
  String get department => 'Department';

  @override
  String get watchingNow => 'Watching now';

  @override
  String get pinLimitReached => 'You have reached the limit of 5 pinned titles.';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get notificationTitle => 'Now available!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title is now available on $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'New season!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'New season of $title available on $provider.';
  }

  @override
  String get selectRegion => 'Select region';

  @override
  String get searchRegion => 'Search region';

  @override
  String get regionAuto => 'Automatic detection (IP)';

  @override
  String get shareLink => 'Share';

  @override
  String get director => 'Director';

  @override
  String get creator => 'Creator';

  @override
  String get writer => 'Writer';

  @override
  String seasonsCount(Object count) {
    return '${count}seas';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsPermissionRequired => 'You need to allow notifications in the system settings.';

  @override
  String get notificationsPermissionDescription => 'To receive updates on movie availability and new seasons, you must enable notifications in your system settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get settings => 'Settings';

  @override
  String get errorMessageGeneric => 'An error occurred. Please try again later.';

  @override
  String get notificationsHistory => 'Last notifications';

  @override
  String get notifyCompleteSeason => 'Notify complete season';

  @override
  String get episodes => 'Episodes';

  @override
  String get selectSeason => 'See the seasons';

  @override
  String seasonLabel(Object count) {
    return 'Season $count';
  }

  @override
  String get notifyTitle => 'Notify new seasons';

  @override
  String get notifyMessage => 'Do you want to be notified when a new season airs?';

  @override
  String get no => 'No';

  @override
  String get none => 'None';

  @override
  String get results => 'Results';

  @override
  String inRoleContext(Object context) {
    return ' in $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episode $count';
  }

  @override
  String get edit => 'Edit';

  @override
  String get showEditContent => 'Show edit button';

  @override
  String get translations => 'Translations';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get close => 'Close';

  @override
  String get autoTranslation => 'Automatic Translation';

  @override
  String get originalText => 'Original Text';

  @override
  String get addToHomeScreen => 'Add to Home Screen';

  @override
  String get shortcutFailed => 'Failed to add shortcut';

  @override
  String get rate => 'Rate';

  @override
  String get watchOn => 'Watch on';

  @override
  String get status => 'Status';

  @override
  String get enableAiTranslation => 'AI';

  @override
  String get aiSettingsTitle => 'Artificial Intelligence';

  @override
  String get aiSettingsSubtitle => 'Smart search and AI features';

  @override
  String get aiSettingsDescription => 'AI features allow you to find movies and TV shows based on natural language descriptions and more smart tools. To use them, you can get a free API key at OpenRouter (no credit card required).';

  @override
  String get aiGetApiKeyButton => 'Get API key at OpenRouter';

  @override
  String get aiApiKeyLabel => 'OpenRouter API Key';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Save key';

  @override
  String get aiDeleteKeyButton => 'Delete';

  @override
  String get aiKeySaved => 'API key saved successfully';

  @override
  String get aiKeyCleared => 'API key deleted';

  @override
  String get aiStatusConfigured => 'API key configured';

  @override
  String get aiStatusNotConfigured => 'API key not configured';

  @override
  String get delete => 'Delete';

  @override
  String get aiDeleteConfirmTitle => 'Delete API Key';

  @override
  String get aiDeleteConfirmMessage => 'Are you sure you want to delete the API key? Note that OpenRouter does not allow viewing the key once created and you will need to generate a new one if you do not have it saved.';

  @override
  String get searchTimeout => 'The search took too long to respond. Please try again.';

  @override
  String get aiSearchTimeout => 'The AI search timed out. Try using a less specific or shorter description.';

  @override
  String get aiSearchError => 'An error occurred during AI search. Please try again.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'API rate limit exceeded. Please wait $seconds seconds before trying again.';
  }

  @override
  String get aiRateLimitGeneric => 'API rate limit exceeded. Please wait a moment before trying again.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get loginSubtitle => 'Sign in to save and sync your lists and ratings.';

  @override
  String get googleSignInButton => 'Continue with Google';

  @override
  String get tmdbAccount => 'TMDb Account';

  @override
  String get tmdbImport => 'TMDb Import';

  @override
  String get tmdbImportScreenTitle => 'TMDb Import';

  @override
  String get tmdbImportScreenHeader => 'Import your TMDb data';

  @override
  String get tmdbImportScreenBody => 'You can import your watchlist and ratings from your TMDb account into your MovieScout account. You will need to log in to TMDb. Once the import is complete, your TMDb session will be automatically closed.';

  @override
  String get tmdbImportStartButton => 'Start Import';

  @override
  String get tmdbImportSuccess => 'Data imported successfully!';

  @override
  String get tmdbImportDownloadingWatchlist => 'Downloading watchlist...';

  @override
  String get tmdbImportDownloadingRateslist => 'Downloading ratings...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Downloading rated episodes...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count titles in watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count rated titles';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count rated episodes';
  }

  @override
  String get tmdbImportUploadTitle => 'Sync with account';

  @override
  String get tmdbImportUploading => 'Uploading to your account...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count items uploaded to your account';
  }

  @override
  String get tmdbImportError => 'Error importing data';

  @override
  String get tmdbImportConsentText => 'The import will securely add your TMDb lists and ratings to your MovieScout account.';

  @override
  String get loginConsentText => 'By signing in, you agree to store your data on MovieScout\'s servers for cross-device synchronization, according to our ';

  @override
  String get termsOfService => 'terms of service';

  @override
  String get andThe => ' and the ';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirmTitle => 'Delete account';

  @override
  String get deleteAccountConfirmMessage => 'Are you sure you want to delete your account? This action is irreversible and will permanently delete all your lists and data.';

  @override
  String get deleteAccountSuccess => 'Your account has been deleted successfully';

  @override
  String get deleteAccountError => 'Error deleting account';

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add comment';

  @override
  String get editComment => 'Edit comment';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get writeComment => 'Write a comment...';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get signInToComment => 'Sign in to add a comment';

  @override
  String get deleteCommentConfirm => 'Are you sure you want to delete your comment?';

  @override
  String get save => 'Save';

  @override
  String get you => 'You';

  @override
  String get followingTab => 'Following';

  @override
  String get users => 'Users';

  @override
  String get user => 'User';

  @override
  String get follow => 'Follow';

  @override
  String get following => 'Following';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get latestRatedTitles => 'Latest rated titles';

  @override
  String get emptyFollowingList => 'You are not following any users yet.';

  @override
  String get emptyFollowingSearchHint => 'Search for users to follow them and see their activity.';

  @override
  String get networkErrorMessage => 'Unable to connect to the server. Please check your internet connection.';

  @override
  String get publicProfileTitle => 'Public profile';

  @override
  String get publicProfileSubtitle => 'Enable your public profile to share what you watch with the community';

  @override
  String get privateProfileMessage => 'This profile is private';

  @override
  String get enablePublicProfileBanner => 'Enable your public profile to share what you watch with the community. It can be disabled from settings.';

  @override
  String get enablePublicProfileButton => 'Enable public profile';

  @override
  String get noWatchingNowTitles => 'Not watching any title right now';

  @override
  String get noRatedTitles => 'No rated titles';

  @override
  String get communityTabTitle => 'Community tab';

  @override
  String get communityTabSubtitle => 'Show the community tab in the navigation bar';

  @override
  String get emptyFollowingCommunityHint => 'You can hide this tab from settings if you do not use it.';

  @override
  String get shareAppCommunityPrompt => 'Share MovieScout with your acquaintances and start creating your network.';

  @override
  String get shareAppButton => 'Share MovieScout';

  @override
  String get shareAppMessage => 'Join MovieScout to discover and share movies and series!';

  @override
  String get shareAppGooglePlay => 'Install on Google Play:';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSectionCommunity => 'Community';

  @override
  String get settingsSectionTools => 'Tools & Features';

  @override
  String get settingsSectionData => 'Data & Import';

  @override
  String get settingsNotificationsEnabledSubtitle => 'Availability alerts active';

  @override
  String get settingsNotificationsDisabledSubtitle => 'Availability alerts disabled';

  @override
  String get settingsNotifySeasonComplete => 'Notifies when full season is available';

  @override
  String get settingsNotifySeasonFirstEp => 'Notifies only on first episode premiere';

  @override
  String settingsProvidersCount(Object count) {
    return '$count platforms selected';
  }

  @override
  String get settingsProvidersNone => 'No platforms selected';

  @override
  String get settingsAiConfigured => 'API key configured';

  @override
  String get settingsAiNotConfigured => 'No API key configured';

  @override
  String get settingsProfilePublic => 'Visible to community';

  @override
  String get settingsProfilePrivate => 'Private profile';

  @override
  String get settingsCommunityVisible => 'Visible in navigation bar';

  @override
  String get settingsCommunityHidden => 'Hidden';

  @override
  String get settingsEditVisible => 'Visible on title details';

  @override
  String get settingsEditHidden => 'Hidden';

  @override
  String get settingsImdbSubtitle => 'CSV file (watchlist and ratings)';

  @override
  String get settingsTmdbSubtitle => 'Watchlist and ratings';

  @override
  String get settingsDeleteAccountSubtitle => 'Irreversible action';

  @override
  String get understood => 'Understood';

  @override
  String get settingsInfoProvidersTitle => 'Content Platforms';

  @override
  String get settingsInfoProvidersIntro => 'How does MovieScout use your platforms?';

  @override
  String get settingsInfoProvidersItem1Title => 'Availability alerts';

  @override
  String get settingsInfoProvidersItem1Desc => 'When you add an unavailable title, MovieScout tracks your selected platforms to notify you when it arrives.';

  @override
  String get settingsInfoProvidersItem2Title => 'Search and list filters';

  @override
  String get settingsInfoProvidersItem2Desc => 'Filter the catalog quickly to see only what you can watch with your active subscriptions.';

  @override
  String get settingsInfoProvidersItem3Title => 'Regional catalog';

  @override
  String get settingsInfoProvidersItem3Desc => 'Platform availability adapts automatically to your selected region in settings.';

  @override
  String get settingsInfoNotificationsTitle => 'How Notifications Work';

  @override
  String get settingsInfoNotificationsIntro => 'Automatic availability alerts';

  @override
  String get settingsInfoNotificationsItem1Title => 'Watchlist releases';

  @override
  String get settingsInfoNotificationsItem1Desc => 'Get notified when a title from your watchlist becomes available on your chosen platforms.';

  @override
  String get settingsInfoNotificationsItem2Title => 'New series seasons';

  @override
  String get settingsInfoNotificationsItem2Desc => 'By default you are alerted on the first episode. If complete season is enabled, alerts wait until the full season airs.';

  @override
  String get settingsInfoNotificationsItem3Title => 'Background checks';

  @override
  String get settingsInfoNotificationsItem3Desc => 'MovieScout checks for updates quietly in the background without draining your battery.';

  @override
  String get settingsInfoAiTitle => 'Artificial Intelligence';

  @override
  String get settingsInfoAiIntro => 'Enhancements in translation and search';

  @override
  String get settingsInfoAiItem1Title => 'Contextual translations';

  @override
  String get settingsInfoAiItem1Desc => 'Generates natural synopses and title translations adapted to cinematic context when not available in your language.';

  @override
  String get settingsInfoAiItem2Title => 'Smart search';

  @override
  String get settingsInfoAiItem2Desc => 'Find movies by describing scenes, plot points, or themes even if you do not recall the title.';

  @override
  String get settingsInfoAiItem3Title => 'Secure API key';

  @override
  String get settingsInfoAiItem3Desc => 'Your API key is stored securely on your device and only used for your direct requests.';

  @override
  String get settingsInfoAiNote => 'Important: Free AI models may experience slower response times or temporary rate limits from the provider. For optimal, instant performance, pay-per-use models are recommended.';

  @override
  String get settingsInfoProfileTitle => 'Public Profile & Community';

  @override
  String get settingsInfoProfileIntro => 'The social side of MovieScout';

  @override
  String get settingsInfoProfileItem1Title => 'Share your activity';

  @override
  String get settingsInfoProfileItem1Desc => 'Allow others to find your profile, follow you, and see what you are watching and your ratings.';

  @override
  String get settingsInfoProfileItem2Title => 'Full privacy control';

  @override
  String get settingsInfoProfileItem2Desc => 'Switch to private mode anytime. Only public titles and ratings are shared, never personal data or keys.';

  @override
  String get settingsInfoProfileItem3Title => 'Community tab';

  @override
  String get settingsInfoProfileItem3Desc => 'Show or hide the community tab in the bottom bar based on your preference.';

  @override
  String get settingsInfoEditTitle => 'Collaboration and Editing on TMDb';

  @override
  String get settingsInfoEditIntro => 'Help grow the open database and improve movie information.';

  @override
  String get settingsInfoEditItem1Title => 'Direct access from title details';

  @override
  String get settingsInfoEditItem1Desc => 'Displays a pencil icon on movie and series details to quickly open their editing page on TMDb.';

  @override
  String get settingsInfoEditItem2Title => 'Community and open data';

  @override
  String get settingsInfoEditItem2Desc => 'All MovieScout information comes from The Movie Database (TMDb), a collaborative project maintained by the community.';

  @override
  String get settingsInfoEditItem3Title => 'Content and translation improvements';

  @override
  String get settingsInfoEditItem3Desc => 'You can add or correct titles, overviews, and details in any language for the entire community to enjoy.';

  @override
  String get settingsInfoEditNote => 'To edit content on TMDb, you only need to sign in with a free account at themoviedb.org.';
}
