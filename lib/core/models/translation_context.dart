import 'package:moviescout/core/models/ai_prompt_config.dart';
import 'package:moviescout/core/models/translation_content_type.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/metadata_translator.dart';
import 'package:moviescout/features/discovery/models/tmdb_collection.dart';
import 'package:moviescout/features/discovery/services/tmdb_genre_service.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_item.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';

export 'package:moviescout/core/models/translation_content_type.dart';

class TranslationContext {
  final TranslationContentType type;
  final String originalTitle;
  final String originalDescription;
  final String? seriesTitle;
  final int? seasonNumber;
  final int? episodeNumber;
  final List<String> genres;

  const TranslationContext({
    required this.type,
    this.originalTitle = '',
    this.originalDescription = '',
    this.seriesTitle,
    this.seasonNumber,
    this.episodeNumber,
    this.genres = const [],
  });

  factory TranslationContext.fromItem(
    TmdbItem? item, {
    TranslationContentType? type,
    TmdbTitle? series,
    int? seasonNumber,
    int? episodeNumber,
  }) {
    if (item is TmdbTitle) {
      final resolvedType = type ??
          (item.isSerie
              ? TranslationContentType.tvSeries
              : TranslationContentType.movie);
      return TranslationContext(
        type: resolvedType,
        originalTitle:
            item.originalName.isNotEmpty ? item.originalName : item.name,
        originalDescription: item.overview,
        seriesTitle: resolvedType == TranslationContentType.tvSeries
            ? _formatSeriesTitle(item)
            : null,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
        genres: _extractGenres(item),
      );
    }

    if (item is TmdbSeason) {
      return TranslationContext(
        type: type ?? TranslationContentType.tvSeason,
        originalTitle: item.name,
        originalDescription: item.overview,
        seriesTitle: series != null ? _formatSeriesTitle(series) : null,
        seasonNumber: seasonNumber ?? item.seasonNumber,
        episodeNumber: episodeNumber,
        genres: series != null ? _extractGenres(series) : const [],
      );
    }

    if (item is TmdbEpisode) {
      return TranslationContext(
        type: type ?? TranslationContentType.tvEpisode,
        originalTitle: item.name,
        originalDescription: item.overview,
        seriesTitle: series != null ? _formatSeriesTitle(series) : null,
        seasonNumber: seasonNumber ?? item.seasonNumber,
        episodeNumber: episodeNumber ?? item.episodeNumber,
        genres: series != null ? _extractGenres(series) : const [],
      );
    }

    if (item is TmdbPerson) {
      return TranslationContext(
        type: type ?? TranslationContentType.person,
        originalTitle: item.name,
        originalDescription: item.biography,
      );
    }

    if (item is TmdbCollection) {
      return TranslationContext(
        type: type ?? TranslationContentType.collection,
        originalTitle: item.name,
        originalDescription: item.overview,
      );
    }

    return TranslationContext(
      type: type ?? TranslationContentType.movie,
      originalTitle: item?.name ?? '',
      seriesTitle: series != null ? _formatSeriesTitle(series) : null,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      genres: series != null ? _extractGenres(series) : const [],
    );
  }

  static String _formatSeriesTitle(TmdbTitle title) {
    if (title.originalName.isNotEmpty &&
        title.name.isNotEmpty &&
        title.originalName != title.name) {
      return '${title.name} (${title.originalName})';
    }
    return title.name.isNotEmpty ? title.name : title.originalName;
  }

  static List<String> _extractGenres(TmdbTitle title) {
    return title.genreIds
        .map(
          (id) =>
              MetadataTranslator.translateGenre(id, AppConstants.english) ??
              TmdbGenreService().getName(id),
        )
        .whereType<String>()
        .where((g) => g.isNotEmpty)
        .toList();
  }

  static String _applyTemplatePlaceholders(
    String template, {
    required String targetLanguage,
    required String contentType,
    String task = '',
  }) {
    return template
        .replaceAll(
          AppConstants.aiTemplateTargetLanguagePlaceholder,
          targetLanguage,
        )
        .replaceAll(
          AppConstants.aiTemplateContentTypePlaceholder,
          contentType,
        )
        .replaceAll(AppConstants.aiTemplateTaskPlaceholder, task);
  }

  String buildSystemPrompt({
    AiPromptConfig? promptConfig,
    String? targetLanguageCode,
    String? targetLanguageName,
  }) {
    final langPrompt = promptConfig?.resolveLanguage(targetLanguageCode);
    final resolvedLangName = (langPrompt?.languageName?.isNotEmpty == true)
        ? langPrompt!.languageName!
        : ((targetLanguageName != null && targetLanguageName.trim().isNotEmpty)
            ? targetLanguageName.trim()
            : (targetLanguageCode?.trim() ?? ''));

    final contentTypePrompt = langPrompt?.promptFor(type);
    final resolvedTypeLabel =
        (contentTypePrompt != null && contentTypePrompt.label.isNotEmpty)
            ? contentTypePrompt.label
            : (AppConstants.aiTranslateTypeLabels[type] ?? '');

    final rawTask =
        (contentTypePrompt != null && contentTypePrompt.task.isNotEmpty)
            ? contentTypePrompt.task
            : (langPrompt?.defaultTask.isNotEmpty == true
                ? langPrompt!.defaultTask
                : (AppConstants.aiTranslateTypeInstructions[type] ?? ''));

    final resolvedTask = _applyTemplatePlaceholders(
      rawTask,
      targetLanguage: resolvedLangName,
      contentType: resolvedTypeLabel,
    );

    final template = (langPrompt?.systemTemplate.isNotEmpty == true)
        ? langPrompt!.systemTemplate
        : AppConstants.aiTranslateFallbackSystemTemplate;

    return _applyTemplatePlaceholders(
      template,
      targetLanguage: resolvedLangName,
      contentType: resolvedTypeLabel,
      task: resolvedTask,
    );
  }

