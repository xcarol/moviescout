import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/list_info_line.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/widgets/person_list_controller.dart';

class PersonListInfoLine extends StatelessWidget {
  final PersonListController controller;

  const PersonListInfoLine({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final anyFilterActive = controller.textFilterController.text.isNotEmpty;

    return ListInfoLine(
      leadingWidgets: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                controller.itemCount.toString(),
                style: TextStyle(
                  fontSize: 16,
                ),
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
                ? Icon(Icons.arrow_drop_down)
                : Icon(Icons.arrow_drop_up),
          );
        },
      ),
      onSwapSort: () => controller.toggleSortDirection(),
      onToggleFilters: () => controller.toggleFilters(),
      showFilters: controller.showFilters,
      anyFilterActive: anyFilterActive,
    );
  }
}
