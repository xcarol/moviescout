import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/user_list_entry.dart';

void main() {
  group('UserListEntry', () {
    test('instantiates with all fields and allows updating them', () {
      final initialDate = DateTime.utc(2026, 1, 1);
      final updatedDate = DateTime.utc(2026, 1, 2);

      final entry = UserListEntry(
        listName: 'Favorites',
        tmdbId: 550,
        mediaType: 'movie',
        createdAt: initialDate,
      );

      expect(entry.listName, 'Favorites');
      expect(entry.tmdbId, 550);
      expect(entry.mediaType, 'movie');
      expect(entry.createdAt, initialDate);

      entry.listName = 'Watchlist';
      entry.tmdbId = 600;
      entry.mediaType = 'tv';
      entry.createdAt = updatedDate;

      expect(entry.listName, 'Watchlist');
      expect(entry.tmdbId, 600);
      expect(entry.mediaType, 'tv');
      expect(entry.createdAt, updatedDate);
    });
  });
}
