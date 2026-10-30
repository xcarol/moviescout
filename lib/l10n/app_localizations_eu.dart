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
  String get spanish => 'Español (España)';

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
  String get messageEmptySearch =>
      'Bilaketa bat egin dezakezu beheko barran dagoen lupa erabiliz.';

  @override
  String get messageEmptyOptions => 'Zuk ere egin dezakezu';

  @override
  String get messageEmptyLogin => 'Hasi saioa MovieScout-en';

  @override
  String get search => 'Bilatu izenburu bat';

  @override
  String get searchAiHint =>
      'Deskribatu bilatzen ari zaren filma edo seriea...';

  @override
  String get searchAiTooltip => 'Bilaketa adimenduna (AI)';

  @override
  String get searchTitle => 'Bilatu';

  @override
  String get searchPerson => 'norbaiten bila';

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
  String get anonymousUser => 'Erabiltzailerik ez';

  @override
  String get loginTitle => 'Saioa hasi';

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
  String get imdbImportHint =>
      'Hautatu IMDBtik esportatutako CSV fitxategi bat';

  @override
  String get imdbImportWatchlist => 'Inportatu Ikustera';

  @override
  String get imdbImportRateslist => 'Inportatu Iritziak';

  @override
  String get missingDescription => 'Deskribapena falta da';

  @override
  String get flatrateProviders => 'Harpidetza';

  @override
  String get rentProviders => 'Alokairua';

  @override
  String get buyProviders => 'Erosketak';

  @override
  String get freeProviders => 'Doan';

  @override
  String get adsProviders => 'Iragarkiekin';

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
  String get defaultScheme => 'Lehenetsia';

  @override
  String get about => 'Buruz...';

  @override
  String get aboutDescription =>
      'MovieScout zure film eta serie bilatzailea da, TMDb, OMDb eta JustWatch-en datuekin.';

  @override
  String get aboutGithub => 'Bisitatu proiektua helbidean';

  @override
  String get apiDisclaimer =>
      'Produktu honek TMDB APIa erabiltzen du, baina ez du TMDB-k onartzen edo ziurtatuta.';

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
  String get notificationsPermissionRequired =>
      'Sistemaren ezarpenetan jakinarazpenak onartu behar dituzu.';

  @override
  String get notificationsPermissionDescription =>
      'Filmen eta denboraldi berrien erabilgarritasunari buruzko jakinarazpenak jasotzeko, sistemaren ezarpenetan jakinarazpenak aktibatu behar dituzu.';

  @override
  String get openSettings => 'Ireki ezarpenak';

  @override
  String get settings => 'Konfigurazioa';

  @override
  String get errorMessageGeneric =>
      'Errore bat gertatu da. Saiatu berriro geroago.';

  @override
  String get notificationsHistory => 'Azken jakinarazpenak';

  @override
  String get notifyCompleteSeason => 'Jakinarazi denboraldi osoa';

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
  String get notifyMessage =>
      'Jakinarazpen bat jaso nahi duzu denboraldi berri bat emititzen denean?';

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
  String get aiSettingsDescription =>
      'AI funtzioek hizkuntza naturaleko deskribapenetan eta tresna adimentsuagoetan oinarritutako filmak eta serieak aurki ditzakezu. Horiek erabiltzeko, doako gako bat lor dezakezu OpenRouter-en (ez da txartelik behar).';

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
  String get aiDeleteConfirmMessage =>
      'Ziur API gakoa ezabatu nahi duzula? Kontuan izan OpenRouter-ek ez dizula gakoa kontsultatzen uzten behin sortuta eta beste bat sortu beharko duzula gordeta ez baduzu.';

  @override
  String get searchTimeout =>
      'Bilaketa luzeegia izan da erantzuteko. Saiatu berriro.';

  @override
  String get aiSearchTimeout =>
      'AI bilaketak luzeegia hartu du. Saiatu deskribapen ez hain zehatza edo laburrago batekin.';

  @override
  String get aiSearchError =>
      'Errore bat gertatu da AI bilaketan. Saiatu berriro.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'APIaren denbora-muga gainditu da. Itxaron $seconds segundo berriro saiatu aurretik.';
  }

  @override
  String get aiRateLimitGeneric =>
      'APIaren denbora-muga gainditu da. Itxaron une bat berriro saiatu aurretik.';

  @override
  String get signInWithGoogle => 'Hasi saioa Google-rekin';

  @override
  String get loginSubtitle =>
      'Hasi saioa zure zerrendak eta balorazioak gorde eta sinkronizatzeko.';

  @override
  String get googleSignInButton => 'Jarraitu Google-rekin';

  @override
  String get tmdbAccount => 'TMDb kontua';

  @override
  String get tmdbImport => 'TMDb inportazioa';

  @override
  String get tmdbImportScreenTitle => 'TMDb inportazioa';

  @override
  String get tmdbImportScreenHeader => 'Inportatu zure TMDb datuak';

  @override
  String get tmdbImportScreenBody =>
      'Zure TMDb kontutik zure jarraipen zerrendak eta balorazioak inporta ditzakezu MovieScout kontura. TMDb-n saioa hasi beharko duzu. Inportazioa amaitutakoan, TMDb saioa automatikoki itxiko da.';

  @override
  String get tmdbImportStartButton => 'Hasi inportazioa';

  @override
  String get tmdbImportSuccess => 'Datuak ondo inportatu dira!';

  @override
  String get tmdbImportDownloadingWatchlist =>
      'Jarraipen zerrenda deskargatzen...';

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
  String get tmdbImportConsentText =>
      'Inportazioak modu seguruan gehituko ditu zure TMDb zerrendak eta balorazioak MovieScout kontuan.';

  @override
  String get loginConsentText =>
      'Saioa hasita, zure datuak MovieScout zerbitzarietan gordetzea onartzen duzu gailuen artean sinkronizatzeko, gure';

  @override
  String get termsOfService => 'zerbitzu baldintzak';

  @override
  String get andThe => 'eta du';

  @override
  String get deleteAccount => 'Ezabatu kontua';

  @override
  String get deleteAccountConfirmTitle => 'Ezabatu kontua';

  @override
  String get deleteAccountConfirmMessage =>
      'Ziur zure kontua ezabatu nahi duzula? Ekintza hau itzulezina da eta zure zerrenda eta datu guztiak betiko ezabatuko ditu.';

  @override
  String get deleteAccountSuccess => 'Zure kontua behar bezala ezabatu da';

  @override
  String get deleteAccountError => 'Errore bat gertatu da kontua ezabatzean';

  @override
  String get comments => 'Iruzkinak';

  @override
  String get addComment => 'Gehitu iruzkina';

  @override
  String get editComment => 'Editatu iruzkina';

  @override
  String get deleteComment => 'Ezabatu iruzkina';

  @override
  String get writeComment => 'Idatzi iruzkin bat...';

  @override
  String get noCommentsYet => 'Ez dago iruzkinik oraindik';

  @override
  String get signInToComment => 'Saioa hasi behar duzu iruzkin bat gehitzeko.';

  @override
  String get deleteCommentConfirm => 'Ziur zure iruzkina ezabatu nahi duzula?';

  @override
  String get save => 'Gorde';

  @override
  String get you => 'Zu';

  @override
  String get followingTab => 'Jarraitzen';

  @override
  String get users => 'Erabiltzaileak';

  @override
  String get user => 'Erabiltzailea';

  @override
  String get follow => 'Jarraitu';

  @override
  String get following => 'Jarraitzen';

  @override
  String get unfollow => 'Jarraitzeari utzi';

  @override
  String get latestRatedTitles => 'Baloratutako azken izenburuak';

  @override
  String get emptyFollowingList =>
      'Oraindik ez duzu erabiltzailerik jarraitzen.';

  @override
  String get emptyFollowingSearchHint =>
      'Bilatu erabiltzaileak haiei jarraitzeko eta haien jarduera ikusteko.';

  @override
  String get networkErrorMessage =>
      'Ezin izan da zerbitzariarekin konektatu. Egiaztatu Interneteko konexioa.';

  @override
  String get publicProfileTitle => 'Profil publikoa';

  @override
  String get publicProfileSubtitle =>
      'Aktibatu zure profil publikoa ikusten ari zarena komunitatearekin partekatzeko';

  @override
  String get privateProfileMessage => 'Profil hau pribatua da';

  @override
  String get enablePublicProfileBanner =>
      'Aktibatu zure profil publikoa ikusten ari zarena komunitatearekin partekatzeko. Ezarpenetatik desaktiba daiteke.';

  @override
  String get enablePublicProfileButton => 'Aktibatu profil publikoa';

  @override
  String get noWatchingNowTitles => 'Ez dago titulurik ikusten orain';

  @override
  String get noRatedTitles => 'Ez dago baloratutako titulurik';

  @override
  String get communityTabTitle => 'Komunitatearen fitxa';

  @override
  String get communityTabSubtitle =>
      'Erakutsi komunitatearen fitxa nabigazio-barran';

  @override
  String get emptyFollowingCommunityHint =>
      'Fitxa hau ezarpenetatik ezkutatu dezakezu erabiltzen ez baduzu.';

  @override
  String get shareAppCommunityPrompt =>
      'Partekatu MovieScout zure ezagunekin eta hasi zure komunitatea sortzen.';

  @override
  String get shareAppButton => 'Partekatu MovieScout';

  @override
  String get shareAppMessage =>
      'Batu MovieScout-era filmak eta sailak ezagutzeko eta partekatzeko!';

  @override
  String get shareAppGooglePlay => 'Instalatu Google Play-n:';

  @override
  String get settingsSectionPreferences => 'Edukiaren hobespenak';

  @override
  String get settingsSectionNotifications => 'Jakinarazpenak';

  @override
  String get settingsSectionCommunity => 'Komunitatea eta profila';

  @override
  String get settingsSectionTools => 'Tresnak eta funtzioak';

  @override
  String get settingsSectionData => 'Datuak eta inportazioa';

  @override
  String get settingsNotificationsEnabledSubtitle =>
      'Erabilgarritasun-alertak aktibo';

  @override
  String get settingsNotificationsDisabledSubtitle =>
      'Erabilgarritasun-alertak desgaituta';

  @override
  String get settingsNotifySeasonComplete =>
      'Denboraldi osoa dagoenean jakinarazten du';

  @override
  String get settingsNotifySeasonFirstEp =>
      'Lehen atala estreinatzean bakarrik jakinarazten du';

  @override
  String settingsProvidersCount(Object count) {
    return '$count plataforma hautatuta';
  }

  @override
  String get settingsProvidersNone => 'Ez dago plataformarik hautatuta';

  @override
  String get settingsAiConfigured => 'API gakoa konfiguratuta';

  @override
  String get settingsAiNotConfigured => 'API gakorik gabe';

  @override
  String get settingsProfilePublic => 'Komunitatearentzat ikusgai';

  @override
  String get settingsProfilePrivate => 'Profil pribatua';

  @override
  String get settingsCommunityVisible => 'Beheko barran ikusgai';

  @override
  String get settingsCommunityHidden => 'Ezkutuan';

  @override
  String get settingsEditVisible => 'Fitxetan ikusgai';

  @override
  String get settingsEditHidden => 'Ezkutuan';

  @override
  String get settingsImdbSubtitle =>
      'CSV fitxategia (jarraipen-zerrenda eta iritziak)';

  @override
  String get settingsTmdbSubtitle => 'Jarraipen-zerrenda eta iritziak';

  @override
  String get settingsDeleteAccountSubtitle => 'Ekintza itzulezina';

  @override
  String get understood => 'Ulertuta';

  @override
  String get settingsInfoProvidersTitle => 'Eduki-plataformak';

  @override
  String get settingsInfoProvidersIntro =>
      'Nola erabiltzen ditu MovieScout-ek zure plataformak?';

  @override
  String get settingsInfoProvidersItem1Title => 'Erabilgarritasun-alertak';

  @override
  String get settingsInfoProvidersItem1Desc =>
      'MovieScout-ek aldizka eguneratzen du zure zerrendako titulu bakoitza TMDb-tik (JustWatch-en datuekin) non emititzen den jakiteko. Hemen hautatutako plataformaren batean badago, jakinaraziko dizu.';

  @override
  String get settingsInfoProvidersItem2Title => 'Bilaketetako iragazkia';

  @override
  String get settingsInfoProvidersItem2Desc =>
      'Iragazi katalogoa zure harpidetza aktiboekin ikus dezakezuna bakarrik ikusteko.';

  @override
  String get settingsInfoProvidersItem3Title => 'Eskualdeko katalogoa';

  @override
  String get settingsInfoProvidersItem3Desc =>
      'Erabilgarritasuna automatikoki egokitzen da ezarpenetan hautatutako herrialdera.';

  @override
  String get settingsInfoNotificationsTitle =>
      'Nola funtzionatzen dute jakinarazpenek?';

  @override
  String get settingsInfoNotificationsIntro =>
      'Erabilgarritasun-alerta automatikoak';

  @override
  String get settingsInfoNotificationsItem1Title => 'Zerrendako estreinaldiak';

  @override
  String get settingsInfoNotificationsItem1Desc =>
      'Jaso jakinarazpen bat zure jarraipen-zerrendako titulu bat hautatutako plataformetan erabilgarri dagoenean.';

  @override
  String get settingsInfoNotificationsItem2Title =>
      'Serieen denboraldi berriak';

  @override
  String get settingsInfoNotificationsItem2Desc =>
      'Lehenetsita lehen atalarekin jakinarazten dugu. \'Denboraldi osoa\' aktibatuta, atal guztiak emititu arte itxaroten da.';

  @override
  String get settingsInfoNotificationsItem3Title => 'Hondoko egiaztapenak';

  @override
  String get settingsInfoNotificationsItem3Desc =>
      'MovieScout-ek aldizka eta modu isilean egiaztatzen ditu berritasunak bateria gastatu gabe.';

  @override
  String get settingsInfoAiTitle => 'Adimen Artifiziala';

  @override
  String get settingsInfoAiIntro =>
      'Itzulpenen eta tituluen bilaketen hobekuntzak';

  @override
  String get settingsInfoAiItem1Title => 'Testuinguruko itzulpenak';

  @override
  String get settingsInfoAiItem1Desc =>
      'Sinopsien eta tituluen itzulpen naturalak sortzen ditu zure hizkuntzan erabilgarri ez daudenean.';

  @override
  String get settingsInfoAiItem2Title => 'Bilaketa adimenduna';

  @override
  String get settingsInfoAiItem2Desc =>
      'Bilatu filmak eszenak edo argumentuak deskribatuz titulua gogoratzen ez baduzu ere.';

  @override
  String get settingsInfoAiItem3Title => 'Gako pribatu eta segurua';

  @override
  String get settingsInfoAiItem3Desc =>
      'Zure API gakoa zure gailuan bakarrik gordetzen da modu seguru eta pribatuan.';

  @override
  String get settingsInfoAiNote =>
      'Garrantzitsua: Doako IA ereduek erantzun-denbora motelagoak edo aldi baterako mugak izan ditzakete. Errendimendu hoberena lortzeko, ordainpeko zerbitzua gomendatzen da.';

  @override
  String get settingsInfoProfileTitle => 'Profil Publikoa eta Komunitatea';

  @override
  String get settingsInfoProfileIntro => 'MovieScout-en alderdi soziala';

  @override
  String get settingsInfoProfileItem1Title => 'Partekatu zure jarduera';

  @override
  String get settingsInfoProfileItem1Desc =>
      'Beste erabiltzaileei zure profila aurkitzeko eta ikusten eta baloratzen duzuna ikusteko aukera ematen die.';

  @override
  String get settingsInfoProfileItem2Title => 'Pribatutasuna bermatuta';

  @override
  String get settingsInfoProfileItem2Desc =>
      'Profil pribatura alda dezakezu nahi duzunean. Tituluak eta balorazioak bakarrik partekatzen dira, inoiz ez datu pertsonalak.';

  @override
  String get settingsInfoProfileItem3Title => 'Komunitatearen fitxa';

  @override
  String get settingsInfoProfileItem3Desc =>
      'Erakutsi edo ezkutatu komunitatearen fitxa beheko barran zure hobespenen arabera.';

  @override
  String get settingsInfoEditTitle => 'Lankidetza eta edizioa TMDbn';

  @override
  String get settingsInfoEditIntro =>
      'Lagundu datu-base librea handitzen eta informazioa hobetzen.';

  @override
  String get settingsInfoEditItem1Title => 'Fitxatik zuzeneko sarbidea';

  @override
  String get settingsInfoEditItem1Desc =>
      'Arkatz ikono bat erakusten du filmen eta telesailen fitxetan, TMDb-ko edizio orrira zuzenean joateko.';

  @override
  String get settingsInfoEditItem2Title => 'Komunitatea eta datu irekiak';

  @override
  String get settingsInfoEditItem2Desc =>
      'MovieScout-eko informazio guztia The Movie Database (TMDb)-tik dator, komunitateak mantendutako proiektu kolaboratiboa.';

  @override
  String get settingsInfoEditItem3Title => 'Edukiak eta itzulpenak hobetzea';

  @override
  String get settingsInfoEditItem3Desc =>
      'Edozein hizkuntzatan izenburuak, sinopsiak eta xehetasunak gehitu edo zuzendu ditzakezu.';

  @override
  String get settingsInfoEditNote =>
      'TMDb-n edukia editatzeko themoviedb.org webgunean doako kontu batekin saioa hasi besterik ez duzu behar.';

  @override
  String get spanishLatam => 'Español (Latinoamérica)';

  @override
  String get discoveryResetFilters => 'Reset filters';

  @override
  String get discoveryThemeAny => 'Any';

  @override
  String get discoveryThemeSpace => 'Space & Universe';

  @override
  String get discoveryThemeTimeTravel => 'Time Travel & Multiverse';

  @override
  String get discoveryThemeDystopiaAi => 'Dystopia, AI & Cyberpunk';

  @override
  String get discoveryThemeHeist => 'Heists & Scams';

  @override
  String get discoveryThemeWhodunit => 'Mystery & Whodunit';

  @override
  String get discoveryThemePsychologicalThriller => 'Psychological Thrillers';

  @override
  String get discoveryThemeSuperhero => 'Superheroes & Comics';

  @override
  String get discoveryThemeZombiesApocalypse => 'Zombies & Apocalypse';

  @override
  String get discoveryThemeSupernatural => 'Ghosts & Supernatural';

  @override
  String get discoveryThemeMedievalFantasy => 'Medieval & Sorcery';

  @override
  String get discoveryThemeWar => 'War & Military';

  @override
  String get discoveryThemeAdrenalineAction => 'Action & Adrenaline';

  @override
  String get discoveryThemeComedy => 'Feel-Good Comedy';

  @override
  String get discoveryThemeTearjerkerDrama => 'Drama & Emotion';

  @override
  String get discoveryThemeSurvivalAdventure => 'Adventure & Survival';

  @override
  String get discoveryThemeFilmNoirMafia => 'Film Noir & Mafia';

  @override
  String get discoveryModeForYou => 'For you';

  @override
  String get discoveryModeHiddenGems => 'Hidden gems';

  @override
  String get discoveryModeTopRated => 'Top rated';

  @override
  String get discoveryModeNewReleases => 'New releases';

  @override
  String get discoveryEpochAll => 'All epochs';

  @override
  String get discoveryEpoch2020s => 'Current (2020s)';

  @override
  String get discoveryEpoch2010s => '2010s';

  @override
  String get discoveryEpoch2000s => '2000s';

  @override
  String get discoveryEpoch80s90s => '80s & 90s';

  @override
  String get discoveryEpochClassics => 'Classics (< 1980)';

  @override
  String get discoveryDurationAny => 'Any runtime';

  @override
  String get discoveryDurationShort => 'Short (< 90 min)';

  @override
  String get discoveryDurationStandard => 'Standard (90 - 120 min)';

  @override
  String get discoveryDurationEpic => 'Epic (> 120 min)';
}
