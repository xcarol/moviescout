// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class AppLocalizationsGl extends AppLocalizations {
  AppLocalizationsGl([String locale = 'gl']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Descargando detalles';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Obtendo datos do título ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Plataformas de actualización';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Comprobando dispoñibilidade ($progress/$total)...';
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
  String get selectLanguage => 'Seleccione o idioma';

  @override
  String get messageEmptyList => 'Aínda non se seleccionou ningunha película.';

  @override
  String get messageEmptySearch => 'Podes facer unha busca usando a lupa da barra inferior.';

  @override
  String get messageEmptyOptions => 'Tamén podes';

  @override
  String get messageEmptyLogin => 'Inicia sesión en MovieScout';

  @override
  String get search => 'Busca un título';

  @override
  String get searchAiHint => 'Describe a película ou a serie que buscas...';

  @override
  String get searchAiTooltip => 'Busca intelixente (AI)';

  @override
  String get searchTitle => 'Busca';

  @override
  String get searchPerson => 'buscar alguén';

  @override
  String get searchPlaceholder => 'Busca películas ou series...';

  @override
  String get gallery => 'Galería';

  @override
  String get searchProvider => 'Atopar un provedor';

  @override
  String get trailer => 'Tráiler';

  @override
  String get includeGenres => 'Incluír';

  @override
  String get excludeGenres => 'Excluír';

  @override
  String get pressBackAgainToExit => 'Preme de novo para saír';

  @override
  String get back => 'De volta';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contrasinal';

  @override
  String get anonymousUser => 'Ningún usuario';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginDescription => 'Inicia sesión na túa conta TMDB';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Pechar sesión';

  @override
  String get loginSuccess => 'A sesión comezou con éxito.';

  @override
  String get loginFailed => 'Nome de usuario ou contrasinal incorrectos.';

  @override
  String get logoutSuccess => 'Sesión pechada correctamente.';

  @override
  String get loginToTmdb => 'Inicia sesión en TMDb';

  @override
  String get completeLoginToTmdb => 'Completa o inicio de sesión';

  @override
  String get signupToTmdb => 'Rexístrate en TMDb';

  @override
  String get signInToWatchlist => 'Debes iniciar sesión para engadir títulos.';

  @override
  String get tvShow => 'Serie';

  @override
  String get movie => 'Película';

  @override
  String get select => 'Seleccione';

  @override
  String get imdbImport => 'Importación IMDB';

  @override
  String get imdbImportHint => 'Seleccione un ficheiro CSV exportado desde IMDB';

  @override
  String get imdbImportWatchlist => 'Importar para ver';

  @override
  String get imdbImportRateslist => 'Importar comentarios';

  @override
  String get imdbImportCount => 'Títulos importados correctamente';

  @override
  String get imdbResetWatchlist => 'BORRAR PARA VER';

  @override
  String get imdbResetRateslist => 'BORRAR RECENSIÓNS';

  @override
  String get imdbConfirmationTitle => 'ATENCIÓN';

  @override
  String get imdbResetWatchlistConfirmation => 'Estás seguro de que queres eliminar os títulos Para ver?';

  @override
  String get imdbResetRateslistConfirmation => 'Estás seguro de que queres eliminar as recensións?';

  @override
  String get resetWatchlistCount => 'Títulos a ver:';

  @override
  String get resetRateslistCount => 'Títulos valorados:';

  @override
  String get missingDescription => 'Falta descrición';

  @override
  String get flatrateProviders => 'Subscrición';

  @override
  String get rentProviders => 'Aluguer';

  @override
  String get buyProviders => 'Compras';

  @override
  String get allTypes => 'Valores';

  @override
  String get movies => 'Películas';

  @override
  String get tvshows => 'Serie';

  @override
  String get miniseries => 'Miniserie';

  @override
  String get collection => 'Colección';

  @override
  String get seeCollection => 'Ver a colección';

  @override
  String get sortAlphabetically => 'Alfabético';

  @override
  String get sortRating => 'Avaliación';

  @override
  String get sortUserRating => 'Valoración (Mia)';

  @override
  String get sortReleaseDate => 'Data de lanzamento';

  @override
  String get sortRuntime => 'Duración';

  @override
  String get sortDateRated => 'Data de valoración';

  @override
  String get sortRelevance => 'Relevancia';

  @override
  String get sortAddedOrder => 'Data engadida';

  @override
  String get genres => 'Xéneros';

  @override
  String get titles => 'Valores';

  @override
  String get rate_date => 'Data de valoración';

  @override
  String get your_rate => 'A túa valoración';

  @override
  String get reset_rate => 'Elimina a túa recensión';

  @override
  String get emptyRates => 'Aínda non valoraches ningún título.';

  @override
  String get seen => 'Visto';

  @override
  String get markAsSeen => 'Marca como visto';

  @override
  String get ratedOnly => 'Valorado';

  @override
  String get seenOnly => 'Vistas';

  @override
  String get followingOnly => 'Seguindo';

  @override
  String get pendingOnly => 'Pendentes';

  @override
  String get emptyList => 'Aquí nada.';

  @override
  String get watchlistTitle => 'para ver';

  @override
  String get rateslistTitle => 'Valorado';

  @override
  String get yes => 'Si';

  @override
  String get cancel => 'Cancelar';

  @override
  String get originaTitle => 'Título orixinal';

  @override
  String get originalLanguage => 'Lingua orixinal';

  @override
  String get originCountry => 'País';

  @override
  String get schemeSelectTitle => 'Seleccione a cor';

  @override
  String get defaultScheme => 'Por defecto';

  @override
  String get blackScheme => 'Negro';

  @override
  String get blueScheme => 'Azul';

  @override
  String get redScheme => 'Vermello';

  @override
  String get about => 'Sobre...';

  @override
  String get aboutDescription => 'MovieScout é o teu motor de busca de películas e series con datos de TMDb, OMDb e JustWatch.';

  @override
  String get aboutGithub => 'Visita o proxecto en';

  @override
  String get apiDisclaimer => 'Este produto usa a API de TMDB, pero non está avalado nin certificado por TMDB.';

  @override
  String get privacyDisclaimerPrefix => 'Consulta o';

  @override
  String get privacyDisclaimer => 'Política de privacidade';

  @override
  String get recommended => 'Recomendado';

  @override
  String get providersTitle => 'Plataformas de contidos';

  @override
  String get providers => 'Plataformas';

  @override
  String get filterByProviders => 'Só dispoñible';

  @override
  String get noProvidersAvailable => 'Non hai plataformas dispoñibles';

  @override
  String get discoverlistTitle => 'Descubrir';

  @override
  String get notReleasedYet => 'Aínda non foi lanzado';

  @override
  String get unknownDuration => 'Duración non especificada.';

  @override
  String get cast => 'Cast';

  @override
  String get crew => 'Equipo técnico';

  @override
  String get seeThemAll => 'Ver todo';

  @override
  String get ratedCredits => 'Créditos valorados';

  @override
  String get birthDate => 'Data de nacemento';

  @override
  String get deathDate => 'Data do falecemento';

  @override
  String get placeOfBirth => 'lugar de nacemento';

  @override
  String get years => 'Anos';

  @override
  String get job => 'Publicación';

  @override
  String get department => 'Departamento';

  @override
  String get watchingNow => 'mirando agora';

  @override
  String get pinLimitReached => 'Alcanzaches o límite de 5 títulos establecidos.';

  @override
  String get pin => 'Establecer';

  @override
  String get unpin => 'Desfixo';

  @override
  String get notificationTitle => 'Agora dispoñible!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title agora está dispoñible en $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nova tempada!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nova tempada de $title dispoñible o $provider.';
  }

  @override
  String get selectRegion => 'Seleccione a rexión';

  @override
  String get searchRegion => 'Busca unha rexión';

  @override
  String get regionAuto => 'Detección automática (IP)';

  @override
  String get shareLink => 'Compartir';

  @override
  String get director => 'Director';

  @override
  String get creator => 'Creador';

  @override
  String get writer => 'Escritor';

  @override
  String seasonsCount(Object count) {
    return '${count}temp';
  }

  @override
  String get notifications => 'Notificacións';

  @override
  String get notificationsPermissionRequired => 'Debes permitir as notificacións na configuración do sistema.';

  @override
  String get notificationsPermissionDescription => 'Para recibir notificacións sobre a dispoñibilidade de películas e novas tempadas, debes activar as notificacións na configuración do sistema.';

  @override
  String get openSettings => 'Abra a configuración';

  @override
  String get settings => 'Configuración';

  @override
  String get errorMessageGeneric => 'Produciuse un erro. Téntao de novo máis tarde.';

  @override
  String get youtubeSearch => 'Busca en YouTube';

  @override
  String get notificationsHistory => 'Últimas notificacións';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

  @override
  String get notifyCompleteSeasonSubtitle => 'Só notifica cando toda a tempada estea dispoñible.';

  @override
  String get episodes => 'Episodios';

  @override
  String get selectSeason => 'Ver as estacións';

  @override
  String seasonLabel(Object count) {
    return 'Tempada $count';
  }

  @override
  String get notifyTitle => 'Notificar novas tempadas';

  @override
  String get notifyMessage => 'Queres recibir unha notificación cando se emita unha nova tempada?';

  @override
  String get no => 'Non';

  @override
  String get none => 'Ningún';

  @override
  String get results => 'Resultados';

  @override
  String inRoleContext(Object context) {
    return 'en $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episodio $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get showEditContent => 'Mostrar botón de edición';

  @override
  String get translations => 'Traducións';

  @override
  String get copiedToClipboard => 'Copiouse o texto no portapapeis';

  @override
  String get close => 'Pechar';

  @override
  String get autoTranslation => 'Tradución automática';

  @override
  String get originalText => 'Texto orixinal';

  @override
  String get addToHomeScreen => 'Engadir á pantalla de inicio';

  @override
  String get shortcutAdded => 'Engadido atallo';

  @override
  String get shortcutFailed => 'Non se puido engadir o atallo';

  @override
  String get rate => 'Valora';

  @override
  String get watchOn => 'Ver en';

  @override
  String get status => 'Estado';

  @override
  String get enableAiTranslation => 'AI';

  @override
  String get aiSettingsTitle => 'Intelixencia artificial';

  @override
  String get aiSettingsSubtitle => 'Busca intelixente e funcións de intelixencia artificial';

  @override
  String get aiSettingsDescription => 'As funcións de IA permítenche atopar películas e series baseadas en descricións en linguaxe natural e en ferramentas máis intelixentes. Para usalos, podes obter unha chave gratuíta en OpenRouter (non se precisa ningunha tarxeta).';

  @override
  String get aiGetApiKeyButton => 'Obter clave en OpenRouter';

  @override
  String get aiApiKeyLabel => 'Clave da API de OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-ou-v1-...';

  @override
  String get aiSaveKeyButton => 'Tecla de gardar';

  @override
  String get aiDeleteKeyButton => 'Eliminar';

  @override
  String get aiKeySaved => 'A clave API gardouse correctamente';

  @override
  String get aiKeyCleared => 'Quitouse a chave da API';

  @override
  String get aiStatusConfigured => 'Clave API configurada';

  @override
  String get aiStatusNotConfigured => 'A chave da API non está configurada';

  @override
  String get delete => 'Eliminar';

  @override
  String get aiDeleteConfirmTitle => 'Eliminar a clave API';

  @override
  String get aiDeleteConfirmMessage => 'Estás seguro de que queres eliminar a clave API? Ten en conta que OpenRouter non permite consultar a clave unha vez creada e terás que xerar unha nova se non a tes gardada.';

  @override
  String get searchTimeout => 'A busca tardou demasiado en responder. Téntao de novo.';

  @override
  String get aiSearchTimeout => 'A busca da intelixencia artificial tardou demasiado. Proba cunha descrición menos específica ou máis breve.';

  @override
  String get aiSearchError => 'Produciuse un erro na busca da IA. Téntao de novo.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Superouse o límite de tempo da API. Agarda $seconds segundos antes de tentalo de novo.';
  }

  @override
  String get aiRateLimitGeneric => 'Superouse o límite de tempo da API. Agarda un momento antes de tentalo de novo.';

  @override
  String get signInWithGoogle => 'Inicia sesión con Google';

  @override
  String get googleSignInButton => 'Acceso con Google';

  @override
  String get alreadyUsingMovieScout => 'Xa usaches MovieScout?';

  @override
  String get importTmdbData => 'Importa os teus datos antigos desde TMDB.';

  @override
  String get tmdbAccount => 'Conta TMDb';

  @override
  String get tmdbImport => 'Importación de TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importación de TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importa os teus datos de TMDb';

  @override
  String get tmdbImportScreenBody => 'Podes importar as túas listas de vixilancia e valoracións desde a túa conta de TMDb á túa conta de MovieScout. Deberá iniciar sesión en TMDb. Unha vez completada a importación, a sesión de TMDb pecharase automaticamente.';

  @override
  String get tmdbImportStartButton => 'Iniciar importación';

  @override
  String get tmdbImportSuccess => 'Os datos importáronse correctamente.';

  @override
  String get tmdbImportDownloading => 'Descargando datos de TMDb...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Descargando a lista de vixilancia...';

  @override
  String get tmdbImportDownloadingRateslist => 'Descargando as críticas...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Descargando episodios clasificados...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count títulos na lista de vixilancia';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count valores valorados';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episodios clasificados';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronización da conta';

  @override
  String get tmdbImportUploading => 'Cargando á túa conta...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count elementos cargados na túa conta';
  }

  @override
  String get tmdbImportError => 'Produciuse un erro ao importar os datos';

  @override
  String get tmdbImportLoginRequired => 'Inicie sesión en TMDb para comezar a importación.';

  @override
  String get tmdbImportConsentText => 'A importación engadirá de forma segura as túas listas e valoracións de TMDb á túa conta de MovieScout.';

  @override
  String get loginConsentText => 'Ao iniciar sesión, aceptas almacenar os teus datos nos servidores de MovieScout para a sincronización entre dispositivos, de acordo co noso';

  @override
  String get termsOfService => 'condicións de servizo';

  @override
  String get andThe => 'e o';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar conta';

  @override
  String get deleteAccountConfirmMessage => 'Estás seguro de que queres eliminar a túa conta? Esta acción é irreversible e eliminará todas as túas listas e datos de forma permanente.';

  @override
  String get deleteAccountSuccess => 'A túa conta foi eliminada correctamente';

  @override
  String get deleteAccountError => 'Produciuse un erro ao eliminar a conta';
}
