class UrlConstants {
  // Base URLs
  static const String tmdbApiV4Url = 'https://api.themoviedb.org/4/';
  static const String tmdbApiV3Url = 'https://api.themoviedb.org/3/';
  static const String tmdbWebUrl = 'https://www.themoviedb.org';
  static const String moviescoutWebUrl = 'https://moviescout-tmdb.vercel.app';
  static const String tmdbImageOriginalUrl =
      'https://image.tmdb.org/t/p/original';
  static const String tmdbImageW45Url = 'https://image.tmdb.org/t/p/w45';
  static const String tmdbImageW185Url = 'https://image.tmdb.org/t/p/w185';
  static const String tmdbImageW500Url = 'https://image.tmdb.org/t/p/w500';

  static const String ipApiUrl = 'https://ipapi.co/json/';
  static const String omdbApiUrl = 'https://www.omdbapi.com/';
  static const String githubRepoUrl = 'https://github.com/xcarol/moviescout';
  static const String gravatarUrl = 'https://www.gravatar.com/avatar/';
  static const String imdbTitleUrl = 'https://www.imdb.com/title/';
  static const String imdbNameUrl = 'https://www.imdb.com/name/';

  // Web Templates
  static const String tmdbSignupWebTemplate = '$tmdbWebUrl/account/signup';
  static const String tmdbMovieWebTemplate = '$tmdbWebUrl/movie/{ID}';
  static const String tmdbTvWebTemplate = '$tmdbWebUrl/tv/{ID}';
  static const String tmdbPersonWebTemplate = '$tmdbWebUrl/person/{ID}';
  static const String tmdbTitleWebTemplate = '$tmdbWebUrl/{MEDIA_TYPE}/{ID}';
  
  static const String moviescoutMovieWebTemplate = '$moviescoutWebUrl/movie/{ID}';
  static const String moviescoutTvWebTemplate = '$moviescoutWebUrl/tv/{ID}';
  static const String moviescoutPersonWebTemplate = '$moviescoutWebUrl/person/{ID}';
  static const String moviescoutTitleWebTemplate = '$moviescoutWebUrl/{MEDIA_TYPE}/{ID}';
  static const String moviescoutTvSeasonWebTemplate = '$moviescoutWebUrl/tv/{ID}/season/{SEASON_NUMBER}';
  static const String tmdbTitleEditWebTemplate =
      '$tmdbWebUrl/{MEDIA_TYPE}/{ID}/edit';
  static const String tmdbPersonEditWebTemplate =
      '$tmdbWebUrl/person/{ID}/edit';
  static const String tmdbTvSeasonWebTemplate =
      '$tmdbWebUrl/tv/{ID}/season/{SEASON_NUMBER}';
  static const String tmdbTvSeasonEditWebTemplate =
      '$tmdbWebUrl/tv/{ID}/season/{SEASON_NUMBER}/edit';
  static const String tmdbTvEpisodeEditWebTemplate =
      '$tmdbWebUrl/tv/{ID}/season/{SEASON_NUMBER}/episode/{EPISODE_NUMBER}/edit';
  static const String tmdbAuthAccessWebTemplate =
      '$tmdbWebUrl/auth/access?request_token={REQUEST_TOKEN}';

  static const String tmdbImageOriginalTemplate = '$tmdbImageOriginalUrl{PATH}';
  static const String tmdbImageW45Template = '$tmdbImageW45Url{PATH}';
  static const String tmdbImageW185Template = '$tmdbImageW185Url{PATH}';
  static const String tmdbImageW500Template = '$tmdbImageW500Url{PATH}';

  static const String imdbTitleTemplate = '$imdbTitleUrl{ID}';
  static const String imdbNameTemplate = '$imdbNameUrl{ID}';
  static const String gravatarTemplate = '$gravatarUrl{HASH}?s={SIZE}';

  // Endpoints
  static const String tmdbDetailsEndpoint =
      '/{MEDIA_TYPE}/{ID}?append_to_response=external_ids,watch/providers,recommendations,images,videos,{CREDITS_TYPE}&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';
  static const String tmdbBriefEndpoint =
      '/{MEDIA_TYPE}/{ID}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';
  static const String tmdbProvidersEndpoint =
      '/{MEDIA_TYPE}/{ID}/watch/providers';
  static const String tmdbLightEndpoint =
      '/{MEDIA_TYPE}/{ID}?append_to_response=watch/providers&language={LOCALE}';

  static const String tmdbEpisodeDetailsEndpoint =
      '/tv/{ID}/season/{SEASON_NUMBER}/episode/{EPISODE_NUMBER}?append_to_response=images,videos,credits&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';
  static const String tmdbEpisodeBriefEndpoint =
      '/tv/{ID}/season/{SEASON_NUMBER}/episode/{EPISODE_NUMBER}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

  static const String tmdbSeasonDetailsEndpoint =
      '/tv/{ID}/season/{SEASON_NUMBER}?append_to_response=images,videos,credits&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';
  static const String tmdbSeasonBriefEndpoint =
      '/tv/{ID}/season/{SEASON_NUMBER}?append_to_response=images,videos&language={LOCALE}&include_image_language={LOCALE},null,en&include_video_language={LOCALE},null,en';

  static const String tmdbPersonDetailsEndpoint =
      '/person/{ID}?append_to_response=combined_credits&language={LOCALE}';

  static const String tmdbSearchMoviesEndpoint =
      'search/movie?query={QUERY}&page={PAGE}&language={LOCALE}';
  static const String tmdbSearchTvShowsEndpoint =
      'search/tv?query={QUERY}&page={PAGE}&language={LOCALE}';
  static const String tmdbSearchPersonsEndpoint =
      'search/person?query={QUERY}&page={PAGE}&language={LOCALE}';
  static const String tmdbFindByIdEndpoint =
      'find/{ID}?external_source=imdb_id&language={LOCALE}';

  static const String tmdbWatchlistMoviesEndpoint =
      'account/{ACCOUNT_ID}/watchlist/movies?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}&sort_by=created_at.desc';
  static const String tmdbWatchlistTvEndpoint =
      'account/{ACCOUNT_ID}/watchlist/tv?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}&sort_by=created_at.desc';
  static const String tmdbUpdateWatchlistEndpoint =
      'account/{ACCOUNT_ID}/watchlist?session_id={SESSION_ID}';

  static const String tmdbRateslistMoviesEndpoint =
      'account/{ACCOUNT_ID}/rated/movies?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}&sort_by=created_at.desc';
  static const String tmdbRateslistTvEndpoint =
      'account/{ACCOUNT_ID}/rated/tv?session_id={SESSION_ID}&page={PAGE}&language={LOCALE}&sort_by=created_at.desc';
  static const String tmdbRateMovieEndpoint =
      'movie/{ID}/rating?session_id={SESSION_ID}';
  static const String tmdbRateTvEndpoint =
      'tv/{ID}/rating?session_id={SESSION_ID}';

  static const String tmdbMovieGenresEndpoint =
      'genre/movie/list?language={LOCALE}';
  static const String tmdbTvGenresEndpoint = 'genre/tv/list?language={LOCALE}';

  static const String tmdbPopularMoviesEndpoint =
      'movie/popular?page={PAGE}&language={LOCALE}';
  static const String tmdbPopularTvEndpoint =
      'tv/popular?page={PAGE}&language={LOCALE}';

  static const String tmdbMovieProvidersEndpoint = 'movie/{ID}/watch/providers';
  static const String tmdbTvProvidersEndpoint = 'tv/{ID}/watch/providers';
}
