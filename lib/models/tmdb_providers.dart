import 'package:moviescout/models/tmdb_provider.dart';

const _flatrate = 'flatrate';
const _rent = 'rent';
const _buy = 'buy';

class TmdbProviders {
  final Map _providers;

  const TmdbProviders({required Map<dynamic, dynamic> providers})
      : _providers = providers;

  List<TmdbProvider> _providerList(type) {
    List<TmdbProvider> providerList = List.empty(growable: true);

    if (_providers[type] == null) {
      return providerList;
    }

    for (var provider in _providers[type]) {
      providerList.add(TmdbProvider(provider: provider));
    }

    return providerList;
  }

  bool any(bool Function(TmdbProvider) test) {
    for (var provider in _providers[_flatrate] ?? []) {
      if (test(TmdbProvider(provider: provider))) return true;
    }

    return false;
  }

  bool get isEmpty {
    return flatrate.isEmpty && rent.isEmpty && buy.isEmpty;
  }

  List<TmdbProvider> get flatrate {
    return _providerList(_flatrate);
  }

  List<TmdbProvider> get rent {
    return _providerList(_rent);
  }

  List<TmdbProvider> get buy {
    return _providerList(_buy);
  }
}
