// ignore_for_file: constant_identifier_names, unused_element

const _id = 'id';
const _name = 'name';

class TmdbGenre {
  final Map _genre;
  const TmdbGenre({required Map<dynamic, dynamic> genre}) : _genre = genre;

  int get id {
    return _genre[_id] ?? -1;
  }

  String get name {
    return _genre[_name] ?? '';
  }
}
