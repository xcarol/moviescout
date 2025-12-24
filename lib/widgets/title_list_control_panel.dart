import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/models/title_list_theme.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class TitleListControlPanel extends StatelessWidget {
  final Function textFilterChanged;
  final TextEditingController textFilterController;
  final List<String> selectedGenres;
  final List<String> genresList;
  final Function genresChanged;
  final bool filterByProviders;
  final Function providersChanged;
  final FocusNode focusNode;

  const TitleListControlPanel({
    super.key,
    required this.textFilterChanged,
    required this.textFilterController,
    required this.selectedGenres,
    required this.genresList,
    required this.genresChanged,
    required this.filterByProviders,
    required this.providersChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _genresSelector(context, genresChanged),
              _providersSelector(context, filterByProviders),
            ],
          ),
          _textFilter(context, AppLocalizations.of(context)!.search),
        ],
      ),
    );
  }

  Widget _genresSelector(BuildContext context, Function genresChanged) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final foregroundColor = selectedGenres.isNotEmpty
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;
    final backgroundColor = selectedGenres.isNotEmpty
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;

    return DropdownSelector(
      selectedOption: AppLocalizations.of(context)!.genres,
      options: genresList,
      onSelected: (_) {},
      itemBuilder: (context, option, isSelected, closeMenu) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SwitchListTile(
              title: Text(option),
              value: selectedGenres.contains(option),
              onChanged: (bool value) {
                setState(() {
                  if (value) {
                    selectedGenres.add(option);
                  } else {
                    selectedGenres.remove(option);
                  }
                });
                genresChanged(selectedGenres);
              },
            );
          },
        );
      },
      arrowIcon: Icon(
        Icons.arrow_drop_down,
        color: foregroundColor,
      ),
      textStyle: TextStyle(
        fontSize: 16,
        color: foregroundColor,
      ),
      backgroundColor: backgroundColor,
      border: Border.all(
        color: titleTheme.controlPanelForeground,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }

  Widget _providersSelector(BuildContext context, bool filterByProviders) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.filterByProviders,
          style: TextStyle(
            fontSize: 16,
            color: titleTheme.controlPanelForeground,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          activeThumbColor: titleTheme.controlPanelForeground,
          value: filterByProviders,
          onChanged: (value) {
            providersChanged(value);
          },
        ),
      ],
    );
  }

  Widget _textFilter(BuildContext context, String hintText) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return SizedBox(
      height: 26,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: titleTheme.searchSelectionColor,
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
            hintText: hintText,
            hintStyle: TextStyle(color: titleTheme.searchHintColor),
            suffixIconColor: titleTheme.controlPanelForeground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: titleTheme.controlPanelForeground),
            ),
            suffixIcon: GestureDetector(
              child: Icon(Icons.clear),
              onTap: () {
                textFilterChanged('');
                textFilterController.clear();
              },
            ),
          ),
          onChanged: (String value) {
            textFilterChanged(value);
          },
        ),
      ),
    );
  }
}
