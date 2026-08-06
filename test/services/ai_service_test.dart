import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/services/api/ai_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiTitleSuggestion', () {
    test('parses json correctly with integer year and movie type', () {
      final json = {
        'title': 'Inception',
        'year': 2010,
        'media_type': 'movie',
      };
      final suggestion = AiTitleSuggestion.fromJson(json);
      expect(suggestion.title, 'Inception');
      expect(suggestion.year, 2010);
      expect(suggestion.mediaType, 'movie');
    });

    test('parses json correctly with string year and tv type', () {
      final json = {
        'title': 'Breaking Bad',
        'year': '2008',
        'media_type': 'tv',
      };
      final suggestion = AiTitleSuggestion.fromJson(json);
      expect(suggestion.title, 'Breaking Bad');
      expect(suggestion.year, 2008);
      expect(suggestion.mediaType, 'tv');
    });

    test('handles missing or invalid fields gracefully', () {
      final json = <String, dynamic>{};
      final suggestion = AiTitleSuggestion.fromJson(json);
      expect(suggestion.title, '');
      expect(suggestion.year, isNull);
      expect(suggestion.mediaType, 'movie');
    });
  });

  group('AiRateLimitException and retry parsing', () {
    test('extracts retry seconds correctly from error message', () {
      const errorMsg =
          'You exceeded your current quota. Please retry in 33.609345573s.';
      final seconds = AiService.extractRetrySeconds(errorMsg);
      expect(seconds, 34);
    });

    test('instantiates with retry seconds and rawMessage', () {
      final ex = AiRateLimitException(
        retrySeconds: 34,
        rawMessage: 'Please retry in 33.6s',
      );
      expect(ex.retrySeconds, 34);
      expect(ex.rawMessage, 'Please retry in 33.6s');
      expect(
        ex.toString(),
        'AiRateLimitException(retrySeconds: 34, rawMessage: Please retry in 33.6s)',
      );
    });

    test('instantiates without retry seconds', () {
      final ex = AiRateLimitException(
        retrySeconds: null,
        rawMessage: 'Resource exhausted',
      );
      expect(ex.retrySeconds, isNull);
      expect(ex.rawMessage, 'Resource exhausted');
      expect(
        ex.toString(),
        'AiRateLimitException(retrySeconds: null, rawMessage: Resource exhausted)',
      );
    });
  });

  group('AiService response parsing and safety filtering', () {
    final service = AiService();

    test('parses clean JSON array', () {
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  '[{"title": "Arrival", "year": 2016, "media_type": "movie"}]'
            }
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results.length, 1);
      expect(results.first.title, 'Arrival');
      expect(results.first.year, 2016);
      expect(results.first.mediaType, 'movie');
    });

    test('parses JSON with User Safety header prefix', () {
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  'User Safety: safe\n\n[{"title": "Dune", "year": 2021, "media_type": "movie"}]'
            }
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results.length, 1);
      expect(results.first.title, 'Dune');
      expect(results.first.year, 2021);
    });

    test('handles User Safety without JSON by falling back to text lines', () {
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  'User Safety: safe\n\n1. "Interstellar" (2014) - movie\n2. Severance (2022) - tv'
            }
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results.length, 2);
      expect(results[0].title, 'Interstellar');
      expect(results[0].year, 2014);
      expect(results[0].mediaType, 'movie');
      expect(results[1].title, 'Severance');
      expect(results[1].year, 2022);
      expect(results[1].mediaType, 'tv');
    });

    test('handles only User Safety: safe without crashing or throwing', () {
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {'content': 'User Safety: safe'}
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results, isEmpty);
    });

    test('parses JSON wrapped in markdown code blocks', () {
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  '```json\n[{"title": "The Matrix", "year": 1999, "media_type": "movie"}]\n```'
            }
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results.length, 1);
      expect(results.first.title, 'The Matrix');
    });
  });

  group('AiService API key management', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService().init();
    });

    test('hasApiKey returns false when key is empty', () {
      final service = AiService();
      expect(service.hasApiKey, isFalse);
      expect(service.apiKey, isEmpty);
    });

    test('saveApiKey persists key to preferences', () async {
      final service = AiService();
      await service.saveApiKey('test-key-12345');
      expect(service.hasApiKey, isTrue);
      expect(service.apiKey, 'test-key-12345');
      expect(
        PreferencesService().prefs.getString(AppConstants.aiApiKey),
        'test-key-12345',
      );
    });

    test('suggestTitles throws when key is missing', () async {
      final service = AiService();
      await service.saveApiKey('');
      expect(
        () => service.suggestTitles('mystery movies'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
