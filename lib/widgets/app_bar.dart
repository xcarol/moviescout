import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainAppBar extends AppBar {
  MainAppBar({
    super.key,
    required BuildContext context,
    required String title,
  }) : super(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
              tooltip: AppLocalizations.of(context)!.back,
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        );
}
