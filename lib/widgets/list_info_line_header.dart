import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/list_info_line.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/widgets/list_controller.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';

class ListInfoLineHeader extends StatelessWidget {
  final ListController controller;
  final TmdbBaseListService listService;

  const ListInfoLineHeader({
    super.key,
    required this.controller,
    required this.listService,
  });

  @override
  Widget build(BuildContext context) {
    final anyFilterActive = controller.selectedGenres.isNotEmpty ||
        controller.filterByProviders ||
        controller.textFilterController.text.isNotEmpty;

    return ListInfoLine(
      leadingWidgets: _buildTypeAndCountWidgets(context),
      isLoading: listService.isLoading,
      sortSelector: _sortSelector(context),
      onSwapSort: () => controller.toggleSortDirection(),
      onToggleFilters: () => controller.toggleFilters(),
      showFilters: controller.showFilters,
      anyFilterActive: anyFilterActive,
    );
  }

  List<Widget> _buildTypeAndCountWidgets(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;
    final typeOption = controller.selectedType;

    final textColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterForeground
        : titleTheme.infoLineActiveFilterForeground;
    final backgroundColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterBackground
        : titleTheme.infoLineActiveFilterBackground;

    return [
      DropdownSelector(
        backgroundColor: backgroundColor,
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        borderRadius: BorderRadius.circular(5),
        leading: ValueListenableBuilder(
          valueListenable: listService.selectedItemCount,
          builder: (context, count, child) {
            return Text(
              count.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            );
          },
        ),
        selectedOption: controller.getSelectedTypeLabel(localizations),
        options: controller.titleTypes,
        onSelected: (value) => controller.setSelectedType(context, value),
        arrowIcon: Icon(
          Icons.arrow_drop_down,
          color: textColor,
        ),
      ),
    ];
  }

  Widget _sortSelector(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DropdownSelector(
      selectedOption: controller.getSelectedSortLabel(localizations),
      options: controller.titleSorts,
      onSelected: (value) => controller.setSelectedSort(context, value),
      arrowIcon: controller.isSortAsc
          ? Icon(Icons.arrow_drop_down)
          : Icon(Icons.arrow_drop_up),
    );
  }
}
