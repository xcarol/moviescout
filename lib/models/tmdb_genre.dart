// ignore_for_file: constant_identifier_names, unused_element

class TmdbGenre {
  final Map _genre;
  const TmdbGenre({required Map<int, String> genre}) : _genre = genre;

  int get id {
    return _genre.keys.first ?? -1;
  }

  String get name {
    return _genre.values.first ?? '';
  }
}
