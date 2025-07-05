import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

class TitleListControlPanel extends StatelessWidget {
  final String selectedType;
  final List<String> typesList;
  final Function typeChanged;
  final Function textFilterChanged;
  final TextEditingController textFilterController;
  final List<String> selectedGenres;
  final List<String> genresList;
  final Function genresChanged;
  final String selectedSort;
  final List<String> sortsList;
  final Function sortChanged;
  final Function swapSort;
  final FocusNode focusNode;

  const TitleListControlPanel({
    super.key,
    required this.selectedType,
    required this.typesList,
    required this.typeChanged,
    required this.textFilterChanged,
    required this.textFilterController,
    required this.selectedGenres,
    required this.genresList,
    required this.genresChanged,
    required this.selectedSort,
    required this.sortsList,
    required this.sortChanged,
    required this.swapSort,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _genresSelector(context, genresChanged),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _textFilter(context, AppLocalizations.of(context)!.search),
        ],
      ),
    );
  }

  Widget _genresSelector(BuildContext context, Function genresChanged) {
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
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      textStyle: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      border: Border.all(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }

  Widget _textFilter(BuildContext context, String hintText) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onPrimary;
    final borderColor = colorScheme.onPrimary;

    return SizedBox(
      height: 26,
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
            borderSide: BorderSide(
              color: borderColor,
            ),
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
    );
  }
}
