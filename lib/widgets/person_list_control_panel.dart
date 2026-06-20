import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/text_filter_widget.dart';

class PersonListControlPanel extends StatelessWidget {
  final TextEditingController textFilterController;
  final FocusNode focusNode;
  final Function(String) onTextChanged;

  const PersonListControlPanel({
    super.key,
    required this.textFilterController,
    required this.focusNode,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          TextFilterWidget(
            controller: textFilterController,
            focusNode: focusNode,
            hintText: localizations.searchPerson,
            onChanged: onTextChanged,
          ),
        ],
      ),
    );
  }
}
