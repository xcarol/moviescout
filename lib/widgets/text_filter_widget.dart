import 'package:flutter/material.dart';
import 'package:moviescout/models/title_list_theme.dart';

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
    this.height = 26,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 5),
  });

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return SizedBox(
      height: height,
      child: Theme(
        data: Theme.of(context).copyWith(
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
              style: TextStyle(
                color: titleTheme.controlPanelForeground,
                fontSize: 14,
                fontWeight:
                    value.text.isEmpty ? FontWeight.normal : FontWeight.bold,
              ),
              cursorColor: titleTheme.searchCursorColor,
              cursorHeight: 16,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                hintStyle: TextStyle(color: titleTheme.searchHintColor),
                suffixIconColor: titleTheme.controlPanelForeground,
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: titleTheme.controlPanelForeground),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: titleTheme.controlPanelForeground),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: titleTheme.controlPanelForeground),
                ),
                suffixIcon: value.text.isNotEmpty
                    ? GestureDetector(
                        child: const Icon(Icons.clear, size: 18),
                        onTap: () {
                          controller.clear();
                          onChanged('');
                          if (onCleared != null) onCleared!();
                        },
                      )
                    : const Icon(Icons.search, size: 18),
              ),
              onChanged: (value) => onChanged(value.trim()),
            );
          },
        ),
      ),
    );
  }
}
