import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/settings/services/ai_key_cipher.dart';
import 'package:moviescout/features/settings/services/ai_provider.dart';
import 'package:moviescout/features/titles/repositories/cloud_title_repository.dart';
import 'package:moviescout/core/services/cloud_database_service.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/services/update_manager.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/models/ai_prompt_config.dart';
import 'package:moviescout/core/models/translation_context.dart';

class AiTitleSuggestion {
  final String title;
  final int? year;
  final String mediaType;

  AiTitleSuggestion({
    required this.title,
    this.year,
    this.mediaType = 'movie',
  });

  factory AiTitleSuggestion.fromJson(Map<String, dynamic> json) {
    int? parsedYear;
    if (json['year'] != null) {
      if (json['year'] is int) {
        parsedYear = json['year'] as int;
      } else if (json['year'] is String) {
        parsedYear = int.tryParse(json['year'] as String);
      }
    }

    String parsedMediaType = 'movie';
    if (json['media_type'] != null) {
      final type = json['media_type'].toString().toLowerCase().trim();
      if (type == 'tv' ||
          type == 'serie' ||
          type == 'series' ||
          type == 'show') {
        parsedMediaType = 'tv';
      }
    }

    return AiTitleSuggestion(
      title: (json['title'] ?? '').toString().trim(),
      year: parsedYear,
      mediaType: parsedMediaType,
    );
  }
}

class AiRateLimitException implements Exception {
  final int? retrySeconds;
  final String rawMessage;

  AiRateLimitException({this.retrySeconds, required this.rawMessage});

  @override
  String toString() =>
      'AiRateLimitException(retrySeconds: $retrySeconds, rawMessage: $rawMessage)';
}

class AiApiException implements Exception {
  final int statusCode;
  final String message;

  AiApiException({required this.statusCode, required this.message});

  @override
  String toString() => message;
}

class AiService with ChangeNotifier {
  static final AiService _instance = AiService._internal();

  factory AiService({CloudTitleRepository? cloudRepository}) {
    if (cloudRepository != null) {
      _instance._cloudRepository = cloudRepository;
    }
    return _instance;
  }

  AiService._internal();

  final List<AiProvider> providers = [
    GoogleAiProvider(),
    OpenRouterProvider(),
  ];

  CloudTitleRepository? _cloudRepository;
  String? _remoteDefaultProviderId;
  AiPromptConfig? _promptConfig;
  String? _syncedUserId;
  bool _isSyncingCloud = false;
  Map<String, Map<String, dynamic>> _lastCloudProvidersJson = {};

  AiPromptConfig? get promptConfig => _promptConfig;

  bool hasPromptForLanguage(String? languageCode) =>
      _promptConfig?.hasLanguagePrompt(languageCode) ?? true;

  CloudTitleRepository? get _safeCloudRepository {
    if (_cloudRepository != null) return _cloudRepository;
    try {
      return CloudTitleRepository.instance;
    } catch (_) {
      return null;
    }
  }

  String? get _currentUserId {
    try {
      return CloudDatabaseService.currentUser?.id;
    } catch (_) {
      return null;
    }
  }

  void updateAuth(SupabaseAuthService authService) {
    final user = authService.currentUser;
    if (user != null) {
      if (_syncedUserId != user.id) {
        _syncedUserId = user.id;
        unawaited(syncWithCloud());
      }
    } else {
      _syncedUserId = null;
    }
  }

  Future<void> init() async {
    await Future.wait([
      _initRemoteJson(
        cacheKey: AppConstants.aiConfigCacheKey,
        url: UrlConstants.aiModelsConfigUrl,
        applyJson: applyConfigJson,
      ),
      _initRemoteJson(
        cacheKey: AppConstants.aiPromptsCacheKey,
        url: UrlConstants.aiPromptsConfigUrl,
        applyJson: applyPromptsJson,
      ),
    ]);
  }

