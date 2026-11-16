import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/models/translation_context.dart';

class TranslationsButton extends StatefulWidget {
  final Future<List<TmdbTranslation>> Function() fetchTranslations;
  final String editUrl;
  final TranslationContext translationContext;

  const TranslationsButton({
    super.key,
    required this.fetchTranslations,
    required this.editUrl,
    required this.translationContext,
  });

  @override
  State<TranslationsButton> createState() => _TranslationsButtonState();
}

class _TranslationsButtonState extends State<TranslationsButton> {
  bool _isLoading = false;

  void _showTranslationsScreen(
      BuildContext context, List<TmdbTranslation> translations) {
    context.toTranslations(
      translations: translations,
      editUrl: widget.editUrl,
      translationContext: widget.translationContext,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<AppService>(context).showEditContent) {
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
