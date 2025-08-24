class TmdbProvider {
  static const logoPathName = 'logo_path';
  static const providerId = 'provider_id';
  static const providerName = 'provider_name';
  static const providerEnabled = 'enabled';

  final Map _provider;

  const TmdbProvider({required Map<dynamic, dynamic> provider})
      : _provider = provider;

  String get name {
    if (_provider[providerName] != null) {
      return _provider[providerName].toString();
    }
    return '';
  }

  int get id {
    if (_provider[providerId] != null) {
      return _provider[providerId] as int;
    }
    return 0;
  }

  String get logoPath {
    if (_provider[logoPathName] != null) {
      return (_provider[logoPathName] as String).isNotEmpty
          ? 'https://image.tmdb.org/t/p/w92${_provider[logoPathName]}'
          : '';
    }
    return '';
  }
}