  Future<void> _initRemoteJson({
    required String cacheKey,
    required String url,
    required bool Function(String jsonStr) applyJson,
  }) async {
    final prefs = PreferencesService().prefs;
    final cachedJson = prefs.getString(cacheKey);
    if (cachedJson != null && cachedJson.isNotEmpty) {
      applyJson(cachedJson);
    }

    if (UpdateManager().isUpToDate(cacheKey, UpdateManager.aiConfigTimeout)) {
      return;
    }

    try {
      final uri = Uri.parse(url).replace(
        queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 && response.body.trim().isNotEmpty) {
        if (applyJson(response.body)) {
          await prefs.setString(cacheKey, response.body);
          await UpdateManager().updateLastUpdate(cacheKey);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch remote config ($url): $e');
    }
  }

  @visibleForTesting
  bool applyPromptsJson(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map) return false;
      _promptConfig = AiPromptConfig.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      return true;
    } catch (e) {
      debugPrint('Error parsing AI prompts config JSON: $e');
      return false;
    }
  }

  @visibleForTesting
  bool applyConfigJson(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map) return false;

      final defaultProviderRaw = decoded['default_provider']?.toString().trim();
      if (defaultProviderRaw != null && defaultProviderRaw.isNotEmpty) {
        _remoteDefaultProviderId = defaultProviderRaw;
      }

      final providersMap =
          decoded['providers'] is Map ? decoded['providers'] as Map : decoded;
      for (final provider in providers) {
        final providerConfig = providersMap[provider.id];
        if (providerConfig is Map) {
          provider.applyRemoteConfig(
            Map<String, dynamic>.from(providerConfig),
          );
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error parsing AI models config JSON: $e');
      return false;
    }
  }

  @visibleForTesting
  void resetRemoteConfig() {
    _remoteDefaultProviderId = null;
    _promptConfig = null;
    for (final provider in providers) {
      provider.applyRemoteConfig(null);
    }
  }

  AiProvider get defaultProvider {
    if (_remoteDefaultProviderId != null) {
      for (final provider in providers) {
        if (provider.id == _remoteDefaultProviderId) {
          return provider;
        }
      }
    }
    return providers.first;
  }

  AiProvider get currentProvider {
    final savedId =
        PreferencesService().prefs.getString(AppConstants.aiProviderKey);
    if (savedId != null && savedId.trim().isNotEmpty) {
      for (final provider in providers) {
        if (provider.id == savedId.trim()) {
          return provider;
        }
      }
    }

    final fallbackDefault = defaultProvider;
    if (!fallbackDefault.hasApiKey) {
      for (final provider in providers) {
        if (provider.id != fallbackDefault.id && provider.hasApiKey) {
          return provider;
        }
      }
    }

    return fallbackDefault;
  }

  Future<void> _persistActiveProvider(String providerId) async {
    await PreferencesService()
        .prefs
        .setString(AppConstants.aiProviderKey, providerId.trim());
  }

  Future<void> setSelectedProvider(String providerId) async {
    await _persistActiveProvider(providerId);
    unawaited(pushToCloud());
  }

  String get apiKey => currentProvider.apiKey;

  bool get hasApiKey => currentProvider.hasApiKey;

  String get selectedModel => currentProvider.selectedModel;

  String get selectedThinkingLevel => currentProvider.selectedThinkingLevel;

  Future<void> saveApiKey(String key) async {
    final provider = currentProvider;
    await _persistActiveProvider(provider.id);
    await provider.saveApiKey(key);
    unawaited(pushToCloud());
  }

  Future<void> saveSelectedModel(
    String model, {
    bool isCustom = false,
  }) async {
    final provider = currentProvider;
    await _persistActiveProvider(provider.id);
    await provider.saveSelectedModel(model, isCustom: isCustom);
    unawaited(pushToCloud());
  }

