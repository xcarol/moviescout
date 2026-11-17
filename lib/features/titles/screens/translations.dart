import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/edit_button.dart';
import 'package:moviescout/features/settings/widgets/ai_model_thinking_selector.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/core/services/web_translation_service.dart';
import 'package:moviescout/core/utils/translation_languages.dart';
import 'package:moviescout/core/models/translation_context.dart';

class _CopyIconButton extends StatefulWidget {
  final String textToCopy;
  const _CopyIconButton({required this.textToCopy});

  @override
  State<_CopyIconButton> createState() => _CopyIconButtonState();
}

class _CopyIconButtonState extends State<_CopyIconButton> {
  bool _copied = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.textToCopy));
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Tooltip(
        message: _copied ? AppLocalizations.of(context)!.copiedToClipboard : '',
        child: InkWell(
          borderRadius: AppRadius.borderXs,
          onTap: _copy,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              _copied ? Icons.check : Icons.copy,
              size: 20,
              color: _copied
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class TranslationsScreen extends StatefulWidget {
  final List<TmdbTranslation> translations;
  final String editUrl;
  final TranslationContext translationContext;

  const TranslationsScreen({
    super.key,
    required this.translations,
    required this.editUrl,
    required this.translationContext,
  });

  @override
  State<TranslationsScreen> createState() => TranslationsScreenState();
}

class TranslationsScreenState extends State<TranslationsScreen> {
  String _translatedTitle = '';
  String _translatedDescription = '';
  String? _translationError;
  String? _selectedAiModel;
  String? _selectedThinkingLevel;

  bool _isTranslating = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final service = context.read<WebTranslationService>();
    final isAiActive = AiService().hasApiKey && service.isAiTranslationEnabled;
    if (!isAiActive) {
      _performTranslation();
    }
  }

  String _getEffectiveSourceCode(String serviceSourceCode) {
    var sourceCode = serviceSourceCode;
    final uniqueSourceCodes = <String>{};
    for (var t in widget.translations) {
      if (t.description.isNotEmpty || t.translatedTitle.isNotEmpty) {
        uniqueSourceCodes.add(t.iso639_1);
      }
    }

    if (!uniqueSourceCodes.contains(sourceCode)) {
      if (uniqueSourceCodes.contains('en')) {
        sourceCode = 'en';
      } else if (uniqueSourceCodes.isNotEmpty) {
        sourceCode = uniqueSourceCodes.first;
      }
    }
    return sourceCode;
  }

  Future<void> _performTranslation() async {
    setState(() {
      _isTranslating = true;
      _translationError = null;
    });

    final service = context.read<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);

    String sourceTitle = widget.translationContext.originalTitle;
    String sourceDesc = widget.translationContext.originalDescription;

    final matches = widget.translations.where((t) => t.iso639_1 == sourceCode);
    if (matches.isNotEmpty) {
      final sourceTrans = matches.first;
      if (sourceTrans.translatedTitle.isNotEmpty) {
        sourceTitle = sourceTrans.translatedTitle;
      }
      if (sourceTrans.description.isNotEmpty) {
        sourceDesc = sourceTrans.description;
      }
    }

    try {
      final result = await service.translateTitleAndSynopsis(
        title: sourceTitle,
        description: sourceDesc,
        translationContext: widget.translationContext,
        model: _selectedAiModel,
        thinkingLevel: _selectedThinkingLevel,
      );

      if (mounted) {
        setState(() {
          _translatedTitle = result.title;
          _translatedDescription = result.description;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final String errorMessage;
      if (e is TimeoutException) {
        errorMessage = l10n.aiTranslationTimeout;
      } else if (e is AiRateLimitException) {
        errorMessage = e.retrySeconds != null && e.retrySeconds! > 0
            ? l10n.aiRateLimitWithSeconds(e.retrySeconds!)
            : l10n.aiRateLimitGeneric;
      } else if (e is AiApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = l10n.aiTranslationError;
      }

      setState(() {
        _translatedTitle = '';
        _translatedDescription = '';
        _translationError = errorMessage;
        _isTranslating = false;
      });
    }
  }

  Widget _buildCopyableTextRow(String text,
      {bool isTitle = false, int? maxLines}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style:
                  isTitle ? const TextStyle(fontWeight: FontWeight.w600) : null,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
            ),
          ),
          _CopyIconButton(textToCopy: text),
        ],
      ),
    );
  }

  Widget _buildMagicCard() {
    final service = context.watch<WebTranslationService>();
    final targetCode = service.targetLanguageCode;
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);

    final uniqueSourceCodes = <String, String>{};
    for (var t in widget.translations) {
      if (t.description.isNotEmpty || t.translatedTitle.isNotEmpty) {
        uniqueSourceCodes[t.iso639_1] = t.englishName;
      }
    }

    final List<String> sourceOptions = uniqueSourceCodes.values.toList();
    sourceOptions.sort();

    final allLangs = TranslationLanguages.supportedLanguages.entries.toList();
    final List<String> targetOptions = allLangs.map((e) => e.value).toList();
    targetOptions.sort();

    final selectedSourceOption = uniqueSourceCodes[sourceCode] ??
        (sourceOptions.isNotEmpty ? sourceOptions.first : '');
    final selectedTargetOption =
        TranslationLanguages.supportedLanguages[targetCode] ?? '';
    final isAiActive = AiService().hasApiKey && service.isAiTranslationEnabled;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.autoTranslation,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Symbols.wand_stars, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.enableAiTranslation,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: isAiActive,
                      onChanged: (val) {
                        if (val && !AiService().hasApiKey) {
                          context.toAiSettings().then((_) {
                            if (AiService().hasApiKey && mounted) {
                              service.setAiTranslationEnabled(true);
                              setState(() {
                                _translatedTitle = '';
                                _translatedDescription = '';
                                _translationError = null;
                              });
                            }
                          });
                        } else {
                          service.setAiTranslationEnabled(val);
                          if (val) {
                            setState(() {
                              _translatedTitle = '';
                              _translatedDescription = '';
                              _translationError = null;
                            });
                          } else {
                            _performTranslation();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useRow = constraints.maxWidth > 350.0;
                final sourceDropdown = DropdownSelector(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  selectedOption: selectedSourceOption,
                  options: sourceOptions,
                  maxMenuHeight: 300,
                  isExpanded: true,
                  onSelected: (val) {
                    final code = uniqueSourceCodes.entries
                        .firstWhere((e) => e.value == val)
                        .key;
                    service.setSourceLanguageCode(code);
                    if (!isAiActive) {
                      _performTranslation();
                    }
                  },
                );

                final targetDropdown = DropdownSelector(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  selectedOption: selectedTargetOption,
                  options: targetOptions,
                  maxMenuHeight: 300,
                  isExpanded: true,
                  onSelected: (val) {
                    final code = TranslationLanguages.supportedLanguages.entries
                        .firstWhere((e) => e.value == val)
                        .key;
                    service.setTargetLanguageCode(code);
                    if (!isAiActive) {
                      _performTranslation();
                    }
                  },
                );

                if (useRow) {
                  return Row(
                    children: [
                      Expanded(child: sourceDropdown),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.arrow_forward, size: 16),
                      ),
                      Expanded(child: targetDropdown),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      sourceDropdown,
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(Icons.arrow_downward, size: 16),
                      ),
                      targetDropdown,
                    ],
                  );
                }
              },
            ),
            if (isAiActive) ...[
              const SizedBox(height: 8),
              AiModelThinkingSelector(
                selectedModel: _selectedAiModel,
                selectedThinkingLevel: _selectedThinkingLevel,
                onChanged: (model, thinkingLevel) {
                  setState(() {
                    _selectedAiModel = model;
                    _selectedThinkingLevel = thinkingLevel;
                  });
                },
                onRefresh: _performTranslation,
              ),
            ],
            if (_isTranslating ||
                _translationError != null ||
                _translatedTitle.isNotEmpty ||
                _translatedDescription.isNotEmpty)
              const SizedBox(height: 12),
            if (_isTranslating)
              const Center(child: CircularProgressIndicator())
            else if (_translationError != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _translationError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_translatedTitle.isNotEmpty)
                    _buildCopyableTextRow(_translatedTitle, isTitle: true),
                  if (_translatedTitle.isNotEmpty &&
                      _translatedDescription.isNotEmpty)
                    const SizedBox(height: 8),
                  if (_translatedDescription.isNotEmpty)
                    _buildCopyableTextRow(_translatedDescription),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard() {
    final service = context.watch<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    final sourceName = TranslationLanguages.supportedLanguages[sourceCode] ??
        sourceCode.toUpperCase();

    String sourceTitle = widget.translationContext.originalTitle;
    String sourceDesc = widget.translationContext.originalDescription;

    final matches = widget.translations.where((t) => t.iso639_1 == sourceCode);
    if (matches.isNotEmpty) {
      final sourceTrans = matches.first;
      if (sourceTrans.translatedTitle.isNotEmpty) {
        sourceTitle = sourceTrans.translatedTitle;
      }
      if (sourceTrans.description.isNotEmpty) {
        sourceDesc = sourceTrans.description;
      }
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${AppLocalizations.of(context)!.originalText} ($sourceName)",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (sourceTitle.isNotEmpty)
              _buildCopyableTextRow(sourceTitle, isTitle: true),
            if (sourceTitle.isNotEmpty && sourceDesc.isNotEmpty)
              const SizedBox(height: 8),
            if (sourceDesc.isNotEmpty) _buildCopyableTextRow(sourceDesc),
          ],
        ),
      ),
    );
  }

  List<TmdbTranslation> _findExistingTargetTranslations(
    List<TmdbTranslation> validTranslations,
    String targetCode,
  ) {
    final normalized = targetCode.trim().toLowerCase();
    if (normalized.isEmpty) return const [];

    if (normalized.contains('-')) {
      final exactMatches = validTranslations
          .where(
            (t) =>
                '${t.iso639_1.toLowerCase()}-${t.iso3166_1.toLowerCase()}' ==
                normalized,
          )
          .toList();
      if (exactMatches.isNotEmpty) return exactMatches;
    }

    final baseCode = normalized.split('-').first;
    return validTranslations
        .where((t) => t.iso639_1.toLowerCase() == baseCode)
        .toList();
  }

  Widget _buildExistingTargetTile(
    TmdbTranslation trans, {
    bool showVariant = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final displayTitle = trans.translatedTitle.isNotEmpty
        ? trans.translatedTitle
        : widget.translationContext.originalTitle;
    final titleText = showVariant && trans.iso3166_1.isNotEmpty
        ? '${l10n.existingTranslation} (${trans.iso639_1}-${trans.iso3166_1})'
        : l10n.existingTranslation;

    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: ExpansionTile(
        key: ValueKey('existing_${trans.iso639_1}_${trans.iso3166_1}'),
        initiallyExpanded: false,
        tilePadding: AppSpacing.edgeInsetsHMd,
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          if (displayTitle.isNotEmpty)
            _buildCopyableTextRow(displayTitle, isTitle: true),
          if (displayTitle.isNotEmpty && trans.description.isNotEmpty)
            AppSpacing.gapSm,
          if (trans.description.isNotEmpty)
            _buildCopyableTextRow(trans.description),
        ],
      ),
    );
  }

  Widget _buildTranslationCard(
    TmdbTranslation trans, {
    bool showUseAsSource = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final displayTitle = trans.translatedTitle.isNotEmpty
        ? trans.translatedTitle
        : widget.translationContext.originalTitle;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Padding(
        padding: AppSpacing.edgeInsetsAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trans.englishName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (trans.name.isNotEmpty &&
                          trans.name != trans.englishName)
                        Text(
                          '${trans.name} ${trans.iso639_1}-${trans.iso3166_1}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                if (showUseAsSource)
                  IconButton(
                    icon: const Icon(Icons.auto_awesome),
                    tooltip: l10n.autoTranslation,
                    onPressed: () {
                      context
                          .read<WebTranslationService>()
                          .setSourceLanguageCode(trans.iso639_1);
                      _performTranslation();
                      _scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
              ],
            ),
            AppSpacing.gapSm,
            if (displayTitle.isNotEmpty)
              _buildCopyableTextRow(displayTitle, isTitle: true),
            if (displayTitle.isNotEmpty && trans.description.isNotEmpty)
              AppSpacing.gapSm,
            if (trans.description.isNotEmpty)
              _buildCopyableTextRow(trans.description),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final validTranslations = widget.translations
        .where((t) => t.description.isNotEmpty || t.translatedTitle.isNotEmpty)
        .toList();
    validTranslations.sort((a, b) => a.englishName.compareTo(b.englishName));

    final service = context.watch<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    final targetCode = service.targetLanguageCode;
    final targetTranslations =
        targetCode.toLowerCase() == sourceCode.toLowerCase()
            ? const <TmdbTranslation>[]
            : _findExistingTargetTranslations(validTranslations, targetCode);
    final otherTranslations = validTranslations
        .where(
          (t) =>
              t.iso639_1.toLowerCase() != sourceCode.toLowerCase() &&
              !targetTranslations.contains(t),
        )
        .toList();

    final l10n = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translations),
        actions: [
          EditButton(url: widget.editUrl),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.maxContentWidth,
            ),
            child: validTranslations.isEmpty
                ? Center(
                    child: AppEmptyState(
                      imageAsset: 'assets/empty-search.png',
                      title: l10n.emptyList,
                    ),
                  )
                : ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    children: [
                      _buildMagicCard(),
                      for (final trans in targetTranslations)
                        _buildExistingTargetTile(
                          trans,
                          showVariant: targetTranslations.length > 1,
                        ),
                      _buildSourceCard(),
                      if (otherTranslations.isNotEmpty) ...[
                        AppSpacing.gapSm,
                        Divider(
                          height: 1,
                          color: customColors.dividerColor,
                        ),
                        ExpansionTile(
                          initiallyExpanded: false,
                          tilePadding: AppSpacing.edgeInsetsHLg,
                          shape: const Border(),
                          collapsedShape: const Border(),
                          title: Text(
                            l10n.otherTranslations(otherTranslations.length),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          children: otherTranslations
                              .map(
                                (trans) => _buildTranslationCard(
                                  trans,
                                  showUseAsSource: true,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
