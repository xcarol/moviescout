import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/app_error_view.dart';
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
import 'package:moviescout/core/models/translations_pager.dart';
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
  final TranslationsPager? pager;

  const TranslationsScreen({
    super.key,
    required this.translations,
    required this.editUrl,
    required this.translationContext,
    this.pager,
  });

  @override
  State<TranslationsScreen> createState() => TranslationsScreenState();
}

class TranslationsScreenState extends State<TranslationsScreen> {
  late int _currentIndex;
  PageController? _pageController;
  final Map<int, TranslationPageData> _loadedPages = {};
  final Set<int> _loadingPages = {};
  final Set<int> _errorPages = {};

  @override
  void initState() {
    super.initState();
    final pager = widget.pager;
    _currentIndex =
        pager != null ? pager.initialIndex.clamp(0, pager.itemCount - 1) : 0;
    _loadedPages[_currentIndex] = TranslationPageData(
      translations: widget.translations,
      editUrl: widget.editUrl,
      translationContext: widget.translationContext,
    );

    if (pager != null && pager.itemCount > 1) {
      _pageController = PageController(initialPage: _currentIndex);
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _loadPageIfNeeded(int index, {bool force = false}) async {
    final pager = widget.pager;
    if (pager == null) return;
    if (!force &&
        (_loadedPages.containsKey(index) ||
            _loadingPages.contains(index) ||
            _errorPages.contains(index))) {
      return;
    }

    _loadingPages.add(index);
    if (force && mounted) {
      setState(() {
        _errorPages.remove(index);
      });
    }

    try {
      final data = await pager.loadPage(index);
      if (!mounted) return;
      setState(() {
        _loadingPages.remove(index);
        if (data != null) {
          _loadedPages[index] = data;
          _errorPages.remove(index);
        } else {
          _errorPages.add(index);
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingPages.remove(index);
        _errorPages.add(index);
      });
    }
  }

  Widget _buildPageWrapper(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoints.maxContentWidth,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final targetCode =
        context.watch<WebTranslationService>().targetLanguageCode;
    final pager = widget.pager;
    final currentPage = _loadedPages[_currentIndex];
    final subtitle = pager?.pageTitleBuilder?.call(_currentIndex, l10n);

    return Scaffold(
      appBar: AppBar(
        title: subtitle != null && subtitle.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.translations),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            : Text(l10n.translations),
        actions: [
          if (currentPage != null)
            EditButton(
              url: currentPage.editUrl,
              targetLanguageCode: targetCode,
            ),
        ],
      ),
      body: SafeArea(
        child: pager == null || pager.itemCount <= 1
            ? _buildPageWrapper(
                _TranslationPageContent(
                  pageData: _loadedPages[_currentIndex]!,
                ),
              )
            : PageView.builder(
                controller: _pageController,
                itemCount: pager.itemCount,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _loadPageIfNeeded(index);
                },
                itemBuilder: (context, index) {
                  final pageData = _loadedPages[index];
                  if (pageData != null) {
                    return _buildPageWrapper(
                      _TranslationPageContent(
                        key: ValueKey('translation_page_$index'),
                        pageData: pageData,
                      ),
                    );
                  }
                  if (_errorPages.contains(index)) {
                    return _buildPageWrapper(
                      Center(
                        child: AppErrorView(
                          title: l10n.errorMessageGeneric,
                          message: l10n.networkErrorMessage,
                          onRetry: () => _loadPageIfNeeded(index, force: true),
                        ),
                      ),
                    );
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _loadPageIfNeeded(index);
                    }
                  });
                  return const Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }
}

class _TranslationCandidate {
  final String title;
  final String description;
  final String? modelId;
  final String? thinkingLevel;

  const _TranslationCandidate({
    required this.title,
    required this.description,
    this.modelId,
    this.thinkingLevel,
  });
}

class _TranslationPageContent extends StatefulWidget {
  final TranslationPageData pageData;

  const _TranslationPageContent({
    super.key,
    required this.pageData,
  });

  @override
  State<_TranslationPageContent> createState() =>
      _TranslationPageContentState();
}

class _TranslationPageContentState extends State<_TranslationPageContent>
    with AutomaticKeepAliveClientMixin {
  final List<_TranslationCandidate> _candidates = [];
  int _selectedCandidateIndex = 0;
  String? _translationError;
  String? _selectedAiModel;
  String? _selectedThinkingLevel;

  bool _isTranslating = false;
  final ScrollController _scrollController = ScrollController();

  String? _lastSourceCode;
  String? _lastTargetCode;
  bool? _lastAiActive;

  _TranslationCandidate? get _currentCandidate => (_candidates.isNotEmpty &&
          _selectedCandidateIndex >= 0 &&
          _selectedCandidateIndex < _candidates.length)
      ? _candidates[_selectedCandidateIndex]
      : null;

  String get _translatedTitle => _currentCandidate?.title ?? '';
  String get _translatedDescription => _currentCandidate?.description ?? '';

  void _clearCandidates() {
    _candidates.clear();
    _selectedCandidateIndex = 0;
    _translationError = null;
  }

  @override
  bool get wantKeepAlive => true;

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
    _lastSourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    _lastTargetCode = service.targetLanguageCode;
    _lastAiActive = isAiActive;
    if (!isAiActive) {
      _performTranslation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = context.watch<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    final targetCode = service.targetLanguageCode;
    final isAiActive = AiService().hasApiKey && service.isAiTranslationEnabled;

    if (sourceCode != _lastSourceCode ||
        targetCode != _lastTargetCode ||
        isAiActive != _lastAiActive) {
      _lastSourceCode = sourceCode;
      _lastTargetCode = targetCode;
      _lastAiActive = isAiActive;

      _clearCandidates();
      if (!isAiActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _performTranslation();
          }
        });
      }
    }
  }

