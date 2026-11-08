import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/url_constants.dart';

abstract class AiProvider {
  String get id;
  String get name;
  IconData get icon;
  String get keysUrl;
  String get apiKeyPrefKey;
  String get modelPrefKey;
  String get isCustomModelPrefKey;
  String get thinkingPrefKey;
  String get fallbackDefaultModel;
  List<String> get fallbackAvailableModels;
  Map<String, dynamic> get fallbackGenerationConfig;

  String? _remoteDefaultModel;
  List<String>? _remoteAvailableModels;
  Map<String, dynamic>? _remoteGenerationConfig;
  Map<String, Map<String, dynamic>>? _remoteModelOverrides;

  String get defaultModel => _remoteDefaultModel ?? fallbackDefaultModel;

  List<String> get availableModels =>
      _remoteAvailableModels ?? fallbackAvailableModels;

  List<String> get selectableModels {
    final models = List<String>.from(availableModels);
    final current = selectedModel;
    if (current.isNotEmpty && !models.contains(current)) {
      models.add(current);
    }
    return models;
  }

  void applyRemoteConfig(Map<String, dynamic>? config) {
    if (config == null) {
      _remoteDefaultModel = null;
      _remoteAvailableModels = null;
      _remoteGenerationConfig = null;
      _remoteModelOverrides = null;
      return;
    }

    final modelsRaw = config['models'];
    if (modelsRaw is List) {
      final parsedModels = modelsRaw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (parsedModels.isNotEmpty) {
        _remoteAvailableModels = parsedModels;
      }
    }

    final defaultModelRaw = config['default_model']?.toString().trim();
    if (defaultModelRaw != null && defaultModelRaw.isNotEmpty) {
      _remoteDefaultModel = defaultModelRaw;
    }

    final genConfigRaw = config['generation_config'];
    if (genConfigRaw is Map) {
      _remoteGenerationConfig = Map<String, dynamic>.from(genConfigRaw);
    }

    final overridesRaw = config['model_overrides'];
    if (overridesRaw is Map) {
      final parsedOverrides = <String, Map<String, dynamic>>{};
      for (final entry in overridesRaw.entries) {
        if (entry.value is Map) {
          parsedOverrides[entry.key.toString()] =
              Map<String, dynamic>.from(entry.value as Map);
        }
      }
      _remoteModelOverrides = parsedOverrides;
    }
  }

  Map<String, dynamic> baseGenerationConfig(String model) {
    final base = Map<String, dynamic>.from(
      _remoteGenerationConfig ?? fallbackGenerationConfig,
    );
    final override = _remoteModelOverrides?[model];
    if (override != null) {
      base.addAll(override);
    }
    return base;
  }

  Map<String, dynamic> effectiveGenerationConfig(
    String model, {
    String? thinkingLevel,
  }) {
    final base = baseGenerationConfig(model);
    final effectiveThinking = thinkingLevel?.trim().isNotEmpty == true
        ? thinkingLevel!.trim()
        : PreferencesService().prefs.getString(thinkingPrefKey)?.trim();
    if (effectiveThinking != null && effectiveThinking.isNotEmpty) {
      applyThinkingLevelOverride(base, effectiveThinking);
    }
    return base;
  }

  String defaultThinkingLevelForModel(String model);

  void applyThinkingLevelOverride(
    Map<String, dynamic> config,
    String thinkingLevel,
  );

  String get apiKey =>
      PreferencesService().prefs.getString(apiKeyPrefKey) ?? '';

  bool get hasApiKey => apiKey.trim().isNotEmpty;

  bool get isCustomModel =>
      PreferencesService().prefs.getBool(isCustomModelPrefKey) ?? false;

  String get selectedModel {
    final saved = PreferencesService().prefs.getString(modelPrefKey);
    if (saved != null && saved.trim().isNotEmpty) {
      final trimmed = saved.trim();
      if (isCustomModel || availableModels.contains(trimmed)) {
        return trimmed;
      }
    }
    return defaultModel;
  }

