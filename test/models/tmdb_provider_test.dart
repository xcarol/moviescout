import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/utils/url_constants.dart';

void main() {
  group('TmdbProvider', () {
    test('constants have correct keys', () {
      expect(TmdbProvider.logoPathName, 'logo_path');
      expect(TmdbProvider.providerId, 'provider_id');
      expect(TmdbProvider.providerName, 'provider_name');
      expect(TmdbProvider.providerEnabled, 'enabled');
    });

    test('extracts properties when all fields are provided', () {
      final provider = TmdbProvider(provider: {
        TmdbProvider.providerId: 8,
        TmdbProvider.providerName: 'Netflix',
        TmdbProvider.logoPathName: '/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg',
      });

      expect(provider.id, 8);
      expect(provider.name, 'Netflix');
      expect(
        provider.logoPath,
        UrlConstants.tmdbImageW45Template
            .replaceFirst('{PATH}', '/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg'),
      );
    });

    test('returns defaults when fields are missing or empty', () {
      const provider = TmdbProvider(provider: {});

      expect(provider.id, 0);
      expect(provider.name, '');
      expect(provider.logoPath, '');
    });

    test('logoPath returns empty string when logoPathName is empty string', () {
      final provider = TmdbProvider(provider: {
        TmdbProvider.logoPathName: '',
      });

      expect(provider.logoPath, '');
    });
  });
}
