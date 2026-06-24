import 'package:flutter/material.dart';
import 'package:moviescout/utils/translation_languages.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class TranslationLanguageForm extends StatefulWidget {
  static const String keySource = 'source';
  static const String keyTarget = 'target';
  static const double minRowWidth = 350.0;

  const TranslationLanguageForm({
    super.key,
    required this.sourceLanguageCode,
    required this.targetLanguageCode,
  });

  final String sourceLanguageCode;
  final String targetLanguageCode;

  @override
  State<TranslationLanguageForm> createState() =>
      _TranslationLanguageFormState();
}

class _TranslationLanguageFormState extends State<TranslationLanguageForm> {
  late String _sourceCode;
  late String _targetCode;

  @override
  void initState() {
    super.initState();
    _sourceCode = widget.sourceLanguageCode;
    _targetCode = widget.targetLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    final languages = TranslationLanguages.supportedLanguages.entries.toList();
    languages.sort((a, b) => a.value.compareTo(b.value));

    final List<DropdownMenuItem<String>> items = languages
        .map((lang) => DropdownMenuItem(
              value: lang.key,
              child: Text(
                lang.value,
                overflow: TextOverflow.ellipsis,
              ),
            ))
        .toList();

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.autoTranslation,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.selectLanguages),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool useRow = constraints.maxWidth >
                      TranslationLanguageForm.minRowWidth;

                  final sourceDropdown = DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.sourceLanguage,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    isExpanded: true,
                    initialValue: _sourceCode,
                    items: items,
                    onChanged: (val) {
                      if (val != null) setState(() => _sourceCode = val);
                    },
                  );

                  final targetDropdown = DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.targetLanguage,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    isExpanded: true,
                    initialValue: _targetCode,
                    items: items,
                    onChanged: (val) {
                      if (val != null) setState(() => _targetCode = val);
                    },
                  );

                  if (useRow) {
                    return Row(
                      children: [
                        Expanded(child: sourceDropdown),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.arrow_forward,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Expanded(child: targetDropdown),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sourceDropdown,
                        const SizedBox(height: 16),
                        Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        targetDropdown,
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              TranslationLanguageForm.keySource: _sourceCode,
              TranslationLanguageForm.keyTarget: _targetCode,
            });
          },
          child: Text(AppLocalizations.of(context)!.select),
        ),
      ],
    );
  }
}
