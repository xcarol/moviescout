import 'package:flutter/material.dart';
import 'package:moviescout/models/title_list_theme.dart';

class ListInfoLine extends StatelessWidget {
  final List<Widget> leadingWidgets;
  final ValueNotifier<bool> isLoading;
  final Widget? sortSelector;
  final VoidCallback? onSwapSort;
  final VoidCallback? onToggleFilters;
  final bool showFilters;
  final bool anyFilterActive;

  const ListInfoLine({
    super.key,
    required this.leadingWidgets,
    required this.isLoading,
    this.sortSelector,
    this.onSwapSort,
    this.onToggleFilters,
    this.showFilters = false,
    this.anyFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return Container(
      color: titleTheme.infoLineBackground,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          ...leadingWidgets,
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              if (loading) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (sortSelector != null)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: sortSelector!,
              ),
            )
          else
            const Spacer(),
          if (onSwapSort != null)
            IconButton(
              icon: const Icon(Icons.swap_vert),
              onPressed: onSwapSort,
            ),
          if (onToggleFilters != null)
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  anyFilterActive
                      ? titleTheme.infoLineActiveFilterBackground
                      : titleTheme.infoLineInactiveFilterBackground,
                ),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onToggleFilters,
              icon: Icon(
                showFilters ? Icons.filter_list_off : Icons.filter_list,
                color: anyFilterActive
                    ? titleTheme.infoLineActiveFilterForeground
                    : titleTheme.infoLineInactiveFilterForeground,
              ),
            ),
        ],
      ),
    );
  }
}
