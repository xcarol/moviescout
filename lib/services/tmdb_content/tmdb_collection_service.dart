import 'package:moviescout/services/core/tmdb_base_service.dart';

class TmdbCollectionService extends TmdbBaseService {
  Future<dynamic> getCollectionDetails(int id, String locale) async {
    return get(
      '/collection/{ID}?language={LOCALE}'
          .replaceFirst('{ID}', id.toString())
          .replaceFirst('{LOCALE}', locale),
    );
  }
}
