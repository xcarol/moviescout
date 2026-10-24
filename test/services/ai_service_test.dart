import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/api/ai_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

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

    test('translate throws when key is missing', () async {
      final service = AiService();
      await service.saveApiKey('');
      expect(
        () => service.translate(
          'Hello',
          sourceLanguage: 'en',
          targetLanguage: 'es',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AiService cleanTranslation', () {
    final service = AiService();

    test('strips safety prefixes with newlines and quotes', () {
      expect(
        service.cleanTranslation('User Safety: safe.\n"Hola Mundo"'),
        'Hola Mundo',
      );
      expect(
        service.cleanTranslation('Safety: safe\nBonjour'),
        'Bonjour',
      );
      expect(
        service.cleanTranslation('user safety: safe'),
        '',
      );
    });

    test('strips surrounding quotes without prefixes', () {
      expect(service.cleanTranslation('"Just a quoted string"'), 'Just a quoted string');
      expect(service.cleanTranslation('Unquoted text'), 'Unquoted text');
    });
  });

  group('AiService handleErrorResponse', () {
    final service = AiService();

    test('throws AiRateLimitException on 429 status', () {
      final response = http.Response('Too many requests. Please retry in 15s', 429);
      expect(
        () => service.handleErrorResponse(response),
        throwsA(isA<AiRateLimitException>().having(
          (e) => e.retrySeconds,
          'retrySeconds',
          15,
        )),
      );
    });

    test('throws AiRateLimitException on rate-limited or RESOURCE_EXHAUSTED body', () {
      final rateLimitedResponse = http.Response('Server error: rate-limited', 500);
      expect(
        () => service.handleErrorResponse(rateLimitedResponse),
        throwsA(isA<AiRateLimitException>()),
      );

      final exhaustedResponse = http.Response('RESOURCE_EXHAUSTED', 400);
      expect(
        () => service.handleErrorResponse(exhaustedResponse),
        throwsA(isA<AiRateLimitException>()),
      );
    });

    test('throws generic Exception on non-rate-limited error status', () {
      final response = http.Response('Internal Server Error', 500);
      expect(
        () => service.handleErrorResponse(response),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AiService advanced parsing branches', () {
    final service = AiService();

    test('parses JSON with suggestions, results, titles, movies, or items keys', () {
      final bodyWithSuggestions = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'suggestions': [
                  {'title': 'Dune', 'year': 2021, 'media_type': 'movie'}
                ]
              })
            }
          }
        ]
      });
      expect(service.parseSuggestions(bodyWithSuggestions).first.title, 'Dune');

      final bodyWithResults = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'results': [
                  {'title': 'Blade Runner', 'year': 1982, 'media_type': 'movie'}
                ]
              })
            }
          }
        ]
      });
      expect(service.parseSuggestions(bodyWithResults).first.title, 'Blade Runner');

      final bodyWithTitles = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'titles': [
                  {'title': 'Interstellar', 'year': 2014, 'media_type': 'movie'}
                ]
              })
            }
          }
        ]
      });
      expect(service.parseSuggestions(bodyWithTitles).first.title, 'Interstellar');
    });

    test('parses markdown code block without json identifier and single object block', () {
      final body = jsonEncode({
        'choices': [
          {
            'message': {
              'content': '```\n[{"title": "Tenet", "year": 2020, "media_type": "movie"}]\n```'
            }
          }
        ]
      });
      expect(service.parseSuggestions(body).first.title, 'Tenet');

      final singleObjectBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content': '{"data": [{"title": "Memento", "year": 2000, "media_type": "movie"}]}'
            }
          }
        ]
      });
      expect(service.parseSuggestions(singleObjectBody).first.title, 'Memento');
    });

    test('parses text suggestions with media type and conversational preamble', () {
      final body = jsonEncode({
        'choices': [
          {
            'message': {
              'content': '''Sure, here are some recommendations:
Certainly! Check these out:
Note: great sci-fi
1. Westworld tv
2. "Fight Club" (1999) - movie
3. Inception (2010)
'''
            }
          }
        ]
      });
      final results = service.parseSuggestions(body);
      expect(results.length, 3);
      expect(results[0].title, 'Westworld');
      expect(results[0].mediaType, 'tv');
      expect(results[1].title, 'Fight Club');
      expect(results[1].year, 1999);
      expect(results[2].title, 'Inception');
      expect(results[2].year, 2010);
    });

    test('handles empty choices or null message gracefully', () {
      expect(service.parseSuggestions(jsonEncode({'choices': []})), isEmpty);
      expect(
        service.parseSuggestions(jsonEncode({
          'choices': [
            {'message': null}
          ]
        })),
        isEmpty,
      );
      expect(service.parseSuggestions('completely malformed json {{{'), isEmpty);
    });
  });
}
