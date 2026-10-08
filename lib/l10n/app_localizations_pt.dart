// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get notificationDownloadingTitle => 'Baixando detalhes do título';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Obtendo dados dos títulos ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Atualizando plataformas';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Verificando disponibilidade ($progress/$total)...';
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
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get messageEmptyList => 'Nenhum filme selecionado ainda.';

  @override
  String get messageEmptySearch => 'Você pode pesquisar usando a lupa na barra inferior.';

  @override
  String get messageEmptyOptions => 'Você também pode';

  @override
  String get messageEmptyLogin => 'Entrar no MovieScout';

  @override
  String get search => 'Pesquisar um título';

  @override
  String get searchAiHint => 'Descreva o filme ou série que você está procurando...';

  @override
  String get searchAiTooltip => 'Busca Inteligente (IA)';

  @override
  String get searchTitle => 'Pesquisar';

  @override
  String get searchPerson => 'Pesquisar por alguém';

  @override
  String get searchPlaceholder => 'Pesquisar filmes ou séries...';

  @override
  String get gallery => 'Galeria';

  @override
  String get searchProvider => 'Pesquisar uma plataforma';

  @override
  String get trailer => 'Trailer';

  @override
  String get includeGenres => 'Incluir';

  @override
  String get excludeGenres => 'Excluir';

  @override
  String get pressBackAgainToExit => 'Pressione voltar novamente para sair';

  @override
  String get back => 'Voltar';

  @override
  String get username => 'Nome de usuário';

  @override
  String get password => 'Senha';

  @override
  String get anonymousUser => 'Usuário anônimo';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginDescription => 'Faça login na sua conta do TMDB';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get loginSuccess => 'Login realizado com sucesso.';

  @override
  String get loginFailed => 'Nome de usuário ou senha incorretos.';

  @override
  String get logoutSuccess => 'Desconectado com sucesso.';

  @override
  String get loginToTmdb => 'Entrar no TMDb';

  @override
  String get completeLoginToTmdb => 'Concluir processo de login';

  @override
  String get signupToTmdb => 'Cadastrar-se no TMDb';

  @override
  String get signInToWatchlist => 'Você precisa estar conectado para adicionar títulos.';

  @override
  String get tvShow => 'Série';

  @override
  String get movie => 'Filme';

  @override
  String get select => 'Selecionar';

  @override
  String get imdbImport => 'Importação IMDb';

  @override
  String get imdbImportHint => 'Selecione um arquivo CSV exportado do IMDb';

  @override
  String get imdbImportWatchlist => 'Importar Watchlist';

  @override
  String get imdbImportRateslist => 'Importar avaliações';

  @override
  String get imdbImportCount => 'Títulos importados com sucesso';

  @override
  String get imdbResetWatchlist => 'REDEFINIR WATCHLIST';

  @override
  String get imdbResetRateslist => 'REDEFINIR AVALIAÇÕES';

  @override
  String get imdbConfirmationTitle => 'ATENÇÃO';

  @override
  String get imdbResetWatchlistConfirmation => 'Deseja realmente redefinir a Watchlist?';

  @override
  String get imdbResetRateslistConfirmation => 'Deseja realmente redefinir as avaliações?';

  @override
  String get resetWatchlistCount => 'Títulos na Watchlist: ';

  @override
  String get resetRateslistCount => 'Títulos avaliados: ';

  @override
  String get missingDescription => 'Sem descrição';

  @override
  String get flatrateProviders => 'Streaming';

  @override
  String get rentProviders => 'Aluguel';

  @override
  String get buyProviders => 'Comprar';

  @override
  String get allTypes => 'Títulos';

  @override
  String get movies => 'Filmes';

  @override
  String get tvshows => 'Séries';

  @override
  String get miniseries => 'Minisséries';

  @override
  String get collection => 'Coleção';

  @override
  String get seeCollection => 'Ver coleção';

  @override
  String get sortAlphabetically => 'Alfabética';

  @override
  String get sortRating => 'Avaliação';

  @override
  String get sortUserRating => 'Minha avaliação';

  @override
  String get sortReleaseDate => 'Data de lançamento';

  @override
  String get sortRuntime => 'Duração';

  @override
  String get sortDateRated => 'Data da avaliação';

  @override
  String get sortRelevance => 'Relevância';

  @override
  String get sortAddedOrder => 'Data de adição';

  @override
  String get genres => 'Gêneros';

  @override
  String get titles => 'Títulos';

  @override
  String get rate_date => 'Data da avaliação';

  @override
  String get your_rate => 'Sua avaliação';

  @override
  String get reset_rate => 'Limpar avaliação';

  @override
  String get emptyRates => 'Você ainda não avaliou nenhum título.';

  @override
  String get seen => 'Visto';

  @override
  String get markAsSeen => 'Marcar como visto';

  @override
  String get ratedOnly => 'Avaliados';

  @override
  String get seenOnly => 'Vistos';

  @override
  String get followingOnly => 'Seguindo';

  @override
  String get pendingOnly => 'Pendentes';

  @override
  String get emptyList => 'Nada aqui.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Avaliados';

  @override
  String get yes => 'Sim';

  @override
  String get cancel => 'Cancelar';

  @override
  String get originaTitle => 'Título original';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get originCountry => 'País';

  @override
  String get schemeSelectTitle => 'Selecionar cor';

  @override
  String get defaultScheme => 'Padrão';

  @override
  String get blackScheme => 'Preto';

  @override
  String get blueScheme => 'Azul';

  @override
  String get redScheme => 'Vermelho';

  @override
  String get about => 'Sobre...';

  @override
  String get aboutDescription => 'O MovieScout é seu rastreador de filmes e séries desenvolvido com TMDb, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Visite o projeto no ';

  @override
  String get apiDisclaimer => 'Este produto usa a API do TMDb, mas não é endossado ou certificado pelo TMDb.';

  @override
  String get privacyDisclaimerPrefix => 'Leia a ';

  @override
  String get privacyDisclaimer => 'política de privacidade';

  @override
  String get recommended => 'Recomendados';

  @override
  String get providersTitle => 'Plataformas de streaming';

  @override
  String get providers => 'Plataformas';

  @override
  String get filterByProviders => 'Apenas disponíveis';

  @override
  String get noProvidersAvailable => 'Nenhuma plataforma disponível';

  @override
  String get discoverlistTitle => 'Descobrir';

  @override
  String get notReleasedYet => 'Ainda não lançado';

  @override
  String get unknownDuration => 'Duração não informada.';

  @override
  String get cast => 'Elenco';

  @override
  String get crew => 'Equipe técnica';

  @override
  String get seeThemAll => 'Ver todos';

  @override
  String get ratedCredits => 'Créditos avaliados';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get deathDate => 'Data de falecimento';

  @override
  String get placeOfBirth => 'Local de nascimento';

  @override
  String get years => 'Anos';

  @override
  String get job => 'Cargo';

  @override
  String get department => 'Departamento';

  @override
  String get watchingNow => 'Assistindo agora';

  @override
  String get pinLimitReached => 'Você atingiu o limite de 5 títulos fixados.';

  @override
  String get pin => 'Fixar';

  @override
  String get unpin => 'Desafixar';

  @override
  String get notificationTitle => 'Já disponível!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title já está disponível no $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nova temporada!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nova temporada de $title disponível no $provider.';
  }

  @override
  String get selectRegion => 'Selecionar região';

  @override
  String get searchRegion => 'Pesquisar região';

  @override
  String get regionAuto => 'Detecção automática (IP)';

  @override
  String get shareLink => 'Compartilhar';

  @override
  String get director => 'Diretor';

  @override
  String get creator => 'Criador';

  @override
  String get writer => 'Roteirista';

  @override
  String seasonsCount(Object count) {
    return '$count temps.';
  }

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationsPermissionRequired => 'Você precisa permitir notificações nas configurações do sistema.';

  @override
  String get notificationsPermissionDescription => 'Para receber atualizações sobre disponibilidade de filmes e novas temporadas, ative as notificações.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get settings => 'Configurações';

  @override
  String get errorMessageGeneric => 'Ocorreu um erro. Tente novamente mais tarde.';

  @override
  String get youtubeSearch => 'Pesquisar no YouTube';

  @override
  String get notificationsHistory => 'Últimas notificações';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

  @override
  String get notifyCompleteSeasonSubtitle => 'Notifica apenas quando a temporada inteira estiver disponível.';

  @override
  String get episodes => 'Episódios';

  @override
  String get selectSeason => 'Ver temporadas';

  @override
  String seasonLabel(Object count) {
    return 'Temporada $count';
  }

  @override
  String get notifyTitle => 'Notificar novas temporadas';

  @override
  String get notifyMessage => 'Deseja ser notificado quando uma nova temporada for lançada?';

  @override
  String get no => 'Não';

  @override
  String get none => 'Nenhum';

  @override
  String get results => 'Resultados';

  @override
  String inRoleContext(Object context) {
    return ' em $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episódio $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get showEditContent => 'Mostrar botão de edição';

  @override
  String get translations => 'Traduções';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get close => 'Fechar';

  @override
  String get autoTranslation => 'Tradução automática';

  @override
  String get originalText => 'Texto original';

  @override
  String get addToHomeScreen => 'Adicionar à tela inicial';

  @override
  String get shortcutAdded => 'Atalho adicionado';

  @override
  String get shortcutFailed => 'Falha ao adicionar atalho';

  @override
  String get rate => 'Avaliar';

  @override
  String get watchOn => 'Assistir em';

  @override
  String get status => 'Status';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Inteligência Artificial';

  @override
  String get aiSettingsSubtitle => 'Busca inteligente e recursos de IA';

  @override
  String get aiSettingsDescription => 'A IA permite encontrar filmes e séries através de descrições naturais. Obtenha uma chave de API gratuita no OpenRouter.';

  @override
  String get aiGetApiKeyButton => 'Obter chave no OpenRouter';

  @override
  String get aiApiKeyLabel => 'Chave de API OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Salvar chave';

  @override
  String get aiDeleteKeyButton => 'Excluir';

  @override
  String get aiKeySaved => 'Chave de API salva com sucesso';

  @override
  String get aiKeyCleared => 'Chave de API excluída';

  @override
  String get aiStatusConfigured => 'Chave de API configurada';

  @override
  String get aiStatusNotConfigured => 'Chave de API não configurada';

  @override
  String get delete => 'Excluir';

  @override
  String get aiDeleteConfirmTitle => 'Excluir chave de API';

  @override
  String get aiDeleteConfirmMessage => 'Tem certeza de que deseja excluir a chave de API? O OpenRouter não permite visualizá-la novamente após a criação.';

  @override
  String get searchTimeout => 'A busca demorou muito para responder. Tente novamente.';

  @override
  String get aiSearchTimeout => 'A busca com IA expirou. Tente uma descrição mais curta.';

  @override
  String get aiSearchError => 'Ocorreu um erro durante a busca com IA.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Limite da API atingido. Aguarde $seconds segundos antes de tentar novamente.';
  }

  @override
  String get aiRateLimitGeneric => 'Limite da API atingido. Aguarde um momento.';

  @override
  String get signInWithGoogle => 'Entrar com o Google';

  @override
  String get googleSignInButton => 'Login com Google';

  @override
  String get alreadyUsingMovieScout => 'Já usa o MovieScout?';

  @override
  String get importTmdbData => 'Importe seus dados do TMDb.';

  @override
  String get tmdbAccount => 'Conta do TMDb';

  @override
  String get tmdbImport => 'Importação TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importação TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importe seus dados do TMDb';

  @override
  String get tmdbImportScreenBody => 'Você pode importar sua watchlist e avaliações da sua conta do TMDb. Faça login no TMDb para continuar.';

  @override
  String get tmdbImportStartButton => 'Iniciar importação';

  @override
  String get tmdbImportSuccess => 'Dados importados com sucesso!';

  @override
  String get tmdbImportDownloading => 'Baixando dados do TMDb...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Baixando watchlist...';

  @override
  String get tmdbImportDownloadingRateslist => 'Baixando avaliações...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Baixando episódios avaliados...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count títulos na watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count títulos avaliados';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episódios avaliados';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronizar com a conta';

  @override
  String get tmdbImportUploading => 'Enviando para sua conta...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count itens sincronizados com sua conta';
  }

  @override
  String get tmdbImportError => 'Erro ao importar dados';

  @override
  String get tmdbImportLoginRequired => 'Faça login no TMDb para iniciar a importação.';

  @override
  String get tmdbImportConsentText => 'A importação adicionará com segurança suas listas e notas do TMDb à sua conta do MovieScout.';

  @override
  String get loginConsentText => 'Ao entrar, você concorda em armazenar seus dados nos servidores do MovieScout conforme nossos ';

  @override
  String get termsOfService => 'termos de serviço';

  @override
  String get andThe => ' e a ';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountConfirmTitle => 'Excluir conta';

  @override
  String get deleteAccountConfirmMessage => 'Tem certeza de que deseja excluir sua conta? Esta ação é irreversível.';

  @override
  String get deleteAccountSuccess => 'Sua conta foi excluída com sucesso';

  @override
  String get deleteAccountError => 'Erro ao excluir conta';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt(): super('pt_PT');

  @override
  String get notificationDownloadingTitle => 'Baixando detalhes do título';

  @override
  String notificationFetchingData(int progress, int total) {
    return 'Obtendo dados dos títulos ($progress/$total)...';
  }

  @override
  String get notificationUpdatingProviders => 'Atualizando plataformas';

  @override
  String notificationCheckingAvailability(int progress, int total) {
    return 'Verificando disponibilidade ($progress/$total)...';
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
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get messageEmptyList => 'Nenhum filme selecionado ainda.';

  @override
  String get messageEmptySearch => 'Você pode pesquisar usando a lupa na barra inferior.';

  @override
  String get messageEmptyOptions => 'Você também pode';

  @override
  String get messageEmptyLogin => 'Entrar no MovieScout';

  @override
  String get search => 'Pesquisar um título';

  @override
  String get searchAiHint => 'Descreva o filme ou série que você está procurando...';

  @override
  String get searchAiTooltip => 'Busca Inteligente (IA)';

  @override
  String get searchTitle => 'Pesquisar';

  @override
  String get searchPerson => 'Pesquisar por alguém';

  @override
  String get searchPlaceholder => 'Pesquisar filmes ou séries...';

  @override
  String get gallery => 'Galeria';

  @override
  String get searchProvider => 'Pesquisar uma plataforma';

  @override
  String get trailer => 'Trailer';

  @override
  String get includeGenres => 'Incluir';

  @override
  String get excludeGenres => 'Excluir';

  @override
  String get pressBackAgainToExit => 'Pressione voltar novamente para sair';

  @override
  String get back => 'Voltar';

  @override
  String get username => 'Nome de utilizador';

  @override
  String get password => 'Senha';

  @override
  String get anonymousUser => 'Utilizador anónimo';

  @override
  String get loginTitle => 'Iniciar sessão';

  @override
  String get loginDescription => 'Inicie sessão na sua conta TMDB';

  @override
  String get login => 'Iniciar sessão';

  @override
  String get logout => 'Terminar sessão';

  @override
  String get loginSuccess => 'Sessão iniciada com sucesso.';

  @override
  String get loginFailed => 'Nome de usuário ou senha incorretos.';

  @override
  String get logoutSuccess => 'Sessão terminada com sucesso.';

  @override
  String get loginToTmdb => 'Iniciar sessão no TMDb';

  @override
  String get completeLoginToTmdb => 'Concluir processo de início de sessão';

  @override
  String get signupToTmdb => 'Registar no TMDb';

  @override
  String get signInToWatchlist => 'É necessário ter sessão iniciada para adicionar títulos.';

  @override
  String get tvShow => 'Série';

  @override
  String get movie => 'Filme';

  @override
  String get select => 'Selecionar';

  @override
  String get imdbImport => 'Importação IMDb';

  @override
  String get imdbImportHint => 'Selecione um arquivo CSV exportado do IMDb';

  @override
  String get imdbImportWatchlist => 'Importar Watchlist';

  @override
  String get imdbImportRateslist => 'Importar avaliações';

  @override
  String get imdbImportCount => 'Títulos importados com sucesso';

  @override
  String get imdbResetWatchlist => 'REDEFINIR WATCHLIST';

  @override
  String get imdbResetRateslist => 'REDEFINIR AVALIAÇÕES';

  @override
  String get imdbConfirmationTitle => 'ATENÇÃO';

  @override
  String get imdbResetWatchlistConfirmation => 'Deseja realmente redefinir a Watchlist?';

  @override
  String get imdbResetRateslistConfirmation => 'Deseja realmente redefinir as avaliações?';

  @override
  String get resetWatchlistCount => 'Títulos na Watchlist: ';

  @override
  String get resetRateslistCount => 'Títulos avaliados: ';

  @override
  String get missingDescription => 'Sem descrição';

  @override
  String get flatrateProviders => 'Subscrição';

  @override
  String get rentProviders => 'Alugar';

  @override
  String get buyProviders => 'Comprar';

  @override
  String get allTypes => 'Títulos';

  @override
  String get movies => 'Filmes';

  @override
  String get tvshows => 'Séries';

  @override
  String get miniseries => 'Minisséries';

  @override
  String get collection => 'Coleção';

  @override
  String get seeCollection => 'Ver coleção';

  @override
  String get sortAlphabetically => 'Alfabética';

  @override
  String get sortRating => 'Avaliação';

  @override
  String get sortUserRating => 'Minha avaliação';

  @override
  String get sortReleaseDate => 'Data de lançamento';

  @override
  String get sortRuntime => 'Duração';

  @override
  String get sortDateRated => 'Data da avaliação';

  @override
  String get sortRelevance => 'Relevância';

  @override
  String get sortAddedOrder => 'Data de adição';

  @override
  String get genres => 'Gêneros';

  @override
  String get titles => 'Títulos';

  @override
  String get rate_date => 'Data da avaliação';

  @override
  String get your_rate => 'Sua avaliação';

  @override
  String get reset_rate => 'Limpar avaliação';

  @override
  String get emptyRates => 'Você ainda não avaliou nenhum título.';

  @override
  String get seen => 'Visto';

  @override
  String get markAsSeen => 'Marcar como visto';

  @override
  String get ratedOnly => 'Avaliados';

  @override
  String get seenOnly => 'Vistos';

  @override
  String get followingOnly => 'Seguindo';

  @override
  String get pendingOnly => 'Pendentes';

  @override
  String get emptyList => 'Nada aqui.';

  @override
  String get watchlistTitle => 'Watchlist';

  @override
  String get rateslistTitle => 'Avaliados';

  @override
  String get yes => 'Sim';

  @override
  String get cancel => 'Cancelar';

  @override
  String get originaTitle => 'Título original';

  @override
  String get originalLanguage => 'Idioma original';

  @override
  String get originCountry => 'País';

  @override
  String get schemeSelectTitle => 'Selecionar cor';

  @override
  String get defaultScheme => 'Padrão';

  @override
  String get blackScheme => 'Preto';

  @override
  String get blueScheme => 'Azul';

  @override
  String get redScheme => 'Vermelho';

  @override
  String get about => 'Sobre...';

  @override
  String get aboutDescription => 'O MovieScout é seu rastreador de filmes e séries desenvolvido com TMDb, OMDb & JustWatch.';

  @override
  String get aboutGithub => 'Visite o projeto no ';

  @override
  String get apiDisclaimer => 'Este produto usa a API do TMDb, mas não é endossado ou certificado pelo TMDb.';

  @override
  String get privacyDisclaimerPrefix => 'Leia a ';

  @override
  String get privacyDisclaimer => 'política de privacidade';

  @override
  String get recommended => 'Recomendados';

  @override
  String get providersTitle => 'Plataformas de streaming';

  @override
  String get providers => 'Plataformas';

  @override
  String get filterByProviders => 'Apenas disponíveis';

  @override
  String get noProvidersAvailable => 'Nenhuma plataforma disponível';

  @override
  String get discoverlistTitle => 'Descobrir';

  @override
  String get notReleasedYet => 'Ainda não lançado';

  @override
  String get unknownDuration => 'Duração não informada.';

  @override
  String get cast => 'Elenco';

  @override
  String get crew => 'Equipa técnica';

  @override
  String get seeThemAll => 'Ver todos';

  @override
  String get ratedCredits => 'Créditos avaliados';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get deathDate => 'Data de falecimento';

  @override
  String get placeOfBirth => 'Local de nascimento';

  @override
  String get years => 'Anos';

  @override
  String get job => 'Cargo';

  @override
  String get department => 'Departamento';

  @override
  String get watchingNow => 'A ver agora';

  @override
  String get pinLimitReached => 'Você atingiu o limite de 5 títulos fixados.';

  @override
  String get pin => 'Fixar';

  @override
  String get unpin => 'Desafixar';

  @override
  String get notificationTitle => 'Já disponível!';

  @override
  String notificationBody(Object title, Object provider) {
    return '$title já está disponível no $provider.';
  }

  @override
  String get notificationNewSeasonTitle => 'Nova temporada!';

  @override
  String notificationNewSeasonBody(Object title, Object provider) {
    return 'Nova temporada de $title disponível no $provider.';
  }

  @override
  String get selectRegion => 'Selecionar região';

  @override
  String get searchRegion => 'Pesquisar região';

  @override
  String get regionAuto => 'Detecção automática (IP)';

  @override
  String get shareLink => 'Partilhar';

  @override
  String get director => 'Diretor';

  @override
  String get creator => 'Criador';

  @override
  String get writer => 'Roteirista';

  @override
  String seasonsCount(Object count) {
    return '$count temps.';
  }

  @override
  String get notifications => 'Notificações';

  @override
  String get notificationsPermissionRequired => 'Deve permitir as notificações nas definições do sistema.';

  @override
  String get notificationsPermissionDescription => 'Para receber atualizações sobre disponibilidade de filmes e novas temporadas, ative as notificações nas definições.';

  @override
  String get openSettings => 'Abrir definições';

  @override
  String get settings => 'Definições';

  @override
  String get errorMessageGeneric => 'Ocorreu um erro. Tente novamente mais tarde.';

  @override
  String get youtubeSearch => 'Pesquisar no YouTube';

  @override
  String get notificationsHistory => 'Últimas notificações';

  @override
  String get notifyCompleteSeason => 'Notificar temporada completa';

  @override
  String get notifyCompleteSeasonSubtitle => 'Notifica apenas quando a temporada inteira estiver disponível.';

  @override
  String get episodes => 'Episódios';

  @override
  String get selectSeason => 'Ver temporadas';

  @override
  String seasonLabel(Object count) {
    return 'Temporada $count';
  }

  @override
  String get notifyTitle => 'Notificar novas temporadas';

  @override
  String get notifyMessage => 'Deseja ser notificado quando uma nova temporada for lançada?';

  @override
  String get no => 'Não';

  @override
  String get none => 'Nenhum';

  @override
  String get results => 'Resultados';

  @override
  String inRoleContext(Object context) {
    return ' em $context';
  }

  @override
  String episodeLabel(Object count) {
    return 'Episódio $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get showEditContent => 'Mostrar botão de edição';

  @override
  String get translations => 'Traduções';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get close => 'Fechar';

  @override
  String get autoTranslation => 'Tradução automática';

  @override
  String get originalText => 'Texto original';

  @override
  String get addToHomeScreen => 'Adicionar ao ecrã principal';

  @override
  String get shortcutAdded => 'Atalho adicionado';

  @override
  String get shortcutFailed => 'Falha ao adicionar atalho';

  @override
  String get rate => 'Avaliar';

  @override
  String get watchOn => 'Ver em';

  @override
  String get status => 'Status';

  @override
  String get enableAiTranslation => 'IA';

  @override
  String get aiSettingsTitle => 'Inteligência Artificial';

  @override
  String get aiSettingsSubtitle => 'Pesquisa inteligente e funcionalidades de IA';

  @override
  String get aiSettingsDescription => 'A IA permite encontrar filmes e séries através de descrições em linguagem natural. Obtenha uma chave gratuita no OpenRouter.';

  @override
  String get aiGetApiKeyButton => 'Obter chave no OpenRouter';

  @override
  String get aiApiKeyLabel => 'Chave de API OpenRouter';

  @override
  String get aiApiKeyHint => 'sk-or-v1-...';

  @override
  String get aiSaveKeyButton => 'Salvar chave';

  @override
  String get aiDeleteKeyButton => 'Eliminar';

  @override
  String get aiKeySaved => 'Chave de API salva com sucesso';

  @override
  String get aiKeyCleared => 'Chave de API eliminada';

  @override
  String get aiStatusConfigured => 'Chave de API configurada';

  @override
  String get aiStatusNotConfigured => 'Chave de API não configurada';

  @override
  String get delete => 'Eliminar';

  @override
  String get aiDeleteConfirmTitle => 'Eliminar chave de API';

  @override
  String get aiDeleteConfirmMessage => 'Tem a certeza de que pretende eliminar a chave de API? O OpenRouter não permite visualizá-la novamente após a criação.';

  @override
  String get searchTimeout => 'A busca demorou muito para responder. Tente novamente.';

  @override
  String get aiSearchTimeout => 'A busca com IA expirou. Tente uma descrição mais curta.';

  @override
  String get aiSearchError => 'Ocorreu um erro durante a busca com IA.';

  @override
  String aiRateLimitWithSeconds(int seconds) {
    return 'Limite da API atingido. Aguarde $seconds segundos antes de tentar novamente.';
  }

  @override
  String get aiRateLimitGeneric => 'Limite da API atingido. Aguarde um momento.';

  @override
  String get signInWithGoogle => 'Iniciar sessão com o Google';

  @override
  String get googleSignInButton => 'Sessão com Google';

  @override
  String get alreadyUsingMovieScout => 'Já utiliza o MovieScout?';

  @override
  String get importTmdbData => 'Importe seus dados do TMDb.';

  @override
  String get tmdbAccount => 'Conta do TMDb';

  @override
  String get tmdbImport => 'Importação TMDb';

  @override
  String get tmdbImportScreenTitle => 'Importação TMDb';

  @override
  String get tmdbImportScreenHeader => 'Importe seus dados do TMDb';

  @override
  String get tmdbImportScreenBody => 'Pode importar a sua watchlist e avaliações da sua conta TMDb. Inicie sessão no TMDb para continuar.';

  @override
  String get tmdbImportStartButton => 'Iniciar importação';

  @override
  String get tmdbImportSuccess => 'Dados importados com sucesso!';

  @override
  String get tmdbImportDownloading => 'Baixando dados do TMDb...';

  @override
  String get tmdbImportDownloadingWatchlist => 'Baixando watchlist...';

  @override
  String get tmdbImportDownloadingRateslist => 'Baixando avaliações...';

  @override
  String get tmdbImportDownloadingEpisodes => 'Baixando episódios avaliados...';

  @override
  String tmdbImportWatchlistCount(Object count) {
    return '$count títulos na watchlist';
  }

  @override
  String tmdbImportRateslistCount(Object count) {
    return '$count títulos avaliados';
  }

  @override
  String tmdbImportEpisodesCount(Object count) {
    return '$count episódios avaliados';
  }

  @override
  String get tmdbImportUploadTitle => 'Sincronizar com a conta';

  @override
  String get tmdbImportUploading => 'Enviando para sua conta...';

  @override
  String tmdbImportUploadedCount(Object count) {
    return '$count itens sincronizados com sua conta';
  }

  @override
  String get tmdbImportError => 'Erro ao importar dados';

  @override
  String get tmdbImportLoginRequired => 'Inicie sessão no TMDb para iniciar a importação.';

  @override
  String get tmdbImportConsentText => 'A importação adicionará com segurança suas listas e notas do TMDb à sua conta do MovieScout.';

  @override
  String get loginConsentText => 'Ao iniciar sessão, concorda em guardar os seus dados nos servidores do MovieScout de acordo com os nossos ';

  @override
  String get termsOfService => 'termos de serviço';

  @override
  String get andThe => ' e a ';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar conta';

  @override
  String get deleteAccountConfirmMessage => 'Tem a certeza de que pretende eliminar a sua conta? Esta ação é irreversível.';

  @override
  String get deleteAccountSuccess => 'A sua conta foi eliminada com sucesso';

  @override
  String get deleteAccountError => 'Erro ao eliminar a conta';
}
