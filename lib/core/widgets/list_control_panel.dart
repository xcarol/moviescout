import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/widgets/list_controller.dart';
import 'package:moviescout/core/widgets/rating_filter_tabs.dart';
import 'package:moviescout/core/widgets/text_filter_widget.dart';
import 'package:moviescout/features/titles/services/tmdb_base_list_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class ListControlPanel extends StatelessWidget {
  final ListController controller;
  final TmdbBaseListService listService;
  final bool showRatingFilter;

  const ListControlPanel({
    super.key,
    required this.controller,
    required this.listService,
    this.showRatingFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listService.listGenres,
      builder: (context, genres, child) {
        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
        return Container(
          color: titleTheme.controlPanelBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _genresSelector(context, genres),
                  _providersSelector(context),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              TextFilterWidget(
                controller: controller.textFilterController,
                focusNode: controller.searchFocusNode,
                hintText: AppLocalizations.of(context)!.searchTitle,
                onChanged: (String value) {
                  controller.setTextFilter(value);
                },
              ),
              if (showRatingFilter) ...[
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [RatingFilterTabs(controller: controller)],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _genresSelector(BuildContext context, List<String> genresList) {
    final theme = Theme.of(context);
    final titleTheme = theme.extension<TitleListTheme>()!;
    final selectedGenres = controller.selectedGenres.toList();
    final excludeGenres = controller.excludeGenres;
    final isActive = selectedGenres.isNotEmpty;
    final foregroundColor = isActive
        ? titleTheme.controlPanelActiveFilterForeground
        : titleTheme.controlPanelInactiveFilterForeground;
    final backgroundColor = isActive
        ? titleTheme.controlPanelActiveFilterBackground
        : titleTheme.controlPanelInactiveFilterBackground;
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: isActive ? backgroundColor : theme.colorScheme.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () async {
          await context.toGenres(
            genresList: genresList,
            selectedGenres: selectedGenres,
            excludeGenres: excludeGenres,
            onGenresChanged: (genres, exclude) {
              controller.setGenres(genres, exclude);
            },
          );
        },
        child: Container(
          height: AppSizes.filterControlHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.genres,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.arrow_forward_ios,
                color: foregroundColor,
                size: AppSizes.iconXs,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _promptConfigureProviders(BuildContext context, AppLocalizations l10n) {
    SnackMessage.showActionSnackBar(
      message: l10n.noProvidersSelectedPrompt,
      actionLabel: l10n.settings,
      onAction: () {
        context.toProviders();
      },
      context: context,
    );
  }

  Widget _providersSelector(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final l10n = AppLocalizations.of(context)!;
    final hasProviders = controller.providerListIds.isNotEmpty;
    final isActive = hasProviders && controller.filterByProviders;
    final activeColor = titleTheme.controlPanelActiveFilterBackground;
    final inactiveColor = titleTheme.controlPanelInactiveFilterForeground;

    return Tooltip(
      message: l10n.discoveryFilterByYourProviders,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: AppSizes.compactActionConstraints,
            icon: Icon(
              Icons.tv,
              size: AppSizes.iconMd,
              color: isActive ? activeColor : inactiveColor,
            ),
            onPressed: () {
              if (!hasProviders) {
                _promptConfigureProviders(context, l10n);
                return;
              }
              controller.setFilterByProviders(!isActive);
            },
          ),
          const SizedBox(width: AppSpacing.xxs),
          Switch(
            value: isActive,
            onChanged: (bool value) {
              if (!hasProviders) {
                _promptConfigureProviders(context, l10n);
                return;
              }
              controller.setFilterByProviders(value);
            },
          ),
        ],
      ),
    );
  }
}
