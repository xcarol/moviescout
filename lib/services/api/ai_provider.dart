import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/utils/url_constants.dart';

abstract class AiProvider {
  String get id;
  String get name;
  IconData get icon;
  String get keysUrl;
  String get apiKeyPrefKey;
  String get modelPrefKey;
  String get defaultModel;
  List<String> get availableModels;

  String get apiKey =>
      PreferencesService().prefs.getString(apiKeyPrefKey) ?? '';

  bool get hasApiKey => apiKey.trim().isNotEmpty;

  String get selectedModel {
    final saved = PreferencesService().prefs.getString(modelPrefKey);
    if (saved != null && saved.trim().isNotEmpty) {
      return saved.trim();
    }
    return defaultModel;
  }

  Future<void> saveApiKey(String key) async {
    final trimmed = key.trim();
    await PreferencesService().prefs.setString(apiKeyPrefKey, trimmed);
  }

  Future<void> saveSelectedModel(String model) async {
    final trimmed = model.trim();
    if (trimmed.isEmpty || trimmed == defaultModel) {
      await PreferencesService().prefs.remove(modelPrefKey);
    } else {
      await PreferencesService().prefs.setString(modelPrefKey, trimmed);
    }
  }

  Uri buildUrl([String? model]);
  Map<String, String> buildHeaders(String key);
  Map<String, dynamic> buildSuggestionBody(String query, [String? model]);
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
  ]);
  String? extractMessageContent(String responseBody);

  String description(AppLocalizations l10n);
  String getApiKeyButtonLabel(AppLocalizations l10n);
  String apiKeyLabel(AppLocalizations l10n);
  String apiKeyHint(AppLocalizations l10n);
  String customModelHint(AppLocalizations l10n);
  String deleteConfirmMessage(AppLocalizations l10n);
  String modelDisplayLabel(String model, AppLocalizations l10n);
}

class GoogleAiProvider extends AiProvider {
  @override
  String get id => AppConstants.aiProviderGoogle;

  @override
  String get name => 'Google AI';

  @override
  IconData get icon => Icons.auto_awesome;

  @override
  String get keysUrl => UrlConstants.googleAiKeysUrl;

  @override
  String get apiKeyPrefKey => AppConstants.aiGoogleApiKey;

  @override
  String get modelPrefKey => AppConstants.aiGoogleModelKey;

  @override
  String get defaultModel => AppConstants.defaultAiGoogleModel;

  @override
  List<String> get availableModels => AppConstants.availableAiGoogleModels;

  @override
  Uri buildUrl([String? model]) {
    final targetModel = model ?? selectedModel;
    return Uri.parse(
      '${UrlConstants.googleAiApiBaseUrl}$targetModel:generateContent',
    );
  }

  @override
  Map<String, String> buildHeaders(String key) => {
        'Content-Type': 'application/json',
        'x-goog-api-key': key,
      };

  @override
  Map<String, dynamic> buildSuggestionBody(String query, [String? model]) => {
        'systemInstruction': {
          'parts': [
            {'text': AppConstants.aiSearchSystemPrompt},
          ],
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': 'Movies or TV shows about: $query'},
            ],
          },
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'thinkingConfig': {
            'thinkingLevel': 'LOW',
          },
        },
      };

  @override
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
  ]) =>
      {
        'systemInstruction': {
          'parts': [
            {'text': AppConstants.aiTranslateSystemPrompt},
          ],
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text':
                    'Translate from $sourceLanguage to $targetLanguage:\n\n$text',
              },
            ],
          },
        ],
        'generationConfig': {
          'thinkingConfig': {
            'thinkingLevel': 'LOW',
          },
        },
      };

  @override
  String? extractMessageContent(String responseBody) {
    final data = jsonDecode(responseBody);
    if (data is Map && data['error'] != null) {
      final err = data['error'];
      final message =
          err is Map ? (err['message'] ?? err.toString()) : err.toString();
      throw Exception('$name API error: $message');
    }
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) return null;

    final firstCandidate = candidates.first;
    if (firstCandidate is! Map) return null;
    final content = firstCandidate['content'];
    if (content is! Map) return null;
    final parts = content['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) return null;

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map && part['thought'] != true && part['text'] is String) {
        buffer.write(part['text'] as String);
      }
    }
    final text = buffer.toString().trim();
    return text.isNotEmpty ? text : null;
  }

  @override
  String description(AppLocalizations l10n) => l10n.aiGoogleSettingsDescription;

  @override
  String getApiKeyButtonLabel(AppLocalizations l10n) =>
      l10n.aiGoogleGetApiKeyButton;

  @override
  String apiKeyLabel(AppLocalizations l10n) => l10n.aiGoogleApiKeyLabel;

  @override
  String apiKeyHint(AppLocalizations l10n) => l10n.aiGoogleApiKeyHint;

  @override
  String customModelHint(AppLocalizations l10n) => l10n.aiGoogleModelCustomHint;

  @override
  String deleteConfirmMessage(AppLocalizations l10n) =>
      l10n.aiGoogleDeleteConfirmMessage;

  @override
  String modelDisplayLabel(String model, AppLocalizations l10n) => model;
}

