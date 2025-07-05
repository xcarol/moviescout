import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String selectedOption;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final Icon? arrowIcon;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const DropdownSelector({
    super.key,
    required this.selectedOption,
    required this.options,
    required this.onSelected,
    this.arrowIcon,
    this.textStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final MenuController controller = MenuController();
    final TextStyle effectiveTextStyle = textStyle ??
        TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        );

    final Icon effectiveArrowIcon = arrowIcon ??
        Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.primary,
        );

    return MenuAnchor(
      controller: controller,
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedOption,
                  style: effectiveTextStyle,
                ),
                effectiveArrowIcon,
              ],
            ),
          ),
        );
      },
      menuChildren: options.map((option) {
        final isSelected = selectedOption == option;
        return ListTile(
          title: Text(option),
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.secondary,
          onTap: () {
            if (!isSelected) onSelected(option);
            controller.close();
          },
        );
      }).toList(),
    );
  }
}