  String get selectedThinkingLevel {
    final saved = PreferencesService().prefs.getString(thinkingPrefKey);
    if (saved != null && saved.trim().isNotEmpty) {
      return saved.trim();
    }
    return defaultThinkingLevelForModel(selectedModel);
  }

  Future<void> saveApiKey(String key) async {
    final trimmed = key.trim();
    await PreferencesService().prefs.setString(apiKeyPrefKey, trimmed);
  }

  Future<void> saveSelectedModel(
    String model, {
    bool isCustom = false,
  }) async {
    final trimmed = model.trim();
    await PreferencesService().prefs.setBool(isCustomModelPrefKey, isCustom);
    await PreferencesService().prefs.remove(thinkingPrefKey);
    if (trimmed.isEmpty || (!isCustom && trimmed == defaultModel)) {
      await PreferencesService().prefs.remove(modelPrefKey);
    } else {
      await PreferencesService().prefs.setString(modelPrefKey, trimmed);
    }
  }

  Future<void> saveSelectedThinkingLevel(String? level) async {
    final trimmed = level?.trim() ?? '';
    final defaultForCurrent = defaultThinkingLevelForModel(selectedModel);
    if (trimmed.isEmpty || trimmed == defaultForCurrent) {
      await PreferencesService().prefs.remove(thinkingPrefKey);
    } else {
      await PreferencesService().prefs.setString(thinkingPrefKey, trimmed);
    }
  }

  Uri buildUrl();
  Map<String, String> buildHeaders(String key);
  Map<String, dynamic> buildSuggestionBody(
    String query, [
    String? model,
    String? thinkingLevel,
  ]);
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
    String? thinkingLevel,
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
  String get isCustomModelPrefKey => AppConstants.aiGoogleModelIsCustomKey;

  @override
  String get thinkingPrefKey => AppConstants.aiGoogleThinkingKey;

  @override
  String get fallbackDefaultModel => AppConstants.defaultAiGoogleModel;

  @override
  List<String> get fallbackAvailableModels =>
      AppConstants.availableAiGoogleModels;

  @override
  Map<String, dynamic> get fallbackGenerationConfig => {
        'thinking_level': AppConstants.aiThinkingLevel,
      };

  @override
  String defaultThinkingLevelForModel(String model) {
    final config = baseGenerationConfig(model);
    final level = config['thinking_level']?.toString().trim();
    if (level != null && level.isNotEmpty) return level;
    return AppConstants.aiThinkingLevel;
  }

  @override
  void applyThinkingLevelOverride(
    Map<String, dynamic> config,
    String thinkingLevel,
  ) {
    config['thinking_level'] = thinkingLevel;
  }

  @override
  Uri buildUrl() => Uri.parse(UrlConstants.googleAiApiUrl);

  @override
  Map<String, String> buildHeaders(String key) => {
        'Content-Type': 'application/json',
        'x-goog-api-key': key,
      };

  @override
  Map<String, dynamic> buildSuggestionBody(
    String query, [
    String? model,
    String? thinkingLevel,
  ]) {
    final targetModel = model ?? selectedModel;
    final genConfig = effectiveGenerationConfig(
      targetModel,
      thinkingLevel: thinkingLevel,
    );
    return {
      'model': targetModel,
      'system_instruction': AppConstants.aiSearchSystemPrompt,
      'input': 'Movies or TV shows about: $query',
      if (genConfig.isNotEmpty) 'generation_config': genConfig,
    };
  }

