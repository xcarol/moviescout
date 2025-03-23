import 'package:flutter/material.dart';

class TitleListControls extends StatelessWidget {
  final String selectedType;
  final List<String> listTypes;
  final Function typeChanged;

  const TitleListControls({
    super.key,
    required this.selectedType,
    required this.listTypes,
    required this.typeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          typeSelector(),
        ],
      ),
    );
  }

  Widget typeSelector() {
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
}
