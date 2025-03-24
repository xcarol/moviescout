import 'package:flutter/material.dart';

class TitleListControls extends StatelessWidget {
  final String selectedType;
  final List<String> listTypes;
  final Function typeChanged;
  final String selectedSort;
  final List<String> listSorts;
  final Function sortChanged;
  final Function swapSort;

  const TitleListControls({
    super.key,
    required this.selectedType,
    required this.listTypes,
    required this.typeChanged,
    required this.selectedSort,
    required this.listSorts,
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
          _sortSelector(),
          _swapSortButton(),
        ],
      ),
    );
  }

  Widget _typeSelector() {
    return DropdownButton<String>(
      value: selectedType,
      items: listTypes.map((title) {
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

  Widget _sortSelector() {
    return DropdownButton<String>(
      hint: Text('Sort by'),
      value: selectedSort,
      items: listSorts.map((sortName) {
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
