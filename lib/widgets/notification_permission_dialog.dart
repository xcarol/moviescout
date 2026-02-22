import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.notificationsPermissionRequired),
      content: Text(localizations.notificationsPermissionDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            if (defaultTargetPlatform == TargetPlatform.android) {
              const intent = AndroidIntent(
                action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                arguments: <String, dynamic>{
                  'android.provider.extra.APP_PACKAGE': 'com.xicra.moviescout',
                },
              );
              await intent.launch();
            } else {
              await AppSettings.openAppSettings();
            }
          },
          child: Text(localizations.openSettings),
        ),
      ],
    );
  }
}
