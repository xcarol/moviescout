// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Titeldetails werden heruntergeladen';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Daten für Titel werden geladen ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Streaming-Dienste werden aktualisiert';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Verfügbarkeit wird geprüft ($progress/$total)...';
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
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get messageEmptyList => 'Noch keine Filme ausgewählt.';

  @override
  String get messageEmptySearch => 'Du kannst mit der Lupe in der unteren Leiste suchen.';

  @override
  String get messageEmptyOptions => 'Du kannst auch';

  @override
  String get messageEmptyLogin => 'Bei MovieScout anmelden';

  @override
  String get search => 'Nach einem Titel suchen';

  @override
  String get searchAiHint => 'Beschreibe den Film oder die Serie, die du suchst...';

  @override
  String get searchAiTooltip => 'Smarte Suche (KI)';

  @override
  String get searchTitle => 'Suchen';

  @override
  String get searchPerson => 'Nach einer Person suchen';

  @override
  String get searchPlaceholder => 'Filme oder Serien suchen...';

  @override
  String get gallery => 'Galerie';

  @override
  String get searchProvider => 'Streaming-Dienst suchen';

  @override
  String get trailer => 'Trailer';

  @override
  String get includeGenres => 'Einschließen';

  @override
  String get excludeGenres => 'Ausschließen';

  @override
  String get pressBackAgainToExit => 'Erneut drücken zum Beenden';

  @override
  String get back => 'Zurück';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get anonymousUser => 'Anonymer Benutzer';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get loginDescription => 'Melde dich bei deinem TMDB-Konto an';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get loginSuccess => 'Erfolgreich angemeldet.';

  @override
  String get loginFailed => 'Benutzername oder Passwort falsch.';

  @override
  String get logoutSuccess => 'Erfolgreich abgemeldet.';

  @override
  String get loginToTmdb => 'Bei TMDb anmelden';

  @override
  String get completeLoginToTmdb => 'Anmeldevorgang abschließen';

  @override
  String get signupToTmdb => 'Bei TMDb registrieren';

  @override
  String get signInToWatchlist => 'Du musst angemeldet sein, um Titel hinzuzufügen.';

  @override
  String get tvShow => 'Serie';

  @override
  String get movie => 'Film';

  @override
  String get select => 'Auswählen';

  @override
  String get imdbImport => 'IMDb-Import';

  @override
  String get imdbImportHint => 'Wähle eine IMDb-CSV-Exportdatei';

  @override
  String get imdbImportWatchlist => 'Watchlist importieren';

  @override
  String get imdbImportRateslist => 'Bewertungen importieren';

  @override
  String get imdbImportCount => 'Titel erfolgreich importiert';

  @override
  String get imdbResetWatchlist => 'WATCHLIST ZURÜCKSETZEN';

  @override
  String get imdbResetRateslist => 'BEWERTUNGEN ZURÜCKSETZEN';

  @override
  String get imdbConfirmationTitle => 'WARNUNG';

  @override
  String get imdbResetWatchlistConfirmation => 'Möchtest du die Watchlist wirklich zurücksetzen?';

  @override
  String get imdbResetRateslistConfirmation => 'Möchtest du die Bewertungen wirklich zurücksetzen?';

  @override
  String get resetWatchlistCount => 'Watchlist-Titel: ';

  @override
  String get resetRateslistCount => 'Bewertete Titel: ';

  @override
  String get missingDescription => 'Keine Beschreibung verfügbar';

  @override
  String get flatrateProviders => 'Flatrate';

  @override
  String get rentProviders => 'Leihen';

  @override
  String get buyProviders => 'Kaufen';

  @override
  String get allTypes => 'Titel';

  @override
  String get movies => 'Filme';

  @override
  String get tvshows => 'Serien';

  @override
  String get miniseries => 'Miniserien';

  @override
  String get collection => 'Filmreihe';

  @override
  String get seeCollection => 'Filmreihe ansehen';

  @override
  String get sortAlphabetically => 'Alphabetisch';

  @override
  String get sortRating => 'Bewertung';

  @override
  String get sortUserRating => 'Meine Bewertung';

  @override
  String get sortReleaseDate => 'Veröffentlichungsdatum';

  @override
  String get sortRuntime => 'Laufzeit';

  @override
  String get sortDateRated => 'Bewertungsdatum';

  @override
  String get sortRelevance => 'Relevanz';

  @override
  String get sortAddedOrder => 'Hinzugefügt am';

  @override
  String get genres => 'Genres';

  @override
  String get titles => 'Titel';

  @override
  String get rate_date => 'Bewertungsdatum';

  @override
  String get your_rate => 'Deine Bewertung';

  @override
  String get reset_rate => 'Bewertung löschen';

  @override
  String get emptyRates => 'Du hast noch keine Titel bewertet.';

  @override
  String get seen => 'Gesehen';

  @override
  String get markAsSeen => 'Als gesehen markieren';

  @override
  String get ratedOnly => 'Bewertet';

  @override
  String get seenOnly => 'Gesehen';

  @override
  String get followingOnly => 'Gefolgt';

  @override
  String get pendingOnly => 'Ausstehend';

  @override
  String get emptyList => 'Hier ist nichts.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Bewertungsliste';

  @override
  String get yes => 'Ja';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get originaTitle => 'Originaltitel';

  @override
  String get originalLanguage => 'Originalsprache';

  @override
  String get originCountry => 'Land';

  @override
  String get schemeSelectTitle => 'Farbe auswählen';

  @override
  String get defaultScheme => 'Standard';

  @override
  String get blackScheme => 'Schwarz';

  @override
  String get blueScheme => 'Blau';

  @override
  String get redScheme => 'Rot';

  @override
  String get about => 'Über...';

  @override
  String get aboutDescription => 'MovieScout ist dein Film- und Serientracker, unterstützt von TMDb, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Projekt ansehen auf ';

  @override
  String get apiDisclaimer => 'Dieses Produkt nutzt die TMDb-API, wird jedoch nicht von TMDb unterstützt oder zertifiziert.';

  @override
  String get privacyDisclaimerPrefix => 'Lies die ';

  @override
  String get privacyDisclaimer => 'Datenschutzrichtlinie';

  @override
  String get recommended => 'Empfohlen';

  @override
  String get providersTitle => 'Streaming-Dienste';

  @override
  String get providers => 'Streaming-Dienste';

  @override
  String get filterByProviders => 'Nur verfügbare';

  @override
  String get noProvidersAvailable => 'Keine Streaming-Dienste verfügbar';

  @override
  String get discoverlistTitle => 'Entdecken';

  @override
  String get notReleasedYet => 'Noch nicht veröffentlicht';

  @override
  String get unknownDuration => 'Laufzeit nicht angegeben.';

  @override
  String get cast => 'Besetzung';

  @override
  String get crew => 'Stab';

  @override
  String get seeThemAll => 'Alle anzeigen';

  @override
  String get ratedCredits => 'Bewertete Titel';

  @override
  String get birthDate => 'Geburtsdatum';

  @override
  String get deathDate => 'Sterbedatum';

  @override
  String get placeOfBirth => 'Geburtsort';

  @override
  String get years => 'Jahre';

  @override
  String get job => 'Beruf';

  @override
  String get department => 'Abteilung';

  @override
  String get watchingNow => 'Wird gerade geschaut';

  @override
  String get pinLimitReached => 'Du hast das Limit von 5 angehefteten Titeln erreicht.';

  @override
  String get pin => 'Anheften';

  @override
  String get unpin => 'Lösen';

  @override
  String get notificationTitle => 'Jetzt verfügbar!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title ist jetzt auf $provider verfügbar.';
  }

  @override
  String get notificationNewSeasonTitle => 'Neue Staffel!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Neue Staffel von $title auf $provider verfügbar.';
  }

  @override
  String get selectRegion => 'Region auswählen';

  @override
  String get searchRegion => 'Region suchen';

  @override
  String get regionAuto => 'Automatische Erkennung (IP)';

  @override
  String get shareLink => 'Teilen';

  @override
  String get director => 'Regisseur';

  @override
  String get creator => 'Schöpfer';

  @override
  String get writer => 'Autor';

  @override
  String seasonsCount(Object count) {
    return '$count St.';
  }

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationsPermissionRequired => 'Du musst Benachrichtigungen in den Systemeinstellungen erlauben.';

  @override
  String get notificationsPermissionDescription => 'Um Updates zu Filmverfügbarkeiten und neuen Staffeln zu erhalten, aktiviere Benachrichtigungen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get errorMessageGeneric => 'Ein Fehler ist aufgetreten. Bitte versuche es später erneut.';

  @override
  String get youtubeSearch => 'YouTube-Suche';

  @override
  String get notificationsHistory => 'Letzte Benachrichtigungen';

  @override
  String get notifyCompleteSeason => 'Komplette Staffel melden';

  @override
  String get notifyCompleteSeasonSubtitle => 'Benachrichtigt nur, wenn die ganze Staffel verfügbar ist.';

  @override
  String get episodes => 'Episoden';

  @override
  String get selectSeason => 'Staffeln anzeigen';

  @override
  String seasonLabel(Object count) {
    return 'Staffel $count';
  }

  @override
  String get notifyTitle => 'Neue Staffeln melden';

  @override
  String get notifyMessage => 'Möchtest du benachrichtigt werden, wenn eine neue Staffel ausgestrahlt wird?';

  @override
  String get no => 'Nein';

  @override
  String get none => 'Keine';

  @override
  String get results => 'Ergebnisse';

  @override
  String inRoleContext(Object context) {
    return ' in $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episode $count';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get showEditContent => 'Bearbeiten-Button anzeigen';

  @override
  String get translations => 'Übersetzungen';

  @override
  String get copiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get close => 'Schließen';

  @override
  String get autoTranslation => 'Automatische Übersetzung';

  @override
  String get originalText => 'Originaltext';

  @override
  String get addToHomeScreen => 'Zum Startbildschirm hinzufügen';

  @override
  String get shortcutAdded => 'Verknüpfung hinzugefügt';

  @override
  String get shortcutFailed => 'Verknüpfung konnte nicht hinzugefügt werden';

  @override
  String get rate => 'Bewerten';

  @override
  String get watchOn => 'Ansehen auf';

  @override
  String get status => 'Status';

  @override
  String get enableAiTranslation => 'KI';

  @override
  String get aiSettingsTitle => 'Künstliche Intelligenz';

  @override
  String get aiSettingsSubtitle => 'Smarte Suche und KI-Funktionen';

  @override
  String get aiSettingsDescription => 'KI ermöglicht das Finden von Filmen anhand natürlicher Beschreibungen. Hole dir einen kostenlosen API-Schlüssel bei OpenRouter.';

  @override
  String get aiGetApiKeyButton => 'Schlüssel bei OpenRouter holen';

  @override
  String get aiApiKeyLabel => 'OpenRouter-API-Schlüssel';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Schlüssel speichern';

  @override
  String get aiDeleteKeyButton => 'Löschen';

  @override
  String get aiKeySaved => 'API-Schlüssel erfolgreich gespeichert';

  @override
  String get aiKeyCleared => 'API-Schlüssel gelöscht';

  @override
  String get aiStatusConfigured => 'API-Schlüssel konfiguriert';

  @override
  String get aiStatusNotConfigured => 'API-Schlüssel nicht konfiguriert';

  @override
  String get delete => 'Löschen';

  @override
  String get aiDeleteConfirmTitle => 'API-Schlüssel löschen';

  @override
  String get aiDeleteConfirmMessage => 'Möchtest du den API-Schlüssel wirklich löschen? OpenRouter zeigt ihn nach der Erstellung nicht mehr an.';

  @override
  String get searchTimeout => 'Die Suche hat zu lange gedauert. Bitte versuche es erneut.';

  @override
  String get aiSearchTimeout => 'Zeitüberschreitung bei der KI-Suche. Versuche eine kürzere Beschreibung.';

  @override
  String get aiSearchError => 'Ein Fehler ist bei der KI-Suche aufgetreten.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'API-Limit erreicht. Bitte warte $seconds Sekunden.';
  }

  @override
  String get aiRateLimitGeneric => 'API-Limit erreicht. Bitte warte einen Moment.';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get googleSignInButton => 'Google-Anmeldung';

  @override
  String get alreadyUsingMovieScout => 'Nutzt du MovieScout bereits?';

  @override
  String get importTmdbData => 'Importiere deine Daten von TMDb.';

  @override
  String get tmdbAccount => 'TMDb-Konto';

  @override
  String get tmdbImport => 'TMDb-Import';

  @override
  String get tmdbImportScreenTitle => 'TMDb-Import';

  @override
  String get tmdbImportScreenHeader => 'Importiere deine TMDb-Daten';

  @override
  String get tmdbImportScreenBody => 'Du kannst deine Watchlist und Bewertungen von TMDb importieren. Melde dich bei TMDb an, um fortzufahren.';

  @override
  String get tmdbImportStartButton => 'Import starten';

  @override
  String get tmdbImportSuccess => 'Daten erfolgreich importiert!';

  @override
  String get tmdbImportDownloading => 'TMDb-Daten werden geladen...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Watchlist wird geladen...';

  @override
  String get tmdbImportDownloadingRateslist => 'Bewertungen werden geladen...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Bewertete Episoden werden geladen...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count Titel in der Watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count bewertete Titel';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count bewertete Episoden';
  }

  @override
  String get tmdbImportUploadTitle => 'Mit Konto synchronisieren';

  @override
  String get tmdbImportUploading => 'Wird auf dein Konto hochgeladen...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count Elemente mit deinem Konto synchronisiert';
  }

  @override
  String get tmdbImportError => 'Fehler beim Importieren der Daten';

  @override
  String get tmdbImportLoginRequired => 'Melde dich bei TMDb an, um den Import zu starten.';

  @override
  String get tmdbImportConsentText => 'Der Import fügt deine TMDb-Listen sicher zu deinem MovieScout-Konto hinzu.';

  @override
  String get loginConsentText => 'Mit der Anmeldung stimmst du der Speicherung auf MovieScout-Servern zu, gemäß unserer ';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get andThe => ' und der ';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountConfirmTitle => 'Konto löschen';

  @override
  String get deleteAccountConfirmMessage => 'Möchtest du dein Konto wirklich löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountSuccess => 'Dein Konto wurde erfolgreich gelöscht';

  @override
  String get deleteAccountError => 'Fehler beim Löschen des Kontos';
}
