import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/services/edit_settings_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TranslationsButton extends StatefulWidget {
  final Future<List<TmdbTranslation>> Function() fetchTranslations;

  const TranslationsButton({super.key, required this.fetchTranslations});

  @override
  State<TranslationsButton> createState() => _TranslationsButtonState();
}

class _TranslationsButtonState extends State<TranslationsButton> {
  bool _isLoading = false;

  void _showTranslationsBottomSheet(
      BuildContext context, List<TmdbTranslation> translations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _TranslationsBottomSheet(translations: translations);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<EditSettingsService>(context).showEditContent) {
      return const SizedBox.shrink();
    }

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.translate, size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        try {
          final translations = await widget.fetchTranslations();
          if (!context.mounted) return;
          _showTranslationsBottomSheet(context, translations);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.errorMessageGeneric)),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }
}

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
    return IconButton(
      icon: Icon(
        _copied ? Icons.check : Icons.copy,
        size: 20,
        color: _copied ? Colors.green : null,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: _copy,
      tooltip: _copied ? AppLocalizations.of(context)!.copiedToClipboard : null,
    );
  }
}

class _TranslationsBottomSheet extends StatelessWidget {
  final List<TmdbTranslation> translations;

  const _TranslationsBottomSheet({required this.translations});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        final validTranslations = translations
            .where(
                (t) => t.description.isNotEmpty || t.translatedTitle.isNotEmpty)
            .toList();
        validTranslations
            .sort((a, b) => a.englishName.compareTo(b.englishName));

        if (validTranslations.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.emptyList),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translations,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: validTranslations.length,
                itemBuilder: (context, index) {
                  final trans = validTranslations[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                                '${trans.englishName} (${trans.iso639_1}-${trans.iso3166_1})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          if (trans.translatedTitle.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(trans.translatedTitle,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))),
                                  _CopyIconButton(
                                      textToCopy: trans.translatedTitle),
                                ],
                              ),
                            ),
                          if (trans.translatedTitle.isNotEmpty &&
                              trans.description.isNotEmpty)
                            const SizedBox(height: 8),
                          if (trans.description.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(trans.description,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis)),
                                  _CopyIconButton(
                                      textToCopy: trans.description),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