  @override
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
    String? thinkingLevel,
  ]) {
    final targetModel = model ?? selectedModel;
    final genConfig = effectiveGenerationConfig(
      targetModel,
      thinkingLevel: thinkingLevel,
    );
    return {
      'model': targetModel,
      'system_instruction': AppConstants.aiTranslateSystemPrompt,
      'input': 'Translate from $sourceLanguage to $targetLanguage:\n\n$text',
      if (genConfig.isNotEmpty) 'generation_config': genConfig,
    };
  }

  @override
  String? extractMessageContent(String responseBody) {
    final data = jsonDecode(responseBody);
    if (data is Map && data['error'] != null) {
      final err = data['error'];
      final message =
          err is Map ? (err['message'] ?? err.toString()) : err.toString();
      throw Exception('$name API error: $message');
    }

    if (data is! Map) return null;

    final outputs = data['outputs'];
    if (outputs is List && outputs.isNotEmpty) {
      final buffer = StringBuffer();
      for (final item in outputs) {
        if (item is Map &&
            item['type'] != 'thought' &&
            item['text'] is String) {
          buffer.write(item['text'] as String);
        }
      }
      final text = buffer.toString().trim();
      if (text.isNotEmpty) return text;
    }

    final steps = data['steps'];
    if (steps is List && steps.isNotEmpty) {
      final buffer = StringBuffer();
      for (final step in steps) {
        if (step is Map && step['type'] == 'model_output') {
          final contentList = step['content'];
          if (contentList is List) {
            for (final item in contentList) {
              if (item is Map &&
                  item['type'] != 'thought' &&
                  item['text'] is String) {
                buffer.write(item['text'] as String);
              }
            }
          }
        }
      }
      final text = buffer.toString().trim();
      if (text.isNotEmpty) return text;
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
  String get isCustomModelPrefKey => AppConstants.aiOpenRouterModelIsCustomKey;

  @override
  String get thinkingPrefKey => AppConstants.aiOpenRouterThinkingKey;

  @override
  String get fallbackDefaultModel => AppConstants.defaultAiOpenRouterModel;

  @override
  List<String> get fallbackAvailableModels =>
      AppConstants.availableAiOpenRouterModels;

  @override
  Map<String, dynamic> get fallbackGenerationConfig => {
        'max_tokens': AppConstants.aiMaxTokens,
        'reasoning': {
          'effort': AppConstants.aiThinkingLevel,
        },
      };

  @override
  String defaultThinkingLevelForModel(String model) {
    final config = baseGenerationConfig(model);
    final reasoning = config['reasoning'];
    if (reasoning is Map) {
      final effort = reasoning['effort']?.toString().trim();
      if (effort != null && effort.isNotEmpty) return effort;
    }
    return AppConstants.aiThinkingLevel;
  }

  @override
  void applyThinkingLevelOverride(
    Map<String, dynamic> config,
    String thinkingLevel,
  ) {
    final existing = config['reasoning'];
    final reasoningMap = existing is Map
        ? Map<String, dynamic>.from(existing)
        : <String, dynamic>{};
    reasoningMap['effort'] = thinkingLevel;
    config['reasoning'] = reasoningMap;
  }

  @override
  Uri buildUrl() => Uri.parse(UrlConstants.openRouterApiUrl);

  @override
  Map<String, String> buildHeaders(String key) => {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://moviescout.xicra.com',
        'X-Title': 'MovieScout',
      };

  @override
  Map<String, dynamic> buildSuggestionBody(
    String query, [
    String? model,
    String? thinkingLevel,
  ]) {
    final targetModel = model ?? selectedModel;
    final genConfig = effectiveGenerationConfig(
      targetModel,
      thinkingLevel: thinkingLevel,
    );
    return {
      'model': targetModel,
      ...genConfig,
      'messages': [
        {
          'role': 'system',
          'content': AppConstants.aiSearchSystemPrompt,
        },
        {'role': 'user', 'content': 'Movies or TV shows about: $query'},
      ],
    };
  }

  @override
  Map<String, dynamic> buildTranslationBody(
    String sourceLanguage,
    String targetLanguage,
    String text, [
    String? model,
    String? thinkingLevel,
  ]) {
    final targetModel = model ?? selectedModel;
    final genConfig = effectiveGenerationConfig(
      targetModel,
      thinkingLevel: thinkingLevel,
    );
    return {
      'model': targetModel,
      ...genConfig,
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
  }

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
