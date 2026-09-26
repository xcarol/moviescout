import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/user_list_entry.dart';

void main() {
  group('UserListEntry', () {
    test('instantiates with all fields and allows updating them', () {
      final entry = UserListEntry(
        listName: 'Favorites',
        tmdbId: 550,
        mediaType: 'movie',
        addedOrder: 1,
      );

      expect(entry.listName, 'Favorites');
      expect(entry.tmdbId, 550);
      expect(entry.mediaType, 'movie');
      expect(entry.addedOrder, 1);

      entry.listName = 'Watchlist';
      entry.tmdbId = 600;
      entry.mediaType = 'tv';
      entry.addedOrder = 2;

      expect(entry.listName, 'Watchlist');
      expect(entry.tmdbId, 600);
      expect(entry.mediaType, 'tv');
      expect(entry.addedOrder, 2);
    });
  });
}
