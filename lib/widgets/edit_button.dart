import 'package:flutter/material.dart';
import 'package:moviescout/services/edit_settings_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
