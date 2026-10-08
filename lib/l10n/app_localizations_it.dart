// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Scaricamento dettagli titolo';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Recupero dati per i titoli ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Aggiornamento piattaforme';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Verifica disponibilità ($progress/$total)...';
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
  String get selectLanguage => 'Seleziona la lingua';

  @override
  String get messageEmptyList => 'Nessun film ancora selezionato.';

  @override
  String get messageEmptySearch => 'Puoi effettuare una ricerca usando la lente nella barra in basso.';

  @override
  String get messageEmptyOptions => 'Puoi anche';

  @override
  String get messageEmptyLogin => 'Accedi a MovieScout';

  @override
  String get search => 'Cerca un titolo';

  @override
  String get searchAiHint => 'Descrivi il film o la serie che stai cercando...';

  @override
  String get searchAiTooltip => 'Ricerca Intelligente (IA)';

  @override
  String get searchTitle => 'Cerca';

  @override
  String get searchPerson => 'Cerca una persona';

  @override
  String get searchPlaceholder => 'Cerca film o serie TV...';

  @override
  String get gallery => 'Galleria';

  @override
  String get searchProvider => 'Cerca una piattaforma';

  @override
  String get trailer => 'Trailer';

  @override
  String get includeGenres => 'Includi';

  @override
  String get excludeGenres => 'Escludi';

  @override
  String get pressBackAgainToExit => 'Premi di nuovo per uscire';

  @override
  String get back => 'Indietro';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get anonymousUser => 'Utente anonimo';

  @override
  String get loginTitle => 'Accedi';

  @override
  String get loginDescription => 'Accedi al tuo account TMDB';

  @override
  String get login => 'Accedi';

  @override
  String get logout => 'Esci';

  @override
  String get loginSuccess => 'Accesso effettuato con successo.';

  @override
  String get loginFailed => 'Nome utente o password errati.';

  @override
  String get logoutSuccess => 'Disconnessione completata.';

  @override
  String get loginToTmdb => 'Accedi a TMDb';

  @override
  String get completeLoginToTmdb => 'Completa il processo di accesso';

  @override
  String get signupToTmdb => 'Registrati su TMDb';

  @override
  String get signInToWatchlist => 'Devi aver effettuato l\'accesso per aggiungere titoli.';

  @override
  String get tvShow => 'Serie TV';

  @override
  String get movie => 'Film';

  @override
  String get select => 'Seleziona';

  @override
  String get imdbImport => 'Importa IMDb';

  @override
  String get imdbImportHint => 'Seleziona un file CSV esportato da IMDb';

  @override
  String get imdbImportWatchlist => 'Importa Watchlist';

  @override
  String get imdbImportRateslist => 'Importa valutazioni';

  @override
  String get imdbImportCount => 'Titoli importati con successo';

  @override
  String get imdbResetWatchlist => 'REIMPOSTA WATCHLIST';

  @override
  String get imdbResetRateslist => 'REIMPOSTA VALUTAZIONI';

  @override
  String get imdbConfirmationTitle => 'ATTENZIONE';

  @override
  String get imdbResetWatchlistConfirmation => 'Vuoi davvero reimpostare la Watchlist?';

  @override
  String get imdbResetRateslistConfirmation => 'Vuoi davvero reimpostare le valutazioni?';

  @override
  String get resetWatchlistCount => 'Titoli in Watchlist: ';

  @override
  String get resetRateslistCount => 'Titoli valutati: ';

  @override
  String get missingDescription => 'Descrizione mancante';

  @override
  String get flatrateProviders => 'Abbonamento';

  @override
  String get rentProviders => 'Noleggio';

  @override
  String get buyProviders => 'Acquisto';

  @override
  String get allTypes => 'Titoli';

  @override
  String get movies => 'Film';

  @override
  String get tvshows => 'Serie TV';

  @override
  String get miniseries => 'Miniserie';

  @override
  String get collection => 'Saga';

  @override
  String get seeCollection => 'Vedi saga';

  @override
  String get sortAlphabetically => 'Alfabetico';

  @override
  String get sortRating => 'Valutazione';

  @override
  String get sortUserRating => 'Mia valutazione';

  @override
  String get sortReleaseDate => 'Data di uscita';

  @override
  String get sortRuntime => 'Durata';

  @override
  String get sortDateRated => 'Data valutazione';

  @override
  String get sortRelevance => 'Rilevanza';

  @override
  String get sortAddedOrder => 'Data di aggiunta';

  @override
  String get genres => 'Generi';

  @override
  String get titles => 'Titoli';

  @override
  String get rate_date => 'Data di valutazione';

  @override
  String get your_rate => 'Il tuo voto';

  @override
  String get reset_rate => 'Azzera voto';

  @override
  String get emptyRates => 'Non hai ancora valutato alcun titolo.';

  @override
  String get seen => 'Visto';

  @override
  String get markAsSeen => 'Segna come visto';

  @override
  String get ratedOnly => 'Valutati';

  @override
  String get seenOnly => 'Visti';

  @override
  String get followingOnly => 'Seguiti';

  @override
  String get pendingOnly => 'In attesa';

  @override
  String get emptyList => 'Non c\'è niente qui.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Lista valutazioni';

  @override
  String get yes => 'Sì';

  @override
  String get cancel => 'Annulla';

  @override
  String get originaTitle => 'Titolo originale';

  @override
  String get originalLanguage => 'Lingua originale';

  @override
  String get originCountry => 'Paese';

  @override
  String get schemeSelectTitle => 'Seleziona colore';

  @override
  String get defaultScheme => 'Predefinito';

  @override
  String get blackScheme => 'Nero';

  @override
  String get blueScheme => 'Blu';

  @override
  String get redScheme => 'Rosso';

  @override
  String get about => 'Info...';

  @override
  String get aboutDescription => 'MovieScout è il tuo tracker di film e serie con dati di TMDb, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Visita il progetto su ';

  @override
  String get apiDisclaimer => 'Questo prodotto utilizza le API TMDb ma non è approvato o certificato da TMDb.';

  @override
  String get privacyDisclaimerPrefix => 'Leggi l\' ';

  @override
  String get privacyDisclaimer => 'informativa sulla privacy';

  @override
  String get recommended => 'Consigliati';

  @override
  String get providersTitle => 'Piattaforme di streaming';

  @override
  String get providers => 'Piattaforme';

  @override
  String get filterByProviders => 'Solo disponibili';

  @override
  String get noProvidersAvailable => 'Nessuna piattaforma disponibile';

  @override
  String get discoverlistTitle => 'Scopri';

  @override
  String get notReleasedYet => 'Non ancora uscito';

  @override
  String get unknownDuration => 'Durata non specificata.';

  @override
  String get cast => 'Cast';

  @override
  String get crew => 'Troupe';

  @override
  String get seeThemAll => 'Vedi tutti';

  @override
  String get ratedCredits => 'Titoli valutati';

  @override
  String get birthDate => 'Data di nascita';

  @override
  String get deathDate => 'Data di morte';

  @override
  String get placeOfBirth => 'Luogo di nascita';

  @override
  String get years => 'Anni';

  @override
  String get job => 'Ruolo';

  @override
  String get department => 'Dipartimento';

  @override
  String get watchingNow => 'In visione';

  @override
  String get pinLimitReached => 'Hai raggiunto il limite di 5 titoli fissati.';

  @override
  String get pin => 'Fissa';

  @override
  String get unpin => 'Sblocca';

  @override
  String get notificationTitle => 'Ora disponibile!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title è ora disponibile su $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nuova stagione!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nuova stagione di $title disponibile su $provider.';
  }

  @override
  String get selectRegion => 'Seleziona regione';

  @override
  String get searchRegion => 'Cerca regione';

  @override
  String get regionAuto => 'Rilevamento automatico (IP)';

  @override
  String get shareLink => 'Condividi';

  @override
  String get director => 'Regista';

  @override
  String get creator => 'Creatore';

  @override
  String get writer => 'Sceneggiatore';

  @override
  String seasonsCount(Object count) {
    return '$count stag.';
  }

  @override
  String get notifications => 'Notifiche';

  @override
  String get notificationsPermissionRequired => 'Devi consentire le notifiche nelle impostazioni di sistema.';

  @override
  String get notificationsPermissionDescription => 'Per ricevere aggiornamenti sulla disponibilità dei film e nuove stagioni, attiva le notifiche.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get settings => 'Impostazioni';

  @override
  String get errorMessageGeneric => 'Si è verificato un errore. Riprova più tardi.';

  @override
  String get youtubeSearch => 'Cerca su YouTube';

  @override
  String get notificationsHistory => 'Ultime notifiche';

  @override
  String get notifyCompleteSeason => 'Notifica stagione completa';

  @override
  String get notifyCompleteSeasonSubtitle => 'Notifica solo quando l\'intera stagione è disponibile.';

  @override
  String get episodes => 'Episodi';

  @override
  String get selectSeason => 'Vedi le stagioni';

  @override
  String seasonLabel(Object count) {
    return 'Stagione $count';
  }

  @override
  String get notifyTitle => 'Notifica nuove stagioni';

  @override
  String get notifyMessage => 'Vuoi ricevere una notifica quando va in onda una nuova stagione?';

  @override
  String get no => 'No';

  @override
  String get none => 'Nessuno';

  @override
  String get results => 'Risultati';

  @override
  String inRoleContext(Object context) {
    return ' in $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episodio $count';
  }

  @override
  String get edit => 'Modifica';

  @override
  String get showEditContent => 'Mostra pulsante di modifica';

  @override
  String get translations => 'Traduzioni';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get close => 'Chiudi';

  @override
  String get autoTranslation => 'Traduzione automatica';

  @override
  String get originalText => 'Testo originale';

  @override
  String get addToHomeScreen => 'Aggiungi alla schermata Home';

  @override
  String get shortcutAdded => 'Scorciatoia aggiunta';

  @override
  String get shortcutFailed => 'Impossibile aggiungere scorciatoia';

  @override
  String get rate => 'Valuta';

  @override
  String get watchOn => 'Guarda su';

  @override
  String get status => 'Stato';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Intelligenza Artificiale';

  @override
  String get aiSettingsSubtitle => 'Ricerca intelligente e funzionalità IA';

  @override
  String get aiSettingsDescription => 'L\'IA ti permette di trovare film e serie con descrizioni naturali. Ottieni una chiave API gratuita su OpenRouter.';

  @override
  String get aiGetApiKeyButton => 'Ottieni chiave su OpenRouter';

  @override
  String get aiApiKeyLabel => 'Chiave API OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Salva chiave';

  @override
  String get aiDeleteKeyButton => 'Elimina';

  @override
  String get aiKeySaved => 'Chiave API salvata con successo';

  @override
  String get aiKeyCleared => 'Chiave API eliminata';

  @override
  String get aiStatusConfigured => 'Chiave API configurata';

  @override
  String get aiStatusNotConfigured => 'Chiave API non configurata';

  @override
  String get delete => 'Elimina';

  @override
  String get aiDeleteConfirmTitle => 'Elimina chiave API';

  @override
  String get aiDeleteConfirmMessage => 'Sei sicuro di voler eliminare la chiave API? OpenRouter non consente di visualizzarla dopo la creazione.';

  @override
  String get searchTimeout => 'La ricerca ha impiegato troppo tempo. Riprova.';

  @override
  String get aiSearchTimeout => 'La ricerca IA è scaduta. Prova con una descrizione più breve.';

  @override
  String get aiSearchError => 'Si è verificato un errore durante la ricerca IA.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Limite API superato. Attendi $seconds secondi prima di riprovare.';
  }

  @override
  String get aiRateLimitGeneric => 'Limite API superato. Attendi un momento.';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get googleSignInButton => 'Accedi con Google';

  @override
  String get alreadyUsingMovieScout => 'Usi già MovieScout?';

  @override
  String get importTmdbData => 'Importa i tuoi dati da TMDb.';

  @override
  String get tmdbAccount => 'Account TMDb';

  @override
  String get tmdbImport => 'Importa TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importa TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importa i tuoi dati TMDb';

  @override
  String get tmdbImportScreenBody => 'Puoi importare la watchlist e i voti dal tuo account TMDb. Accedi a TMDb per iniziare.';

  @override
  String get tmdbImportStartButton => 'Avvia importazione';

  @override
  String get tmdbImportSuccess => 'Dati importati con successo!';

  @override
  String get tmdbImportDownloading => 'Scaricamento dati TMDb...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Scaricamento watchlist...';

  @override
  String get tmdbImportDownloadingRateslist => 'Scaricamento voti...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Scaricamento episodi votati...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count titoli nella watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count titoli valutati';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episodi valutati';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronizza con l\'account';

  @override
  String get tmdbImportUploading => 'Caricamento sul tuo account...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count elementi sincronizzati con il tuo account';
  }

  @override
  String get tmdbImportError => 'Errore durante l\'importazione dei dati';

  @override
  String get tmdbImportLoginRequired => 'Accedi a TMDb per iniziare l\'importazione.';

  @override
  String get tmdbImportConsentText => 'L\'importazione aggiungerà in sicurezza le tue liste e voti TMDb al tuo account MovieScout.';

  @override
  String get loginConsentText => 'Accedendo, accetti di memorizzare i dati sui server di MovieScout secondo i nostri ';

  @override
  String get termsOfService => 'termini di servizio';

  @override
  String get andThe => ' e l\'';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountConfirmTitle => 'Elimina account';

  @override
  String get deleteAccountConfirmMessage => 'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile.';

  @override
  String get deleteAccountSuccess => 'Il tuo account è stato eliminato con successo';

  @override
  String get deleteAccountError => 'Errore durante l\'eliminazione dell\'account';
}