  Map<String, dynamic> buildResponseSchema({
    required bool hasTitle,
    required bool hasText,
  }) {
    if (type == TranslationContentType.person) {
      return {
        'type': 'OBJECT',
        'properties': {
          AppConstants.aiSchemaBiographyKey: {
            'type': 'STRING',
            'description': AppConstants.aiTranslateBiographySchemaDescription,
          },
        },
        'required': [AppConstants.aiSchemaBiographyKey],
      };
    }

    final properties = <String, dynamic>{};
    final required = <String>[];

    if (hasTitle) {
      properties[AppConstants.aiSchemaTitleKey] = {
        'type': 'STRING',
        'description': AppConstants.aiTranslateTitleSchemaDescriptions[type] ??
            AppConstants.aiTranslateDefaultTitleSchemaDescription,
      };
      required.add(AppConstants.aiSchemaTitleKey);
    }

    if (hasText || !hasTitle) {
      properties[AppConstants.aiSchemaSynopsisKey] = {
        'type': 'STRING',
        'description':
            AppConstants.aiTranslateSynopsisSchemaDescriptions[type] ??
                AppConstants.aiTranslateDefaultSynopsisSchemaDescription,
      };
      required.add(AppConstants.aiSchemaSynopsisKey);
    }

    return {
      'type': 'OBJECT',
      'properties': properties,
      'required': required,
    };
  }

  String _resolveInputLabel(
    AiLanguagePrompt? langPrompt,
    String key,
    String fallback,
  ) {
    final localized = langPrompt?.inputLabels[key];
    return (localized != null && localized.isNotEmpty) ? localized : fallback;
  }

  String formatPromptInput({
    required String sourceLanguage,
    required String targetLanguage,
    required String text,
    String? title,
    AiPromptConfig? promptConfig,
    String? targetLanguageCode,
  }) {
    final langPrompt = promptConfig?.resolveLanguage(targetLanguageCode);
    final trimmedTitle = title?.trim() ?? '';
    final trimmedText = text.trim();
    final buffer = StringBuffer()
      ..writeln(
        '${_resolveInputLabel(langPrompt, 'source_language', AppConstants.aiInputSourceLanguageLabel)}: $sourceLanguage',
      )
      ..writeln(
        '${_resolveInputLabel(langPrompt, 'target_language', AppConstants.aiInputTargetLanguageLabel)}: $targetLanguage',
      );

    final typePromptLabel = langPrompt?.promptFor(type)?.label;
    final typeLabel = (typePromptLabel != null && typePromptLabel.isNotEmpty)
        ? typePromptLabel
        : AppConstants.aiTranslateTypeLabels[type];
    if (typeLabel != null && typeLabel.isNotEmpty) {
      buffer.writeln(
        '${_resolveInputLabel(langPrompt, 'type', AppConstants.aiInputTypeLabel)}: $typeLabel',
      );
    }

    final resolvedSeriesTitle = seriesTitle?.trim() ?? '';
    if (resolvedSeriesTitle.isNotEmpty &&
        (type == TranslationContentType.tvSeason ||
            type == TranslationContentType.tvEpisode ||
            (type == TranslationContentType.tvSeries &&
                resolvedSeriesTitle != trimmedTitle))) {
      buffer.writeln(
        '${_resolveInputLabel(langPrompt, 'series', AppConstants.aiInputSeriesLabel)}: $resolvedSeriesTitle',
      );
    }

    if (seasonNumber != null) {
      buffer.writeln(
        '${_resolveInputLabel(langPrompt, 'season', AppConstants.aiInputSeasonLabel)}: $seasonNumber',
      );
    }

    if (episodeNumber != null) {
      buffer.writeln(
        '${_resolveInputLabel(langPrompt, 'episode', AppConstants.aiInputEpisodeLabel)}: $episodeNumber',
      );
    }

    if (genres.isNotEmpty) {
      buffer.writeln(
        '${_resolveInputLabel(langPrompt, 'genres', AppConstants.aiInputGenresLabel)}: ${genres.join(', ')}',
      );
    }

    buffer.writeln();

    if (type == TranslationContentType.person) {
      if (trimmedTitle.isNotEmpty) {
        buffer.writeln(
          '${_resolveInputLabel(langPrompt, 'person', AppConstants.aiInputPersonLabel)}: $trimmedTitle',
        );
      }
      if (trimmedText.isNotEmpty) {
        buffer.write(
          '${_resolveInputLabel(langPrompt, 'biography', AppConstants.aiInputBiographyLabel)}: $trimmedText',
        );
      }
    } else {
      if (trimmedTitle.isNotEmpty) {
        buffer.writeln(
          '${_resolveInputLabel(langPrompt, 'title', AppConstants.aiInputTitleLabel)}: $trimmedTitle',
        );
      }
      if (trimmedText.isNotEmpty) {
        buffer.write(
          '${_resolveInputLabel(langPrompt, 'synopsis', AppConstants.aiInputSynopsisLabel)}: $trimmedText',
        );
      }
    }

    return buffer.toString().trimRight();
  }
}
