enum TranslationContentType {
  movie('movie'),
  tvSeries('tv_series'),
  tvSeason('tv_season'),
  tvEpisode('tv_episode'),
  collection('collection'),
  person('person');

  final String jsonKey;

  const TranslationContentType(this.jsonKey);
}
