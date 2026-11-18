import 'package:material_ui/material_ui.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/core/models/translations_pager.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/models/translation_context.dart';

class ActionMenu extends StatelessWidget {
  final String? editUrl;
  final Future<List<TmdbTranslation>> Function()? fetchTranslations;
  final TranslationContext? translationContext;
  final TranslationsPager? translationsPager;
  final String? shareUrl;
  final VoidCallback? onPin;

  const ActionMenu({
    super.key,
    this.editUrl,
    this.fetchTranslations,
    this.translationContext,
    this.translationsPager,
    this.shareUrl,
    this.onPin,
  });

  void _openEditUrl(BuildContext context) {
    if (editUrl == null) return;
    context.toTmdbEditWebView(editUrl: editUrl!);
  }

  Future<void> _fetchTranslations(BuildContext context) async {
    if (fetchTranslations == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final translations = await fetchTranslations!();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      context.toTranslations(
        translations: translations,
        editUrl: editUrl ?? '',
        translationContext: translationContext ??
            const TranslationContext(type: TranslationContentType.movie),
        translationsPager: translationsPager,
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.errorMessageGeneric)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showEdit = Provider.of<AppService>(context).showEditContent;
    final hasEdit = showEdit && editUrl != null;
    final hasTranslations = showEdit && fetchTranslations != null;
    final hasPin = onPin != null;
    final hasShare = shareUrl != null;

    if (!hasEdit && !hasTranslations && !hasPin && !hasShare) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            _openEditUrl(context);
            break;
          case 'translations':
            await _fetchTranslations(context);
            break;
          case 'pin':
            if (onPin != null) onPin!();
            break;
          case 'share':
            if (shareUrl != null) {
              SharePlus.instance.share(ShareParams(uri: Uri.parse(shareUrl!)));
            }
            break;
        }
      },
      itemBuilder: (context) {
        final loc = AppLocalizations.of(context)!;
        return [
          if (hasEdit)
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: Text(loc.edit),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (hasTranslations)
            PopupMenuItem(
              value: 'translations',
              child: ListTile(
                leading: const Icon(Icons.translate),
                title: Text(loc.translations),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (hasPin)
            PopupMenuItem(
              value: 'pin',
              child: ListTile(
                leading: const Icon(Icons.add_to_home_screen),
                title: Text(loc.addToHomeScreen),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (hasShare)
            PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: const Icon(Icons.share),
                title: Text(loc.shareLink),
                contentPadding: EdgeInsets.zero,
              ),
            ),
        ];
      },
    );
  }
}
