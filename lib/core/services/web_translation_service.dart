import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/features/settings/services/language_service.dart';
import 'package:moviescout/core/utils/translation_languages.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';

class WebTranslationService with ChangeNotifier {
  static final WebTranslationService _instance =
      WebTranslationService._internal();

  factory WebTranslationService() => _instance;

  WebTranslationService._internal();

  final _translator = GoogleTranslator();

  String get sourceLanguageCode =>
      PreferencesService().prefs.getString(AppConstants.translationSource) ??
      'en';

  String get targetLanguageCode {
    final stored =
        PreferencesService().prefs.getString(AppConstants.translationTarget);
    if (stored != null && stored.isNotEmpty) return stored;
    return LanguageService().locale.languageCode;
  }

  String get sourceLanguageName => _getLanguageName(sourceLanguageCode);
  String get targetLanguageName => _getLanguageName(targetLanguageCode);

  Future<void> setSourceLanguageCode(String code) async {
    await PreferencesService()
        .prefs
        .setString(AppConstants.translationSource, code);
    notifyListeners();
  }

  Future<void> setTargetLanguageCode(String code) async {
    await PreferencesService()
        .prefs
        .setString(AppConstants.translationTarget, code);
    notifyListeners();
  }

  bool get isAiTranslationEnabled =>
      PreferencesService().prefs.getBool(AppConstants.aiTranslationEnabled) ??
      false;

  Future<void> setAiTranslationEnabled(bool enabled) async {
    await PreferencesService()
        .prefs
        .setBool(AppConstants.aiTranslationEnabled, enabled);
    notifyListeners();
  }

  String _getLanguageName(String code) {
    try {
      return TranslationLanguages.supportedLanguages[code.toLowerCase()] ??
          code.toUpperCase();
    } catch (e) {
      return code.toUpperCase();
    }
  }

  Future<String> translate(
    String text, {
    String? model,
    String? thinkingLevel,
  }) async {
    if (text.isEmpty) return text;

    if (AiService().hasApiKey && isAiTranslationEnabled) {
      return await AiService().translate(
        text,
        sourceLanguage: sourceLanguageName,
        targetLanguage: targetLanguageName,
        model: model,
        thinkingLevel: thinkingLevel,
      );
    }

    try {
      final translation = await _translator.translate(
        text,
        from: sourceLanguageCode,
        to: targetLanguageCode,
      );
      return translation.text;
    } catch (e) {
      debugPrint('Translation error: $e');
      return text; // Return original on error
    }
  }

  Future<({String title, String description})> translateTitleAndSynopsis({
    required String title,
    required String description,
    String? model,
    String? thinkingLevel,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedDesc = description.trim();
    if (trimmedTitle.isEmpty && trimmedDesc.isEmpty) {
      return (title: '', description: '');
    }

    if (AiService().hasApiKey && isAiTranslationEnabled) {
      if (trimmedTitle.isEmpty) {
        final translatedDesc = await AiService().translate(
          trimmedDesc,
          sourceLanguage: sourceLanguageName,
          targetLanguage: targetLanguageName,
          model: model,
          thinkingLevel: thinkingLevel,
        );
        return (title: '', description: translatedDesc);
      }

      final payload = trimmedDesc.isNotEmpty
          ? 'TITLE: $trimmedTitle\nSYNOPSIS: $trimmedDesc'
          : 'TITLE: $trimmedTitle';

      final response = await AiService().translate(
        payload,
        sourceLanguage: sourceLanguageName,
        targetLanguage: targetLanguageName,
        model: model,
        thinkingLevel: thinkingLevel,
      );

      return parseTitleAndSynopsis(
        response,
        hasDescription: trimmedDesc.isNotEmpty,
      );
    }

    final results = await Future.wait([
      trimmedTitle.isNotEmpty ? translate(trimmedTitle) : Future.value(''),
      trimmedDesc.isNotEmpty ? translate(trimmedDesc) : Future.value(''),
    ]);
    return (title: results[0], description: results[1]);
  }

  @visibleForTesting
  ({String title, String description}) parseTitleAndSynopsis(
    String response, {
    required bool hasDescription,
  }) {
    final titlePrefixRegex = RegExp(
      r'^\s*(?:TITLE|TÍTOL|TITOL|TÍTULO|TITULO)\s*:\s*',
      caseSensitive: false,
    );
    final synopsisSplitRegex = RegExp(
      r'\n\s*(?:SYNOPSIS|SINOPSI|SINOPSIS)\s*:\s*',
      caseSensitive: false,
    );

    if (!hasDescription) {
      final cleanedTitle =
          _stripSurroundingQuotes(response.replaceFirst(titlePrefixRegex, ''));
      return (title: cleanedTitle, description: '');
    }

    final match = synopsisSplitRegex.firstMatch(response);
    if (match != null) {
      final rawTitle = response.substring(0, match.start);
      final rawDesc = response.substring(match.end);
      return (
        title: _stripSurroundingQuotes(
          rawTitle.replaceFirst(titlePrefixRegex, ''),
        ),
        description: _stripSurroundingQuotes(rawDesc),
      );
    }

    final newlineIndex = response.indexOf('\n');
    if (newlineIndex != -1) {
      final rawTitle = response.substring(0, newlineIndex);
      final rawDesc = response.substring(newlineIndex + 1);
      return (
        title: _stripSurroundingQuotes(
          rawTitle.replaceFirst(titlePrefixRegex, ''),
        ),
        description: _stripSurroundingQuotes(rawDesc),
      );
    }

    return (
      title: _stripSurroundingQuotes(
        response.replaceFirst(titlePrefixRegex, ''),
      ),
      description: '',
    );
  }

  String _stripSurroundingQuotes(String value) {
    final trimmed = value.trim();
    if (trimmed.length > 1 &&
        trimmed.startsWith('"') &&
        trimmed.endsWith('"')) {
      return trimmed.substring(1, trimmed.length - 1).trim();
    }
    return trimmed;
  }
}
