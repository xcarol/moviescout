import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';

class ListInfoLine extends StatelessWidget {
  final List<Widget> leadingWidgets;
  final ValueNotifier<bool> isLoading;
  final Widget? sortSelector;
  final VoidCallback? onSwapSort;
  final VoidCallback? onToggleFilters;
  final bool showFilters;
  final bool anyFilterActive;
  final List<Widget> trailingWidgets;

  const ListInfoLine({
    super.key,
    required this.leadingWidgets,
    required this.isLoading,
    this.sortSelector,
    this.onSwapSort,
    this.onToggleFilters,
    this.showFilters = false,
    this.anyFilterActive = false,
    this.trailingWidgets = const [],
  });

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return Container(
      color: titleTheme.infoLineBackground,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          ...leadingWidgets,
          const SizedBox(width: AppSpacing.xs),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              if (loading) {
                return const SizedBox(
                  width: AppSizes.iconMd,
                  height: AppSizes.iconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.strokeWidthSm,
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
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.swap_vert),
              onPressed: onSwapSort,
            ),
          ...trailingWidgets,
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
