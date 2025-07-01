import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie Scout'**
  String get appTitle;

  /// No description provided for @messageEmptyList.
  ///
  /// In en, this message translates to:
  /// **'No films slected yet.'**
  String get messageEmptyList;

  /// No description provided for @messageEmptyList2.
  ///
  /// In en, this message translates to:
  /// **'Do a search using the magnifying glass in the bottom bar.'**
  String get messageEmptyList2;

  /// No description provided for @messageEmptyList3.
  ///
  /// In en, this message translates to:
  /// **'Log in or register to TMDB from the side menu.'**
  String get messageEmptyList3;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search for a title'**
  String get search;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous user'**
  String get anonymousUser;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Login to your TMDB account'**
  String get loginDescription;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in succesfully.'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Username or password incorrect.'**
  String get loginFailed;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out succesfully.'**
  String get logoutSuccess;

  /// No description provided for @loginToTmdb.
  ///
  /// In en, this message translates to:
  /// **'Sign in to TMDb'**
  String get loginToTmdb;

  /// No description provided for @completeLoginToTmdb.
  ///
  /// In en, this message translates to:
  /// **'Complete sign in process'**
  String get completeLoginToTmdb;

  /// No description provided for @signupToTmdb.
  ///
  /// In en, this message translates to:
  /// **'Register to TMDb'**
  String get signupToTmdb;

  /// No description provided for @signInToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'User must be logged in to add titles.'**
  String get signInToWatchlist;

  /// No description provided for @tvShow.
  ///
  /// In en, this message translates to:
  /// **'Tv show'**
  String get tvShow;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @imdbImport.
  ///
  /// In en, this message translates to:
  /// **'Import from IMDB'**
  String get imdbImport;

  /// No description provided for @imdbImportHint.
  ///
  /// In en, this message translates to:
  /// **'Select an IMDB export CSV file'**
  String get imdbImportHint;

  /// No description provided for @imdbImportWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Import Watchlist'**
  String get imdbImportWatchlist;

  /// No description provided for @imdbImportRateslist.
  ///
  /// In en, this message translates to:
  /// **'Import Rates'**
  String get imdbImportRateslist;

  /// No description provided for @imdbImportCount.
  ///
  /// In en, this message translates to:
  /// **'Succesfully imported titles'**
  String get imdbImportCount;

  /// No description provided for @imdbResetWatchlist.
  ///
  /// In en, this message translates to:
  /// **'RESET WATCHLIST'**
  String get imdbResetWatchlist;

  /// No description provided for @imdbResetRateslist.
  ///
  /// In en, this message translates to:
  /// **'RESET RATINGS'**
  String get imdbResetRateslist;

  /// No description provided for @imdbConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get imdbConfirmationTitle;

  /// No description provided for @imdbResetWatchlistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset Watchlist?'**
  String get imdbResetWatchlistConfirmation;

  /// No description provided for @imdbResetRateslistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset Ratings?'**
  String get imdbResetRateslistConfirmation;

  /// No description provided for @resetWatchlistCount.
  ///
  /// In en, this message translates to:
  /// **'Watchlist titles: '**
  String get resetWatchlistCount;

  /// No description provided for @resetRateslistCount.
  ///
  /// In en, this message translates to:
  /// **'Rated titles: '**
  String get resetRateslistCount;

  /// No description provided for @missingDescription.
  ///
  /// In en, this message translates to:
  /// **'Missing description'**
  String get missingDescription;

  /// No description provided for @flatrateProviders.
  ///
  /// In en, this message translates to:
  /// **'Flatrate'**
  String get flatrateProviders;

  /// No description provided for @rentProviders.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rentProviders;

  /// No description provided for @buyProviders.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyProviders;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTypes;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @tvshows.
  ///
  /// In en, this message translates to:
  /// **'Tv Shows'**
  String get tvshows;

  /// No description provided for @sortAlphabetically.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sortAlphabetically;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get sortRating;

  /// No description provided for @sortUserRating.
  ///
  /// In en, this message translates to:
  /// **'Rating (Mine)'**
  String get sortUserRating;

  /// No description provided for @sortReleaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get sortReleaseDate;

  /// No description provided for @sortRuntime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get sortRuntime;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @titles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get titles;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @your_rate.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get your_rate;

  /// No description provided for @reset_rate.
  ///
  /// In en, this message translates to:
  /// **'Reset rating'**
  String get reset_rate;

  /// No description provided for @emptyRates.
  ///
  /// In en, this message translates to:
  /// **'You have not been rated any title yet.'**
  String get emptyRates;

  /// No description provided for @watchlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlistTitle;

  /// No description provided for @rateslistTitle.
  ///
  /// In en, this message translates to:
  /// **'Rated list'**
  String get rateslistTitle;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @originaTitle.
  ///
  /// In en, this message translates to:
  /// **'Original title'**
  String get originaTitle;

  /// No description provided for @originalLanguage.
  ///
  /// In en, this message translates to:
  /// **'Original language'**
  String get originalLanguage;

  /// No description provided for @originCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get originCountry;

  /// No description provided for @schemeSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get schemeSelectTitle;

  /// No description provided for @defaultScheme.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultScheme;

  /// No description provided for @blackScheme.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get blackScheme;

  /// No description provided for @blueScheme.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blueScheme;

  /// No description provided for @redScheme.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get redScheme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About...'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Movie Scout the ultimate movie and series tracker.'**
  String get aboutDescription;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @providersTitle.
  ///
  /// In en, this message translates to:
  /// **'Content providers'**
  String get providersTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return AppLocalizationsCa();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
