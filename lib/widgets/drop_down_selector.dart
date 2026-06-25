import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String selectedOption;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final Icon? arrowIcon;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Widget Function(BuildContext, String, bool, VoidCallback)? itemBuilder;
  final Widget? leading;
  final double? maxMenuHeight;
  final bool isExpanded;

  const DropdownSelector({
    super.key,
    required this.selectedOption,
    required this.options,
    required this.onSelected,
    this.arrowIcon,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.itemBuilder,
    this.leading,
    this.maxMenuHeight,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final MenuController controller = MenuController();
    final TextStyle effectiveTextStyle = textStyle ?? TextStyle(fontSize: 16);
    final Icon effectiveArrowIcon = arrowIcon ?? Icon(Icons.arrow_drop_down);

    return MenuAnchor(
      controller: controller,
      style: maxMenuHeight != null
          ? MenuStyle(
              maximumSize: WidgetStateProperty.all(
                Size(double.infinity, maxMenuHeight!),
              ),
            )
          : null,
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8),
                ],
                if (isExpanded)
                  Expanded(
                    child: Text(
                      selectedOption,
                      style: effectiveTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  Text(selectedOption, style: effectiveTextStyle),
                effectiveArrowIcon,
              ],
            ),
          ),
        );
      },
      menuChildren: options.map((option) {
        final isSelected = selectedOption == option;

        if (itemBuilder != null) {
          return itemBuilder!(
            context,
            option,
            isSelected,
            () {
              if (!isSelected) onSelected(option);
              controller.close();
            },
          );
        }

        return ListTile(
          title: Text(option),
          selected: isSelected,
          tileColor: backgroundColor,
          onTap: () {
            if (!isSelected) onSelected(option);
            controller.close();
          },
        );
      }).toList(),
    );
  }
}
