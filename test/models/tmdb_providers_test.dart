import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_providers.dart';

void main() {
  group('TmdbProviders', () {
    test('extracts flatrate, rent, and buy provider lists', () {
      final providers = TmdbProviders(providers: {
        'flatrate': [
          {'provider_id': 8, 'provider_name': 'Netflix'},
          {'provider_id': 337, 'provider_name': 'Disney Plus'},
        ],
        'rent': [
          {'provider_id': 2, 'provider_name': 'Apple TV'},
        ],
        'buy': [
          {'provider_id': 3, 'provider_name': 'Google Play'},
        ],
      });

      expect(providers.isEmpty, isFalse);
      expect(providers.flatrate.length, 2);
      expect(providers.flatrate.first.id, 8);
      expect(providers.flatrate.first.name, 'Netflix');
      expect(providers.flatrate.last.id, 337);

      expect(providers.rent.length, 1);
      expect(providers.rent.first.id, 2);
      expect(providers.rent.first.name, 'Apple TV');

      expect(providers.buy.length, 1);
      expect(providers.buy.first.id, 3);
      expect(providers.buy.first.name, 'Google Play');
    });

    test('returns empty lists and isEmpty = true when providers map is empty', () {
      const providers = TmdbProviders(providers: {});

      expect(providers.isEmpty, isTrue);
      expect(providers.flatrate, isEmpty);
      expect(providers.rent, isEmpty);
      expect(providers.buy, isEmpty);
    });

    test('any searches flatrate providers correctly', () {
      final providers = TmdbProviders(providers: {
        'flatrate': [
          {'provider_id': 8, 'provider_name': 'Netflix'},
          {'provider_id': 337, 'provider_name': 'Disney Plus'},
        ],
      });

      expect(providers.any((p) => p.id == 8), isTrue);
      expect(providers.any((p) => p.name == 'Disney Plus'), isTrue);
      expect(providers.any((p) => p.id == 999), isFalse);
    });

    test('any returns false when flatrate is null or empty', () {
      const providers = TmdbProviders(providers: {});
      expect(providers.any((p) => true), isFalse);
    });
  });
}
