import type { SupportedLocale } from './locales';

export type WebMessageKey =
	| 'landingMotto'
	| 'landingSubtitle'
	| 'landingFeatureAvailabilityTitle'
	| 'landingFeatureAvailabilityDesc'
	| 'landingFeatureNotificationsTitle'
	| 'landingFeatureNotificationsDesc'
	| 'landingFeatureOrganizeTitle'
	| 'landingFeatureOrganizeDesc'
	| 'landingFeatureDetailsTitle'
	| 'landingFeatureDetailsDesc'
	| 'getItOnGooglePlay'
	| 'viewOnGithub'
	| 'openInApp'
	| 'appBannerTitle'
	| 'appBannerSubtitle'
	| 'home'
	| 'languageLabel'
	| 'regionLabel'
	| 'privacyPolicy'
	| 'termsOfService'
	| 'justwatchAttribution'
	| 'episodesCount'
	| 'seasonsCountLabel'
	| 'moviesCountLabel'
	| 'biography'
	| 'knownFor'
	| 'filmography'
	| 'taggedImages'
	| 'collectionParts'
	| 'backToSeries'
	| 'backToSeason'
	| 'previousEpisode'
	| 'nextEpisode'
	| 'showMore'
	| 'showLess'
	| 'watchInRegion'
	| 'notFoundTitle'
	| 'notFoundMessage'
	| 'backToHome'
	| 'retry'
	| 'ratingsTitle'
	| 'releaseDate'
	| 'firstAirDate'
	| 'runtime'
	| 'status'
	| 'certification'
	| 'minutesShort'
	| 'playTrailer'
	| 'close'
	| 'externalLinks'
	| 'skipToContent'
	| 'airDate';

export type WebMessagesDictionary = Record<WebMessageKey, string>;

