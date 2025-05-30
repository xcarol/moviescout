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
            if (Navigator.canPop(context))
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                tooltip: AppLocalizations.of(context)!.back,
              ),
          ],
        );
}
