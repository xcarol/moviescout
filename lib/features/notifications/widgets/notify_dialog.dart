import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:provider/provider.dart';

class NotifyDialog extends StatelessWidget {
  final TmdbTitle title;

  const NotifyDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.notifyTitle),
      content: Text(AppLocalizations.of(context)!.notifyMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.no),
        ),
        FilledButton(
          onPressed: () async {
            final rateslistService =
                Provider.of<RateslistService>(context, listen: false);
            await rateslistService.toggleNotify(title);
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
