// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Descargando Detalles';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Obteniendo datos de títulos ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Actualizando Plataformas';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Comprobando disponibilidad ($progress/$total)...';
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
  String get selectLanguage => 'Selecciona el idioma';

  @override
  String get messageEmptyList => 'Aún no se ha seleccionado ninguna película.';

  @override
  String get messageEmptySearch =>
      'Puedes hacer una búsqueda utilizando la lupa de la barra inferior.';

  @override
  String get messageEmptyOptions => 'También puedes';

  @override
  String get messageEmptyLogin => 'Iniciar sesión en MovieScout';

  @override
  String get search => 'Busca un título';

  @override
  String get searchAiHint => 'Describe la película o serie que buscas...';

  @override
  String get searchAiTooltip => 'Búsqueda Inteligente (IA)';

  @override
  String get searchTitle => 'Búsqueda';

  @override
  String get searchPerson => 'Busca alguien';

  @override
  String get gallery => 'Galería';

  @override
  String get searchProvider => 'Busca un proveedor';

  @override
  String get trailer => 'Tráiler';

  @override
  String get includeGenres => 'Incluir';

  @override
  String get excludeGenres => 'Excluir';

  @override
  String get pressBackAgainToExit => 'Presiona de nuevo para salir';

  @override
  String get back => 'Atrás';

  @override
  String get username => 'Usuario';

  @override
  String get anonymousUser => 'Sin usuario';

  @override
  String get loginTitle => 'Inicio de sesión';

  @override
  String get login => 'Inicia sesión';

  @override
  String get logout => 'Cierra sesión';

  @override
  String get loginSuccess => 'Sesión iniciada correctamente.';

  @override
  String get loginFailed => 'Usuario o contraseña incorrectos.';

  @override
  String get logoutSuccess => 'Sesión cerrada correctamente.';

  @override
  String get loginToTmdb => 'Inicia sesión en TMDb';

  @override
  String get completeLoginToTmdb => 'Completa el inicio de sesión';

  @override
  String get signInToWatchlist =>
      'Es necesario iniciar sesión para añadir títulos.';

  @override
  String get tvShow => 'Serie';

  @override
  String get movie => 'Película';

  @override
  String get select => 'Selecciona';

  @override
  String get imdbImport => 'Importación de IMDB';

  @override
  String get imdbImportHint => 'Selecciona un archivo CSV exportado de IMDB';

  @override
  String get imdbImportWatchlist => 'Importar Para Ver';

  @override
  String get imdbImportRateslist => 'Importar Valoraciones';

  @override
  String get missingDescription => 'Falta la descripción';

  @override
  String get flatrateProviders => 'Suscripción';

  @override
  String get rentProviders => 'Alquiler';

  @override
  String get buyProviders => 'Compra';

  @override
  String get allTypes => 'Títulos';

  @override
  String get movies => 'Películas';

  @override
  String get tvshows => 'Series';

  @override
  String get miniseries => 'Miniseries';

  @override
  String get collection => 'Colección';

  @override
  String get seeCollection => 'Ver la colección';

  @override
  String get sortAlphabetically => 'Alfabético';

  @override
  String get sortRating => 'Valoración';

  @override
  String get sortUserRating => 'Valoración (Mia)';

  @override
  String get sortReleaseDate => 'Fecha de estreno';

  @override
  String get sortRuntime => 'Duración';

  @override
  String get sortDateRated => 'Fecha de valoración';

  @override
  String get sortRelevance => 'Relevancia';

  @override
  String get sortAddedOrder => 'Fecha de adición';

  @override
  String get genres => 'Géneros';

  @override
  String get titles => 'Títulos';

  @override
  String get rate_date => 'Fecha de valoración';

  @override
  String get your_rate => 'Tu valoración';

  @override
  String get reset_rate => 'Elimina tu valoración';

  @override
  String get emptyRates => 'Todavía no has valorado ningún título.';

  @override
  String get seen => 'Visto';

  @override
  String get markAsSeen => 'Marcar como visto';

  @override
  String get ratedOnly => 'Valoradas';

  @override
  String get seenOnly => 'Vistas';

  @override
  String get followingOnly => 'Siguiendo';

  @override
  String get emptyList => 'Nada por aquí.';

  @override
  String get watchlistTitle => 'Por ver';

  @override
  String get rateslistTitle => 'Valoradas';

  @override
  String get yes => 'Sí';

  @override
  String get cancel => 'Cancela';

  @override
  String get originaTitle => 'Título original';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get originCountry => 'País';

  @override
  String get defaultScheme => 'Por defecto';

  @override
  String get about => 'Sobre...';

  @override
  String get aboutDescription =>
      'MovieScout es tu buscador de películas y series con datos de TMDb, OMDb y JustWatch.';

  @override
  String get aboutGithub => 'Visita el proyecto en ';

  @override
  String get apiDisclaimer =>
      'Este producto utiliza la API de TMDB, pero no está avalado ni certificado por TMDB.';

  @override
  String get privacyDisclaimerPrefix => 'Consulta la ';

  @override
  String get privacyDisclaimer => 'política de privacidad';

  @override
  String get recommended => 'Recomendados';

  @override
  String get providersTitle => 'Plataformas de contenido';

  @override
  String get providers => 'Platforms';

  @override
  String get filterByProviders => 'Solo disponibles';

  @override
  String get noProvidersAvailable => 'No hay plataformas disponibles';

  @override
  String get discoverlistTitle => 'Descubre';

  @override
  String get notReleasedYet => 'Todavia no se ha estrenado';

  @override
  String get unknownDuration => 'Duración no especificada.';

  @override
  String get cast => 'Elenco';

  @override
  String get crew => 'Equipo técnico';

  @override
  String get seeThemAll => 'Ver todo';

  @override
  String get ratedCredits => 'Creditos valorados';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get deathDate => 'Fecha de defunción';

  @override
  String get placeOfBirth => 'Lugar de nacimiento';

  @override
  String get years => 'Años';

  @override
  String get job => 'Cargo';

  @override
  String get department => 'Departamento';

  @override
  String get watchingNow => 'Mirando ahora';

  @override
  String get pinLimitReached => 'Has alcanzado el límite de 5 títulos fijados.';

  @override
  String get pin => 'Fijar';

  @override
  String get unpin => 'Desfijar';

  @override
  String get notificationTitle => '¡Ya disponible!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title ya está disponible en $provider.';
  }

  @override
  String get notificationNewSeasonTitle => '¡Nueva temporada!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nueva temporada de $title disponible en $provider.';
  }

  @override
  String get selectRegion => 'Selecciona la región';

  @override
  String get searchRegion => 'Buscar una región';

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
  String get notifications => 'Notificaciones';

  @override
  String get notificationsPermissionRequired =>
      'Debes permitir las notificaciones en los ajustes del sistema.';

  @override
  String get notificationsPermissionDescription =>
      'Para recibir avisos de disponibilidad de películas y nuevas temporadas, debes activar las notificaciones en los ajustes del sistema.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get settings => 'Configuración';

  @override
  String get errorMessageGeneric =>
      'Ha ocurrido un error. Inténtalo de nuevo más tarde.';

  @override
  String get notificationsHistory => 'Últimas notificaciones';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

  @override
  String get episodes => 'Episodios';

  @override
  String get selectSeason => 'Ver las temporadas';

  @override
  String seasonLabel(Object count) {
    return 'Temporada $count';
  }

  @override
  String get notifyTitle => 'Notificar nuevas temporadas';

  @override
  String get notifyMessage =>
      '¿Quieres recibir una notificación cuando se emita una nueva temporada?';

  @override
  String get no => 'No';

  @override
  String get none => 'Ninguno';

  @override
  String get results => 'Resultados';

  @override
  String inRoleContext(Object context) {
    return ' en $context';
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
  String get translations => 'Traducciones';

  @override
  String get copiedToClipboard => 'Texto copiado al portapapeles';

  @override
  String get close => 'Cerrar';

  @override
  String get autoTranslation => 'Traducción Automática';

  @override
  String get originalText => 'Texto Original';

  @override
  String get addToHomeScreen => 'Añadir a la pantalla de inicio';

  @override
  String get shortcutFailed => 'No se ha podido añadir el acceso directo';

  @override
  String get rate => 'Valora';

  @override
  String get watchOn => 'Ver en';

  @override
  String get status => 'Estado';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Inteligencia Artificial';

  @override
  String get aiSettingsSubtitle => 'Búsqueda inteligente y funciones de IA';

  @override
  String get aiSettingsDescription =>
      'Las funciones de IA te permiten encontrar películas y series basándose en descripciones en lenguaje natural y más herramientas inteligentes. Para utilizarlas, puedes obtener una clave gratuita en OpenRouter (sin necesidad de tarjeta).';

  @override
  String get aiGetApiKeyButton => 'Obtener clave en OpenRouter';

  @override
  String get aiApiKeyLabel => 'Clave API de OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Guardar clave';

  @override
  String get aiDeleteKeyButton => 'Eliminar';

  @override
  String get aiKeySaved => 'Clave API guardada correctamente';

  @override
  String get aiKeyCleared => 'Clave API eliminada';

  @override
  String get aiStatusConfigured => 'Clave API configurada';

  @override
  String get aiStatusNotConfigured => 'Clave API no configurada';

  @override
  String get delete => 'Eliminar';

  @override
  String get aiDeleteConfirmTitle => 'Eliminar clave API';

  @override
  String get aiDeleteConfirmMessage =>
      '¿Seguro que quieres eliminar la clave API? Ten en cuenta que OpenRouter no permite consultar la clave una vez creada y tendrás que generar una nueva si no la tienes guardada.';

  @override
  String get searchTimeout =>
      'La búsqueda ha tardado demasiado tiempo en responder. Inténtalo de nuevo.';

  @override
  String get aiSearchTimeout =>
      'La búsqueda con IA ha tardado demasiado tiempo. Prueba con una descripción menos específica o más corta.';

  @override
  String get aiSearchError =>
      'Se ha producido un error en la búsqueda IA. Inténtalo de nuevo.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Se ha superado el límite temporal de la API. Espera $seconds segundos antes de volver a intentarlo.';
  }

  @override
  String get aiRateLimitGeneric =>
      'Se ha superado el límite temporal de la API. Espera un momento antes de volver a intentarlo.';

  @override
  String get signInWithGoogle => 'Inicia sesión con Google';

  @override
  String get loginSubtitle =>
      'Inicia sesión para guardar y sincronizar tus listas y valoraciones.';

  @override
  String get googleSignInButton => 'Continuar con Google';

  @override
  String get tmdbAccount => 'Cuenta de TMDb';

  @override
  String get tmdbImport => 'Importación de TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importación de TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importa tus datos de TMDb';

  @override
  String get tmdbImportScreenBody =>
      'Puedes importar tus listas de seguimiento y valoraciones desde tu cuenta de TMDb a tu cuenta de MovieScout. Deberás iniciar sesión en TMDb. Una vez finalizada la importación, la sesión de TMDb se cerrará automáticamente.';

  @override
  String get tmdbImportStartButton => 'Comenzar la importación';

  @override
  String get tmdbImportSuccess => '¡Datos importados con éxito!';

  @override
  String get tmdbImportDownloadingWatchlist =>
      'Descargando la lista de seguimiento...';

  @override
  String get tmdbImportDownloadingRateslist =>
      'Descargando las valoraciones...';

  @override
  String get tmdbImportDownloadingEpisodes =>
      'Descargando episodios valorados...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count títulos en la lista de seguimiento';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count títulos valorados';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episodios valorados';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronización con la cuenta';

  @override
  String get tmdbImportUploading => 'Subiendo a tu cuenta...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count elementos subidos a tu cuenta';
  }

  @override
  String get tmdbImportError => 'Error al importar los datos';

  @override
  String get tmdbImportConsentText =>
      'La importación añadirá tus listas y valoraciones de TMDb a tu cuenta de MovieScout de forma segura.';

  @override
  String get loginConsentText =>
      'Al iniciar sesión, aceptas almacenar tus datos en los servidores de MovieScout para sincronizarlos entre dispositivos, de acuerdo con nuestra ';

  @override
  String get termsOfService => 'términos de servicio';

  @override
  String get andThe => ' y los ';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmMessage =>
      '¿Seguro que quieres eliminar tu cuenta? Esta acción es irreversible y eliminará todas tus listas y datos de forma permanente.';

  @override
  String get deleteAccountSuccess => 'Tu cuenta se ha eliminado correctamente';

  @override
  String get deleteAccountError => 'Error al eliminar la cuenta';

  @override
  String get comments => 'Comentarios';

  @override
  String get addComment => 'Añadir comentario';

  @override
  String get editComment => 'Editar comentario';

  @override
  String get deleteComment => 'Eliminar comentario';

  @override
  String get writeComment => 'Escribe un comentario...';

  @override
  String get noCommentsYet => 'Aún no hay comentarios';

  @override
  String get signInToComment => 'Inicia sesión para añadir un comentario';

  @override
  String get deleteCommentConfirm =>
      '¿Seguro que quieres eliminar tu comentario?';

  @override
  String get save => 'Guardar';

  @override
  String get you => 'Tú';

  @override
  String get followingTab => 'Siguiendo';

  @override
  String get users => 'Usuarios';

  @override
  String get user => 'Usuario';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Siguiendo';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String get latestRatedTitles => 'Últimos títulos valorados';

  @override
  String get emptyFollowingList => 'Aún no sigues a ningún usuario.';

  @override
  String get emptyFollowingSearchHint =>
      'Busca usuarios para seguirlos y ver su actividad.';

  @override
  String get networkErrorMessage =>
      'No se ha podido conectar con el servidor. Comprueba la conexión a internet.';

  @override
  String get publicProfileTitle => 'Perfil público';

  @override
  String get publicProfileSubtitle =>
      'Activa tu perfil público para compartir lo que ves con la comunidad';

  @override
  String get privateProfileMessage => 'Este perfil es privado';

  @override
  String get enablePublicProfileBanner =>
      'Activa tu perfil público para compartir lo que ves con la comunidad. Se puede desactivar desde la configuración.';

  @override
  String get enablePublicProfileButton => 'Activar perfil público';

  @override
  String get noWatchingNowTitles => 'No está viendo ningún título ahora mismo';

  @override
  String get noRatedTitles => 'No hay ningún título valorado';

  @override
  String get communityTabTitle => 'Pestaña de comunidad';

  @override
  String get communityTabSubtitle =>
      'Muestra la pestaña de comunidad en la barra de navegación';

  @override
  String get emptyFollowingCommunityHint =>
      'Puedes ocultar esta pestaña desde la configuración si no la usas.';

  @override
  String get shareAppCommunityPrompt =>
      'Comparte MovieScout con tus conocidos y empieza a crear tu red.';

  @override
  String get shareAppButton => 'Compartir MovieScout';

  @override
  String get shareAppMessage =>
      '¡Únete a MovieScout para descubrir y compartir películas y series!';

  @override
  String get shareAppGooglePlay => 'Instálala en Google Play:';

  @override
  String get settingsSectionPreferences => 'Preferencias de contenido';

  @override
  String get settingsSectionNotifications => 'Notificaciones';

  @override
  String get settingsSectionCommunity => 'Comunidad y perfil';

  @override
  String get settingsSectionTools => 'Herramientas y funciones';

  @override
  String get settingsSectionData => 'Datos e importación';

  @override
  String get settingsNotificationsEnabledSubtitle =>
      'Avisos de disponibilidad activos';

  @override
  String get settingsNotificationsDisabledSubtitle =>
      'Avisos de disponibilidad desactivados';

  @override
  String get settingsNotifySeasonComplete =>
      'Avisa cuando la temporada está completa';

  @override
  String get settingsNotifySeasonFirstEp =>
      'Avisa solo cuando se estrena el primer capítulo';

  @override
  String settingsProvidersCount(Object count) {
    return '$count plataformas seleccionadas';
  }

  @override
  String get settingsProvidersNone => 'Ninguna plataforma seleccionada';

  @override
  String get settingsAiConfigured => 'Clave de API configurada';

  @override
  String get settingsAiNotConfigured => 'Sin clave configurada';

  @override
  String get settingsProfilePublic => 'Visible para la comunidad';

  @override
  String get settingsProfilePrivate => 'Perfil privado';

  @override
  String get settingsCommunityVisible => 'Visible en la barra inferior';

  @override
  String get settingsCommunityHidden => 'Oculta';

  @override
  String get settingsEditVisible => 'Visibles en las fichas';

  @override
  String get settingsEditHidden => 'Ocultos';

  @override
  String get settingsImdbSubtitle =>
      'Archivo CSV (lista de seguimiento y valoraciones)';

  @override
  String get settingsTmdbSubtitle => 'Lista de seguimiento y valoraciones';

  @override
  String get settingsDeleteAccountSubtitle => 'Acción irreversible';

  @override
  String get understood => 'Entendido';

  @override
  String get settingsInfoProvidersTitle => 'Plataformas de contenido';

  @override
  String get settingsInfoProvidersIntro =>
      '¿Cómo utiliza MovieScout tus plataformas?';

  @override
  String get settingsInfoProvidersItem1Title => 'Avisos de disponibilidad';

  @override
  String get settingsInfoProvidersItem1Desc =>
      'MovieScout actualiza periódicamente cada título de tu lista desde TMDb (con datos de JustWatch) para saber dónde se emite. Si coincide con alguna de las plataformas que has marcado aquí, te avisa.';

  @override
  String get settingsInfoProvidersItem2Title => 'Filtro en búsquedas y listas';

  @override
  String get settingsInfoProvidersItem2Desc =>
      'Podrás filtrar rápidamente el catálogo para ver solo el contenido disponible con tus suscripciones activas.';

  @override
  String get settingsInfoProvidersItem3Title => 'Catálogo según tu región';

  @override
  String get settingsInfoProvidersItem3Desc =>
      'La disponibilidad se adapta automáticamente al país seleccionado en la configuración.';

  @override
  String get settingsInfoNotificationsTitle =>
      '¿Cómo funcionan las notificaciones?';

  @override
  String get settingsInfoNotificationsIntro =>
      'Avisos automáticos de disponibilidad';

  @override
  String get settingsInfoNotificationsItem1Title => 'Llegada a tus plataformas';

  @override
  String get settingsInfoNotificationsItem1Desc =>
      'Te avisaremos cuando un título de tu lista de seguimiento pase a estar disponible en alguna de tus plataformas seleccionadas.';

  @override
  String get settingsInfoNotificationsItem2Title =>
      'Nuevas temporadas de series';

  @override
  String get settingsInfoNotificationsItem2Desc =>
      'Por defecto te avisamos con el primer capítulo. Si activas \'Temporada completa\', solo te avisaremos cuando se hayan emitido todos los episodios.';

  @override
  String get settingsInfoNotificationsItem3Title =>
      'Comprobaciones en segundo plano';

  @override
  String get settingsInfoNotificationsItem3Desc =>
      'La app comprueba novedades periódicamente de forma silenciosa y sin gastar batería innecesaria.';

  @override
  String get settingsInfoAiTitle => 'Inteligencia Artificial';

  @override
  String get settingsInfoAiIntro =>
      'Mejoras en la búsqueda y traducción de títulos';

  @override
  String get settingsInfoAiItem1Title => 'Traducciones contextuales';

  @override
  String get settingsInfoAiItem1Desc =>
      'Genera traducciones naturales de sinopsis y títulos adaptadas al tono cinematográfico cuando no están disponibles en tu idioma.';

  @override
  String get settingsInfoAiItem2Title => 'Búsqueda inteligente';

  @override
  String get settingsInfoAiItem2Desc =>
      'Encuentra películas describiendo escenas, argumentos o personajes aunque no recuerdes el título.';

  @override
  String get settingsInfoAiItem3Title => 'Clave privada y segura';

  @override
  String get settingsInfoAiItem3Desc =>
      'Tu clave de API se guarda exclusivamente en tu dispositivo de forma segura y privada.';

  @override
  String get settingsInfoAiNote =>
      'Importante: Los modelos gratuitos de IA pueden tener tiempos de respuesta más lentos o límites temporales dependientes del proveedor. Para un rendimiento óptimo, se recomienda un servicio de pago por uso.';

  @override
  String get settingsInfoProfileTitle => 'Perfil Público y Comunidad';

  @override
  String get settingsInfoProfileIntro => 'La dimensión social de MovieScout';

  @override
  String get settingsInfoProfileItem1Title => 'Comparte tu actividad';

  @override
  String get settingsInfoProfileItem1Desc =>
      'Permite que otros usuarios puedan encontrar tu perfil, seguirte y ver qué títulos estás viendo y tus valoraciones.';

  @override
  String get settingsInfoProfileItem2Title => 'Privacidad garantizada';

  @override
  String get settingsInfoProfileItem2Desc =>
      'Puedes desactivar el perfil público cuando quieras. Solo se comparten títulos y valoraciones, nunca datos personales.';

  @override
  String get settingsInfoProfileItem3Title => 'Pestaña de comunidad';

  @override
  String get settingsInfoProfileItem3Desc =>
      'Puedes mostrar u ocultar la pestaña de comunidad en la barra de navegación inferior según tus preferencias.';

  @override
  String get settingsInfoEditTitle => 'Colaboración y edición en TMDb';

  @override
  String get settingsInfoEditIntro =>
      'Ayuda a hacer crecer la base de datos libre y a mejorar la información.';

  @override
  String get settingsInfoEditItem1Title => 'Acceso directo desde la ficha';

  @override
  String get settingsInfoEditItem1Desc =>
      'Muestra un icono de lápiz en las fichas de películas y series para acceder directamente a su página de edición.';

  @override
  String get settingsInfoEditItem2Title => 'Comunidad y datos abiertos';

  @override
  String get settingsInfoEditItem2Desc =>
      'Toda la información de MovieScout proviene de The Movie Database (TMDb), un proyecto colaborativo mantenido por la comunidad.';

  @override
  String get settingsInfoEditItem3Title => 'Mejora de contenido y traducciones';

  @override
  String get settingsInfoEditItem3Desc =>
      'Puedes añadir o corregir títulos, sinopsis y detalles en cualquier idioma para que todo el mundo pueda beneficiarse.';

  @override
  String get settingsInfoEditNote =>
      'Para editar contenido en TMDb solo necesitas iniciar sesión con una cuenta gratuita en themoviedb.org.';
}
