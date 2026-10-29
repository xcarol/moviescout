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
  String get selectLanguage => 'Seleccione o idioma';

  @override
  String get messageEmptyList => 'Aínda non se seleccionou ningunha película.';

  @override
  String get messageEmptySearch =>
      'Podes facer unha busca usando a lupa da barra inferior.';

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
  String get anonymousUser => 'Ningún usuario';

  @override
  String get loginTitle => 'Iniciar sesión';

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
  String get imdbImportHint =>
      'Seleccione un ficheiro CSV exportado desde IMDB';

  @override
  String get imdbImportWatchlist => 'Importar para ver';

  @override
  String get imdbImportRateslist => 'Importar comentarios';

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
  String get defaultScheme => 'Por defecto';

  @override
  String get about => 'Sobre...';

  @override
  String get aboutDescription =>
      'MovieScout é o teu motor de busca de películas e series con datos de TMDb, OMDb e JustWatch.';

  @override
  String get aboutGithub => 'Visita o proxecto en';

  @override
  String get apiDisclaimer =>
      'Este produto usa a API de TMDB, pero non está avalado nin certificado por TMDB.';

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
  String get pinLimitReached =>
      'Alcanzaches o límite de 5 títulos establecidos.';

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
  String get notificationsPermissionRequired =>
      'Debes permitir as notificacións na configuración do sistema.';

  @override
  String get notificationsPermissionDescription =>
      'Para recibir notificacións sobre a dispoñibilidade de películas e novas tempadas, debes activar as notificacións na configuración do sistema.';

  @override
  String get openSettings => 'Abra a configuración';

  @override
  String get settings => 'Configuración';

  @override
  String get errorMessageGeneric =>
      'Produciuse un erro. Téntao de novo máis tarde.';

  @override
  String get notificationsHistory => 'Últimas notificacións';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

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
  String get notifyMessage =>
      'Queres recibir unha notificación cando se emita unha nova tempada?';

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
  String get aiSettingsSubtitle =>
      'Busca intelixente e funcións de intelixencia artificial';

  @override
  String get aiSettingsDescription =>
      'As funcións de IA permítenche atopar películas e series baseadas en descricións en linguaxe natural e en ferramentas máis intelixentes. Para usalos, podes obter unha chave gratuíta en OpenRouter (non se precisa ningunha tarxeta).';

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
  String get aiDeleteConfirmMessage =>
      'Estás seguro de que queres eliminar a clave API? Ten en conta que OpenRouter non permite consultar a clave unha vez creada e terás que xerar unha nova se non a tes gardada.';

  @override
  String get searchTimeout =>
      'A busca tardou demasiado en responder. Téntao de novo.';

  @override
  String get aiSearchTimeout =>
      'A busca da intelixencia artificial tardou demasiado. Proba cunha descrición menos específica ou máis breve.';

  @override
  String get aiSearchError =>
      'Produciuse un erro na busca da IA. Téntao de novo.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Superouse o límite de tempo da API. Agarda $seconds segundos antes de tentalo de novo.';
  }

  @override
  String get aiRateLimitGeneric =>
      'Superouse o límite de tempo da API. Agarda un momento antes de tentalo de novo.';

  @override
  String get signInWithGoogle => 'Inicia sesión con Google';

  @override
  String get loginSubtitle =>
      'Inicia sesión para gardar e sincronizar as túas listas e valoracións.';

  @override
  String get googleSignInButton => 'Continuar con Google';

  @override
  String get tmdbAccount => 'Conta TMDb';

  @override
  String get tmdbImport => 'Importación de TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importación de TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importa os teus datos de TMDb';

  @override
  String get tmdbImportScreenBody =>
      'Podes importar as túas listas de vixilancia e valoracións desde a túa conta de TMDb á túa conta de MovieScout. Deberá iniciar sesión en TMDb. Unha vez completada a importación, a sesión de TMDb pecharase automaticamente.';

  @override
  String get tmdbImportStartButton => 'Iniciar importación';

  @override
  String get tmdbImportSuccess => 'Os datos importáronse correctamente.';

  @override
  String get tmdbImportDownloadingWatchlist =>
      'Descargando a lista de vixilancia...';

  @override
  String get tmdbImportDownloadingRateslist => 'Descargando as críticas...';

  @override
  String get tmdbImportDownloadingEpisodes =>
      'Descargando episodios clasificados...';

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
  String get tmdbImportConsentText =>
      'A importación engadirá de forma segura as túas listas e valoracións de TMDb á túa conta de MovieScout.';

  @override
  String get loginConsentText =>
      'Ao iniciar sesión, aceptas almacenar os teus datos nos servidores de MovieScout para a sincronización entre dispositivos, de acordo co noso';

  @override
  String get termsOfService => 'condicións de servizo';

  @override
  String get andThe => 'e o';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar conta';

  @override
  String get deleteAccountConfirmMessage =>
      'Estás seguro de que queres eliminar a túa conta? Esta acción é irreversible e eliminará todas as túas listas e datos de forma permanente.';

  @override
  String get deleteAccountSuccess => 'A túa conta foi eliminada correctamente';

  @override
  String get deleteAccountError => 'Produciuse un erro ao eliminar a conta';

  @override
  String get comments => 'Comentarios';

  @override
  String get addComment => 'Engadir comentario';

  @override
  String get editComment => 'Editar comentario';

  @override
  String get deleteComment => 'Eliminar comentario';

  @override
  String get writeComment => 'Escribe un comentario...';

  @override
  String get noCommentsYet => 'Aínda non hai comentarios';

  @override
  String get signInToComment =>
      'Debes iniciar sesión para engadir un comentario.';

  @override
  String get deleteCommentConfirm =>
      'Estás seguro de que queres eliminar o teu comentario?';

  @override
  String get save => 'Gardar';

  @override
  String get you => 'Ti';

  @override
  String get followingTab => 'Seguindo';

  @override
  String get users => 'Usuarios';

  @override
  String get user => 'Usuario';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String get latestRatedTitles => 'Últimos títulos valorados';

  @override
  String get emptyFollowingList => 'Aínda non segues a ningún usuario.';

  @override
  String get emptyFollowingSearchHint =>
      'Busca usuarios para segilos e ver a súa actividade.';

  @override
  String get networkErrorMessage =>
      'Non se puido conectar co servidor. Comproba a túa conexión a internet.';

  @override
  String get publicProfileTitle => 'Perfil público';

  @override
  String get publicProfileSubtitle =>
      'Activa o teu perfil público para compartir o que ves coa comunidade';

  @override
  String get privateProfileMessage => 'Este perfil é privado';

  @override
  String get enablePublicProfileBanner =>
      'Activa o teu perfil público para compartir o que ves coa comunidade. Pódese desactivar dende a configuración.';

  @override
  String get enablePublicProfileButton => 'Activar perfil público';

  @override
  String get noWatchingNowTitles => 'Non está a ver ningún título agora mesmo';

  @override
  String get noRatedTitles => 'Non hai ningún título valorado';

  @override
  String get communityTabTitle => 'Pestana de comunidade';

  @override
  String get communityTabSubtitle =>
      'Mostra a pestana de comunidade na barra de navegación';

  @override
  String get emptyFollowingCommunityHint =>
      'Podes ocultar esta pestana dende a configuración se non a usas.';

  @override
  String get shareAppCommunityPrompt =>
      'Comparte MovieScout cos teus coñecidos e empeza a crear a túa comunidade.';

  @override
  String get shareAppButton => 'Compartir MovieScout';

  @override
  String get shareAppMessage =>
      'Únete a MovieScout para descubrir e compartir películas e series!';

  @override
  String get shareAppGooglePlay => 'Instálaa en Google Play:';

  @override
  String get settingsSectionPreferences => 'Preferencias de contido';

  @override
  String get settingsSectionNotifications => 'Notificacións';

  @override
  String get settingsSectionCommunity => 'Comunidade e perfil';

  @override
  String get settingsSectionTools => 'Ferramentas e funcións';

  @override
  String get settingsSectionData => 'Datos e importación';

  @override
  String get settingsNotificationsEnabledSubtitle =>
      'Avisos de dispoñibilidade activos';

  @override
  String get settingsNotificationsDisabledSubtitle =>
      'Avisos de dispoñibilidade desactivados';

  @override
  String get settingsNotifySeasonComplete =>
      'Avisa cando a tempada estea completa';

  @override
  String get settingsNotifySeasonFirstEp =>
      'Avisa só cando se estrea o primeiro capítulo';

  @override
  String settingsProvidersCount(Object count) {
    return '$count plataformas seleccionadas';
  }

  @override
  String get settingsProvidersNone => 'Ningunha plataforma seleccionada';

  @override
  String get settingsAiConfigured => 'Chave de API configurada';

  @override
  String get settingsAiNotConfigured => 'Sen chave configurada';

  @override
  String get settingsProfilePublic => 'Visible para a comunidade';

  @override
  String get settingsProfilePrivate => 'Perfil privado';

  @override
  String get settingsCommunityVisible => 'Visible na barra inferior';

  @override
  String get settingsCommunityHidden => 'Oculta';

  @override
  String get settingsEditVisible => 'Visibles nas fichas';

  @override
  String get settingsEditHidden => 'Ocultos';

  @override
  String get settingsImdbSubtitle =>
      'Ficheiro CSV (lista de seguimento e valoracións)';

  @override
  String get settingsTmdbSubtitle => 'Lista de seguimento e valoracións';

  @override
  String get settingsDeleteAccountSubtitle => 'Acción irreversible';

  @override
  String get understood => 'Entendido';

  @override
  String get settingsInfoProvidersTitle => 'Plataformas de contidos';

  @override
  String get settingsInfoProvidersIntro =>
      'Como utiliza MovieScout as túas plataformas?';

  @override
  String get settingsInfoProvidersItem1Title => 'Avisos de dispoñibilidade';

  @override
  String get settingsInfoProvidersItem1Desc =>
      'MovieScout actualiza periodicamente cada título da túa lista dende TMDb (con datos de JustWatch) para saber onde se emite. Se coincide con algunha das plataformas que marcaches aquí, avísate.';

  @override
  String get settingsInfoProvidersItem2Title => 'Filtro nas procuras';

  @override
  String get settingsInfoProvidersItem2Desc =>
      'Filtra rapidamente o catálogo para ver só o contido dispoñible coas túas subscricións activas.';

  @override
  String get settingsInfoProvidersItem3Title => 'Catálogo rexional';

  @override
  String get settingsInfoProvidersItem3Desc =>
      'A dispoñibilidade adáptase automaticamente ao país seleccionado na configuración.';

  @override
  String get settingsInfoNotificationsTitle =>
      'Como funcionan as notificacións?';

  @override
  String get settingsInfoNotificationsIntro =>
      'Avisos automáticos de dispoñibilidade';

  @override
  String get settingsInfoNotificationsItem1Title => 'Estreas na lista';

  @override
  String get settingsInfoNotificationsItem1Desc =>
      'Recibe un aviso cando un título da túa lista pase a estar dispoñible nas túas plataformas seleccionadas.';

  @override
  String get settingsInfoNotificationsItem2Title => 'Novas tempadas de series';

  @override
  String get settingsInfoNotificationsItem2Desc =>
      'Por defecto avisamos co primeiro capítulo. Se activas \'Tempada completa\', o aviso agarda a emisión de todos os episodios.';

  @override
  String get settingsInfoNotificationsItem3Title =>
      'Comprobacións en segundo plano';

  @override
  String get settingsInfoNotificationsItem3Desc =>
      'MovieScout comproba as novidades periodicamente de forma silenciosa e sen gastar batería.';

  @override
  String get settingsInfoAiTitle => 'Intelixencia Artificial';

  @override
  String get settingsInfoAiIntro =>
      'Melloras na procura e tradución de títulos';

  @override
  String get settingsInfoAiItem1Title => 'Traducións contextuais';

  @override
  String get settingsInfoAiItem1Desc =>
      'Xera traducións naturais de sinopses e títulos adaptadas ao ton cinematográfico cando non estean dispoñibles no teu idioma.';

  @override
  String get settingsInfoAiItem2Title => 'Procura intelixente';

  @override
  String get settingsInfoAiItem2Desc =>
      'Atopa películas describindo escenas ou argumentos aínda que non te acordes do título.';

  @override
  String get settingsInfoAiItem3Title => 'Chave privada e segura';

  @override
  String get settingsInfoAiItem3Desc =>
      'A túa chave de API gárdase exclusivamente no teu dispositivo de forma segura e privada.';

  @override
  String get settingsInfoAiNote =>
      'Importante: Os modelos gratuítos de IA poden ter tempos de resposta máis lentos ou límites de peticións dependentes do provedor. Recoméndase un servizo de pago por uso para un rendemento óptimo.';

  @override
  String get settingsInfoProfileTitle => 'Perfil Público e Comunidade';

  @override
  String get settingsInfoProfileIntro => 'A dimensión social de MovieScout';

  @override
  String get settingsInfoProfileItem1Title => 'Comparte a túa actividade';

  @override
  String get settingsInfoProfileItem1Desc =>
      'Permite que outros usuarios atopen o teu perfil, sígante e vexan o que estás a ver e as túas valoracións.';

  @override
  String get settingsInfoProfileItem2Title => 'Privacidade garantida';

  @override
  String get settingsInfoProfileItem2Desc =>
      'Podes cambiar a modo privado cando queiras. Só se comparten títulos e valoracións, nunca datos persoais.';

  @override
  String get settingsInfoProfileItem3Title => 'Pestana de comunidade';

  @override
  String get settingsInfoProfileItem3Desc =>
      'Amosa ou oculta a pestana de comunidade na barra de navegación inferior segundo as túas preferencias.';

  @override
  String get settingsInfoEditTitle => 'Colaboración e edición en TMDb';

  @override
  String get settingsInfoEditIntro =>
      'Axuda a facer medrar a base de datos libre e a mellorar a información.';

  @override
  String get settingsInfoEditItem1Title => 'Acceso directo dende a ficha';

  @override
  String get settingsInfoEditItem1Desc =>
      'Amosa unha icona de lapis nas fichas de filmes e series para acceder directamente á súa páxina de edición.';

  @override
  String get settingsInfoEditItem2Title => 'Comunidade e datos abertos';

  @override
  String get settingsInfoEditItem2Desc =>
      'Toda a información de MovieScout provén de The Movie Database (TMDb), un proxecto colaborativo mantido pola comunidade.';

  @override
  String get settingsInfoEditItem3Title => 'Mellora de contidos e traducións';

  @override
  String get settingsInfoEditItem3Desc =>
      'Podes engadir ou corrixir títulos, sinopses e detalles en calquera idioma para beneficio de todos.';

  @override
  String get settingsInfoEditNote =>
      'Para editar contido en TMDb só precisas iniciar sesión cunha conta gratuíta en themoviedb.org.';

  @override
  String get spanishLatam => 'Español (Latinoamérica)';
}
