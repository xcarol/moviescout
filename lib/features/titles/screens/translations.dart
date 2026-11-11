import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
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
    Future.delayed(AppDurations.feedback, () {
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
            padding: const EdgeInsets.all(AppSpacing.micro),
            child: Icon(
              _copied ? Icons.check : Icons.copy,
              size: AppSizes.iconMd,
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
  final String originalTitle;
  final String originalDescription;
  final String editUrl;

  const TranslationsScreen({
    super.key,
    required this.translations,
    required this.originalTitle,
    required this.originalDescription,
    required this.editUrl,
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

    String sourceTitle = widget.originalTitle;
    String sourceDesc = widget.originalDescription;

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
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.borderSm,
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
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: AppSizes.iconMd),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.autoTranslation,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Symbols.wand_stars, size: AppSizes.iconMd),
                    const SizedBox(width: AppSpacing.xs),
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
            const SizedBox(height: AppSpacing.xs),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useRow =
                    constraints.maxWidth > AppBreakpoints.inlineDropdown;
                final sourceDropdown = DropdownSelector(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: AppRadius.borderXs,
                  selectedOption: selectedSourceOption,
                  options: sourceOptions,
                  maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
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
                  borderRadius: AppRadius.borderXs,
                  selectedOption: selectedTargetOption,
                  options: targetOptions,
                  maxMenuHeight: AppSizes.dropdownMaxMenuHeight,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        child: Icon(Icons.arrow_forward, size: AppSizes.iconSm),
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
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child:
                            Icon(Icons.arrow_downward, size: AppSizes.iconSm),
                      ),
                      targetDropdown,
                    ],
                  );
                }
              },
            ),
            if (isAiActive) ...[
              const SizedBox(height: AppSpacing.xs),
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
              const SizedBox(height: AppSpacing.sm),
            if (_isTranslating)
              const Center(child: CircularProgressIndicator())
            else if (_translationError != null)
              Container(
                padding: AppSpacing.chipPadding,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppSizes.iconMd,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: AppSpacing.xs),
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
                    const SizedBox(height: AppSpacing.xs),
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

    String sourceTitle = widget.originalTitle;
    String sourceDesc = widget.originalDescription;

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
      margin: AppSpacing.screenHorizontal,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${AppLocalizations.of(context)!.originalText} ($sourceName)",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.xs),
            if (sourceTitle.isNotEmpty)
              _buildCopyableTextRow(sourceTitle, isTitle: true),
            if (sourceTitle.isNotEmpty && sourceDesc.isNotEmpty)
              const SizedBox(height: AppSpacing.xs),
            if (sourceDesc.isNotEmpty) _buildCopyableTextRow(sourceDesc),
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
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translations),
        actions: [
          EditButton(url: widget.editUrl),
        ],
      ),
      body: validTranslations.isEmpty
          ? AppEmptyState(
              icon: Icons.translate,
              message: AppLocalizations.of(context)!.emptyList,
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: validTranslations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          _buildMagicCard(),
                          _buildSourceCard(),
                          Divider(
                            height: AppSizes.borderWidthRegular,
                            color: customColors.dividerColor,
                          ),
                        ],
                      );
                    }

                    final trans = validTranslations[index - 1];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          child: Padding(
                            padding: AppSpacing.screenPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trans.englishName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (trans.name.isNotEmpty &&
                                              trans.name != trans.englishName)
                                            Text(
                                              '${trans.name} ${trans.iso639_1}-${trans.iso3166_1}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.auto_awesome),
                                      tooltip: AppLocalizations.of(context)!
                                          .autoTranslation,
                                      onPressed: () {
                                        context
                                            .read<WebTranslationService>()
                                            .setSourceLanguageCode(
                                                trans.iso639_1);
                                        _performTranslation();
                                        _scrollController.animateTo(
                                          0.0,
                                          duration: AppDurations.normal,
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                _buildCopyableTextRow(
                                  trans.translatedTitle.isNotEmpty
                                      ? trans.translatedTitle
                                      : widget.originalTitle,
                                  isTitle: true,
                                ),
                                if (trans.description.isNotEmpty) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  _buildCopyableTextRow(trans.description),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: AppSizes.borderWidthRegular,
                          color: customColors.dividerColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
