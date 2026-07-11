import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/expandable_text.dart';

class ExpandableDescription extends StatelessWidget {
  final String text;
  final int initialMaxLines;

  const ExpandableDescription({
    super.key,
    required this.text,
    this.initialMaxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        text.isEmpty ? AppLocalizations.of(context)!.missingDescription : text;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ExpandableText(
        text: displayText,
        initialMaxLines: initialMaxLines,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
