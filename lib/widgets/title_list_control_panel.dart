import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _typeSelector(),
          const SizedBox(width: 8),
          _textFilter(AppLocalizations.of(context)!.search),
          const SizedBox(width: 8),
          _genresSelector(context, genresChanged),
          const SizedBox(width: 8),
          _sortSelector(),
          _swapSortButton(),
        ],
      ),
    );
  }

  List<MenuEntry> _menuEntries(List<String> list) {
    return list
        .map<MenuEntry>((String name) => MenuEntry(value: name, label: name))
        .toList();
  }

  Widget _typeSelector() {
    return DropdownMenu<String>(
      initialSelection: selectedType,
      dropdownMenuEntries: _menuEntries(typesList),
      onSelected: (newValue) {
        typeChanged(newValue);
      },
    );
  }

  Widget _textFilter(String hintText) {
    return Expanded(
      child: TextField(
          controller: textFilterController,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                textFilterChanged('');
                textFilterController.clear();
              },
            ),
          ),
          onChanged: (String value) {
            textFilterChanged(value);
          }),
    );
  }

  Widget _genresSelector(BuildContext context, Function genresChanged) {
    return MenuAnchor(
      key: Key('_menuKey'),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.genres,
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
      menuChildren: genresList.map((String option) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CheckboxListTile(
              title: Text(option),
              value: selectedGenres.contains(option),
              onChanged: (bool? checked) {
                setState(() {
                  if (checked == true) {
                    selectedGenres.add(option);
                  } else {
                    selectedGenres.remove(option);
                  }
                  genresChanged(selectedGenres);
                });
              },
            );
          },
        );
      }).toList(),
    );
  }

  Widget _sortSelector() {
    return DropdownMenu<String>(
      initialSelection: selectedSort,
      dropdownMenuEntries: _menuEntries(sortsList),
      onSelected: (newValue) {
        sortChanged(newValue);
      },
    );
  }

  Widget _swapSortButton() {
    return IconButton(
      icon: Icon(Icons.swap_vert),
      onPressed: () {
        swapSort();
      },
    );
  }
}
