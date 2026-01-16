import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/list_info_line.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/widgets/title_list_controller.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/rating_filter_tabs.dart';

class TitleListInfoLine extends StatelessWidget {
  final TitleListController controller;
  final TmdbListService listService;

  const TitleListInfoLine({
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
          backgroundColor: backgroundColor,
        ),
        borderRadius: BorderRadius.circular(5),
        leading: ValueListenableBuilder(
          valueListenable: listService.selectedTitleCount,
          builder: (context, count, child) {
            return Text(
              count.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                backgroundColor: backgroundColor,
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
      if (listService is TmdbRateslistService) ...[
        const SizedBox(width: 8),
        RatingFilterTabs(controller: controller),
      ],
    ];
  }

  Widget _sortSelector(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;
    return DropdownSelector(
      selectedOption: controller.getSelectedSortLabel(localizations),
      options: controller.titleSorts,
      onSelected: (value) => controller.setSelectedSort(context, value),
      arrowIcon: controller.isSortAsc
          ? Icon(
              Icons.arrow_drop_down,
              color: titleTheme.sortArrowColor,
            )
          : Icon(
              Icons.arrow_drop_up,
              color: titleTheme.sortArrowColor,
            ),
    );
  }
}
