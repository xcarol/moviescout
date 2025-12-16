import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';

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
    final foregroundColor = selectedGenres.isNotEmpty
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;
    final backgroundColor = selectedGenres.isNotEmpty
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primary;

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
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }

  Widget _providersSelector(BuildContext context, bool filterByProviders) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.filterByProviders,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          activeThumbColor: Theme.of(context).colorScheme.onPrimary,
          value: filterByProviders,
          onChanged: (value) {
            providersChanged(value);
          },
        ),
      ],
    );
  }

  Widget _textFilter(BuildContext context, String hintText) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onPrimary;
    final borderColor = colorScheme.onPrimary;

    return SizedBox(
      height: 26,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: textColor.withValues(alpha: 0.5),
          ),
        ),
        child: TextField(
          controller: textFilterController,
          focusNode: focusNode,
          style: TextStyle(color: textColor, fontSize: 14),
          cursorColor: borderColor,
          cursorHeight: 16,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(color: textColor),
            suffixIconColor: textColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: borderColor),
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
