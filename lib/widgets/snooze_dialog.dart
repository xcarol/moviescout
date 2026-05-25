import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:provider/provider.dart';

class SnoozeDialog extends StatelessWidget {
  final TmdbTitle title;

  const SnoozeDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.snoozeTitle),
      content: Text(AppLocalizations.of(context)!.snoozeMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.no),
        ),
        TextButton(
          onPressed: () async {
            final rateslistService =
                Provider.of<TmdbRateslistService>(context, listen: false);
            await rateslistService.toggleSnooze(title);
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          child: Text(AppLocalizations.of(context)!.yes),
        ),
      ],
    );
  }
}
