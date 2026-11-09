import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';

class TextFilterWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onCleared;
  final double height;
  final EdgeInsetsGeometry contentPadding;

  const TextFilterWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    this.onCleared,
    this.height = AppSizes.filterControlHeight,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs,
      vertical: AppSpacing.xxs,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.extension<TitleListTheme>()!;
    final borderRadius = AppRadius.borderSm;

    return SizedBox(
      height: height,
      child: Theme(
        data: theme.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: titleTheme.searchSelectionColor,
            selectionHandleColor: titleTheme.searchCursorColor,
          ),
        ),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              textAlignVertical: TextAlignVertical.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: titleTheme.controlPanelForeground,
                fontWeight:
                    value.text.isEmpty ? FontWeight.normal : FontWeight.w600,
              ),
              cursorColor: titleTheme.searchCursorColor,
              cursorHeight: AppSizes.iconSm,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: theme.colorScheme.surface,
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: titleTheme.searchHintColor,
                ),
                suffixIconColor: titleTheme.controlPanelForeground,
                suffixIconConstraints: AppSizes.suffixIconConstraints,
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: AppSizes.borderWidthFocused,
                  ),
                ),
                suffixIcon: value.text.isNotEmpty
                    ? InkWell(
                        borderRadius: borderRadius,
                        onTap: () {
                          controller.clear();
                          onChanged('');
                          if (onCleared != null) onCleared!();
                        },
                        child: const Icon(Icons.clear, size: AppSizes.iconSm),
                      )
                    : const Icon(Icons.search, size: AppSizes.iconSm),
              ),
              onChanged: (value) => onChanged(value.trim()),
            );
          },
        ),
      ),
    );
  }
}
