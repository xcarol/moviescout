// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Xehetasunak deskargatzen';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Tituluaren datuak lortzen ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Plataformak eguneratzea';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Erabilgarritasuna egiaztatzen ($progress/$total)...';
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
  String get selectLanguage => 'Hautatu hizkuntza';

  @override
  String get messageEmptyList => 'Oraindik ez da filma hautatu.';

  @override
  String get messageEmptySearch => 'Bilaketa bat egin dezakezu beheko barran dagoen lupa erabiliz.';

  @override
  String get messageEmptyOptions => 'Zuk ere egin dezakezu';

  @override
  String get messageEmptyLogin => 'Hasi saioa MovieScout-en';

  @override
  String get search => 'Bilatu izenburu bat';

  @override
  String get searchAiHint => 'Deskribatu bilatzen ari zaren filma edo seriea...';

  @override
  String get searchAiTooltip => 'Bilaketa adimenduna (AI)';

  @override
  String get searchTitle => 'Bilatu';

  @override
  String get searchPerson => 'norbaiten bila';

  @override
  String get searchPlaceholder => 'Bilatu filmak edo serieak...';

  @override
  String get gallery => 'Galeria';

  @override
  String get searchProvider => 'Bilatu hornitzaile bat';

  @override
  String get trailer => 'Trailerra';

  @override
  String get includeGenres => 'Sartu';

  @override
  String get excludeGenres => 'Baztertu';

  @override
  String get pressBackAgainToExit => 'Sakatu berriro irteteko';

  @override
  String get back => 'Itzuli';

  @override
  String get username => 'Erabiltzailea';

  @override
  String get password => 'Pasahitza';

  @override
  String get anonymousUser => 'Erabiltzailerik ez';

  @override
  String get loginTitle => 'Saioa hasi';

  @override
  String get loginDescription => 'Hasi saioa zure TMDB kontuan';

  @override
  String get login => 'Hasi saioa';

  @override
  String get logout => 'Amaitu saioa';

  @override
  String get loginSuccess => 'Saioa ongi hasi da.';

  @override
  String get loginFailed => 'Erabiltzaile-izena edo pasahitza okerra.';

  @override
  String get logoutSuccess => 'Saioa ondo itxi da.';

  @override
  String get loginToTmdb => 'Hasi saioa TMDb-en';

  @override
  String get completeLoginToTmdb => 'Osatu saioa hasteko';

  @override
  String get signupToTmdb => 'Eman izena TMDb-en';

  @override
  String get signInToWatchlist => 'Saioa hasi behar duzu izenburuak gehitzeko.';

  @override
  String get tvShow => 'Seriea';

  @override
  String get movie => 'Filma';

  @override
  String get select => 'Hautatu';

  @override
  String get imdbImport => 'IMDB inportazioa';

  @override
  String get imdbImportHint => 'Hautatu IMDBtik esportatutako CSV fitxategi bat';

  @override
  String get imdbImportWatchlist => 'Inportatu Ikustera';

  @override
  String get imdbImportRateslist => 'Inportatu Iritziak';

  @override
  String get imdbImportCount => 'Inportatu dira tituluak';

  @override
  String get imdbResetWatchlist => 'EZABATU IKUSTEKO';

  @override
  String get imdbResetRateslist => 'IRUZKINAK EZABATU';

  @override
  String get imdbConfirmationTitle => 'ADI';

  @override
  String get imdbResetWatchlistConfirmation => 'Ziur Ikusi beharreko izenburuak kendu nahi dituzula?';

  @override
  String get imdbResetRateslistConfirmation => 'Ziur Iritziak ezabatu nahi dituzula?';

  @override
  String get resetWatchlistCount => 'Ikusi beharreko tituluak:';

  @override
  String get resetRateslistCount => 'Baloratutako tituluak:';

  @override
  String get missingDescription => 'Deskribapena falta da';

  @override
  String get flatrateProviders => 'Harpidetza';

  @override
  String get rentProviders => 'Alokairua';

  @override
  String get buyProviders => 'Erosketak';

  @override
  String get allTypes => 'Baloreak';

  @override
  String get movies => 'Filmak';

  @override
  String get tvshows => 'Seriea';

  @override
  String get miniseries => 'Miniseriea';

  @override
  String get collection => 'Bilduma';

  @override
  String get seeCollection => 'Ikusi bilduma';

  @override
  String get sortAlphabetically => 'Alfabetikoa';

  @override
  String get sortRating => 'Ebaluazioa';

  @override
  String get sortUserRating => 'Balorazioa (Mia)';

  @override
  String get sortReleaseDate => 'Kaleratze data';

  @override
  String get sortRuntime => 'Iraupena';

  @override
  String get sortDateRated => 'Balorazio data';

  @override
  String get sortRelevance => 'Garrantzia';

  @override
  String get sortAddedOrder => 'Gehitutako data';

  @override
  String get genres => 'Generoak';

  @override
  String get titles => 'Baloreak';

  @override
  String get rate_date => 'Balorazio data';

  @override
  String get your_rate => 'Zure balorazioa';

  @override
  String get reset_rate => 'Ezabatu zure iritzia';

  @override
  String get emptyRates => 'Oraindik ez duzu titulurik baloratu.';

  @override
  String get seen => 'Ikusita';

  @override
  String get markAsSeen => 'Markatu ikusi bezala';

  @override
  String get ratedOnly => 'Baloratua';

  @override
  String get seenOnly => 'Ikuspegiak';

  @override
  String get followingOnly => 'Jarraian';

  @override
  String get pendingOnly => 'Belarritakoak';

  @override
  String get emptyList => 'Hemen ezer ez.';

  @override
  String get watchlistTitle => 'ikusteko';

  @override
  String get rateslistTitle => 'Baloratua';

  @override
  String get yes => 'Bai';

  @override
  String get cancel => 'Utzi';

  @override
  String get originaTitle => 'Jatorrizko izenburua';

  @override
  String get originalLanguage => 'Jatorrizko hizkuntza';

  @override
  String get originCountry => 'Herrialdea';

  @override
  String get schemeSelectTitle => 'Hautatu kolorea';

  @override
  String get defaultScheme => 'Lehenetsia';

  @override
  String get blackScheme => 'Beltza';

  @override
  String get blueScheme => 'Urdina';

  @override
  String get redScheme => 'Gorria';

  @override
  String get about => 'Buruz...';

  @override
  String get aboutDescription => 'MovieScout zure film eta serie bilatzailea da, TMDb, OMDb eta JustWatch-en datuekin.';

  @override
  String get aboutGithub => 'Bisitatu proiektua helbidean';

  @override
  String get apiDisclaimer => 'Produktu honek TMDB APIa erabiltzen du, baina ez du TMDB-k onartzen edo ziurtatuta.';

  @override
  String get privacyDisclaimerPrefix => 'Kontsultatu';

  @override
  String get privacyDisclaimer => 'Pribatutasun-politika';

  @override
  String get recommended => 'Gomendagarria';

  @override
  String get providersTitle => 'Eduki-plataformak';

  @override
  String get providers => 'Plataformak';

  @override
  String get filterByProviders => 'Bakarrik eskuragarri';

  @override
  String get noProvidersAvailable => 'Ez dago plataformarik erabilgarri';

  @override
  String get discoverlistTitle => 'Ezagutu';

  @override
  String get notReleasedYet => 'Oraindik ez da kaleratu';

  @override
  String get unknownDuration => 'Iraupena zehaztu gabe.';

  @override
  String get cast => 'Antzezleak';

  @override
  String get crew => 'Talde teknikoa';

  @override
  String get seeThemAll => 'Ikusi guztiak';

  @override
  String get ratedCredits => 'Baloratutako kredituak';

  @override
  String get birthDate => 'Jaioteguna';

  @override
  String get deathDate => 'Heriotza-data';

  @override
  String get placeOfBirth => 'jaioterria';

  @override
  String get years => 'Urteak';

  @override
  String get job => 'Argitalpena';

  @override
  String get department => 'Saila';

  @override
  String get watchingNow => 'orain begira';

  @override
  String get pinLimitReached => 'Ezarritako 5 tituluren mugara iritsi zara.';

  @override
  String get pin => 'Ezarri';

  @override
  String get unpin => 'Ainguratu';

  @override
  String get notificationTitle => 'Orain eskuragarri!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title eskuragarri dago orain $provider-n.';
  }

  @override
  String get notificationNewSeasonTitle => 'Denboraldi berria!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return '$title denboraldi berria eskuragarri $provider-n.';
  }

  @override
  String get selectRegion => 'Aukeratu eskualdea';

  @override
  String get searchRegion => 'Eskualde bat bilatu';

  @override
  String get regionAuto => 'Detekzio automatikoa (IP)';

  @override
  String get shareLink => 'Partekatu';

  @override
  String get director => 'Zuzendaria';

  @override
  String get creator => 'Sortzailea';

  @override
  String get writer => 'Idazlea';

  @override
  String seasonsCount(Object count) {
    return '${count}tenp';
  }

  @override
  String get notifications => 'Jakinarazpenak';

  @override
  String get notificationsPermissionRequired => 'Sistemaren ezarpenetan jakinarazpenak onartu behar dituzu.';

  @override
  String get notificationsPermissionDescription => 'Filmen eta denboraldi berrien erabilgarritasunari buruzko jakinarazpenak jasotzeko, sistemaren ezarpenetan jakinarazpenak aktibatu behar dituzu.';

  @override
  String get openSettings => 'Ireki ezarpenak';

  @override
  String get settings => 'Konfigurazioa';

  @override
  String get errorMessageGeneric => 'Errore bat gertatu da. Saiatu berriro geroago.';

  @override
  String get youtubeSearch => 'YouTube Bilaketa';

  @override
  String get notificationsHistory => 'Azken jakinarazpenak';

  @override
  String get notifyCompleteSeason => 'Jakinarazi denboraldi osoa';

  @override
  String get notifyCompleteSeasonSubtitle => 'Denboraldi osoa erabilgarri dagoenean bakarrik jakinarazten du.';

  @override
  String get episodes => 'Pasarteak';

  @override
  String get selectSeason => 'Ikusi urtaroak';

  @override
  String seasonLabel(Object count) {
    return '$count denboraldia';
  }

  @override
  String get notifyTitle => 'Jakinarazi urtaro berriei';

  @override
  String get notifyMessage => 'Jakinarazpen bat jaso nahi duzu denboraldi berri bat emititzen denean?';

  @override
  String get no => 'Ez';

  @override
  String get none => 'Bat ere ez';

  @override
  String get results => 'Emaitzak';

  @override
  String inRoleContext(Object context) {
    return 'urtean $context';
  }

  @override
  String episodeLabel(Object count) {
    return '$count atala';
  }

  @override
  String get edit => 'Editatu';

  @override
  String get showEditContent => 'Erakutsi editatzeko botoia';

  @override
  String get translations => 'Itzulpenak';

  @override
  String get copiedToClipboard => 'Testua arbelean kopiatu da';

  @override
  String get close => 'Itxi';

  @override
  String get autoTranslation => 'Itzulpen automatikoa';

  @override
  String get originalText => 'Jatorrizko testua';

  @override
  String get addToHomeScreen => 'Gehitu hasierako pantailara';

  @override
  String get shortcutAdded => 'Lasterbidea gehitu da';

  @override
  String get shortcutFailed => 'Ezin izan da lasterbidea gehitu';

  @override
  String get rate => 'Tarifa';

  @override
  String get watchOn => 'Ikusi';

  @override
  String get status => 'Estatua';

  @override
  String get enableAiTranslation => 'AI';

  @override
  String get aiSettingsTitle => 'Adimen artifiziala';

  @override
  String get aiSettingsSubtitle => 'Bilaketa adimenduna eta AI Ezaugarriak';

  @override
  String get aiSettingsDescription => 'AI funtzioek hizkuntza naturaleko deskribapenetan eta tresna adimentsuagoetan oinarritutako filmak eta serieak aurki ditzakezu. Horiek erabiltzeko, doako gako bat lor dezakezu OpenRouter-en (ez da txartelik behar).';

  @override
  String get aiGetApiKeyButton => 'Lortu gakoa OpenRouter-en';

  @override
  String get aiApiKeyLabel => 'OpenRouter API gakoa';

  @override
  String get aiApiKeyHint => 'sk-edo-v1-...';

  @override
  String get aiSaveKeyButton => 'Gorde tekla';

  @override
  String get aiDeleteKeyButton => 'Ezabatu';

  @override
  String get aiKeySaved => 'Behar bezala gorde da API gakoa';

  @override
  String get aiKeyCleared => 'Kendu da API gakoa';

  @override
  String get aiStatusConfigured => 'Konfiguratutako API gakoa';

  @override
  String get aiStatusNotConfigured => 'API gakoa ez dago konfiguratuta';

  @override
  String get delete => 'Ezabatu';

  @override
  String get aiDeleteConfirmTitle => 'Ezabatu API gakoa';

  @override
  String get aiDeleteConfirmMessage => 'Ziur API gakoa ezabatu nahi duzula? Kontuan izan OpenRouter-ek ez dizula gakoa kontsultatzen uzten behin sortuta eta beste bat sortu beharko duzula gordeta ez baduzu.';

  @override
  String get searchTimeout => 'Bilaketa luzeegia izan da erantzuteko. Saiatu berriro.';

  @override
  String get aiSearchTimeout => 'AI bilaketak luzeegia hartu du. Saiatu deskribapen ez hain zehatza edo laburrago batekin.';

  @override
  String get aiSearchError => 'Errore bat gertatu da AI bilaketan. Saiatu berriro.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'APIaren denbora-muga gainditu da. Itxaron $seconds segundo berriro saiatu aurretik.';
  }

  @override
  String get aiRateLimitGeneric => 'APIaren denbora-muga gainditu da. Itxaron une bat berriro saiatu aurretik.';

  @override
  String get signInWithGoogle => 'Hasi saioa Google-rekin';

  @override
  String get googleSignInButton => 'Sar zaitez Google-rekin';

  @override
  String get alreadyUsingMovieScout => 'Dagoeneko erabiltzen al zenuen MovieScout?';

  @override
  String get importTmdbData => 'Inportatu zure datu zaharrak TMDBtik.';

  @override
  String get tmdbAccount => 'TMDb kontua';

  @override
  String get tmdbImport => 'TMDb inportazioa';

  @override
  String get tmdbImportScreenTitle => 'TMDb inportazioa';

  @override
  String get tmdbImportScreenHeader => 'Inportatu zure TMDb datuak';

  @override
  String get tmdbImportScreenBody => 'Zure TMDb kontutik zure jarraipen zerrendak eta balorazioak inporta ditzakezu MovieScout kontura. TMDb-n saioa hasi beharko duzu. Inportazioa amaitutakoan, TMDb saioa automatikoki itxiko da.';

  @override
  String get tmdbImportStartButton => 'Hasi inportazioa';

  @override
  String get tmdbImportSuccess => 'Datuak ondo inportatu dira!';

  @override
  String get tmdbImportDownloading => 'TMDb-tik datuak deskargatzen...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Jarraipen zerrenda deskargatzen...';

  @override
  String get tmdbImportDownloadingRateslist => 'Iritziak deskargatzen...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Atal baloratuak deskargatzen...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count izenburuak jarraipen-zerrendan';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count balore balioetsiak';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count atal baloratu dira';
  }

  @override
  String get tmdbImportUploadTitle => 'Kontuaren sinkronizazioa';

  @override
  String get tmdbImportUploading => 'Zure kontura kargatzen...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count elementu zure kontuan kargatu dira';
  }

  @override
  String get tmdbImportError => 'Errore bat gertatu da datuak inportatzean';

  @override
  String get tmdbImportLoginRequired => 'Hasi saioa TMDb-n inportazioa hasteko.';

  @override
  String get tmdbImportConsentText => 'Inportazioak modu seguruan gehituko ditu zure TMDb zerrendak eta balorazioak MovieScout kontuan.';

  @override
  String get loginConsentText => 'Saioa hasita, zure datuak MovieScout zerbitzarietan gordetzea onartzen duzu gailuen artean sinkronizatzeko, gure';

  @override
  String get termsOfService => 'zerbitzu baldintzak';

  @override
  String get andThe => 'eta du';

  @override
  String get deleteAccount => 'Ezabatu kontua';

  @override
  String get deleteAccountConfirmTitle => 'Ezabatu kontua';

  @override
  String get deleteAccountConfirmMessage => 'Ziur zure kontua ezabatu nahi duzula? Ekintza hau itzulezina da eta zure zerrenda eta datu guztiak betiko ezabatuko ditu.';

  @override
  String get deleteAccountSuccess => 'Zure kontua behar bezala ezabatu da';

  @override
  String get deleteAccountError => 'Errore bat gertatu da kontua ezabatzean';
}
