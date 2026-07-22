import 'package:flutter/material.dart';
import 'package:moviescout/services/edit_settings_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/region_service.dart';

class EditButton extends StatelessWidget {
  final String url;

  const EditButton({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<EditSettingsService>(context).showEditContent) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.edit, size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(),
      onPressed: () {
        final languageCode = LanguageService().locale.languageCode;
        final countryCode = RegionService().currentRegion ??
            LanguageService().locale.countryCode ??
            "US";
        final localeStr = '$languageCode-$countryCode';

        final separator = url.contains('?') ? '&' : '?';
        final finalUrl = '$url${separator}language=$localeStr';

        launchUrl(
          Uri.parse(finalUrl),
          mode: LaunchMode.inAppWebView,
        );
      },
    );
  }
}