export const WEB_MESSAGES: Record<SupportedLocale, WebMessagesDictionary> = {
	'en-US': {
		landingMotto: 'Discover. Track. Watch.',
		landingSubtitle:
			'MovieScout is a movie and TV series tracker powered by TMDB, OMDb, and JustWatch. Built around your watchlist, not around streaming catalogs.',
		landingFeatureAvailabilityTitle: 'Stream Availability',
		landingFeatureAvailabilityDesc:
			'Easily find out which streaming platforms host your favorite movies and series via JustWatch.',
		landingFeatureNotificationsTitle: 'Availability Notifications',
		landingFeatureNotificationsDesc:
			'Get notified when watchlist titles or new seasons become available on your streaming services.',
		landingFeatureOrganizeTitle: 'Search and Organize',
		landingFeatureOrganizeDesc:
			'Quickly search, rate, filter, and organize titles across your watchlist and personal lists.',
		landingFeatureDetailsTitle: 'Detailed Information',
		landingFeatureDetailsDesc:
			'Explore posters, ratings from TMDB and OMDb, cast, crew, trailers, and collections.',
		getItOnGooglePlay: 'Get it on Google Play',
		viewOnGithub: 'View on GitHub',
		openInApp: 'Open in MovieScout',
		appBannerTitle: 'Track titles and get availability alerts',
		appBannerSubtitle:
			'Save to your watchlist, check your platforms, and get notified on Android.',
		home: 'Home',
		languageLabel: 'Language',
		regionLabel: 'Region',
		privacyPolicy: 'Privacy Policy',
		termsOfService: 'Terms of Service',
		justwatchAttribution: 'Streaming availability data provided by JustWatch.',
		episodesCount: '{count} episodes',
		seasonsCountLabel: '{count} seasons',
		moviesCountLabel: '{count} movies',
		biography: 'Biography',
		knownFor: 'Known for',
		filmography: 'Filmography',
		taggedImages: 'Tagged images',
		collectionParts: 'Movies in this collection',
		backToSeries: 'Back to series',
		backToSeason: 'Back to season',
		previousEpisode: 'Previous episode',
		nextEpisode: 'Next episode',
		showMore: 'Show more',
		showLess: 'Show less',
		watchInRegion: 'Where to watch in {region}',
		notFoundTitle: 'Content not found',
		notFoundMessage: 'The requested title, person, or page is unavailable or does not exist.',
		backToHome: 'Back to home',
		retry: 'Retry',
		ratingsTitle: 'Ratings',
		releaseDate: 'Release date',
		firstAirDate: 'First air date',
		runtime: 'Runtime',
		status: 'Status',
		certification: 'Age rating',
		minutesShort: 'min',
		playTrailer: 'Watch trailer',
		close: 'Close',
		externalLinks: 'External links',
		skipToContent: 'Skip to content',
		airDate: 'Air date'
	},
	'ca-ES': {
		landingMotto: 'Descobreix. Segueix. Mira.',
		landingSubtitle:
			'MovieScout és el teu gestor de pel·lícules i sèries impulsat per TMDB, OMDb i JustWatch. Centrat en la teva llista de seguiment, no en els catàlegs.',
		landingFeatureAvailabilityTitle: 'Disponibilitat en streaming',
		landingFeatureAvailabilityDesc:
			'Descobreix fàcilment en quines plataformes estan disponibles les teves pel·lícules i sèries amb JustWatch.',
		landingFeatureNotificationsTitle: 'Avisos de disponibilitat',
		landingFeatureNotificationsDesc:
			'Rep notificacions quan els títols pendents o noves temporades arribin als teus serveis.',
		landingFeatureOrganizeTitle: 'Cerca i organització',
		landingFeatureOrganizeDesc:
			'Cerca, puntua, filtra i organitza ràpidament la teva llista de seguiment i les teves valoracions.',
		landingFeatureDetailsTitle: 'Informació detallada',
		landingFeatureDetailsDesc:
			'Consulta pòsters, puntuacions de TMDB i OMDb, repartiment, equip tècnic, tràilers i col·leccions.',
		getItOnGooglePlay: 'Disponible a Google Play',
		viewOnGithub: 'Veure a GitHub',
		openInApp: 'Obrir a MovieScout',
		appBannerTitle: 'Segueix títols i rep avisos de disponibilitat',
		appBannerSubtitle:
			'Desa a la llista, comprova les teves plataformes i rep notificacions a Android.',
		home: 'Inici',
		languageLabel: 'Idioma',
		regionLabel: 'Regió',
		privacyPolicy: 'Política de privadesa',
		termsOfService: 'Termes del servei',
		justwatchAttribution: 'Dades de disponibilitat en streaming proporcionades per JustWatch.',
		episodesCount: '{count} episodis',
		seasonsCountLabel: '{count} temporades',
		moviesCountLabel: '{count} pel·lícules',
		biography: 'Biografia',
		knownFor: 'Conegut/da per',
		filmography: 'Filmografia',
		taggedImages: 'Imatges etiquetades',
		collectionParts: 'Pel·lícules de la col·lecció',
		backToSeries: 'Tornar a la sèrie',
		backToSeason: 'Tornar a la temporada',
		previousEpisode: 'Episodi anterior',
		nextEpisode: 'Episodi següent',
		showMore: 'Veure més',
		showLess: 'Veure menys',
		watchInRegion: 'On veure-ho a {region}',
		notFoundTitle: 'Contingut no trobat',
		notFoundMessage: 'El títol, la persona o la pàgina sol·licitada no existeix o no està disponible.',
		backToHome: "Tornar a l'inici",
		retry: 'Tornar-ho a provar',
		ratingsTitle: 'Puntuacions',
		releaseDate: "Data d'estrena",
		firstAirDate: 'Primera emissió',
		runtime: 'Durada',
		status: 'Estat',
		certification: 'Classificació',
		minutesShort: 'min',
		playTrailer: 'Veure tràiler',
		close: 'Tancar',
		externalLinks: 'Enllaços externs',
		skipToContent: 'Anar al contingut',
		airDate: "Data d'emissió"
	},
	'es-ES': {
		landingMotto: 'Descubre. Sigue. Mira.',
		landingSubtitle:
			'MovieScout es un gestor de películas y series impulsado por TMDB, OMDb y JustWatch. Pensado alrededor de tu lista de seguimiento, no de los catálogos.',
		landingFeatureAvailabilityTitle: 'Disponibilidad en streaming',
		landingFeatureAvailabilityDesc:
			'Encuentra fácilmente qué plataformas de streaming tienen tus películas y series favoritas mediante JustWatch.',
		landingFeatureNotificationsTitle: 'Avisos de disponibilidad',
		landingFeatureNotificationsDesc:
			'Recibe notificaciones cuando un título pendiente o una nueva temporada llegue a tus plataformas.',
		landingFeatureOrganizeTitle: 'Busca y organiza',
		landingFeatureOrganizeDesc:
			'Busca, puntúa, filtra y organiza rápidamente tu lista de seguimiento y valoraciones.',
		landingFeatureDetailsTitle: 'Información detallada',
		landingFeatureDetailsDesc:
			'Consulta pósters, puntuaciones de TMDB y OMDb, reparto, equipo técnico, tráileres y colecciones.',
		getItOnGooglePlay: 'Disponible en Google Play',
		viewOnGithub: 'Ver en GitHub',
		openInApp: 'Abrir en MovieScout',
		appBannerTitle: 'Sigue títulos y recibe avisos de disponibilidad',
		appBannerSubtitle:
			'Guárdalo en tu lista, consulta tus plataformas y recibe avisos en Android.',
		home: 'Inicio',
		languageLabel: 'Idioma',
		regionLabel: 'Región',
		privacyPolicy: 'Política de privacidad',
		termsOfService: 'Términos del servicio',
		justwatchAttribution: 'Datos de disponibilidad en streaming proporcionados por JustWatch.',
		episodesCount: '{count} episodios',
		seasonsCountLabel: '{count} temporadas',
		moviesCountLabel: '{count} películas',
		biography: 'Biografía',
		knownFor: 'Conocido/a por',
		filmography: 'Filmografía',
		taggedImages: 'Imágenes etiquetadas',
		collectionParts: 'Películas de la colección',
		backToSeries: 'Volver a la serie',
		backToSeason: 'Volver a la temporada',
		previousEpisode: 'Episodio anterior',
		nextEpisode: 'Episodio siguiente',
		showMore: 'Ver más',
		showLess: 'Ver menos',
		watchInRegion: 'Dónde ver en {region}',
		notFoundTitle: 'Contenido no encontrado',
		notFoundMessage: 'El título, la persona o la página solicitada no existe o no está disponible.',
		backToHome: 'Volver al inicio',
		retry: 'Reintentar',
		ratingsTitle: 'Puntuaciones',
		releaseDate: 'Fecha de estreno',
		firstAirDate: 'Primera emisión',
		runtime: 'Duración',
		status: 'Estado',
		certification: 'Clasificación',
		minutesShort: 'min',
		playTrailer: 'Ver tráiler',
		close: 'Cerrar',
		externalLinks: 'Enlaces externos',
		skipToContent: 'Ir al contenido',
		airDate: 'Fecha de emisión'
	},
	'es-419': {
		landingMotto: 'Descubre. Sigue. Mira.',
		landingSubtitle:
			'MovieScout es un gestor de películas y series impulsado por TMDB, OMDb y JustWatch. Diseñado en torno a tu lista de seguimiento, no de los catálogos.',
		landingFeatureAvailabilityTitle: 'Disponibilidad en streaming',
		landingFeatureAvailabilityDesc:
			'Encuentra fácilmente en qué plataformas de streaming están tus películas y series favoritas con JustWatch.',
		landingFeatureNotificationsTitle: 'Notificaciones de disponibilidad',
		landingFeatureNotificationsDesc:
			'Recibe avisos cuando los títulos de tu lista o nuevas temporadas lleguen a tus servicios.',
		landingFeatureOrganizeTitle: 'Busca y organiza',
		landingFeatureOrganizeDesc:
			'Busca, califica, filtra y organiza rápidamente tu lista de seguimiento y calificaciones.',
		landingFeatureDetailsTitle: 'Información detallada',
		landingFeatureDetailsDesc:
			'Explora pósters, puntajes de TMDB y OMDb, elenco, equipo técnico, tráileres y colecciones.',
		getItOnGooglePlay: 'Disponible en Google Play',
		viewOnGithub: 'Ver en GitHub',
		openInApp: 'Abrir en MovieScout',
		appBannerTitle: 'Sigue títulos y recibe alertas de disponibilidad',
		appBannerSubtitle:
			'Guárdalo en tu lista, revisa tus plataformas y recibe alertas en Android.',
		home: 'Inicio',
		languageLabel: 'Idioma',
		regionLabel: 'Región',
		privacyPolicy: 'Política de privacidad',
		termsOfService: 'Términos del servicio',
		justwatchAttribution: 'Datos de disponibilidad en streaming proporcionados por JustWatch.',
		episodesCount: '{count} episodios',
		seasonsCountLabel: '{count} temporadas',
		moviesCountLabel: '{count} películas',
		biography: 'Biografía',
		knownFor: 'Conocido/a por',
		filmography: 'Filmografía',
		taggedImages: 'Imágenes etiquetadas',
		collectionParts: 'Películas de la colección',
		backToSeries: 'Volver a la serie',
		backToSeason: 'Volver a la temporada',
		previousEpisode: 'Episodio anterior',
		nextEpisode: 'Episodio siguiente',
		showMore: 'Ver más',
		showLess: 'Ver menos',
		watchInRegion: 'Dónde ver en {region}',
		notFoundTitle: 'Contenido no encontrado',
		notFoundMessage: 'El título, la persona o la página solicitada no existe o no está disponible.',
		backToHome: 'Volver al inicio',
		retry: 'Reintentar',
		ratingsTitle: 'Puntajes',
		releaseDate: 'Fecha de estreno',
		firstAirDate: 'Primera emisión',
		runtime: 'Duración',
		status: 'Estado',
		certification: 'Clasificación',
		minutesShort: 'min',
		playTrailer: 'Ver tráiler',
		close: 'Cerrar',
		externalLinks: 'Enlaces externos',
		skipToContent: 'Ir al contenido',
		airDate: 'Fecha de emisión'
	},
	'eu-ES': {
		landingMotto: 'Ezagutu. Jarraitu. Ikusi.',
		landingSubtitle:
			'MovieScout TMDB, OMDb eta JustWatch bidezko film eta telesailen kudeatzailea da. Zure jarraipen-zerrendan oinarritua, ez katalogoetan.',
		landingFeatureAvailabilityTitle: 'Streaming erabilgarritasuna',
		landingFeatureAvailabilityDesc:
			'Aurkitu erraz zure film eta telesail gogokoenak zein plataformatan dauden JustWatch bidez.',
		landingFeatureNotificationsTitle: 'Erabilgarritasun jakinarazpenak',
		landingFeatureNotificationsDesc:
			'Jaso abisuak zure zerrendako tituluak edo denboraldi berriak zure zerbitzuetan eskuragarri daudenean.',
		landingFeatureOrganizeTitle: 'Bilatu eta antolatu',
		landingFeatureOrganizeDesc:
			'Bilatu, baloratu, iragazi eta antolatu azkar zure jarraipen-zerrenda eta balorazioak.',
		landingFeatureDetailsTitle: 'Informazio zehatza',
		landingFeatureDetailsDesc:
			'Ikusi posterrak, TMDB eta OMDb puntuazioak, aktoreak, lantaldea, trailerrak eta bildumak.',
		getItOnGooglePlay: 'Eskuratu Google Play-n',
		viewOnGithub: 'Ikusi GitHub-en',
		openInApp: 'Ireki MovieScout-en',
		appBannerTitle: 'Jarraitu tituluak eta jaso erabilgarritasun abisuak',
		appBannerSubtitle:
			'Gorde zerrendan, egiaztatu zure plataformak eta jaso abisuak Android-en.',
		home: 'Hasiera',
		languageLabel: 'Hizkuntza',
		regionLabel: 'Eskualdea',
		privacyPolicy: 'Pribatutasun politika',
		termsOfService: 'Zerbitzuaren baldintzak',
		justwatchAttribution: 'Streaming erabilgarritasun datuak JustWatch-ek hornituak.',
		episodesCount: '{count} atal',
		seasonsCountLabel: '{count} denboraldi',
		moviesCountLabel: '{count} film',
		biography: 'Biografia',
		knownFor: 'Ezaguna honengatik',
		filmography: 'Filmografia',
		taggedImages: 'Etiketatutako irudiak',
		collectionParts: 'Bildumako filmak',
		backToSeries: 'Itzuli telesailera',
		backToSeason: 'Itzuli denboraldira',
		previousEpisode: 'Aurreko atala',
		nextEpisode: 'Hurrengo atala',
		showMore: 'Gehiago ikusi',
		showLess: 'Gutxiago ikusi',
		watchInRegion: 'Non ikusi hemen: {region}',
		notFoundTitle: 'Edukia ez da aurkitu',
		notFoundMessage: 'Eskatutako titulua, pertsona edo orria ez dago eskuragarri edo ez da existitzen.',
		backToHome: 'Itzuli hasierara',
		retry: 'Saiatu berriro',
		ratingsTitle: 'Puntuazioak',
		releaseDate: 'Estreinaldi data',
		firstAirDate: 'Lehen emisioa',
		runtime: 'Iraupena',
		status: 'Egoera',
		certification: 'Adin-kalifikazioa',
		minutesShort: 'min',
		playTrailer: 'Ikusi trailerra',
		close: 'Itxi',
		externalLinks: 'Kanpoko estekak',
		skipToContent: 'Joan edukira',
		airDate: 'Emisio data'
	},
	'gl-ES': {
		landingMotto: 'Descobre. Segue. Mira.',
		landingSubtitle:
			'MovieScout é un xestor de filmes e series impulsado por TMDB, OMDb e JustWatch. Centrado na túa lista de seguimento, non nos catálogos.',
		landingFeatureAvailabilityTitle: 'Dispoñibilidade en streaming',
		landingFeatureAvailabilityDesc:
			'Atopa facilmente en que plataformas de streaming están os teus filmes e series favoritos con JustWatch.',
		landingFeatureNotificationsTitle: 'Notificacións de dispoñibilidade',
		landingFeatureNotificationsDesc:
			'Recibe avisos cando os títulos da túa lista ou novas tempadas cheguen aos teus servizos.',
		landingFeatureOrganizeTitle: 'Busca e organiza',
		landingFeatureOrganizeDesc:
			'Busca, puntúa, filtra e organiza rapidamente a túa lista de seguimento e valoracións.',
		landingFeatureDetailsTitle: 'Información detallada',
		landingFeatureDetailsDesc:
			'Consulta pósteres, puntuacións de TMDB e OMDb, elenco, equipo técnico, tráileres e coleccións.',
		getItOnGooglePlay: 'Dispoñible en Google Play',
		viewOnGithub: 'Ver en GitHub',
		openInApp: 'Abrir en MovieScout',
		appBannerTitle: 'Segue títulos e recibe alertas de dispoñibilidade',
		appBannerSubtitle:
			'Garda na túa lista, consulta as túas plataformas e recibe avisos en Android.',
		home: 'Inicio',
		languageLabel: 'Idioma',
		regionLabel: 'Rexión',
		privacyPolicy: 'Política de privacidade',
		termsOfService: 'Termos do servizo',
		justwatchAttribution: 'Datos de dispoñibilidade en streaming proporcionados por JustWatch.',
		episodesCount: '{count} episodios',
		seasonsCountLabel: '{count} tempadas',
		moviesCountLabel: '{count} filmes',
		biography: 'Biografía',
		knownFor: 'Coñecido/a por',
		filmography: 'Filmografía',
		taggedImages: 'Imaxes etiquetadas',
		collectionParts: 'Filmes desta colección',
		backToSeries: 'Volver á serie',
		backToSeason: 'Volver á tempada',
		previousEpisode: 'Episodio anterior',
		nextEpisode: 'Seguinte episodio',
		showMore: 'Ver máis',
		showLess: 'Ver menos',
		watchInRegion: 'Onde ver en {region}',
		notFoundTitle: 'Contido non atopado',
		notFoundMessage: 'O título, a persoa ou a páxina solicitada non existe ou non está dispoñible.',
		backToHome: 'Volver ao inicio',
		retry: 'Tentar de novo',
		ratingsTitle: 'Puntuacións',
		releaseDate: 'Data de estrea',
		firstAirDate: 'Primeira emisión',
		runtime: 'Duración',
		status: 'Estado',
		certification: 'Clasificación',
		minutesShort: 'min',
		playTrailer: 'Ver tráiler',
		close: 'Pechar',
		externalLinks: 'Ligazóns externas',
		skipToContent: 'Ir ao contido',
		airDate: 'Data de emisión'
	},
	'fr-FR': {
		landingMotto: 'Découvrir. Suivre. Regarder.',
		landingSubtitle:
			'MovieScout est un suivi de films et séries propulsé par TMDB, OMDb et JustWatch. Conçu autour de votre liste, pas des catalogues.',
		landingFeatureAvailabilityTitle: 'Disponibilité en streaming',
		landingFeatureAvailabilityDesc:
			'Trouvez facilement sur quelles plateformes sont disponibles vos films et séries grâce à JustWatch.',
		landingFeatureNotificationsTitle: 'Alertes de disponibilité',
		landingFeatureNotificationsDesc:
			'Recevez une notification dès qu’un titre de votre liste ou une nouvelle saison arrive sur vos services.',
		landingFeatureOrganizeTitle: 'Rechercher et organiser',
		landingFeatureOrganizeDesc:
			'Recherchez, notez, filtrez et organisez rapidement votre liste à voir et vos notes.',
		landingFeatureDetailsTitle: 'Informations détaillées',
		landingFeatureDetailsDesc:
			'Consultez affiches, notes TMDB et OMDb, distribution, équipe technique, bandes-annonces et sagas.',
		getItOnGooglePlay: 'Disponible sur Google Play',
		viewOnGithub: 'Voir sur GitHub',
		openInApp: 'Ouvrir dans MovieScout',
		appBannerTitle: 'Suivez vos titres et recevez des alertes',
		appBannerSubtitle:
			'Ajoutez à votre liste, vérifiez vos plateformes et recevez des alertes sur Android.',
		home: 'Accueil',
		languageLabel: 'Langue',
		regionLabel: 'Région',
		privacyPolicy: 'Politique de confidentialité',
		termsOfService: "Conditions d'utilisation",
		justwatchAttribution: 'Données de disponibilité streaming fournies par JustWatch.',
		episodesCount: '{count} épisodes',
		seasonsCountLabel: '{count} saisons',
		moviesCountLabel: '{count} films',
		biography: 'Biographie',
		knownFor: 'Connu(e) pour',
		filmography: 'Filmographie',
		taggedImages: 'Images associées',
		collectionParts: 'Films de la saga',
		backToSeries: 'Retour à la série',
		backToSeason: 'Retour à la saison',
		previousEpisode: 'Épisode précédent',
		nextEpisode: 'Épisode suivant',
		showMore: 'Voir plus',
		showLess: 'Voir moins',
		watchInRegion: 'Où regarder ({region})',
		notFoundTitle: 'Contenu introuvable',
		notFoundMessage: 'Le titre, la personne ou la page demandée est indisponible ou introuvable.',
		backToHome: "Retour à l'accueil",
		retry: 'Réessayer',
		ratingsTitle: 'Notes',
		releaseDate: 'Date de sortie',
		firstAirDate: 'Première diffusion',
		runtime: 'Durée',
		status: 'Statut',
		certification: 'Classification',
		minutesShort: 'min',
		playTrailer: 'Voir la bande-annonce',
		close: 'Fermer',
		externalLinks: 'Liens externes',
		skipToContent: 'Aller au contenu',
		airDate: 'Date de diffusion'
	},
	'de-DE': {
		landingMotto: 'Entdecken. Merken. Ansehen.',
		landingSubtitle:
			'MovieScout ist dein Film- und Serien-Tracker mit TMDB, OMDb und JustWatch. Gebaut rund um deine Merkliste, nicht rund um Streaming-Kataloge.',
		landingFeatureAvailabilityTitle: 'Streaming-Verfügbarkeit',
		landingFeatureAvailabilityDesc:
			'Finde über JustWatch sofort heraus, auf welchen Plattformen deine Filme und Serien verfügbar sind.',
		landingFeatureNotificationsTitle: 'Verfügbarkeits-Benachrichtigungen',
		landingFeatureNotificationsDesc:
			'Werde benachrichtigt, sobald Titel deiner Merkliste oder neue Staffeln bei deinen Diensten starten.',
		landingFeatureOrganizeTitle: 'Suchen und organisieren',
		landingFeatureOrganizeDesc:
			'Suche, bewerte, filtere und organisiere Titel schnell in deiner Merkliste und deinen Listen.',
		landingFeatureDetailsTitle: 'Detaillierte Informationen',
		landingFeatureDetailsDesc:
			'Entdecke Poster, TMDB- und OMDb-Bewertungen, Besetzung, Crew, Trailer und Filmreihen.',
		getItOnGooglePlay: 'Jetzt bei Google Play',
		viewOnGithub: 'Auf GitHub ansehen',
		openInApp: 'In MovieScout öffnen',
		appBannerTitle: 'Titel verfolgen & Verfügbarkeits-Alerts erhalten',
		appBannerSubtitle:
			'Zur Merkliste hinzufügen, Plattformen prüfen und auf Android benachrichtigt werden.',
		home: 'Startseite',
		languageLabel: 'Sprache',
		regionLabel: 'Region',
		privacyPolicy: 'Datenschutz',
		termsOfService: 'Nutzungsbedingungen',
		justwatchAttribution: 'Streaming-Verfügbarkeitsdaten bereitgestellt von JustWatch.',
		episodesCount: '{count} Folgen',
		seasonsCountLabel: '{count} Staffeln',
		moviesCountLabel: '{count} Filme',
		biography: 'Biografie',
		knownFor: 'Bekannt für',
		filmography: 'Filmografie',
		taggedImages: 'Markierte Bilder',
		collectionParts: 'Filme in dieser Reihe',
		backToSeries: 'Zurück zur Serie',
		backToSeason: 'Zurück zur Staffel',
		previousEpisode: 'Vorherige Folge',
		nextEpisode: 'Nächste Folge',
		showMore: 'Mehr anzeigen',
		showLess: 'Weniger anzeigen',
		watchInRegion: 'Wo ansehen in {region}',
		notFoundTitle: 'Inhalt nicht gefunden',
		notFoundMessage: 'Der angeforderte Titel, die Person oder Seite existiert nicht oder ist nicht verfügbar.',
		backToHome: 'Zur Startseite',
		retry: 'Erneut versuchen',
		ratingsTitle: 'Bewertungen',
		releaseDate: 'Erscheinungsdatum',
		firstAirDate: 'Erstausstrahlung',
		runtime: 'Laufzeit',
		status: 'Status',
		certification: 'Altersfreigabe',
		minutesShort: 'Min.',
		playTrailer: 'Trailer ansehen',
		close: 'Schließen',
		externalLinks: 'Externe Links',
		skipToContent: 'Zum Inhalt springen',
		airDate: 'Ausstrahlungsdatum'
	},
	'it-IT': {
		landingMotto: 'Scopri. Segui. Guarda.',
		landingSubtitle:
			'MovieScout è un tracker di film e serie TV basato su TMDB, OMDb e JustWatch. Costruito intorno alla tua lista, non ai cataloghi.',
		landingFeatureAvailabilityTitle: 'Disponibilità in streaming',
		landingFeatureAvailabilityDesc:
			'Scopri subito su quali piattaforme streaming sono disponibili i tuoi film e serie con JustWatch.',
		landingFeatureNotificationsTitle: 'Notifiche di disponibilità',
		landingFeatureNotificationsDesc:
			'Ricevi un avviso quando i titoli in lista o le nuove stagioni arrivano sui tuoi servizi.',
		landingFeatureOrganizeTitle: 'Cerca e organizza',
		landingFeatureOrganizeDesc:
			'Cerca, valuta, filtra e organizza rapidamente la tua lista e le tue valutazioni.',
		landingFeatureDetailsTitle: 'Informazioni dettagliate',
		landingFeatureDetailsDesc:
			'Esplora poster, voti TMDB e OMDb, cast, troupe, trailer e collezioni.',
		getItOnGooglePlay: 'Disponibile su Google Play',
		viewOnGithub: 'Vedi su GitHub',
		openInApp: 'Apri in MovieScout',
		appBannerTitle: 'Segui i titoli e ricevi avvisi di disponibilità',
		appBannerSubtitle:
			'Salva in lista, controlla le piattaforme e ricevi notifiche su Android.',
		home: 'Home',
		languageLabel: 'Lingua',
		regionLabel: 'Regione',
		privacyPolicy: 'Informativa sulla privacy',
		termsOfService: 'Termini di servizio',
		justwatchAttribution: 'Dati sulla disponibilità in streaming forniti da JustWatch.',
		episodesCount: '{count} episodi',
		seasonsCountLabel: '{count} stagioni',
		moviesCountLabel: '{count} film',
		biography: 'Biografia',
		knownFor: 'Noto/a per',
		filmography: 'Filmografia',
		taggedImages: 'Immagini correlate',
		collectionParts: 'Film nella collezione',
		backToSeries: 'Torna alla serie',
		backToSeason: 'Torna alla stagione',
		previousEpisode: 'Episodio precedente',
		nextEpisode: 'Episodio successivo',
		showMore: 'Mostra di più',
		showLess: 'Mostra meno',
		watchInRegion: 'Dove guardare in {region}',
		notFoundTitle: 'Contenuto non trovato',
		notFoundMessage: 'Il titolo, la persona o la pagina richiesta non è disponibile o non esiste.',
		backToHome: 'Torna alla home',
		retry: 'Riprova',
		ratingsTitle: 'Valutazioni',
		releaseDate: 'Data di uscita',
		firstAirDate: 'Prima messa in onda',
		runtime: 'Durata',
		status: 'Stato',
		certification: 'Classificazione',
		minutesShort: 'min',
		playTrailer: 'Guarda trailer',
		close: 'Chiudi',
		externalLinks: 'Link esterni',
		skipToContent: 'Vai al contenuto',
		airDate: 'Data di trasmissione'
	},
	'pt-BR': {
		landingMotto: 'Descubra. Acompanhe. Assista.',
		landingSubtitle:
			'MovieScout é um rastreador de filmes e séries com dados do TMDB, OMDb e JustWatch. Feito em torno da sua lista, não dos catálogos.',
		landingFeatureAvailabilityTitle: 'Disponibilidade em streaming',
		landingFeatureAvailabilityDesc:
			'Descubra facilmente em quais plataformas de streaming seus filmes e séries estão disponíveis com o JustWatch.',
		landingFeatureNotificationsTitle: 'Alertas de disponibilidade',
		landingFeatureNotificationsDesc:
			'Receba notificações quando títulos da sua lista ou novas temporadas chegarem aos seus serviços.',
		landingFeatureOrganizeTitle: 'Busque e organize',
		landingFeatureOrganizeDesc:
			'Busque, avalie, filtre e organize rapidamente sua lista de interesse e avaliações.',
		landingFeatureDetailsTitle: 'Informações detalhadas',
		landingFeatureDetailsDesc:
			'Veja pôsteres, notas do TMDB e OMDb, elenco, equipe técnica, trailers e coleções.',
		getItOnGooglePlay: 'Disponível no Google Play',
		viewOnGithub: 'Ver no GitHub',
		openInApp: 'Abrir no MovieScout',
		appBannerTitle: 'Acompanhe títulos e receba alertas',
		appBannerSubtitle:
			'Salve na sua lista, confira suas plataformas e receba alertas no Android.',
		home: 'Início',
		languageLabel: 'Idioma',
		regionLabel: 'Região',
		privacyPolicy: 'Política de privacidade',
		termsOfService: 'Termos de serviço',
		justwatchAttribution: 'Dados de disponibilidade em streaming fornecidos por JustWatch.',
		episodesCount: '{count} episódios',
		seasonsCountLabel: '{count} temporadas',
		moviesCountLabel: '{count} filmes',
		biography: 'Biografia',
		knownFor: 'Conhecido(a) por',
		filmography: 'Filmografia',
		taggedImages: 'Imagens marcadas',
		collectionParts: 'Filmes desta coleção',
		backToSeries: 'Voltar para a série',
		backToSeason: 'Voltar para a temporada',
		previousEpisode: 'Episódio anterior',
		nextEpisode: 'Próximo episódio',
		showMore: 'Ver mais',
		showLess: 'Ver menos',
		watchInRegion: 'Onde assistir em {region}',
		notFoundTitle: 'Conteúdo não encontrado',
		notFoundMessage: 'O título, pessoa ou página solicitada não existe ou não está disponível.',
		backToHome: 'Voltar ao início',
		retry: 'Tentar novamente',
		ratingsTitle: 'Avaliações',
		releaseDate: 'Data de lançamento',
		firstAirDate: 'Primeira exibição',
		runtime: 'Duração',
		status: 'Status',
		certification: 'Classificação',
		minutesShort: 'min',
		playTrailer: 'Assistir trailer',
		close: 'Fechar',
		externalLinks: 'Links externos',
		skipToContent: 'Ir para o conteúdo',
		airDate: 'Data de exibição'
	},
	'pt-PT': {
		landingMotto: 'Descobre. Acompanha. Vê.',
		landingSubtitle:
			'O MovieScout é um gestor de filmes e séries com dados do TMDB, OMDb e JustWatch. Pensado em torno da tua lista, não dos catálogos.',
		landingFeatureAvailabilityTitle: 'Disponibilidade em streaming',
		landingFeatureAvailabilityDesc:
			'Descobre facilmente em que plataformas de streaming estão disponíveis os teus filmes e séries com o JustWatch.',
		landingFeatureNotificationsTitle: 'Notificações de disponibilidade',
		landingFeatureNotificationsDesc:
			'Recebe notificações quando títulos da tua lista ou novas temporadas chegarem aos teus serviços.',
		landingFeatureOrganizeTitle: 'Pesquisa e organiza',
		landingFeatureOrganizeDesc:
			'Pesquisa, classifica, filtra e organiza rapidamente a tua lista e avaliações.',
		landingFeatureDetailsTitle: 'Informação detalhada',
		landingFeatureDetailsDesc:
			'Explora pósteres, classificações do TMDB e OMDb, elenco, equipa técnica, trailers e coleções.',
		getItOnGooglePlay: 'Disponível no Google Play',
		viewOnGithub: 'Ver no GitHub',
		openInApp: 'Abrir no MovieScout',
		appBannerTitle: 'Acompanha títulos e recebe alertas',
		appBannerSubtitle:
			'Guarda na tua lista, verifica as tuas plataformas e recebe alertas no Android.',
		home: 'Início',
		languageLabel: 'Idioma',
		regionLabel: 'Região',
		privacyPolicy: 'Política de privacidade',
		termsOfService: 'Termos de serviço',
		justwatchAttribution: 'Dados de disponibilidade em streaming fornecidos pela JustWatch.',
		episodesCount: '{count} episódios',
		seasonsCountLabel: '{count} temporadas',
		moviesCountLabel: '{count} filmes',
		biography: 'Biografia',
		knownFor: 'Conhecido(a) por',
		filmography: 'Filmografia',
		taggedImages: 'Imagens associadas',
		collectionParts: 'Filmes desta coleção',
		backToSeries: 'Voltar à série',
		backToSeason: 'Voltar à temporada',
		previousEpisode: 'Episódio anterior',
		nextEpisode: 'Episódio seguinte',
		showMore: 'Ver mais',
		showLess: 'Ver menos',
		watchInRegion: 'Onde ver em {region}',
		notFoundTitle: 'Conteúdo não encontrado',
		notFoundMessage: 'O título, pessoa ou página solicitada não existe ou não está disponível.',
		backToHome: 'Voltar ao início',
		retry: 'Tentar novamente',
		ratingsTitle: 'Classificações',
		releaseDate: 'Data de estreia',
		firstAirDate: 'Primeira transmissão',
		runtime: 'Duração',
		status: 'Estado',
		certification: 'Classificação etária',
		minutesShort: 'min',
		playTrailer: 'Ver trailer',
		close: 'Fechar',
		externalLinks: 'Ligações externas',
		skipToContent: 'Saltar para o conteúdo',
		airDate: 'Data de transmissão'
	}
};
