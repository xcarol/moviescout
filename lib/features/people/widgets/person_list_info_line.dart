import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/core/widgets/list_info_line.dart';
import 'package:moviescout/features/people/widgets/person_list_controller.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class PersonListInfoLine extends StatelessWidget {
  final PersonListController controller;

  const PersonListInfoLine({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final anyFilterActive = controller.textFilterController.text.isNotEmpty;
    final theme = Theme.of(context);

    return ListInfoLine(
      leadingWidgets: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderSm,
              ),
              child: Text(
                controller.itemCount.toString(),
                style: theme.textTheme.bodyLarge,
              ),
            );
          },
        ),
      ],
      isLoading: controller.listService.isLoading,
      sortSelector: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return DropdownSelector(
            selectedOption:
                controller.getSelectedSortLabel(AppLocalizations.of(context)!),
            options: controller.personSorts,
            onSelected: (value) => controller.setSelectedSort(context, value),
            arrowIcon: controller.isSortAsc
                ? const Icon(Icons.arrow_drop_down)
                : const Icon(Icons.arrow_drop_up),
          );
        },
      ),
      onSwapSort: () => controller.toggleSortDirection(),
      onToggleFilters: () => controller.toggleFilters(),
      showFilters: controller.showFilters,
      anyFilterActive: anyFilterActive,
      trailingWidgets: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                controller.isGridView ? Icons.view_list : Icons.grid_view,
              ),
              onPressed: () => controller.toggleGridView(),
            );
          },
        ),
      ],
    );
  }
}