  Future<void> saveSelectedThinkingLevel(String? level) async {
    final provider = currentProvider;
    await _persistActiveProvider(provider.id);
    await provider.saveSelectedThinkingLevel(level);
    unawaited(pushToCloud());
  }

  bool _hasAnyLocalSettings() {
    final prefs = PreferencesService().prefs;
    if ((prefs.getString(AppConstants.aiProviderKey)?.trim() ?? '')
        .isNotEmpty) {
      return true;
    }
    if (prefs.getBool(AppConstants.aiTranslationEnabled) == true) {
      return true;
    }
    for (final provider in providers) {
      if (provider.hasApiKey ||
          provider.customModel.isNotEmpty ||
          (prefs.getString(provider.modelPrefKey)?.trim() ?? '').isNotEmpty ||
          (prefs.getString(provider.thinkingPrefKey)?.trim() ?? '')
              .isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Future<void> syncWithCloud({
    CloudTitleRepository? cloudRepository,
    String? userId,
    AiKeyCipher cipher = const AiKeyCipher(),
  }) async {
    if (_isSyncingCloud) return;
    final repo = cloudRepository ?? _safeCloudRepository;
    final resolvedUserId = userId ?? _currentUserId;
    if (repo == null || resolvedUserId == null) return;

    _isSyncingCloud = true;
    try {
      final cloudSettings = await repo.fetchUserAiSettings(resolvedUserId);

      if (cloudSettings == null) {
        if (_hasAnyLocalSettings()) {
          await pushToCloud(
            cloudRepository: repo,
            userId: resolvedUserId,
            cipher: cipher,
          );
        }
        return;
      }

      await applyCloudSettings(
        cloudSettings,
        userId: resolvedUserId,
        cipher: cipher,
      );
      notifyListeners();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        reportToCrashlytics: false,
        userMessage: 'Error syncing AI settings from cloud',
      );
    } finally {
      _isSyncingCloud = false;
    }
  }

  Future<void> pushToCloud({
    CloudTitleRepository? cloudRepository,
    String? userId,
    AiKeyCipher cipher = const AiKeyCipher(),
  }) async {
    final repo = cloudRepository ?? _safeCloudRepository;
    final resolvedUserId = userId ?? _currentUserId;
    if (repo == null || resolvedUserId == null) return;

    if (!cipher.isConfigured && providers.any((p) => p.hasApiKey)) {
      ErrorService.log(
        'Missing ${AppConstants.aiKeyEncryptionSecret}; skipping encrypted API key upload',
        reportToCrashlytics: false,
      );
    }

    try {
      final settings =
          buildCloudSettings(userId: resolvedUserId, cipher: cipher);
      await repo.updateUserAiSettings(settings);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        reportToCrashlytics: false,
        userMessage: 'Error saving AI settings to cloud',
      );
    }
  }

  @visibleForTesting
  Map<String, dynamic> buildCloudSettings({
    required String userId,
    AiKeyCipher cipher = const AiKeyCipher(),
  }) {
    final prefs = PreferencesService().prefs;
    final activeProvider =
        prefs.getString(AppConstants.aiProviderKey)?.trim() ?? '';
    final aiTranslationEnabled =
        prefs.getBool(AppConstants.aiTranslationEnabled) ?? false;

    final providersMap = <String, dynamic>{};
    for (final provider in providers) {
      final previousEncrypted = _lastCloudProvidersJson[provider.id]
              ?['api_key_encrypted']
          ?.toString();
      final providerJson = provider.toCloudJson(
        cipher: cipher,
        userId: userId,
        fallbackEncryptedKey: previousEncrypted,
      );
      providersMap[provider.id] = providerJson;
    }
    _lastCloudProvidersJson = providersMap.map(
      (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
    );

    return {
      'user_id': userId,
      'active_provider': activeProvider.isNotEmpty ? activeProvider : null,
      'ai_translation_enabled': aiTranslationEnabled,
      'providers': providersMap,
    };
  }

  @visibleForTesting
  Future<void> applyCloudSettings(
    Map<String, dynamic> cloudSettings, {
    required String userId,
    AiKeyCipher cipher = const AiKeyCipher(),
  }) async {
    final prefs = PreferencesService().prefs;

    final activeProvider =
        cloudSettings['active_provider']?.toString().trim() ?? '';
    if (activeProvider.isNotEmpty) {
      await prefs.setString(AppConstants.aiProviderKey, activeProvider);
    } else {
      await prefs.remove(AppConstants.aiProviderKey);
    }

    if (cloudSettings['ai_translation_enabled'] is bool) {
      await prefs.setBool(
        AppConstants.aiTranslationEnabled,
        cloudSettings['ai_translation_enabled'] as bool,
      );
    }

    final rawProviders = cloudSettings['providers'];
    if (rawProviders is Map) {
      final cachedProviders = <String, Map<String, dynamic>>{};
      for (final provider in providers) {
        final providerData = rawProviders[provider.id];
        if (providerData is Map) {
          final typed = Map<String, dynamic>.from(providerData);
          cachedProviders[provider.id] = typed;
          await provider.applyCloudJson(
            typed,
            cipher: cipher,
            userId: userId,
          );
        }
      }
      _lastCloudProvidersJson = cachedProviders;
    }
  }

  Future<void> clearUserSettings() async {
    final prefs = PreferencesService().prefs;
    await prefs.remove(AppConstants.aiProviderKey);
    await prefs.remove(AppConstants.aiTranslationEnabled);
    for (final provider in providers) {
      await provider.clearLocalSettings();
    }
    _syncedUserId = null;
    _lastCloudProvidersJson = {};
    notifyListeners();
  }

  static int? extractRetrySeconds(String errorMessage) {
    final regex = RegExp(
      r'retry (?:in|after)\s*([0-9]+(?:\.[0-9]+)?)\s*s',
      caseSensitive: false,
    );
    final match = regex.firstMatch(errorMessage);
    if (match != null) {
      final secStr = match.group(1);
      if (secStr != null) {
        final sec = double.tryParse(secStr);
        if (sec != null) {
          return sec.ceil();
        }
      }
    }
    return null;
  }

  Future<List<AiTitleSuggestion>> suggestTitles(
    String userQuery, {
    String? model,
    String? thinkingLevel,
  }) async {
    final provider = currentProvider;
    final key = provider.apiKey.trim();
    if (key.isEmpty) {
      throw Exception('${provider.name} API key is not configured');
    }

    final targetUrl = provider.buildUrl(model);
    final headers = provider.buildHeaders(key);
    final body = jsonEncode(
      provider.buildSuggestionBody(userQuery, model, thinkingLevel),
    );

    try {
      final response = await http
          .post(targetUrl, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return _parseSuggestions(response.body);
      }

      _handleErrorResponse(response);
    } on TimeoutException catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'AI search timeout',
      );
      rethrow;
    } catch (e, stackTrace) {
      if (e is! AiRateLimitException) {
        ErrorService.log(
          e,
          stackTrace: stackTrace,
          userMessage: 'Error in AI search',
        );
      }
      rethrow;
    }
  }

