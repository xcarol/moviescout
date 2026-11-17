import 'package:moviescout/core/models/translation_content_type.dart';

class AiContentTypePrompt {
  final String label;
  final String task;

  const AiContentTypePrompt({
    required this.label,
    required this.task,
  });

  factory AiContentTypePrompt.fromJson(Map<String, dynamic> json) {
    return AiContentTypePrompt(
      label: json['label']?.toString().trim() ?? '',
      task: json['task']?.toString().trim() ?? '',
    );
  }
}

class AiLanguagePrompt {
  final String? languageName;
  final String systemTemplate;
  final String defaultTask;
  final Map<String, AiContentTypePrompt> contentTypes;
  final Map<String, String> inputLabels;

  const AiLanguagePrompt({
    this.languageName,
    required this.systemTemplate,
    this.defaultTask = '',
    this.contentTypes = const {},
    this.inputLabels = const {},
  });

  factory AiLanguagePrompt.fromJson(Map<String, dynamic> json) {
    final parsedTypes = <String, AiContentTypePrompt>{};
    final rawTypes = json['content_types'];
    if (rawTypes is Map) {
      for (final entry in rawTypes.entries) {
        if (entry.value is Map) {
          parsedTypes[entry.key.toString().trim()] =
              AiContentTypePrompt.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        } else if (entry.value is String) {
          parsedTypes[entry.key.toString().trim()] = AiContentTypePrompt(
            label: entry.value.toString().trim(),
            task: '',
          );
        }
      }
    }

    final parsedInputLabels = <String, String>{};
    final rawInputLabels = json['input_labels'];
    if (rawInputLabels is Map) {
      for (final entry in rawInputLabels.entries) {
        final value = entry.value?.toString().trim() ?? '';
        if (value.isNotEmpty) {
          parsedInputLabels[entry.key.toString().trim()] = value;
        }
      }
    }

    final langNameRaw = json['language_name']?.toString().trim();
    return AiLanguagePrompt(
      languageName:
          (langNameRaw != null && langNameRaw.isNotEmpty) ? langNameRaw : null,
      systemTemplate: json['system_template']?.toString().trim() ?? '',
      defaultTask: json['default_task']?.toString().trim() ?? '',
      contentTypes: parsedTypes,
      inputLabels: parsedInputLabels,
    );
  }

  AiContentTypePrompt? promptFor(TranslationContentType type) =>
      contentTypes[type.jsonKey];
}

class AiPromptConfig {
  final String defaultLanguage;
  final Map<String, AiLanguagePrompt> languages;

  const AiPromptConfig({
    this.defaultLanguage = 'en',
    this.languages = const {},
  });

  factory AiPromptConfig.fromJson(Map<String, dynamic> json) {
    final defaultLangRaw = json['default_language']?.toString().trim();
    final parsedLanguages = <String, AiLanguagePrompt>{};
    final rawLanguages = json['languages'];
    if (rawLanguages is Map) {
      for (final entry in rawLanguages.entries) {
        if (entry.value is Map) {
          parsedLanguages[_normalizeCode(entry.key.toString())] =
              AiLanguagePrompt.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }

    return AiPromptConfig(
      defaultLanguage: (defaultLangRaw != null && defaultLangRaw.isNotEmpty)
          ? _normalizeCode(defaultLangRaw)
          : 'en',
      languages: parsedLanguages,
    );
  }

  static String _normalizeCode(String code) =>
      code.trim().toLowerCase().replaceAll('_', '-');

  AiLanguagePrompt? resolveLanguage(String? languageCode) {
    if (languages.isEmpty) return null;
    if (languageCode != null && languageCode.trim().isNotEmpty) {
      final normalized = _normalizeCode(languageCode);
      final exact = languages[normalized];
      if (exact != null) return exact;

      final separatorIdx = normalized.indexOf('-');
      if (separatorIdx != -1) {
        final base = languages[normalized.substring(0, separatorIdx)];
        if (base != null) return base;
      }
    }
    return languages[defaultLanguage];
  }
}
