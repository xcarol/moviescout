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
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SizedBox(
            height: 26,
            child: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: titleTheme.searchSelectionColor,
                  selectionHandleColor: titleTheme.searchCursorColor,
                ),
              ),
              child: TextField(
                controller: textFilterController,
                focusNode: focusNode,
                style: TextStyle(
                    color: titleTheme.controlPanelForeground,
                    fontSize: 14,
                    fontWeight: textFilterController.text.isEmpty
                        ? FontWeight.normal
                        : FontWeight.bold),
                cursorColor: titleTheme.searchCursorColor,
                cursorHeight: 16,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: localizations.searchPerson,
                  hintStyle: TextStyle(color: titleTheme.searchHintColor),
                  suffixIconColor: titleTheme.controlPanelForeground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: titleTheme.controlPanelForeground),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: titleTheme.controlPanelForeground),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: titleTheme.controlPanelForeground),
                  ),
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.clear),
                    onTap: () {
                      textFilterController.clear();
                      onTextChanged('');
                    },
                  ),
                ),
                onChanged: onTextChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
