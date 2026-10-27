// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Téléchargement des détails du titre';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Récupération des données des titres ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Mise à jour des plateformes';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Vérification des disponibilités ($progress/$total)...';
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
  String get selectLanguage => 'Choisir la langue';

  @override
  String get messageEmptyList => 'Aucun film sélectionné pour l\'instant.';

  @override
  String get messageEmptySearch => 'Vous pouvez lancer une recherche avec la loupe en bas.';

  @override
  String get messageEmptyOptions => 'Vous pouvez aussi';

  @override
  String get messageEmptyLogin => 'Se connecter à MovieScout';

  @override
  String get search => 'Rechercher un titre';

  @override
  String get searchAiHint => 'Décrivez le film ou la série que vous recherchez...';

  @override
  String get searchAiTooltip => 'Recherche Intelligente (IA)';

  @override
  String get searchTitle => 'Rechercher';

  @override
  String get searchPerson => 'Rechercher une personne';

  @override
  String get gallery => 'Galerie';

  @override
  String get searchProvider => 'Rechercher une plateforme';

  @override
  String get trailer => 'Bande-annonce';

  @override
  String get includeGenres => 'Inclure';

  @override
  String get excludeGenres => 'Exclure';

  @override
  String get pressBackAgainToExit => 'Appuyez à nouveau pour quitter';

  @override
  String get back => 'Retour';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get anonymousUser => 'Utilisateur anonyme';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get loginSuccess => 'Connecté avec succès.';

  @override
  String get loginFailed => 'Nom d\'utilisateur ou mot de passe incorrect.';

  @override
  String get logoutSuccess => 'Déconnecté avec succès.';

  @override
  String get loginToTmdb => 'Se connecter à TMDb';

  @override
  String get completeLoginToTmdb => 'Terminer le processus de connexion';

  @override
  String get signInToWatchlist => 'Vous devez être connecté pour ajouter des titres.';

  @override
  String get tvShow => 'Série';

  @override
  String get movie => 'Film';

  @override
  String get select => 'Sélectionner';

  @override
  String get imdbImport => 'Import IMDb';

  @override
  String get imdbImportHint => 'Sélectionnez un fichier CSV exporté d\'IMDb';

  @override
  String get imdbImportWatchlist => 'Importer la Watchlist';

  @override
  String get imdbImportRateslist => 'Importer les notes';

  @override
  String get missingDescription => 'Description manquante';

  @override
  String get flatrateProviders => 'Abonnement';

  @override
  String get rentProviders => 'Location';

  @override
  String get buyProviders => 'Achat';

  @override
  String get allTypes => 'Titres';

  @override
  String get movies => 'Films';

  @override
  String get tvshows => 'Séries';

  @override
  String get miniseries => 'Mini-séries';

  @override
  String get collection => 'Saga';

  @override
  String get seeCollection => 'Voir la saga';

  @override
  String get sortAlphabetically => 'Alphabétique';

  @override
  String get sortRating => 'Note';

  @override
  String get sortUserRating => 'Note (Moi)';

  @override
  String get sortReleaseDate => 'Date de sortie';

  @override
  String get sortRuntime => 'Durée';

  @override
  String get sortDateRated => 'Date d\'évaluation';

  @override
  String get sortRelevance => 'Pertinence';

  @override
  String get sortAddedOrder => 'Date d\'ajout';

  @override
  String get genres => 'Genres';

  @override
  String get titles => 'Titres';

  @override
  String get rate_date => 'Date de notation';

  @override
  String get your_rate => 'Votre note';

  @override
  String get reset_rate => 'Réinitialiser la note';

  @override
  String get emptyRates => 'Vous n\'avez encore noté aucun titre.';

  @override
  String get seen => 'Vu';

  @override
  String get markAsSeen => 'Marquer comme vu';

  @override
  String get ratedOnly => 'Noté';

  @override
  String get seenOnly => 'Vu';

  @override
  String get followingOnly => 'Suivi';

  @override
  String get emptyList => 'Rien ici.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Titres notés';

  @override
  String get yes => 'Oui';

  @override
  String get cancel => 'Annuler';

  @override
  String get originaTitle => 'Titre original';

  @override
  String get originalLanguage => 'Langue originale';

  @override
  String get originCountry => 'Pays';

  @override
  String get defaultScheme => 'Par défaut';

  @override
  String get about => 'À propos...';

  @override
  String get aboutDescription => 'MovieScout est votre suivi de films et séries alimenté par TMDb, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Voir le projet sur ';

  @override
  String get apiDisclaimer => 'Ce produit utilise l\'API TMDb mais n\'est ni approuvé ni certifié par TMDb.';

  @override
  String get privacyDisclaimerPrefix => 'Consultez la ';

  @override
  String get privacyDisclaimer => 'politique de confidentialité';

  @override
  String get recommended => 'Recommandé';

  @override
  String get providersTitle => 'Plateformes';

  @override
  String get providers => 'Plateformes';

  @override
  String get filterByProviders => 'Disponibles uniquement';

  @override
  String get noProvidersAvailable => 'Aucune plateforme disponible';

  @override
  String get discoverlistTitle => 'Découvrir';

  @override
  String get notReleasedYet => 'Pas encore sorti';

  @override
  String get unknownDuration => 'Durée non spécifiée.';

  @override
  String get cast => 'Distribution';

  @override
  String get crew => 'Équipe technique';

  @override
  String get seeThemAll => 'Voir tout';

  @override
  String get ratedCredits => 'Titres notés';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get deathDate => 'Date de décès';

  @override
  String get placeOfBirth => 'Lieu de naissance';

  @override
  String get years => 'Années';

  @override
  String get job => 'Poste';

  @override
  String get department => 'Département';

  @override
  String get watchingNow => 'En cours de visionnage';

  @override
  String get pinLimitReached => 'Vous avez atteint la limite de 5 titres épinglés.';

  @override
  String get pin => 'Épingler';

  @override
  String get unpin => 'Détacher';

  @override
  String get notificationTitle => 'Maintenant disponible !';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title est maintenant disponible sur $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nouvelle saison !';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nouvelle saison de $title disponible sur $provider.';
  }

  @override
  String get selectRegion => 'Choisir la région';

  @override
  String get searchRegion => 'Rechercher une région';

  @override
  String get regionAuto => 'Détection automatique (IP)';

  @override
  String get shareLink => 'Partager';

  @override
  String get director => 'Réalisateur';

  @override
  String get creator => 'Créateur';

  @override
  String get writer => 'Scénariste';

  @override
  String seasonsCount(Object count) {
    return '${count}sais';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsPermissionRequired => 'Vous devez autoriser les notifications dans les paramètres système.';

  @override
  String get notificationsPermissionDescription => 'Pour être informé de la disponibilité des films et des nouvelles saisons, activez les notifications.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get settings => 'Paramètres';

  @override
  String get errorMessageGeneric => 'Une erreur est survenue. Veuillez réessayer plus tard.';

  @override
  String get notificationsHistory => 'Dernières notifications';

  @override
  String get notifyCompleteSeason => 'Notifier saison complète';

  @override
  String get episodes => 'Épisodes';

  @override
  String get selectSeason => 'Voir les saisons';

  @override
  String seasonLabel(Object count) {
    return 'Saison $count';
  }

  @override
  String get notifyTitle => 'Notifier les nouvelles saisons';

  @override
  String get notifyMessage => 'Voulez-vous être notifié lors de la diffusion d\'une nouvelle saison ?';

  @override
  String get no => 'Non';

  @override
  String get none => 'Aucun';

  @override
  String get results => 'Résultats';

  @override
  String inRoleContext(Object context) {
    return ' dans $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Épisode $count';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get showEditContent => 'Afficher le bouton de modification';

  @override
  String get translations => 'Traductions';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get close => 'Fermer';

  @override
  String get autoTranslation => 'Traduction automatique';

  @override
  String get originalText => 'Texte original';

  @override
  String get addToHomeScreen => 'Ajouter à l\'écran d\'accueil';

  @override
  String get shortcutFailed => 'Échec de l\'ajout du raccourci';

  @override
  String get rate => 'Noter';

  @override
  String get watchOn => 'Regarder sur';

  @override
  String get status => 'Statut';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Intelligence Artificielle';

  @override
  String get aiSettingsSubtitle => 'Recherche intelligente et fonctions d\'IA';

  @override
  String get aiSettingsDescription => 'L\'IA vous permet de trouver des films et séries par description naturelle. Obtenez une clé API gratuite sur OpenRouter.';

  @override
  String get aiGetApiKeyButton => 'Obtenir une clé sur OpenRouter';

  @override
  String get aiApiKeyLabel => 'Clé API OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Enregistrer la clé';

  @override
  String get aiDeleteKeyButton => 'Supprimer';

  @override
  String get aiKeySaved => 'Clé API enregistrée avec succès';

  @override
  String get aiKeyCleared => 'Clé API supprimée';

  @override
  String get aiStatusConfigured => 'Clé API configurée';

  @override
  String get aiStatusNotConfigured => 'Clé API non configurée';

  @override
  String get delete => 'Supprimer';

  @override
  String get aiDeleteConfirmTitle => 'Supprimer la clé API';

  @override
  String get aiDeleteConfirmMessage => 'Êtes-vous sûr de vouloir supprimer la clé API ? OpenRouter ne permet pas de la revoir une fois créée.';

  @override
  String get searchTimeout => 'La recherche a pris trop de temps. Veuillez réessayer.';

  @override
  String get aiSearchTimeout => 'La recherche IA a expiré. Essayez une description plus courte.';

  @override
  String get aiSearchError => 'Une erreur est survenue lors de la recherche IA.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Limite de requêtes atteinte. Attendez $seconds secondes avant de réessayer.';
  }

  @override
  String get aiRateLimitGeneric => 'Limite de requêtes atteinte. Veuillez patienter un instant.';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get loginSubtitle => 'Connectez-vous pour enregistrer et synchroniser vos listes et vos notes.';

  @override
  String get googleSignInButton => 'Continuer avec Google';

  @override
  String get tmdbAccount => 'Compte TMDb';

  @override
  String get tmdbImport => 'Import TMDb';

  @override
  String get tmdbImportScreenTitle => 'Import TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importez vos données TMDb';

  @override
  String get tmdbImportScreenBody => 'Vous pouvez importer votre watchlist et vos notes depuis votre compte TMDb. Connectez-vous à TMDb pour continuer.';

  @override
  String get tmdbImportStartButton => 'Démarrer l\'import';

  @override
  String get tmdbImportSuccess => 'Données importées avec succès !';

  @override
  String get tmdbImportDownloadingWatchlist => 'Téléchargement de la watchlist...';

  @override
  String get tmdbImportDownloadingRateslist => 'Téléchargement des notes...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Téléchargement des épisodes notés...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count titres dans la watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count titres notés';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count épisodes notés';
  }

  @override
  String get tmdbImportUploadTitle => 'Synchroniser avec le compte';

  @override
  String get tmdbImportUploading => 'Téléversement vers votre compte...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count éléments synchronisés avec votre compte';
  }

  @override
  String get tmdbImportError => 'Erreur lors de l\'importation des données';

  @override
  String get tmdbImportConsentText => 'L\'import ajoutera en toute sécurité vos listes et notes TMDb à votre compte MovieScout.';

  @override
  String get loginConsentText => 'En vous connectant, vous acceptez de stocker vos données sur les serveurs de MovieScout selon nos ';

  @override
  String get termsOfService => 'conditions d\'utilisation';

  @override
  String get andThe => ' et la ';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmMessage => 'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.';

  @override
  String get deleteAccountSuccess => 'Votre compte a été supprimé avec succès';

  @override
  String get deleteAccountError => 'Erreur lors de la suppression du compte';

  @override
  String get comments => 'Commentaires';

  @override
  String get addComment => 'Ajouter un commentaire';

  @override
  String get editComment => 'Modifier le commentaire';

  @override
  String get deleteComment => 'Supprimer le commentaire';

  @override
  String get writeComment => 'Écrire un commentaire...';

  @override
  String get noCommentsYet => 'Aucun commentaire pour le moment';

  @override
  String get signInToComment => 'Vous devez être connecté pour ajouter un commentaire.';

  @override
  String get deleteCommentConfirm => 'Êtes-vous sûr de vouloir supprimer votre commentaire ?';

  @override
  String get save => 'Enregistrer';

  @override
  String get you => 'Vous';

  @override
  String get followingTab => 'Abonnements';

  @override
  String get users => 'Utilisateurs';

  @override
  String get user => 'Utilisateur';

  @override
  String get follow => 'Suivre';

  @override
  String get following => 'Suivi';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String get latestRatedTitles => 'Derniers titres notés';

  @override
  String get emptyFollowingList => 'Vous ne suivez aucun utilisateur pour le moment.';

  @override
  String get emptyFollowingSearchHint => 'Recherchez des utilisateurs pour les suivre et voir leur activité.';

  @override
  String get networkErrorMessage => 'Impossible de se connecter au serveur. Veuillez vérifier votre connexion Internet.';

  @override
  String get publicProfileTitle => 'Profil public';

  @override
  String get publicProfileSubtitle => 'Activez votre profil public pour partager ce que vous regardez avec la communauté';

  @override
  String get privateProfileMessage => 'Ce profil est privé';

  @override
  String get enablePublicProfileBanner => 'Activez votre profil public pour partager ce que vous regardez avec la communauté. Il peut être désactivé depuis les paramètres.';

  @override
  String get enablePublicProfileButton => 'Activer le profil public';

  @override
  String get noWatchingNowTitles => 'Ne regarde aucun titre pour le moment';

  @override
  String get noRatedTitles => 'Aucun titre noté';

  @override
  String get communityTabTitle => 'Onglet communauté';

  @override
  String get communityTabSubtitle => 'Afficher l\'onglet communauté dans la barre de navigation';

  @override
  String get emptyFollowingCommunityHint => 'Vous pouvez masquer cet onglet dans les paramètres si vous ne l\'utilisez pas.';

  @override
  String get shareAppCommunityPrompt => 'Partagez MovieScout avec vos proches et commencez à créer votre réseau.';

  @override
  String get shareAppButton => 'Partager MovieScout';

  @override
  String get shareAppMessage => 'Rejoignez MovieScout pour découvrir et partager des films et des séries !';

  @override
  String get shareAppGooglePlay => 'Installez-la sur Google Play :';

  @override
  String get settingsSectionPreferences => 'Préférences de contenu';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSectionCommunity => 'Communauté et profil';

  @override
  String get settingsSectionTools => 'Outils et fonctionnalités';

  @override
  String get settingsSectionData => 'Données et import';

  @override
  String get settingsNotificationsEnabledSubtitle => 'Alertes de disponibilité actives';

  @override
  String get settingsNotificationsDisabledSubtitle => 'Alertes de disponibilité désactivées';

  @override
  String get settingsNotifySeasonComplete => 'Notifie lorsque la saison complète est disponible';

  @override
  String get settingsNotifySeasonFirstEp => 'Notifie uniquement lors du premier épisode';

  @override
  String settingsProvidersCount(Object count) {
    return '$count plateformes sélectionnées';
  }

  @override
  String get settingsProvidersNone => 'Aucune plateforme sélectionnée';

  @override
  String get settingsAiConfigured => 'Clé API configurée';

  @override
  String get settingsAiNotConfigured => 'Aucune clé configurée';

  @override
  String get settingsProfilePublic => 'Visible pour la communauté';

  @override
  String get settingsProfilePrivate => 'Profil privé';

  @override
  String get settingsCommunityVisible => 'Visible dans la barre de navigation';

  @override
  String get settingsCommunityHidden => 'Masquée';

  @override
  String get settingsEditVisible => 'Visibles sur les fiches';

  @override
  String get settingsEditHidden => 'Masqués';

  @override
  String get settingsImdbSubtitle => 'Fichier CSV (watchlist et notes)';

  @override
  String get settingsTmdbSubtitle => 'Watchlist et notes';

  @override
  String get settingsDeleteAccountSubtitle => 'Action irréversible';

  @override
  String get understood => 'Compris';

  @override
  String get settingsInfoProvidersTitle => 'Plateformes de streaming';

  @override
  String get settingsInfoProvidersIntro => 'Comment MovieScout utilise-t-il vos plateformes ?';

  @override
  String get settingsInfoProvidersItem1Title => 'Alertes de disponibilité';

  @override
  String get settingsInfoProvidersItem1Desc => 'Lorsque vous ajoutez un titre indisponible, MovieScout surveille vos plateformes sélectionnées pour vous avertir dès son arrivée.';

  @override
  String get settingsInfoProvidersItem2Title => 'Filtre dans les recherches';

  @override
  String get settingsInfoProvidersItem2Desc => 'Filtrez rapidement le catalogue pour ne voir que le contenu disponible avec vos abonnements actifs.';

  @override
  String get settingsInfoProvidersItem3Title => 'Catalogue régional';

  @override
  String get settingsInfoProvidersItem3Desc => 'La disponibilité s\'adapte automatiquement au pays sélectionné dans les paramètres.';

  @override
  String get settingsInfoNotificationsTitle => 'Comment fonctionnent les notifications ?';

  @override
  String get settingsInfoNotificationsIntro => 'Alertes automatiques de disponibilité';

  @override
  String get settingsInfoNotificationsItem1Title => 'Sorties de la watchlist';

  @override
  String get settingsInfoNotificationsItem1Desc => 'Recevez une alerte lorsqu\'un titre de votre watchlist devient disponible sur vos plateformes sélectionnées.';

  @override
  String get settingsInfoNotificationsItem2Title => 'Nouvelles saisons de séries';

  @override
  String get settingsInfoNotificationsItem2Desc => 'Par défaut, vous êtes averti dès le premier épisode. Si \'Saison complète\' est activé, l\'alerte attend la diffusion de tous les épisodes.';

  @override
  String get settingsInfoNotificationsItem3Title => 'Vérifications en arrière-plan';

  @override
  String get settingsInfoNotificationsItem3Desc => 'MovieScout recherche les nouveautés régulièrement, silencieusement et sans vider votre batterie.';

  @override
  String get settingsInfoAiTitle => 'Intelligence Artificielle';

  @override
  String get settingsInfoAiIntro => 'Améliorations des traductions et recherches de titres';

  @override
  String get settingsInfoAiItem1Title => 'Traductions contextuelles';

  @override
  String get settingsInfoAiItem1Desc => 'Génère des traductions naturelles pour les synopsis et titres adaptées au contexte cinématographique lorsqu\'ils manquent dans votre langue.';

  @override
  String get settingsInfoAiItem2Title => 'Recherche intelligente';

  @override
  String get settingsInfoAiItem2Desc => 'Trouvez des films en décrivant des scènes, intrigues ou personnages même sans vous souvenir du titre.';

  @override
  String get settingsInfoAiItem3Title => 'Clé privée et sécurisée';

  @override
  String get settingsInfoAiItem3Desc => 'Votre clé API est stockée de manière sécurisée et privée uniquement sur votre appareil.';

  @override
  String get settingsInfoAiNote => 'Important : Les modèles d\'IA gratuits peuvent présenter des temps de réponse plus longs ou des limites temporaires selon le fournisseur. Pour des performances optimales, un service payant à l\'usage est recommandé.';

  @override
  String get settingsInfoProfileTitle => 'Profil Public & Communauté';

  @override
  String get settingsInfoProfileIntro => 'L\'aspect communautaire de MovieScout';

  @override
  String get settingsInfoProfileItem1Title => 'Partagez votre activité';

  @override
  String get settingsInfoProfileItem1Desc => 'Permet aux autres utilisateurs de trouver votre profil, de vous suivre et de voir ce que vous regardez et notez.';

  @override
  String get settingsInfoProfileItem2Title => 'Confidentialité sous contrôle';

  @override
  String get settingsInfoProfileItem2Desc => 'Passez en mode privé à tout moment. Seuls les titres et notes publics sont partagés, jamais vos données personnelles.';

  @override
  String get settingsInfoProfileItem3Title => 'Onglet communauté';

  @override
  String get settingsInfoProfileItem3Desc => 'Affichez ou masquez l\'onglet communauté dans la barre de navigation selon vos préférences.';

  @override
  String get settingsInfoEditTitle => 'Collaboration et modification sur TMDb';

  @override
  String get settingsInfoEditIntro => 'Aidez à enrichir la base de données ouverte et à améliorer les informations.';

  @override
  String get settingsInfoEditItem1Title => 'Accès direct depuis la fiche';

  @override
  String get settingsInfoEditItem1Desc => 'Affiche une icône de crayon sur les fiches de films et séries pour accéder directement à leur page de modification.';

  @override
  String get settingsInfoEditItem2Title => 'Communauté et données ouvertes';

  @override
  String get settingsInfoEditItem2Desc => 'Toutes les informations de MovieScout proviennent de The Movie Database (TMDb), un projet collaboratif mondial.';

  @override
  String get settingsInfoEditItem3Title => 'Amélioration des contenus et traductions';

  @override
  String get settingsInfoEditItem3Desc => 'Vous pouvez ajouter ou corriger des titres, synopsis et détails dans n\'importe quelle langue.';

  @override
  String get settingsInfoEditNote => 'Pour modifier du contenu sur TMDb, vous devez simplement vous connecter avec un compte gratuit sur themoviedb.org.';
}
