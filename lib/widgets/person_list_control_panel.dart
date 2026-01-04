import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_list_theme.dart';

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
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;

    return Container(
      color: titleTheme.controlPanelBackground,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: TextField(
              controller: textFilterController,
              focusNode: focusNode,
              onChanged: onTextChanged,
              style: TextStyle(color: titleTheme.controlPanelForeground),
              decoration: InputDecoration(
                hintText: localizations.searchPerson,
                hintStyle: TextStyle(color: titleTheme.searchHintColor),
                prefixIcon: Icon(Icons.search,
                    color: titleTheme.controlPanelForeground),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    textFilterController.clear();
                    onTextChanged('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