class OpenRouterProvider extends AiProvider {
  @override
  String get id => AppConstants.aiProviderOpenRouter;

  @override
  String get name => 'OpenRouter';

  @override
  IconData get icon => Icons.hub_outlined;

  @override
  String get keysUrl => UrlConstants.openRouterKeysUrl;

  @override
  String get apiKeyPrefKey => AppConstants.aiOpenRouterApiKey;

  @override
  String get modelPrefKey => AppConstants.aiOpenRouterModelKey;

  @override
  String get defaultModel => AppConstants.defaultAiOpenRouterModel;

  @override
  List<String> get availableModels => AppConstants.availableAiOpenRouterModels;

  @override
  Uri buildUrl([String? model]) => Uri.parse(UrlConstants.openRouterApiUrl);

  @override
  Map<String, String> buildHeaders(String key) => {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://moviescout.xicra.com',
        'X-Title': 'MovieScout',
      };

  @override
  Map<String, dynamic> buildSuggestionBody(String query, [String? model]) => {
        'model': model ?? selectedModel,
        'max_tokens': AppConstants.aiMaxTokens,
        'reasoning': {
          'effort': 'low',
        },
        'messages': [
          {
            'role': 'system',
            'content': AppConstants.aiSearchSystemPrompt,
          },
          {'role': 'user', 'content': 'Movies or TV shows about: $query'},
        ],
      };

  @override
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
  ]) =>
      {
        'model': model ?? selectedModel,
        'max_tokens': AppConstants.aiMaxTokens,
        'reasoning': {
          'effort': 'low',
        },
        'messages': [
          {
            'role': 'system',
            'content': AppConstants.aiTranslateSystemPrompt,
          },
          {
            'role': 'user',
            'content':
                'Translate from $sourceLanguage to $targetLanguage:\n\n$text',
          },
        ],
      };

  @override
  String? extractMessageContent(String responseBody) {
    final data = jsonDecode(responseBody);
    if (data is Map && data['error'] != null) {
      final err = data['error'];
      final message =
          err is Map ? (err['message'] ?? err.toString()) : err.toString();
      throw Exception('$name API error: $message');
    }
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;

    final firstChoice = choices.first;
    if (firstChoice is! Map) return null;
    final message = firstChoice['message'];
    if (message is! Map) return null;

    final content = message['content'] as String?;
    return content?.trim();
  }

  @override
  String description(AppLocalizations l10n) =>
      l10n.aiOpenRouterSettingsDescription;

  @override
  String getApiKeyButtonLabel(AppLocalizations l10n) =>
      l10n.aiOpenRouterGetApiKeyButton;

  @override
  String apiKeyLabel(AppLocalizations l10n) => l10n.aiOpenRouterApiKeyLabel;

  @override
  String apiKeyHint(AppLocalizations l10n) => l10n.aiOpenRouterApiKeyHint;

  @override
  String customModelHint(AppLocalizations l10n) =>
      l10n.aiOpenRouterModelCustomHint;

  @override
  String deleteConfirmMessage(AppLocalizations l10n) =>
      l10n.aiOpenRouterDeleteConfirmMessage;

  @override
  String modelDisplayLabel(String model, AppLocalizations l10n) {
    switch (model) {
      case AppConstants.aiOpenRouterModelFree:
        return l10n.aiOpenRouterModelFreeLabel;
      case AppConstants.aiOpenRouterModelAuto:
        return l10n.aiOpenRouterModelAutoLabel;
      default:
        return model;
    }
  }
}
