// ignore_for_file: constant_identifier_names, unused_element

const _logo_path = 'logo_path';
const _provider_id = 'provider_id';
const _provider_name = 'provider_name';
const _display_priority = 'display_priority';

class TmdbProvider {
  final Map _provider;

  const TmdbProvider({required Map<dynamic, dynamic> provider})
      : _provider = provider;

  String get name {
    if (_provider[_provider_name] != null) {
      return _provider[_provider_name].toString();
    }
    return '';
  }
  
  String get logoPath {
    if (_provider[_logo_path] != null) {
      return (_provider[_logo_path] as String).isNotEmpty
          ? 'https://image.tmdb.org/t/p/w92${_provider[_logo_path]}'
          : '';
    }
    return '';
  }
}
