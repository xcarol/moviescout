import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/utils/translation_languages.dart';

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

  String _getLanguageName(String code) {
    try {
      return TranslationLanguages.supportedLanguages[code.toLowerCase()] ??
          code.toUpperCase();
    } catch (e) {
      return code.toUpperCase();
    }
  }

  Future<String> translate(String text) async {
    if (text.isEmpty) return text;
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
}
