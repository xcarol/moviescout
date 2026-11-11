import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';

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
    context.toTranslations(
      translations: translations,
      originalTitle: widget.originalTitle,
      originalDescription: widget.originalDescription,
      editUrl: widget.editUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<AppService>(context).showEditContent) {
      return const SizedBox.shrink();
    }

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: SizedBox(
          width: AppSizes.iconMd,
          height: AppSizes.iconMd,
          child: CircularProgressIndicator(strokeWidth: AppSizes.strokeWidthSm),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.translate, size: AppSizes.iconMd),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
          SnackMessage.showSnackBar(
            AppLocalizations.of(context)!.errorMessageGeneric,
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
