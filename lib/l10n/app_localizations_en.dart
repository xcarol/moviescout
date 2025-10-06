// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie Scout';

  @override
  String get messageEmptyList => 'No films slected yet.';

  @override
  String get messageEmptySearch => 'You can do a search by using the magnifying glass in the bottom bar.';

  @override
  String get messageEmptyOptions => 'You can also';

  @override
  String get messageEmptyTmdb => 'Connect to TMDb';

  @override
  String get search => 'Search for a title';

  @override
  String get searchTitle => 'Search';

  @override
  String get back => 'Back';

  @override
  String get username => 'User name';

  @override
  String get password => 'Password';

  @override
  String get anonymousUser => 'Anonymous user';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginDescription => 'Login to your TMDB account';

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
  String get signupToTmdb => 'Register to TMDb';

  @override
  String get signInToWatchlist => 'User must be logged in to add titles.';

  @override
  String get tvShow => 'Tv show';

  @override
  String get movie => 'Movie';

  @override
  String get select => 'Select';

  @override
  String get imdbImport => 'Import from IMDB';

  @override
  String get imdbImportHint => 'Select an IMDB export CSV file';

  @override
  String get imdbImportWatchlist => 'Import Watchlist';

  @override
  String get imdbImportRateslist => 'Import Rates';

  @override
  String get imdbImportCount => 'Succesfully imported titles';

  @override
  String get imdbResetWatchlist => 'RESET WATCHLIST';

  @override
  String get imdbResetRateslist => 'RESET RATINGS';

  @override
  String get imdbConfirmationTitle => 'WARNING';

  @override
  String get imdbResetWatchlistConfirmation => 'Do you really want to reset Watchlist?';

  @override
  String get imdbResetRateslistConfirmation => 'Do you really want to reset Ratings?';

  @override
  String get resetWatchlistCount => 'Watchlist titles: ';

  @override
  String get resetRateslistCount => 'Rated titles: ';

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
  String get genres => 'Genres';

  @override
  String get titles => 'Titles';

  @override
  String get rate => 'Rate';

  @override
  String get your_rate => 'Your rating';

  @override
  String get reset_rate => 'Reset rating';

  @override
  String get emptyRates => 'You have not been rated any title yet.';

  @override
  String get emptyDiscover => 'Nothing here.';

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
  String get schemeSelectTitle => 'Select color';

  @override
  String get defaultScheme => 'Default';

  @override
  String get blackScheme => 'Black';

  @override
  String get blueScheme => 'Blue';

  @override
  String get redScheme => 'Red';

  @override
  String get about => 'About...';

  @override
  String get aboutDescription => 'Movie Scout your movie and series tracker.';

  @override
  String get aboutGithub => 'Visit project on ';

  @override
  String get recommended => 'Recommended';

  @override
  String get providersTitle => 'Content providers';

  @override
  String get providers => 'Providers';

  @override
  String get filterByProviders => 'Only available';

  @override
  String get noProvidersAvailable => 'No providers available';

  @override
  String get discoverlistTitle => 'Discover';

  @override
  String get notReleasedYet => 'Not release yet';

  @override
  String get unknownDuration => 'Runtime not specified.';
}
