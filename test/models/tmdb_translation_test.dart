import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/utils/app_constants.dart';

void main() {
  group('TmdbTranslation', () {
    test('instantiates with all fields via constructor', () {
      final translation = TmdbTranslation(
        iso3166_1: 'ES',
        iso639_1: 'ca',
        name: 'Català',
        englishName: 'Catalan',
        data: {
          AppConstants.title: 'Títol en català',
          AppConstants.overview: 'Sinopsi en català',
        },
      );

      expect(translation.iso3166_1, 'ES');
      expect(translation.iso639_1, 'ca');
      expect(translation.name, 'Català');
      expect(translation.englishName, 'Catalan');
      expect(translation.translatedTitle, 'Títol en català');
      expect(translation.description, 'Sinopsi en català');
    });

    test('fromJson parses complete json data', () {
      final json = {
        AppConstants.iso3166_1: 'FR',
        AppConstants.iso639_1: 'fr',
        AppConstants.name: 'Français',
        AppConstants.englishName: 'French',
        AppConstants.data: {
          AppConstants.title: 'Titre Français',
          AppConstants.overview: 'Description en français',
        },
      };

      final translation = TmdbTranslation.fromJson(json);
      expect(translation.iso3166_1, 'FR');
      expect(translation.iso639_1, 'fr');
      expect(translation.name, 'Français');
      expect(translation.englishName, 'French');
      expect(translation.translatedTitle, 'Titre Français');
      expect(translation.description, 'Description en français');
    });

    test('fromJson defaults missing fields gracefully', () {
      final translation = TmdbTranslation.fromJson({});
      expect(translation.iso3166_1, '');
      expect(translation.iso639_1, '');
      expect(translation.name, '');
      expect(translation.englishName, '');
      expect(translation.data, isEmpty);
      expect(translation.translatedTitle, '');
      expect(translation.description, '');
    });

    test('translatedTitle falls back to name when title is missing', () {
      final translation = TmdbTranslation.fromJson({
        AppConstants.data: {
          AppConstants.name: 'Nom en català',
        },
      });

      expect(translation.translatedTitle, 'Nom en català');
    });

    test('description uses biography when available, otherwise overview', () {
      final personTranslation = TmdbTranslation.fromJson({
        AppConstants.data: {
          AppConstants.biography: 'Biografia de la persona',
          AppConstants.overview: 'Overview fallback',
        },
      });
      expect(personTranslation.description, 'Biografia de la persona');

      final titleTranslation = TmdbTranslation.fromJson({
        AppConstants.data: {
          AppConstants.overview: 'Sinopsi de la pel·lícula',
        },
      });
      expect(titleTranslation.description, 'Sinopsi de la pel·lícula');
    });
  });
}