  String _getEffectiveSourceCode(String serviceSourceCode) {
    var sourceCode = serviceSourceCode;
    final uniqueSourceCodes = <String>{};
    for (var t in widget.pageData.translations) {
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
    final isAiActive = AiService().hasApiKey && service.isAiTranslationEnabled;
    final provider = AiService().currentProvider;
    final models = provider.selectableModels;
    final effectiveModel =
        (_selectedAiModel != null && models.contains(_selectedAiModel))
            ? _selectedAiModel!
            : provider.selectedModel;
    final defaultThinking =
        provider.defaultThinkingLevelForModel(effectiveModel);
    final rawThinking =
        _selectedThinkingLevel ?? provider.selectedThinkingLevel;
    final effectiveThinking =
        AiModelThinkingSelector.thinkingOptions.contains(rawThinking)
            ? rawThinking
            : (AiModelThinkingSelector.thinkingOptions.contains(defaultThinking)
                ? defaultThinking
                : 'low');
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);

    String sourceTitle = widget.pageData.translationContext.originalTitle;
    String sourceDesc = widget.pageData.translationContext.originalDescription;

    final matches =
        widget.pageData.translations.where((t) => t.iso639_1 == sourceCode);
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
        translationContext: widget.pageData.translationContext,
        model: _selectedAiModel,
        thinkingLevel: _selectedThinkingLevel,
      );

