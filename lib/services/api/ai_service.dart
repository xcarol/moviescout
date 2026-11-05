import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moviescout/services/api/ai_provider.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

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

class AiService {
  static final AiService _instance = AiService._internal();

  factory AiService() {
    return _instance;
  }

  AiService._internal();

  final List<AiProvider> providers = [
    GoogleAiProvider(),
    OpenRouterProvider(),
  ];

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

    final defaultProvider = providers.first;
    if (!defaultProvider.hasApiKey) {
      for (final provider in providers.skip(1)) {
        if (provider.hasApiKey) {
          return provider;
        }
      }
    }

    return defaultProvider;
  }

  Future<void> setSelectedProvider(String providerId) async {
    await PreferencesService()
        .prefs
        .setString(AppConstants.aiProviderKey, providerId.trim());
  }

  String get apiKey => currentProvider.apiKey;

  bool get hasApiKey => currentProvider.hasApiKey;

  String get selectedModel => currentProvider.selectedModel;

  Future<void> saveApiKey(String key) async {
    final provider = currentProvider;
    await setSelectedProvider(provider.id);
    await provider.saveApiKey(key);
  }

  Future<void> saveSelectedModel(String model) async {
    final provider = currentProvider;
    await setSelectedProvider(provider.id);
    await provider.saveSelectedModel(model);
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

  Future<List<AiTitleSuggestion>> suggestTitles(String userQuery) async {
    final provider = currentProvider;
    final key = provider.apiKey.trim();
    if (key.isEmpty) {
      throw Exception('${provider.name} API key is not configured');
    }

    final targetUrl = provider.buildUrl();
    final headers = provider.buildHeaders(key);
    final body = jsonEncode(provider.buildSuggestionBody(userQuery));

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
  }) async {
    final provider = currentProvider;
    final key = provider.apiKey.trim();
    if (key.isEmpty) {
      throw Exception('${provider.name} API key is not configured');
    }

    final targetUrl = provider.buildUrl();
    final headers = provider.buildHeaders(key);
    final body = jsonEncode(
      provider.buildTranslationBody(sourceLanguage, targetLanguage, text),
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
      } catch (_) {}

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
