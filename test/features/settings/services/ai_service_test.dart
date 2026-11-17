import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/features/settings/services/ai_key_cipher.dart';
import 'package:moviescout/features/settings/services/ai_provider.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/models/translation_context.dart';
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

  group('AiService response parsing (Google AI default provider)', () {
    final service = AiService();

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService().init();
      service.resetRemoteConfig();
    });

    test(
        'parses Interactions API outputs response with thought and text blocks',
        () {
      final responseBody = jsonEncode({
        'id': 'int_123',
        'outputs': [
          {
            'type': 'thought',
            'summary': [
              {'type': 'text', 'text': 'Internal reasoning'}
            ]
          },
          {
            'type': 'text',
            'text':
                '[{"title": "Arrival", "year": 2016, "media_type": "movie"}]'
          }
        ]
      });
      final results = service.parseSuggestions(responseBody);
      expect(results.length, 1);
      expect(results.first.title, 'Arrival');
      expect(results.first.year, 2016);
      expect(results.first.mediaType, 'movie');
    });

    test('parses clean Gemini JSON response (legacy candidates format)', () {
      final responseBody = jsonEncode({
        'candidates': [
          {
            'content': {
              'parts': [
                {
                  'text':
                      '[{"title": "Arrival", "year": 2016, "media_type": "movie"}]'
                }
              ]
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

    test('handles empty candidates or malformed JSON gracefully', () {
      expect(service.parseSuggestions(jsonEncode({'candidates': []})), isEmpty);
      expect(
          service.parseSuggestions('completely malformed json {{{'), isEmpty);
    });
  });

  group('AiService response parsing and safety filtering (OpenRouter provider)',
      () {
    final service = AiService();

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        AppConstants.aiProviderKey: AppConstants.aiProviderOpenRouter,
      });
      await PreferencesService().init();
    });

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

  group('AiService provider and API key management', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService().init();
      AiService().resetRemoteConfig();
    });

    test('defaults to GoogleAiProvider when no provider or keys are saved', () {
      final service = AiService();
      expect(service.currentProvider, isA<GoogleAiProvider>());
      expect(service.currentProvider.id, AppConstants.aiProviderGoogle);
      expect(service.hasApiKey, isFalse);
      expect(service.apiKey, isEmpty);
      expect(service.selectedModel, AppConstants.defaultAiGoogleModel);
    });

    test(
        'automatically falls back to OpenRouterProvider when legacy OpenRouter key exists and provider is not explicitly set',
        () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.aiOpenRouterApiKey: 'legacy-or-key',
      });
      await PreferencesService().init();

      final service = AiService();
      expect(service.currentProvider, isA<OpenRouterProvider>());
      expect(service.apiKey, 'legacy-or-key');
      expect(service.selectedModel, AppConstants.defaultAiOpenRouterModel);
    });

    test('saveApiKey persists key to active provider preferences', () async {
      final service = AiService();
      await service.saveApiKey('google-key-12345');
      expect(service.hasApiKey, isTrue);
      expect(service.apiKey, 'google-key-12345');
      expect(
        PreferencesService().prefs.getString(AppConstants.aiGoogleApiKey),
        'google-key-12345',
      );

      await service.setSelectedProvider(AppConstants.aiProviderOpenRouter);
      expect(service.currentProvider, isA<OpenRouterProvider>());
      expect(service.hasApiKey, isFalse);

      await service.saveApiKey('openrouter-key-67890');
      expect(
        PreferencesService().prefs.getString(AppConstants.aiOpenRouterApiKey),
        'openrouter-key-67890',
      );
      expect(
        PreferencesService().prefs.getString(AppConstants.aiGoogleApiKey),
        'google-key-12345',
      );
    });

    test('saveSelectedModel persists model per provider', () async {
      final service = AiService();
      await service.saveSelectedModel(AppConstants.aiGoogleModelFlashLite);
      expect(service.selectedModel, AppConstants.aiGoogleModelFlashLite);
      expect(
        PreferencesService().prefs.getString(AppConstants.aiGoogleModelKey),
        AppConstants.aiGoogleModelFlashLite,
      );

      await service.saveSelectedModel(AppConstants.defaultAiGoogleModel);
      expect(service.selectedModel, AppConstants.defaultAiGoogleModel);
      expect(
        PreferencesService().prefs.getString(AppConstants.aiGoogleModelKey),
        isNull,
      );

      await service.setSelectedProvider(AppConstants.aiProviderOpenRouter);
      await service.saveSelectedModel('openai/gpt-4o-mini', isCustom: true);
      expect(service.selectedModel, 'openai/gpt-4o-mini');
      expect(service.currentProvider.customModel, 'openai/gpt-4o-mini');
      expect(
        PreferencesService().prefs.getString(AppConstants.aiOpenRouterModelKey),
        'openai/gpt-4o-mini',
      );

      await service.saveSelectedModel(
        AppConstants.aiOpenRouterModelAuto,
        isCustom: false,
      );
      expect(service.selectedModel, AppConstants.aiOpenRouterModelAuto);
      expect(service.currentProvider.isCustomModel, isFalse);
      expect(service.currentProvider.customModel, 'openai/gpt-4o-mini');
      expect(
        service.currentProvider.selectableModels,
        contains('openai/gpt-4o-mini'),
      );
    });

    test(
        'applyConfigJson updates models, defaults, and falls back removed presets',
        () async {
      final service = AiService();
      final remoteConfig = jsonEncode({
        'version': 1,
        'default_provider': 'google_ai',
        'providers': {
          'google_ai': {
            'default_model': 'gemini-flash-latest',
            'models': [
              'gemini-flash-latest',
              'gemini-flash-lite-latest',
              'gemini-2.5-flash'
            ],
            'generation_config': {'thinking_level': 'low'}
          },
          'openrouter': {
            'default_model': 'openrouter/free',
            'models': ['openrouter/free', 'openrouter/auto'],
            'generation_config': {
              'max_tokens': 4096,
              'reasoning': {'effort': 'low'}
            }
          }
        }
      });

      service.applyConfigJson(remoteConfig);
      expect(
        service.currentProvider.availableModels,
        contains('gemini-2.5-flash'),
      );

      await service.saveSelectedModel('gemini-2.5-flash', isCustom: false);
      expect(service.selectedModel, 'gemini-2.5-flash');

      final updatedConfigWithout25 = jsonEncode({
        'version': 2,
        'providers': {
          'google_ai': {
            'default_model': 'gemini-flash-latest',
            'models': ['gemini-flash-latest', 'gemini-flash-lite-latest'],
          }
        }
      });
      service.applyConfigJson(updatedConfigWithout25);
      expect(service.selectedModel, 'gemini-flash-latest');
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

    test(
        'GoogleAiProvider injects model in URL and builds type-specific generateContent bodies',
        () {
      final provider = GoogleAiProvider();
      final url = provider.buildUrl('gemini-3.6-flash');
      expect(
        url.toString(),
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent',
      );

      const episodeContext = TranslationContext(
        type: TranslationContentType.tvEpisode,
        seriesTitle: 'The Diplomat',
        seasonNumber: 2,
        episodeNumber: 4,
        genres: ['Drama', 'Political Thriller'],
      );
      final episodeBody = provider.buildTranslationBody(
        'English',
        'Catalan',
        'A shocking security breach sends the administration into crisis.',
        title: 'Redcoats',
        translationContext: episodeContext,
        model: 'gemini-3.6-flash',
        thinkingLevel: 'medium',
      );

      expect(episodeBody.containsKey('model'), isFalse);
      expect(episodeBody['system_instruction'], {
        'parts': [
          {
            'text': episodeContext.buildSystemPrompt(
              targetLanguageName: 'Catalan',
            ),
          },
        ],
      });
      expect(episodeBody['contents'], [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  'Source language: English\nTarget language: Catalan\nType: TV Series Episode\nSeries: The Diplomat\nSeason: 2\nEpisode: 4\nGenres: Drama, Political Thriller\n\nTitle: Redcoats\nSynopsis: A shocking security breach sends the administration into crisis.',
            },
          ],
        },
      ]);
      expect(episodeBody['generationConfig'], {
        'temperature': AppConstants.aiTemperature,
        'thinkingConfig': {
          'thinkingLevel': 'MEDIUM',
        },
        'responseMimeType': AppConstants.aiMimeTypeJson,
        'responseSchema': episodeContext.buildResponseSchema(
          hasTitle: true,
          hasText: true,
        ),
      });

      const personContext = TranslationContext(
        type: TranslationContentType.person,
      );
      final personBody = provider.buildTranslationBody(
        'English',
        'Catalan',
        'Keri Lynn Russell is an American actress.',
        title: 'Keri Russell',
        translationContext: personContext,
        model: 'gemini-3.6-flash',
        thinkingLevel: 'low',
      );

      expect(personBody['system_instruction'], {
        'parts': [
          {
            'text': personContext.buildSystemPrompt(
              targetLanguageName: 'Catalan',
            ),
          },
        ],
      });
      expect(personBody['contents'], [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  'Source language: English\nTarget language: Catalan\nType: Person Biography\n\nPerson: Keri Russell\nBiography: Keri Lynn Russell is an American actress.',
            },
          ],
        },
      ]);
      expect(personBody['generationConfig'], {
        'temperature': AppConstants.aiTemperature,
        'thinkingConfig': {
          'thinkingLevel': 'LOW',
        },
        'responseMimeType': AppConstants.aiMimeTypeJson,
        'responseSchema': personContext.buildResponseSchema(
          hasTitle: true,
          hasText: true,
        ),
      });
    });

    test(
        'applyPromptsJson injects remote language templates and content types dynamically',
        () {
      final service = AiService();
      final promptsJson = jsonEncode({
        'version': 1,
        'default_language': 'en',
        'languages': {
          'en': {
            'language_name': 'English',
            'system_template':
                'Translate {CONTENT_TYPE} into {TARGET_LANGUAGE}. {TASK}',
            'content_types': {
              'movie': {'label': 'movie', 'task': 'Translate film.'},
            },
          },
          'ca': {
            'language_name': 'català',
            'system_template':
                'Tradueix {CONTENT_TYPE} al {TARGET_LANGUAGE}. {TASK}',
            'content_types': {
              'tv_episode': {
                'label': 'episodi de sèrie',
                'task': 'Tradueix episodi en {TARGET_LANGUAGE}.',
              },
            },
          },
          'ja': {
            'language_name': '日本語',
            'system_template':
                '{CONTENT_TYPE}を{TARGET_LANGUAGE}に翻訳してください。{TASK}',
            'content_types': {
              'movie': {
                'label': '映画',
                'task': '自然な{TARGET_LANGUAGE}にしてください。',
              },
            },
          },
        },
      });

      expect(service.applyPromptsJson(promptsJson), isTrue);

      final provider = GoogleAiProvider();
      const episodeContext = TranslationContext(
        type: TranslationContentType.tvEpisode,
        seriesTitle: 'The Diplomat',
        seasonNumber: 2,
        episodeNumber: 4,
      );

      final caBody = provider.buildTranslationBody(
        'English',
        'Catalan',
        'Plot',
        title: 'Redcoats',
        translationContext: episodeContext,
        promptConfig: service.promptConfig,
        targetLanguageCode: 'ca',
      );
      expect(
        caBody['system_instruction']['parts'][0]['text'],
        'Tradueix episodi de sèrie al català. Tradueix episodi en català.',
      );
      expect(
        caBody['contents'][0]['parts'][0]['text'],
        contains('Type: episodi de sèrie'),
      );

      const movieContext = TranslationContext(
        type: TranslationContentType.movie,
      );
      final jaPrompt = movieContext.buildSystemPrompt(
        promptConfig: service.promptConfig,
        targetLanguageCode: 'ja',
        targetLanguageName: 'Japanese',
      );
      expect(
        jaPrompt,
        '映画を日本語に翻訳してください。自然な日本語にしてください。',
      );

      final regionalFallback = movieContext.buildSystemPrompt(
        promptConfig: service.promptConfig,
        targetLanguageCode: 'en-GB',
        targetLanguageName: 'English',
      );
      expect(
        regionalFallback,
        'Translate movie into English. Translate film.',
      );
    });

    test('AiKeyCipher encrypts and decrypts per user and rejects tampering',
        () {
      const cipher = AiKeyCipher(secret: 'test-super-secret-key-32-chars!!');
      const userA = 'user-uuid-a';
      const userB = 'user-uuid-b';

      final encrypted = cipher.encrypt('AIzaSyFakeKey12345', userId: userA);
      expect(encrypted, isNotNull);
      expect(encrypted, startsWith('v1:'));
      expect(encrypted, isNot(contains('AIzaSyFakeKey12345')));

      expect(cipher.decrypt(encrypted, userId: userA), 'AIzaSyFakeKey12345');
      expect(cipher.decrypt(encrypted, userId: userB), isNull);

      const wrongCipher = AiKeyCipher(secret: 'another-secret-key-completely');
      expect(wrongCipher.decrypt(encrypted, userId: userA), isNull);

      expect(cipher.decrypt('${encrypted}tampered', userId: userA), isNull);
    });

    test('cloud payload round-trips encrypted keys, custom model, and settings',
        () async {
      const cipher = AiKeyCipher(secret: 'test-super-secret-key-32-chars!!');
      const userId = 'user-cloud-123';
      final service = AiService();

      await service.setSelectedProvider(AppConstants.aiProviderGoogle);
      await service.saveApiKey('google-secret-key');
      await service.saveSelectedModel('gemini-custom-exp', isCustom: true);
      await service.saveSelectedModel(
        AppConstants.aiGoogleModelFlashLite,
        isCustom: false,
      );
      await service.saveSelectedThinkingLevel('high');
      await PreferencesService()
          .prefs
          .setBool(AppConstants.aiTranslationEnabled, true);

      final cloudSettings =
          service.buildCloudSettings(userId: userId, cipher: cipher);
      expect(cloudSettings['user_id'], userId);
      expect(cloudSettings['active_provider'], AppConstants.aiProviderGoogle);
      expect(cloudSettings['ai_translation_enabled'], isTrue);

      final googleSettings =
          cloudSettings['providers'][AppConstants.aiProviderGoogle] as Map;
      expect(
        googleSettings['api_key_encrypted'],
        startsWith('v1:'),
      );
      expect(
        googleSettings['api_key_encrypted'],
        isNot(contains('google-secret-key')),
      );
      expect(googleSettings['custom_model'], 'gemini-custom-exp');
      expect(googleSettings['model'], AppConstants.aiGoogleModelFlashLite);
      expect(googleSettings['is_custom_model'], isFalse);
      expect(googleSettings['thinking_level'], 'high');

      await service.clearUserSettings();
      expect(service.hasApiKey, isFalse);
      expect(service.currentProvider.customModel, isEmpty);

      await service.applyCloudSettings(
        cloudSettings,
        userId: userId,
        cipher: cipher,
      );
      expect(service.apiKey, 'google-secret-key');
      expect(service.selectedModel, AppConstants.aiGoogleModelFlashLite);
      expect(service.currentProvider.customModel, 'gemini-custom-exp');
      expect(service.selectedThinkingLevel, 'high');
      expect(
        PreferencesService().prefs.getBool(AppConstants.aiTranslationEnabled),
        isTrue,
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
      expect(service.cleanTranslation('"Just a quoted string"'),
          'Just a quoted string');
      expect(service.cleanTranslation('Unquoted text'), 'Unquoted text');
    });
  });

  group('AiService handleErrorResponse', () {
    final service = AiService();

    test('throws AiRateLimitException on 429 status', () {
      final response =
          http.Response('Too many requests. Please retry in 15s', 429);
      expect(
        () => service.handleErrorResponse(response),
        throwsA(isA<AiRateLimitException>().having(
          (e) => e.retrySeconds,
          'retrySeconds',
          15,
        )),
      );
    });

    test(
        'throws AiRateLimitException on rate-limited or RESOURCE_EXHAUSTED body',
        () {
      final rateLimitedResponse =
          http.Response('Server error: rate-limited', 500);
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

    test('throws AiApiException on 40x status with extracted error message',
        () {
      final response404 = http.Response(
        jsonEncode({
          'error': {'message': 'Model not found', 'code': 404}
        }),
        404,
      );
      expect(
        () => service.handleErrorResponse(response404),
        throwsA(isA<AiApiException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', 'Model not found')),
      );

      final response402 = http.Response(
        jsonEncode({
          'error': {'message': 'Insufficient credits', 'code': 402}
        }),
        402,
      );
      expect(
        () => service.handleErrorResponse(response402),
        throwsA(isA<AiApiException>()
            .having((e) => e.statusCode, 'statusCode', 402)
            .having((e) => e.message, 'message', 'Insufficient credits')),
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

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        AppConstants.aiProviderKey: AppConstants.aiProviderOpenRouter,
      });
      await PreferencesService().init();
    });

    test('parses JSON with suggestions, results, titles, movies, or items keys',
        () {
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
      expect(service.parseSuggestions(bodyWithResults).first.title,
          'Blade Runner');

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
      expect(
          service.parseSuggestions(bodyWithTitles).first.title, 'Interstellar');
    });

    test(
        'parses markdown code block without json identifier and single object block',
        () {
      final body = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  '```\n[{"title": "Tenet", "year": 2020, "media_type": "movie"}]\n```'
            }
          }
        ]
      });
      expect(service.parseSuggestions(body).first.title, 'Tenet');

      final singleObjectBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content':
                  '{"data": [{"title": "Memento", "year": 2000, "media_type": "movie"}]}'
            }
          }
        ]
      });
      expect(service.parseSuggestions(singleObjectBody).first.title, 'Memento');
    });

    test('parses text suggestions with media type and conversational preamble',
        () {
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
      expect(
          service.parseSuggestions('completely malformed json {{{'), isEmpty);
    });
  });
}
