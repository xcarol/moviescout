import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_genre.dart';

void main() {
  group('TmdbGenre', () {
    test('extracts id and name from map with entry', () {
      const genre = TmdbGenre(genre: {28: 'Action'});
      expect(genre.id, 28);
      expect(genre.name, 'Action');
    });

    test('handles multiple entries by picking first', () {
      const genre = TmdbGenre(genre: {12: 'Adventure', 16: 'Animation'});
      expect(genre.id, 12);
      expect(genre.name, 'Adventure');
    });

    test('handles empty map by throwing StateError when calling first', () {
      const genre = TmdbGenre(genre: {});
      expect(() => genre.id, throwsStateError);
      expect(() => genre.name, throwsStateError);
    });
  });
}
