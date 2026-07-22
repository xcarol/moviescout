import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/services/edit_settings_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/screens/translations.dart';

class TranslationsButton extends StatefulWidget {
  final Future<List<TmdbTranslation>> Function() fetchTranslations;
  final String originalTitle;
  final String originalDescription;
  final String editUrl;

  const TranslationsButton({
    super.key,
    required this.fetchTranslations,
    required this.originalTitle,
    required this.originalDescription,
    required this.editUrl,
  });

  @override
  State<TranslationsButton> createState() => _TranslationsButtonState();
}

class _TranslationsButtonState extends State<TranslationsButton> {
  bool _isLoading = false;

  void _showTranslationsScreen(
      BuildContext context, List<TmdbTranslation> translations) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TranslationsScreen(
          translations: translations,
          originalTitle: widget.originalTitle,
          originalDescription: widget.originalDescription,
          editUrl: widget.editUrl,
        ),
      ),
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
          _showTranslationsScreen(context, translations);
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
