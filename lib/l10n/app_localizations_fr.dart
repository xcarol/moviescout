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
  String get searchPlaceholder => 'Rechercher des films ou séries...';

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
  String get password => 'Mot de passe';

  @override
  String get anonymousUser => 'Utilisateur anonyme';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginDescription => 'Connectez-vous à votre compte TMDB';

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
  String get signupToTmdb => 'S\'inscrire sur TMDb';

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
  String get imdbImportCount => 'Titres importés avec succès';

  @override
  String get imdbResetWatchlist => 'RÉINITIALISER WATCHLIST';

  @override
  String get imdbResetRateslist => 'RÉINITIALISER NOTES';

  @override
  String get imdbConfirmationTitle => 'ATTENTION';

  @override
  String get imdbResetWatchlistConfirmation => 'Voulez-vous vraiment réinitialiser la Watchlist ?';

  @override
  String get imdbResetRateslistConfirmation => 'Voulez-vous vraiment réinitialiser les notes ?';

  @override
  String get resetWatchlistCount => 'Titres en Watchlist : ';

  @override
  String get resetRateslistCount => 'Titres notés : ';

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
  String get pendingOnly => 'En attente';

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
  String get schemeSelectTitle => 'Choisir la couleur';

  @override
  String get defaultScheme => 'Par défaut';

  @override
  String get blackScheme => 'Noir';

  @override
  String get blueScheme => 'Bleu';

  @override
  String get redScheme => 'Rouge';

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
  String get youtubeSearch => 'Recherche YouTube';

  @override
  String get notificationsHistory => 'Dernières notifications';

  @override
  String get notifyCompleteSeason => 'Notifier saison complète';

  @override
  String get notifyCompleteSeasonSubtitle => 'Notifie uniquement lorsque toute la saison est disponible.';

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
  String get shortcutAdded => 'Raccourci ajouté';

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
  String get googleSignInButton => 'Connexion Google';

  @override
  String get alreadyUsingMovieScout => 'Vous utilisez déjà MovieScout ?';

  @override
  String get importTmdbData => 'Importez vos données depuis TMDb.';

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
  String get tmdbImportDownloading => 'Téléchargement des données TMDb...';

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
  String get tmdbImportLoginRequired => 'Connectez-vous à TMDb pour lancer l\'import.';

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
}