  Future<String> translate(
    String text, {
    required String sourceLanguage,
    required String targetLanguage,
    String? targetLanguageCode,
    String? title,
    TranslationContext? translationContext,
    String? model,
    String? thinkingLevel,
  }) async {
    final provider = currentProvider;
    final key = provider.apiKey.trim();
    if (key.isEmpty) {
      throw Exception('${provider.name} API key is not configured');
    }

    final targetUrl = provider.buildUrl(model);
    final headers = provider.buildHeaders(key);
    final body = jsonEncode(
      provider.buildTranslationBody(
        sourceLanguage,
        targetLanguage,
        text,
        title: title,
        translationContext: translationContext,
        promptConfig: _promptConfig,
        targetLanguageCode: targetLanguageCode,
        model: model,
        thinkingLevel: thinkingLevel,
      ),
    );

    try {
      final response = await http
          .post(targetUrl, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final content = provider.extractMessageContent(response.body);
        if (content != null && content.isNotEmpty) {
          final cleaned = _cleanTranslation(content);
          if (cleaned.isNotEmpty) {
            return cleaned;
          }
        }
        throw Exception(
          '${provider.name} returned an empty translation: ${response.body}',
        );
      }

      _handleErrorResponse(response);
    } on TimeoutException catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'AI translation timeout',
      );
      rethrow;
    } catch (e, stackTrace) {
      if (e is! AiRateLimitException) {
        ErrorService.log(
          e,
          stackTrace: stackTrace,
          userMessage: 'Error in AI translation',
        );
      }
      rethrow;
    }
  }

  String _cleanTranslation(String text) {
    String cleaned = text.trim();
    final safetyPrefixes = [
      'user safety: safe.',
      'safety: safe.',
      'user safety: safe',
      'safety: safe',
      'user safety:',
      'safety:'
    ];

    bool cleanedPrefix = true;
    while (cleanedPrefix) {
      cleanedPrefix = false;
      for (final prefix in safetyPrefixes) {
        if (cleaned.toLowerCase().startsWith(prefix)) {
          final nextNewline = cleaned.indexOf('\n');
          if (nextNewline != -1) {
            cleaned = cleaned.substring(nextNewline).trim();
            cleanedPrefix = true;
            break;
          } else {
            cleaned = cleaned.substring(prefix.length).trim();
            cleanedPrefix = true;
            break;
          }
        }
      }
    }

    if (cleaned.startsWith('"') &&
        cleaned.endsWith('"') &&
        cleaned.length > 1) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }
    return cleaned;
  }

  Never _handleErrorResponse(http.Response response) {
    if (response.statusCode == 429 ||
        response.body.contains('rate-limited') ||
        response.body.contains('RESOURCE_EXHAUSTED')) {
      throw AiRateLimitException(
        retrySeconds: extractRetrySeconds(response.body),
        rawMessage: response.body,
      );
    }

    if (response.statusCode >= 400) {
      try {
        final data = jsonDecode(response.body);
        if (data is Map && data['error'] != null) {
          final err = data['error'];
          if (err is Map && err['message'] != null) {
            throw AiApiException(
              statusCode: response.statusCode,
              message: err['message'].toString().trim(),
            );
          } else if (err is String) {
            throw AiApiException(
              statusCode: response.statusCode,
              message: err.trim(),
            );
          }
        }
      } on AiApiException {
        rethrow;
      } catch (e, stackTrace) {
        ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
      }

      if (response.statusCode < 500) {
        throw AiApiException(
          statusCode: response.statusCode,
          message: 'API request failed (${response.statusCode})',
        );
      }
    }

    throw Exception(
      '${currentProvider.name} API request failed with status: ${response.statusCode} - ${response.body}',
    );
  }

  @visibleForTesting
  List<AiTitleSuggestion> parseSuggestions(String responseBody) =>
      _parseSuggestions(responseBody);

  @visibleForTesting
  String cleanTranslation(String text) => _cleanTranslation(text);

  @visibleForTesting
  Never handleErrorResponse(http.Response response) =>
      _handleErrorResponse(response);

  List<AiTitleSuggestion> _parseSuggestions(String responseBody) {
    try {
      final content = currentProvider.extractMessageContent(responseBody);
      if (content == null || content.isEmpty) {
        ErrorService.log(
          'Empty content from ${currentProvider.name}: $responseBody',
          userMessage: 'Empty ${currentProvider.name} response',
        );
        return [];
      }

      final jsonStr = _extractJsonBlock(content);
      if (jsonStr != null) {
        final suggestions = _parseJsonSuggestions(jsonStr);
        if (suggestions.isNotEmpty) {
          return suggestions;
        }
      }

      return _parseTextSuggestions(content);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error parsing ${currentProvider.name} response',
      );
      return [];
    }
  }

  String? _extractJsonBlock(String content) {
    String text = content;
    if (text.startsWith('```json')) {
      text = text.substring(7);
    } else if (text.startsWith('```')) {
      text = text.substring(3);
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    text = text.trim();

    final firstBracket = text.indexOf('[');
    final firstBrace = text.indexOf('{');

    if (firstBracket != -1 && (firstBrace == -1 || firstBracket < firstBrace)) {
      final lastBracket = text.lastIndexOf(']');
      if (lastBracket != -1 && lastBracket > firstBracket) {
        return text.substring(firstBracket, lastBracket + 1);
      }
    } else if (firstBrace != -1) {
      final lastBrace = text.lastIndexOf('}');
      if (lastBrace != -1 && lastBrace > firstBrace) {
        return text.substring(firstBrace, lastBrace + 1);
      }
    }

    if (text.startsWith('[') || text.startsWith('{')) {
      return text;
    }
    return null;
  }

  List<AiTitleSuggestion> _parseJsonSuggestions(String jsonStr) {
    try {
      final dynamic parsedJson = jsonDecode(jsonStr);
      final List<dynamic>? list = _extractSuggestionList(parsedJson);

      if (list != null) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((item) => AiTitleSuggestion.fromJson(item))
            .where((suggestion) => suggestion.title.isNotEmpty)
            .toList();
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'JSON parsing attempt failed',
      );
    }
    return [];
  }

  List<dynamic>? _extractSuggestionList(dynamic parsedJson) {
    if (parsedJson is List) return parsedJson;
    if (parsedJson is Map) {
      final list = parsedJson['suggestions'] ??
          parsedJson['results'] ??
          parsedJson['titles'] ??
          parsedJson['movies'] ??
          parsedJson['items'];
      if (list is List) return list;

      for (var val in parsedJson.values) {
        if (val is List) return val;
      }
    }
    return null;
  }

  List<AiTitleSuggestion> _parseTextSuggestions(String text) {
    final suggestions = <AiTitleSuggestion>[];
    final lines = text.split('\n');

    final bulletRegex = RegExp(r'^(?:\d+[\.\)]|[-*•])\s+');
    final yearRegex = RegExp(r'\((\d{4})\)');
    final typeRegex =
        RegExp(r'\b(tv|serie|series|show|movie|film)\b', caseSensitive: false);

    for (var line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      final lower = trimmed.toLowerCase();
      if (lower.startsWith('user safety:') ||
          lower.startsWith('safety:') ||
          lower.startsWith('here are') ||
          lower.startsWith('sure,') ||
          lower.startsWith('note:') ||
          lower.startsWith('certainly')) {
        continue;
      }

      trimmed = trimmed.replaceFirst(bulletRegex, '').trim();

      String mediaType = 'movie';
      final typeMatch = typeRegex.firstMatch(trimmed);
      if (typeMatch != null) {
        final t = typeMatch.group(1)!.toLowerCase();
        if (t == 'tv' || t == 'serie' || t == 'series' || t == 'show') {
          mediaType = 'tv';
        }
      }

      int? year;
      final yearMatch = yearRegex.firstMatch(trimmed);
      if (yearMatch != null) {
        year = int.tryParse(yearMatch.group(1)!);
        trimmed = trimmed.substring(0, yearMatch.start).trim();
      } else if (typeMatch != null) {
        trimmed = trimmed.substring(0, typeMatch.start).trim();
      }

      trimmed =
          trimmed.replaceAll(RegExp(r'^["\s\-–—:]+|["\s\-–—:]+$'), '').trim();

      if (trimmed.isNotEmpty && trimmed.length > 1) {
        suggestions.add(AiTitleSuggestion(
          title: trimmed,
          year: year,
          mediaType: mediaType,
        ));
      }
    }

    return suggestions;
  }
}