      if (mounted) {
        setState(() {
          final candidate = _TranslationCandidate(
            title: result.title,
            description: result.description,
            modelId: isAiActive ? effectiveModel : null,
            thinkingLevel: isAiActive ? effectiveThinking : null,
          );
          if (isAiActive) {
            _candidates.add(candidate);
            _selectedCandidateIndex = _candidates.length - 1;
          } else {
            _candidates
              ..clear()
              ..add(candidate);
            _selectedCandidateIndex = 0;
          }
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
        _clearCandidates();
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
    for (final t in widget.pageData.translations) {
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
                      _clearCandidates();
                    });
                  } else {
                    _clearCandidates();
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
        (_translatedTitle.isNotEmpty || _translatedDescription.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AiModelThinkingSelector(
          selectedModel: _selectedAiModel,
          selectedThinkingLevel: _selectedThinkingLevel,
          showApplyTranslation: widget.pageData.editUrl.isNotEmpty,
          applyTranslationTooltip: l10n.applyTranslationToTmdb,
          onApplyTranslation: canApplyToTmdb
              ? () => context.toTmdbEditWebView(
                    editUrl: widget.pageData.editUrl,
                    targetLanguageCode: targetCode,
                    contentType: widget.pageData.translationContext.type,
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

  Widget _buildCandidateHistoryBar() {
    if (_candidates.length <= 1) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final current = _currentCandidate;
    final provider = AiService().currentProvider;

    String metadataLabel = '';
    if (current?.modelId != null && current!.modelId!.isNotEmpty) {
      final modelLabel = provider.modelDisplayLabel(current.modelId!, l10n);
      if (current.thinkingLevel != null && current.thinkingLevel!.isNotEmpty) {
        final thinkingLabel = AiModelThinkingSelector.thinkingDisplayLabel(
          current.thinkingLevel!,
          l10n,
        );
        metadataLabel = '$modelLabel · $thinkingLabel';
      } else {
        metadataLabel = modelLabel;
      }
    }

    final canGoPrev = _selectedCandidateIndex > 0;
    final canGoNext = _selectedCandidateIndex < _candidates.length - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metadataLabel,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            borderRadius: AppRadius.borderXs,
            onTap: canGoPrev
                ? () => setState(() => _selectedCandidateIndex--)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: Icon(
                Icons.chevron_left,
                size: 18,
                color: canGoPrev
                    ? colorScheme.onSurface
                    : colorScheme.outlineVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              '${_selectedCandidateIndex + 1} / ${_candidates.length}',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            borderRadius: AppRadius.borderXs,
            onTap: canGoNext
                ? () => setState(() => _selectedCandidateIndex++)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: canGoNext
                    ? colorScheme.onSurface
                    : colorScheme.outlineVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationResult() {
    final hasCandidateContent =
        _translatedTitle.isNotEmpty || _translatedDescription.isNotEmpty;
    final hasContent =
        _isTranslating || _translationError != null || hasCandidateContent;
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
        else ...[
          if (_translationError != null) ...[
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
            ),
            if (hasCandidateContent) AppSpacing.gapSm,
          ],
          if (hasCandidateContent) ...[
            _buildCandidateHistoryBar(),
            if (_translatedTitle.isNotEmpty)
              _buildCopyableTextRow(_translatedTitle, isTitle: true),
            if (_translatedTitle.isNotEmpty &&
                _translatedDescription.isNotEmpty)
              AppSpacing.gapSm,
            if (_translatedDescription.isNotEmpty)
              _buildCopyableTextRow(_translatedDescription),
          ],
        ],
      ],
    );
  }

  Widget _buildSourceCard() {
    final service = context.watch<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);
    final sourceName = TranslationLanguages.supportedLanguages[sourceCode] ??
        sourceCode.toUpperCase();

    String sourceTitle = widget.pageData.translationContext.originalTitle;
    String sourceDesc = widget.pageData.translationContext.originalDescription;

    final matches =
        widget.pageData.translations.where((t) => t.iso639_1 == sourceCode);
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
        : widget.pageData.translationContext.originalTitle;
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
        : widget.pageData.translationContext.originalTitle;

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
    super.build(context);
    final validTranslations = widget.pageData.translations
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

    if (validTranslations.isEmpty) {
      return Center(
        child: AppEmptyState(
          imageAsset: 'assets/empty-search.png',
          title: l10n.emptyList,
        ),
      );
    }

    return ListView(
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
    );
  }
}
