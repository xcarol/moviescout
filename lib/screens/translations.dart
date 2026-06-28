import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/widgets/edit_button.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/web_translation_service.dart';
import 'package:moviescout/utils/translation_languages.dart';

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
          borderRadius: BorderRadius.circular(4),
          onTap: _copy,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              _copied ? Icons.check : Icons.copy,
              size: 20,
              color: _copied
                  ? Colors.green
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
    _performTranslation();
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
    });

    final service = context.read<WebTranslationService>();
    final sourceCode = _getEffectiveSourceCode(service.sourceLanguageCode);

    String sourceTitle = widget.originalTitle;
    String sourceDesc = widget.originalDescription;

    try {
      final sourceTrans =
          widget.translations.firstWhere((t) => t.iso639_1 == sourceCode);
      if (sourceTrans.translatedTitle.isNotEmpty) {
        sourceTitle = sourceTrans.translatedTitle;
      }
      if (sourceTrans.description.isNotEmpty) {
        sourceDesc = sourceTrans.description;
      }
    } catch (e) {
      // not found
    }

    final translatedTitle = await service.translate(sourceTitle);
    final translatedDesc = await service.translate(sourceDesc);

    if (mounted) {
      setState(() {
        _translatedTitle = translatedTitle;
        _translatedDescription = translatedDesc;
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
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useRow = constraints.maxWidth > 350.0;
                final sourceDropdown = DropdownSelector(
                  selectedOption: selectedSourceOption,
                  options: sourceOptions,
                  maxMenuHeight: 300,
                  isExpanded: true,
                  onSelected: (val) {
                    final code = uniqueSourceCodes.entries
                        .firstWhere((e) => e.value == val)
                        .key;
                    service.setSourceLanguageCode(code);
                    _performTranslation();
                  },
                );

                final targetDropdown = DropdownSelector(
                  selectedOption: selectedTargetOption,
                  options: targetOptions,
                  maxMenuHeight: 300,
                  isExpanded: true,
                  onSelected: (val) {
                    final code = TranslationLanguages.supportedLanguages.entries
                        .firstWhere((e) => e.value == val)
                        .key;
                    service.setTargetLanguageCode(code);
                    _performTranslation();
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
            const SizedBox(height: 12),
            if (_isTranslating)
              const Center(child: CircularProgressIndicator())
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

    String sourceTitle = widget.originalTitle;
    String sourceDesc = widget.originalDescription;

    try {
      final sourceTrans =
          widget.translations.firstWhere((t) => t.iso639_1 == sourceCode);
      if (sourceTrans.translatedTitle.isNotEmpty) {
        sourceTitle = sourceTrans.translatedTitle;
      }
      if (sourceTrans.description.isNotEmpty) {
        sourceDesc = sourceTrans.description;
      }
    } catch (e) {
      // not found
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
          ? Center(
              child: Text(AppLocalizations.of(context)!.emptyList),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: validTranslations.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _buildMagicCard(),
                      _buildSourceCard(),
                      Divider(
                        height: 1,
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
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                                    .onSurfaceVariant)),
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
                                        .setSourceLanguageCode(trans.iso639_1);
                                    _performTranslation();
                                    _scrollController.animateTo(
                                      0.0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildCopyableTextRow(
                                trans.translatedTitle.isNotEmpty
                                    ? trans.translatedTitle
                                    : widget.originalTitle,
                                isTitle: true),
                            if (trans.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildCopyableTextRow(trans.description),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: customColors.dividerColor,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
