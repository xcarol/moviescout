// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Descarregant Detalls';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Obtenint dades de títols ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Actualitzant Plataformes';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Comprovant disponibilitat ($progress/$total)...';
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
  String get selectLanguage => 'Selecciona l\'idioma';

  @override
  String get messageEmptyList => 'Encara no s\'ha escollit cap pel·lícula.';

  @override
  String get messageEmptySearch =>
      'Pots fer una cerca utilitzant la lupa de la barra inferior.';

  @override
  String get messageEmptyOptions => 'També pots';

  @override
  String get messageEmptyLogin => 'Iniciar sessió a MovieScout';

  @override
  String get search => 'Cerca un títol';

  @override
  String get searchAiHint => 'Descriu la pel·lícula o sèrie que busques...';

  @override
  String get searchAiTooltip => 'Cerca Intel·ligent (IA)';

  @override
  String get searchTitle => 'Cerca';

  @override
  String get searchPerson => 'Cerca algú';

  @override
  String get gallery => 'Galeria';

  @override
  String get searchProvider => 'Cerca un proveïdor';

  @override
  String get trailer => 'Tràiler';

  @override
  String get includeGenres => 'Incloure';

  @override
  String get excludeGenres => 'Excloure';

  @override
  String get pressBackAgainToExit => 'Prem de nou per sortir';

  @override
  String get back => 'Enrere';

  @override
  String get username => 'Usuari';

  @override
  String get anonymousUser => 'Sense usuari';

  @override
  String get loginTitle => 'Inici de sessió';

  @override
  String get login => 'Inicia sessió';

  @override
  String get logout => 'Tanca sessió';

  @override
  String get loginSuccess => 'Sessió iniciada correctament.';

  @override
  String get loginFailed => 'Usuari o contrasenya incorrectes.';

  @override
  String get logoutSuccess => 'Sessió tancada correctament.';

  @override
  String get loginToTmdb => 'Inicia sessió amb TMDb';

  @override
  String get completeLoginToTmdb => 'Completa l\'inici de sessió';

  @override
  String get signInToWatchlist => 'Cal iniciar sessió per afegir títols.';

  @override
  String get tvShow => 'Sèrie';

  @override
  String get movie => 'Pel·lícula';

  @override
  String get select => 'Sel·lecciona';

  @override
  String get imdbImport => 'Importació de IMDB';

  @override
  String get imdbImportHint => 'Sel·lecciona un arxiu CSV exportat de IMDB';

  @override
  String get imdbImportWatchlist => 'Importar Per Veure';

  @override
  String get imdbImportRateslist => 'Importar Valoracions';

  @override
  String get missingDescription => 'Falta la descripció';

  @override
  String get flatrateProviders => 'Subscripció';

  @override
  String get rentProviders => 'Lloguer';

  @override
  String get buyProviders => 'Compra';

  @override
  String get freeProviders => 'Gratuït';

  @override
  String get adsProviders => 'Amb anuncis';

  @override
  String get allTypes => 'Títols';

  @override
  String get movies => 'Pel·lícules';

  @override
  String get tvshows => 'Sèries';

  @override
  String get miniseries => 'Minisèries';

  @override
  String get collection => 'Col·lecció';

  @override
  String get seeCollection => 'Veure la col·lecció';

  @override
  String get sortAlphabetically => 'Alfabètic';

  @override
  String get sortRating => 'Valoració';

  @override
  String get sortUserRating => 'Valoració (Meva)';

  @override
  String get sortReleaseDate => 'Data d\'estrena';

  @override
  String get sortRuntime => 'Duració';

  @override
  String get sortDateRated => 'Data de valoració';

  @override
  String get sortRelevance => 'Rellevància';

  @override
  String get sortAddedOrder => 'Data d\'addició';

  @override
  String get genres => 'Gèneres';

  @override
  String get titles => 'Títols';

  @override
  String get rate_date => 'Data de valoració';

  @override
  String get your_rate => 'La teva valoració';

  @override
  String get reset_rate => 'Elimina la valoració';

  @override
  String get emptyRates => 'Encara no has valorat cap títol.';

  @override
  String get seen => 'Vist';

  @override
  String get markAsSeen => 'Marca com a vist';

  @override
  String get ratedOnly => 'Valorades';

  @override
  String get seenOnly => 'Vistes';

  @override
  String get followingOnly => 'Seguint';

  @override
  String get emptyList => 'No hi ha ningú per aquí.';

  @override
  String get watchlistTitle => 'Per veure';

  @override
  String get rateslistTitle => 'Valorades';

  @override
  String get yes => 'Sí';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get originaTitle => 'Títol original';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get originCountry => 'País';

  @override
  String get defaultScheme => 'Per defecte';

  @override
  String get about => 'Quant a...';

  @override
  String get aboutDescription =>
      'MovieScout és el teu cercador de pel·lícules i sèries amb dades de TMDb, OMDb i JustWatch.';

  @override
  String get aboutGithub => 'Visita el projecte a ';

  @override
  String get apiDisclaimer =>
      'Aquest producte utilitza l\'API de TMDB, però no està avalat ni certificat per TMDB.';

  @override
  String get privacyDisclaimerPrefix => 'Consulta la ';

  @override
  String get privacyDisclaimer => 'política de privadesa';

  @override
  String get recommended => 'Recomanats';

  @override
  String get providersTitle => 'Plataformes de contingut';

  @override
  String get providers => 'Plataformes';

  @override
  String get filterByProviders => 'Només disponibles';

  @override
  String get noProvidersAvailable => 'No hi ha plataformes disponibles';

  @override
  String get discoverlistTitle => 'Descobreix';

  @override
  String get notReleasedYet => 'Encara no s\'ha estrenat';

  @override
  String get unknownDuration => 'Duració no especificada.';

  @override
  String get cast => 'Repartiment';

  @override
  String get crew => 'Equip tècnic';

  @override
  String get seeThemAll => 'Veure-ho tot';

  @override
  String get ratedCredits => 'Crèdits valorats';

  @override
  String get birthDate => 'Data de naixement';

  @override
  String get deathDate => 'Data de defunció';

  @override
  String get placeOfBirth => 'Lloc de neixament';

  @override
  String get years => 'Anys';

  @override
  String get job => 'Càrrec';

  @override
  String get department => 'Departament';

  @override
  String get watchingNow => 'Mirant ara';

  @override
  String get pinLimitReached => 'Has arribat al límit de 5 títols fixats.';

  @override
  String get pin => 'Fixar';

  @override
  String get unpin => 'Desfixar';

  @override
  String get notificationTitle => 'Ja disponible!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title ja està disponible a $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nova temporada!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nova temporada de $title disponible a $provider.';
  }

  @override
  String get selectRegion => 'Selecciona la regió';

  @override
  String get searchRegion => 'Cerca una regió';

  @override
  String get regionAuto => 'Detecció automàtica (IP)';

  @override
  String get shareLink => 'Compartir';

  @override
  String get director => 'Director';

  @override
  String get creator => 'Creador';

  @override
  String get writer => 'Escriptor';

  @override
  String seasonsCount(Object count) {
    return '${count}temp';
  }

  @override
  String get notifications => 'Notificacions';

  @override
  String get notificationsPermissionRequired =>
      'Cal que permetis les notificacions a la configuració del sistema.';

  @override
  String get notificationsPermissionDescription =>
      'Per rebre avisos de disponibilitat de pel·lícules i noves temporades, cal que activis les notificacions als ajustos del sistema.';

  @override
  String get openSettings => 'Obrir ajustos';

  @override
  String get settings => 'Configuració';

  @override
  String get errorMessageGeneric =>
      'S\'ha produït un error. Torna-ho a provar més tard.';

  @override
  String get notificationsHistory => 'Últimes notificacions';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

  @override
  String get episodes => 'Episodis';

  @override
  String get selectSeason => 'Veure les temporades';

  @override
  String seasonLabel(Object count) {
    return 'Temporada $count';
  }

  @override
  String get notifyTitle => 'Notificar noves temporades';

  @override
  String get notifyMessage =>
      'Vols que t\'avisem quan hi hagi una nova temporada?';

  @override
  String get no => 'No';

  @override
  String get none => 'Cap';

  @override
  String get results => 'Resultats';

  @override
  String inRoleContext(Object context) {
    return ' a $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episodi $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get showEditContent => 'Mostrar botó d\'edició';

  @override
  String get translations => 'Traduccions';

  @override
  String get copiedToClipboard => 'Text copiat al portapapers';

  @override
  String get close => 'Tancar';

  @override
  String get autoTranslation => 'Traducció Automàtica';

  @override
  String get originalText => 'Text Original';

  @override
  String get addToHomeScreen => 'Afegir a la pantalla d\'inici';

  @override
  String get shortcutFailed => 'No s\'ha pogut afegir la drecera';

  @override
  String get rate => 'Valora';

  @override
  String get watchOn => 'Veure a';

  @override
  String get status => 'Estat';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Intel·ligència Artificial';

  @override
  String get aiSettingsSubtitle => 'Cerca intel·ligent i funcions d\'IA';

  @override
  String get aiSettingsDescription =>
      'Les funcions d\'IA et permeten trobar pel·lícules i sèries basant-se en descripcions en llenguatge natural i més eines intel·ligents. Per utilitzar-les, pots obtenir una clau gratuïta a OpenRouter (sense necessitat de targeta).';

  @override
  String get aiGetApiKeyButton => 'Obtenir clau a OpenRouter';

  @override
  String get aiApiKeyLabel => 'Clau API d\'OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Desar clau';

  @override
  String get aiDeleteKeyButton => 'Eliminar';

  @override
  String get aiKeySaved => 'Clau API desada correctament';

  @override
  String get aiKeyCleared => 'Clau API eliminada';

  @override
  String get aiStatusConfigured => 'Clau API configurada';

  @override
  String get aiStatusNotConfigured => 'Clau API no configurada';

  @override
  String get delete => 'Eliminar';

  @override
  String get aiDeleteConfirmTitle => 'Eliminar clau API';

  @override
  String get aiDeleteConfirmMessage =>
      'Segur que vols eliminar la clau API? Tingues en compte que OpenRouter no permet consultar la clau un cop creada i n\'hauràs de generar una de nova si no la tens guardada.';

  @override
  String get searchTimeout =>
      'La cerca ha trigat massa temps a respondre. Torna-ho a provar.';

  @override
  String get aiSearchTimeout =>
      'La cerca amb IA ha trigat massa temps. Prova amb una descripció menys específica o més curta.';

  @override
  String get aiSearchError =>
      'S\'ha produït un error en la cerca IA. Torna-ho a provar.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'S\'ha superat el límit temporal de l\'API. Espera $seconds segons abans de tornar-ho a provar.';
  }

  @override
  String get aiRateLimitGeneric =>
      'S\'ha superat el límit temporal de l\'API. Espera una estona abans de tornar-ho a provar.';

  @override
  String get signInWithGoogle => 'Inicia sessió amb Google';

  @override
  String get loginSubtitle =>
      'Inicia sessió per desar i sincronitzar les teves llistes i valoracions.';

  @override
  String get googleSignInButton => 'Continua amb Google';

  @override
  String get tmdbAccount => 'Compte de TMDb';

  @override
  String get tmdbImport => 'Importació de TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importació de TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importa les teves dades de TMDb';

  @override
  String get tmdbImportScreenBody =>
      'Pots importar les teves llistes de seguiment i valoracions des del teu compte de TMDb al teu compte de MovieScout. Caldrà que iniciïs sessió a TMDb. Un cop finalitzada la importació, la sessió de TMDb es tancarà automàticament.';

  @override
  String get tmdbImportStartButton => 'Començar la importació';

  @override
  String get tmdbImportSuccess => 'Dades importades amb èxit!';

  @override
  String get tmdbImportDownloadingWatchlist =>
      'Descarregant la llista de seguiment...';

  @override
  String get tmdbImportDownloadingRateslist =>
      'Descarregant les valoracions...';

  @override
  String get tmdbImportDownloadingEpisodes =>
      'Descarregant episodis valorats...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count títols a la llista de seguiment';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count títols valorats';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episodis valorats';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronització amb el compte';

  @override
  String get tmdbImportUploading => 'Pujant al teu compte...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count elements pujats al teu compte';
  }

  @override
  String get tmdbImportError => 'Error en importar les dades';

  @override
  String get tmdbImportConsentText =>
      'La importació afegirà les teves llistes i valoracions de TMDb al teu compte de MovieScout de manera segura.';

  @override
  String get loginConsentText =>
      'En iniciar sessió, acceptes emmagatzemar les teves dades als servidors de MovieScout per sincronitzar-les entre dispositius, d\'acord amb la nostra ';

  @override
  String get termsOfService => 'termes de servei';

  @override
  String get andThe => ' i els ';

  @override
  String get deleteAccount => 'Eliminar compte';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar compte';

  @override
  String get deleteAccountConfirmMessage =>
      'Segur que vols eliminar el teu compte? Aquesta acció és irreversible i s\'esborraran totes les teves llistes i dades de manera permanent.';

  @override
  String get deleteAccountSuccess =>
      'El teu compte s\'ha eliminat correctament';

  @override
  String get deleteAccountError => 'Error en eliminar el compte';

  @override
  String get comments => 'Comentaris';

  @override
  String get addComment => 'Afegir comentari';

  @override
  String get editComment => 'Editar comentari';

  @override
  String get deleteComment => 'Eliminar comentari';

  @override
  String get writeComment => 'Escriu un comentari...';

  @override
  String get noCommentsYet => 'Encara no hi ha cap comentari';

  @override
  String get signInToComment => 'Inicia sessió per afegir un comentari';

  @override
  String get deleteCommentConfirm =>
      'Segur que vols eliminar el teu comentari?';

  @override
  String get save => 'Desa';

  @override
  String get you => 'Tu';

  @override
  String get followingTab => 'Seguint';

  @override
  String get users => 'Usuaris';

  @override
  String get user => 'Usuari';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguint';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String get latestRatedTitles => 'Últims títols valorats';

  @override
  String get emptyFollowingList => 'Encara no segueixes cap usuari.';

  @override
  String get emptyFollowingSearchHint =>
      'Cerca usuaris per seguir-los i veure la seva activitat.';

  @override
  String get networkErrorMessage =>
      'No s\'ha pogut connectar amb el servidor. Comprova la connexió a internet.';

  @override
  String get publicProfileTitle => 'Perfil públic';

  @override
  String get publicProfileSubtitle =>
      'Activa el teu perfil públic per compartir el que mires amb la comunitat';

  @override
  String get privateProfileMessage => 'Aquest perfil és privat';

  @override
  String get enablePublicProfileBanner =>
      'Activa el teu perfil públic per compartir el que mires amb la comunitat. Es pot desactivar des de la configuració.';

  @override
  String get enablePublicProfileButton => 'Activar perfil públic';

  @override
  String get noWatchingNowTitles => 'No està mirant cap títol ara mateix';

  @override
  String get noRatedTitles => 'No hi ha cap títol valorat';

  @override
  String get communityTabTitle => 'Pestanya de comunitat';

  @override
  String get communityTabSubtitle =>
      'Mostra la pestanya de comunitat a la barra de navegació';

  @override
  String get emptyFollowingCommunityHint =>
      'Pots amagar aquesta pestanya des de la configuració si no la fas servir.';

  @override
  String get shareAppCommunityPrompt =>
      'Comparteix MovieScout amb els teus coneguts i comença a crear la teva comunitat.';

  @override
  String get shareAppButton => 'Compartir MovieScout';

  @override
  String get shareAppMessage =>
      'Uneix-te a MovieScout per descobrir i compartir pel·lícules i sèries!';

  @override
  String get shareAppGooglePlay => 'Instal·la-la a Google Play:';

  @override
  String get settingsSectionPreferences => 'Preferències de contingut';

  @override
  String get settingsSectionNotifications => 'Notificacions';

  @override
  String get settingsSectionCommunity => 'Comunitat i perfil';

  @override
  String get settingsSectionTools => 'Eines i funcions';

  @override
  String get settingsSectionData => 'Dades i importació';

  @override
  String get settingsNotificationsEnabledSubtitle =>
      'Avisos de disponibilitat actius';

  @override
  String get settingsNotificationsDisabledSubtitle =>
      'Avisos de disponibilitat desactivats';

  @override
  String get settingsNotifySeasonComplete =>
      'Avisa quan la temporada està sencera';

  @override
  String get settingsNotifySeasonFirstEp =>
      'Avisa només quan s\'estrena el primer capítol';

  @override
  String settingsProvidersCount(Object count) {
    return '$count plataformes seleccionades';
  }

  @override
  String get settingsProvidersNone => 'Cap plataforma seleccionada';

  @override
  String get settingsAiConfigured => 'Clau d\'API configurada';

  @override
  String get settingsAiNotConfigured => 'Sense clau configurada';

  @override
  String get settingsProfilePublic => 'Visible per a la comunitat';

  @override
  String get settingsProfilePrivate => 'Perfil privat';

  @override
  String get settingsCommunityVisible => 'Visible a la barra inferior';

  @override
  String get settingsCommunityHidden => 'Amagada';

  @override
  String get settingsEditVisible => 'Visibles a les fitxes';

  @override
  String get settingsEditHidden => 'Ocults';

  @override
  String get settingsImdbSubtitle =>
      'Fitxer CSV (llista de seguiment i valoracions)';

  @override
  String get settingsTmdbSubtitle => 'Llista de seguiment i valoracions';

  @override
  String get settingsDeleteAccountSubtitle => 'Acció irreversible';

  @override
  String get understood => 'Entesos';

  @override
  String get settingsInfoProvidersTitle => 'Plataformes de contingut';

  @override
  String get settingsInfoProvidersIntro =>
      'Com utilitza MovieScout les teves plataformes?';

  @override
  String get settingsInfoProvidersItem1Title => 'Avisos de disponibilitat';

  @override
  String get settingsInfoProvidersItem1Desc =>
      'MovieScout actualitza periòdicament cada títol de la teva llista des de TMDb (amb dades de JustWatch) per saber on s\'emet. Si coincideix amb alguna de les plataformes que has marcat aquí, t\'avisa.';

  @override
  String get settingsInfoProvidersItem2Title =>
      'Filtre a les cerques i llistes';

  @override
  String get settingsInfoProvidersItem2Desc =>
      'Podràs filtrar ràpidament el catàleg per veure només el contingut que pots reproduir directament amb les teves subscripcions actives.';

  @override
  String get settingsInfoProvidersItem3Title => 'Catàleg segons la teva regió';

  @override
  String get settingsInfoProvidersItem3Desc =>
      'La disponibilitat dels títols a cada plataforma s\'adapta automàticament al país seleccionat a la configuració.';

  @override
  String get settingsInfoNotificationsTitle =>
      'Com funcionen les notificacions?';

  @override
  String get settingsInfoNotificationsIntro =>
      'Avisos automàtics de disponibilitat';

  @override
  String get settingsInfoNotificationsItem1Title =>
      'Arribada a les teves plataformes';

  @override
  String get settingsInfoNotificationsItem1Desc =>
      'T\'avisarem quan un títol de la teva llista de seguiment comenci a estar disponible en alguna de les teves plataformes seleccionades.';

  @override
  String get settingsInfoNotificationsItem2Title =>
      'Noves temporades de sèries';

  @override
  String get settingsInfoNotificationsItem2Desc =>
      'Per defecte t\'avisem tan bon punt s\'estrena el primer capítol d\'una nova temporada. Si actives \'Temporada completa\', només t\'avisarem quan s\'hagin emès tots els episodis.';

  @override
  String get settingsInfoNotificationsItem3Title =>
      'Comprovacions en segon pla';

  @override
  String get settingsInfoNotificationsItem3Desc =>
      'MovieScout actualitza les dades periòdicament de manera silenciosa i respectuosa amb la teva bateria.';

  @override
  String get settingsInfoAiTitle => 'Intel·ligència Artificial';

  @override
  String get settingsInfoAiIntro =>
      'Millores en la cerca i traducció de títols';

  @override
  String get settingsInfoAiItem1Title => 'Traduccions contextuals';

  @override
  String get settingsInfoAiItem1Desc =>
      'Quan una pel·lícula o sèrie no té sinopsi en el teu idioma, la IA genera traduccions adaptades al to cinematogràfic, evitant traduccions literals.';

  @override
  String get settingsInfoAiItem2Title => 'Cerca intel·ligent';

  @override
  String get settingsInfoAiItem2Desc =>
      'Pots trobar pel·lícules descrivint escenes, arguments o personatges encara que no en recordis el títol.';

  @override
  String get settingsInfoAiItem3Title => 'Clau privada i segura';

  @override
  String get settingsInfoAiItem3Desc =>
      'La teva clau d\'API es guarda exclusivament al teu dispositiu de forma segura i privada.';

  @override
  String get settingsInfoAiNote =>
      'Important: Els models gratuïts d\'IA poden tenir temps de resposta més lents o límits de peticions temporals dependents del proveïdor. Per a un rendiment òptim i instantani, es recomana un servei de pagament per ús.';

  @override
  String get settingsInfoProfileTitle => 'Perfil Públic i Comunitat';

  @override
  String get settingsInfoProfileIntro => 'La dimensió social de MovieScout';

  @override
  String get settingsInfoProfileItem1Title => 'Comparteix la teva activitat';

  @override
  String get settingsInfoProfileItem1Desc =>
      'Permet que altres usuaris puguin trobar el teu perfil, seguir-te i consultar quins títols estàs veient i les teves puntuacions.';

  @override
  String get settingsInfoProfileItem2Title => 'Privadesa garantida';

  @override
  String get settingsInfoProfileItem2Desc =>
      'Pots desactivar el perfil públic quan vulguis. Només es comparteixen les teves llistes públiques i valoracions; mai les teves dades personals.';

  @override
  String get settingsInfoProfileItem3Title => 'Pestanya de comunitat';

  @override
  String get settingsInfoProfileItem3Desc =>
      'Pots mostrar o amagar la pestanya de comunitat a la barra de navegació inferior segons les teves preferències.';

  @override
  String get settingsInfoEditTitle => 'Col·laboració i edició a TMDb';

  @override
  String get settingsInfoEditIntro =>
      'Ajuda a fer créixer la base de dades lliure i a millorar la informació.';

  @override
  String get settingsInfoEditItem1Title => 'Accés directe des de la fitxa';

  @override
  String get settingsInfoEditItem1Desc =>
      'Mostra una icona de llapis a les fitxes de pel·lícules i sèries per accedir directament a la seva pàgina d\'edició.';

  @override
  String get settingsInfoEditItem2Title => 'Comunitat i dades obertes';

  @override
  String get settingsInfoEditItem2Desc =>
      'Tota la informació de MovieScout prové de The Movie Database (TMDb), un projecte col·laboratiu mantingut per la comunitat.';

  @override
  String get settingsInfoEditItem3Title => 'Millora de contingut i traduccions';

  @override
  String get settingsInfoEditItem3Desc =>
      'Pots afegir o corregir títols, sinopsis i detalls en qualsevol idioma perquè tothom se\'n pugui beneficiar.';

  @override
  String get settingsInfoEditNote =>
      'Per editar contingut a TMDb només cal iniciar sessió amb un compte gratuït a themoviedb.org.';

  @override
  String get spanishLatam => 'Español (Latinoamérica)';

  @override
  String get discoveryResetFilters => 'Restablir filtres';

  @override
  String get discoveryThemeAny => 'Qualsevol';

  @override
  String get discoveryThemeSpace => 'Espai i Univers';

  @override
  String get discoveryThemeTimeTravel => 'Viatges en el temps i Multivers';

  @override
  String get discoveryThemeDystopiaAi => 'Distòpies, IA i Ciberpunk';

  @override
  String get discoveryThemeHeist => 'Atracaments i Estafes';

  @override
  String get discoveryThemeWhodunit => 'Intriga i Enigmes (Whodunit)';

  @override
  String get discoveryThemePsychologicalThriller => 'Thrillers psicològics';

  @override
  String get discoveryThemeSuperhero => 'Superherois i Còmic';

  @override
  String get discoveryThemeZombiesApocalypse => 'Zombis i Apocalipsi';

  @override
  String get discoveryThemeSupernatural => 'Fantasmes i Sobrenatural';

  @override
  String get discoveryThemeMedievalFantasy => 'Medieval i Bruixeria';

  @override
  String get discoveryThemeWar => 'Guerra i Conflictes bèl·lics';

  @override
  String get discoveryThemeAdrenalineAction => 'Acció i Adrenalina';

  @override
  String get discoveryThemeComedy => 'Comèdia per desconnectar';

  @override
  String get discoveryThemeTearjerkerDrama => 'Drames i Emoció';

  @override
  String get discoveryThemeSurvivalAdventure => 'Aventura i Supervivència';

  @override
  String get discoveryThemeFilmNoirMafia => 'Cinema Negre i Màfia';

  @override
  String get discoveryModeForYou => 'Per a tu';

  @override
  String get discoveryModeHiddenGems => 'Joies ocultes';

  @override
  String get discoveryModeTopRated => 'Aclamades';

  @override
  String get discoveryModeNewReleases => 'Estrenes';

  @override
  String get discoveryEpochAll => 'Totes les èpoques';

  @override
  String get discoveryEpoch2020s => 'Actuals (2020s)';

  @override
  String get discoveryEpoch2010s => 'Dècada 2010s';

  @override
  String get discoveryEpoch2000s => 'Dècada 2000s';

  @override
  String get discoveryEpoch80s90s => 'Anys 80s i 90s';

  @override
  String get discoveryEpochClassics => 'Clàssics (< 1980)';

  @override
  String get discoveryDurationAny => 'Qualsevol durada';

  @override
  String get discoveryDurationShort => 'Pel·lícules curtes (40 - 90 min)';

  @override
  String get discoveryDurationStandard => 'Estàndard (90 - 120 min)';

  @override
  String get discoveryDurationEpic => 'Èpiques (> 120 min)';

  @override
  String get discoveryDurationShortFilm => 'Curtmetratges (< 40 min)';
}
