import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TitleListControlPanel extends StatelessWidget {
  final String selectedType;
  final List<String> typesList;
  final Function typeChanged;
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
          _genresSelector(context, genresChanged),
          _sortSelector(),
          _swapSortButton(),
        ],
      ),
    );
  }

  Widget _typeSelector() {
    return DropdownButton<String>(
      value: selectedType,
      items: typesList.map((title) {
        return DropdownMenuItem(
          value: title,
          child: Text(title),
        );
      }).toList(),
      onChanged: (newValue) {
        typeChanged(newValue);
      },
    );
  }

  Widget _genresSelector(BuildContext context, Function genresChanged) {
    return PopupMenuButton<String>(
      onSelected: (String value) {},
      itemBuilder: (BuildContext context) {
        return genresList.map((String option) {
          return PopupMenuItem<String>(
            value: option,
            child: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  title: Text(option),
                  value: selectedGenres.contains(option),
                  onChanged: (bool? checked) {
                    if (checked == true) {
                      selectedGenres.add(option);
                    } else {
                      selectedGenres.remove(option);
                    }
                    genresChanged(selectedGenres);
                    setState(() {
                      // Needed to 'do' something to update the UI
                      // ignore: unused_local_variable
                      final trickState = '';
                    });
                  },
                );
              },
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.genres),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _sortSelector() {
    return DropdownButton<String>(
      hint: Text('Sort by'),
      value: selectedSort,
      items: sortsList.map((sortName) {
        return DropdownMenuItem(
          value: sortName,
          child: Text(sortName),
        );
      }).toList(),
      onChanged: (newValue) {
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
