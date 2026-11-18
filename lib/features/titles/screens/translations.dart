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
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/models/translation_context.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _requestMissingPrompt(
    String targetName,
    String targetCode,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final subject = l10n.aiPromptRequestSubject(targetName, targetCode);
    final body = l10n.aiPromptRequestBody(targetName, targetCode);
    final mailtoUri = Uri(
      scheme: 'mailto',
      path: UrlConstants.contactEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openAiSettings(
    WebTranslationService service, {
    bool enableIfConfigured = false,
  }) async {
    await context.toAiSettings();
    if (!mounted) return;

    final hasKey = AiService().hasApiKey;
    if (enableIfConfigured && hasKey) {
      await service.setAiTranslationEnabled(true);
    }

    if (!mounted) return;
    setState(() {
      _selectedAiModel = null;
      _selectedThinkingLevel = null;
      if (enableIfConfigured && hasKey) {
        _translatedTitle = '';
        _translatedDescription = '';
        _translationError = null;
      }
    });

    if (!hasKey &&
        !_isTranslating &&
        _translatedTitle.isEmpty &&
        _translatedDescription.isEmpty) {
      _performTranslation();
    }
  }

  Map<String, String> _buildUniqueSourceCodes() {
    final uniqueSourceCodes = <String, String>{};
    for (final t in widget.translations) {
      if (t.description.isNotEmpty || t.translatedTitle.isNotEmpty) {
        uniqueSourceCodes[t.iso639_1] = t.englishName;
      }
    }
    return uniqueSourceCodes;
  }

  Widget _buildMagicCard() {
    final service = context.watch<WebTranslationService>();
    final targetCode = service.targetLanguageCode;
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    final uniqueSourceCodes = _buildUniqueSourceCodes();
    final isAiActive = AiService().hasApiKey && service.isAiTranslationEnabled;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Padding(
        padding: AppSpacing.edgeInsetsAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMagicCardHeader(service, isAiActive),
            AppSpacing.gapSm,
            _buildLanguageSelectors(
              service: service,
              uniqueSourceCodes: uniqueSourceCodes,
              sourceCode: sourceCode,
              targetCode: targetCode,
              isAiActive: isAiActive,
            ),
            if (isAiActive) ...[
              AppSpacing.gapSm,
              _buildAiConfigurationSection(targetCode),
            ],
            _buildTranslationResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildMagicCardHeader(
    WebTranslationService service,
    bool isAiActive,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const Icon(Icons.auto_awesome, size: 20),
        AppSpacing.gapSm,
        Expanded(
          child: Text(
            l10n.autoTranslation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Tooltip(
              message: l10n.aiSettingsTitle,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: AppRadius.borderXs,
                  onTap: () => _openAiSettings(service),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                      borderRadius: AppRadius.borderXs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Symbols.wand_stars, size: 20),
                        AppSpacing.gapXs,
                        Text(
                          l10n.enableAiTranslation,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.gapXs,
            Switch(
              value: isAiActive,
              onChanged: (val) {
                if (val && !AiService().hasApiKey) {
                  _openAiSettings(service, enableIfConfigured: true);
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
    );
  }

  Widget _buildLanguageSelectors({
    required WebTranslationService service,
    required Map<String, String> uniqueSourceCodes,
    required String sourceCode,
    required String targetCode,
    required bool isAiActive,
  }) {
    final sourceOptions = uniqueSourceCodes.values.toList()..sort();
    final targetOptions =
        TranslationLanguages.supportedLanguages.values.toList()..sort();

    final selectedSourceOption = uniqueSourceCodes[sourceCode] ??
        (sourceOptions.isNotEmpty ? sourceOptions.first : '');
    final selectedTargetOption =
        TranslationLanguages.supportedLanguages[targetCode] ?? '';

    final sourceDropdown = _buildLanguageDropdown(
      selectedOption: selectedSourceOption,
      options: sourceOptions,
      onSelected: (val) {
        final code =
            uniqueSourceCodes.entries.firstWhere((e) => e.value == val).key;
        service.setSourceLanguageCode(code);
        if (!isAiActive) {
          _performTranslation();
        }
      },
    );

    final targetDropdown = _buildLanguageDropdown(
      selectedOption: selectedTargetOption,
      options: targetOptions,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 350.0) {
          return Row(
            children: [
              Expanded(child: sourceDropdown),
              const Padding(
                padding: AppSpacing.edgeInsetsHSm,
                child: Icon(Icons.arrow_forward, size: 16),
              ),
              Expanded(child: targetDropdown),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sourceDropdown,
            const Padding(
              padding: AppSpacing.edgeInsetsVSm,
              child: Icon(Icons.arrow_downward, size: 16),
            ),
            targetDropdown,
          ],
        );
      },
    );
  }

  Widget _buildLanguageDropdown({
    required String selectedOption,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return DropdownSelector(
      border: Border.all(
        color: Theme.of(context).colorScheme.secondary,
      ),
      borderRadius: AppRadius.borderXs,
      selectedOption: selectedOption,
      options: options,
      maxMenuHeight: 300,
      isExpanded: true,
      onSelected: onSelected,
    );
  }

  Widget _buildAiConfigurationSection(String targetCode) {
    final l10n = AppLocalizations.of(context)!;
    final canApplyToTmdb = !_isTranslating &&
        _translationError == null &&
        (_translatedTitle.isNotEmpty || _translatedDescription.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AiModelThinkingSelector(
          selectedModel: _selectedAiModel,
          selectedThinkingLevel: _selectedThinkingLevel,
          showApplyTranslation: widget.editUrl.isNotEmpty,
          applyTranslationTooltip: l10n.applyTranslationToTmdb,
          onApplyTranslation: canApplyToTmdb
              ? () => context.toTmdbEditWebView(
                    editUrl: widget.editUrl,
                    targetLanguageCode: targetCode,
                    contentType: widget.translationContext.type,
                    translatedTitle: _translatedTitle,
                    translatedDescription: _translatedDescription,
                  )
              : null,
          onChanged: (model, thinkingLevel) {
            setState(() {
              _selectedAiModel = model;
              _selectedThinkingLevel = thinkingLevel;
            });
          },
          onRefresh: _performTranslation,
        ),
        if (!AiService().hasPromptForLanguage(targetCode)) ...[
          AppSpacing.gapSm,
          _buildMissingPromptNotice(targetCode),
        ],
      ],
    );
  }

  Widget _buildMissingPromptNotice(String targetCode) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final targetName =
        TranslationLanguages.supportedLanguages[targetCode] ?? targetCode;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppRadius.borderXs,
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          AppSpacing.gapSm,
          Expanded(
            child: Text(
              l10n.aiPromptMissingLanguage(targetName),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          AppSpacing.gapSm,
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => _requestMissingPrompt(targetName, targetCode),
            icon: const Icon(Icons.mail_outline, size: 16),
            label: Text(l10n.aiPromptRequestButton),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationResult() {
    final hasContent = _isTranslating ||
        _translationError != null ||
        _translatedTitle.isNotEmpty ||
        _translatedDescription.isNotEmpty;
    if (!hasContent) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapMd,
        if (_isTranslating)
          const Center(child: CircularProgressIndicator())
        else if (_translationError != null)
          Container(
            padding: AppSpacing.edgeInsetsAllSm,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: AppRadius.borderSm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20,
                  color: colorScheme.onErrorContainer,
                ),
                AppSpacing.gapSm,
                Expanded(
                  child: Text(
                    _translationError!,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          )
        else ...[
          if (_translatedTitle.isNotEmpty)
            _buildCopyableTextRow(_translatedTitle, isTitle: true),
          if (_translatedTitle.isNotEmpty && _translatedDescription.isNotEmpty)
            AppSpacing.gapSm,
          if (_translatedDescription.isNotEmpty)
            _buildCopyableTextRow(_translatedDescription),
        ],
      ],
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
          EditButton(
            url: widget.editUrl,
            targetLanguageCode: targetCode,
          ),
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
