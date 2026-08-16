import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/settings/edit_settings_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/settings/region_service.dart';
import 'package:moviescout/models/tmdb_translation.dart';
import 'package:moviescout/screens/translations.dart';

class ActionMenu extends StatelessWidget {
  final String? editUrl;
  final Future<List<TmdbTranslation>> Function()? fetchTranslations;
  final String? originalTitle;
  final String? originalDescription;
  final String? shareUrl;
  final VoidCallback? onPin;

  const ActionMenu({
    super.key,
    this.editUrl,
    this.fetchTranslations,
    this.originalTitle,
    this.originalDescription,
    this.shareUrl,
    this.onPin,
  });

  void _openEditUrl() {
    if (editUrl == null) return;
    final languageCode = LanguageService().locale.languageCode;
    final countryCode = RegionService().currentRegion ??
        LanguageService().locale.countryCode ??
        "US";
    final localeStr = '$languageCode-$countryCode';

    final separator = editUrl!.contains('?') ? '&' : '?';
    final finalUrl = '$editUrl$separator' 'language=$localeStr';

    launchUrl(
      Uri.parse(finalUrl),
      mode: LaunchMode.inAppBrowserView,
    );
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TranslationsScreen(
            translations: translations,
            originalTitle: originalTitle ?? '',
            originalDescription: originalDescription ?? '',
            editUrl: editUrl ?? '',
          ),
        ),
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
    final showEdit = Provider.of<EditSettingsService>(context).showEditContent;

    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            _openEditUrl();
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
          if (showEdit && editUrl != null)
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: Text(loc.edit),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (showEdit && fetchTranslations != null)
            PopupMenuItem(
              value: 'translations',
              child: ListTile(
                leading: const Icon(Icons.translate),
                title: Text(loc.translations),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (onPin != null)
            PopupMenuItem(
              value: 'pin',
              child: ListTile(
                leading: const Icon(Icons.add_to_home_screen),
                title: Text(loc.addToHomeScreen),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (shareUrl != null)
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
