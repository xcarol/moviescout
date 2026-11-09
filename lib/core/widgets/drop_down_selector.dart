import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class DropdownSelector extends StatelessWidget {
  final String selectedOption;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final Icon? arrowIcon;
  final TextStyle? textStyle;
  final Color? buttonBackgroundColor;
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
    this.buttonBackgroundColor,
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
    final theme = Theme.of(context);
    final TextStyle effectiveTextStyle =
        textStyle ?? theme.textTheme.bodyLarge!;
    final Icon effectiveArrowIcon =
        arrowIcon ?? const Icon(Icons.arrow_drop_down);
    final effectiveRadius = borderRadius ?? AppRadius.borderSm;

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
        return Material(
          color: buttonBackgroundColor ?? Colors.transparent,
          borderRadius:
              effectiveRadius is BorderRadius ? effectiveRadius : null,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius:
                effectiveRadius is BorderRadius ? effectiveRadius : null,
            onTap: () {
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                border: border,
                borderRadius: effectiveRadius,
              ),
              child: Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppSpacing.xs),
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
