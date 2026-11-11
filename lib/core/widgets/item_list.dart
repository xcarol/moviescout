// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/bottom_clamping_scroll_physics.dart';
import 'package:moviescout/core/widgets/custom_refresh_builder.dart';
import 'package:moviescout/core/widgets/drop_down_selector.dart';
import 'package:moviescout/core/widgets/list_control_panel.dart';
import 'package:moviescout/core/widgets/list_controller.dart';
import 'package:moviescout/core/widgets/list_info_line.dart';
import 'package:moviescout/core/widgets/searchable_list_state.dart';
import 'package:moviescout/features/discovery/models/tmdb_collection.dart';
import 'package:moviescout/features/discovery/services/discoverlist_service.dart';
import 'package:moviescout/features/discovery/widgets/collection_card.dart';
import 'package:moviescout/features/discovery/widgets/discovery_control_panel.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/people/services/tmdb_person_titles_service.dart';
import 'package:moviescout/features/people/widgets/person_card.dart';
import 'package:moviescout/features/people/widgets/person_title_card.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/features/settings/services/tmdb_provider_service.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_base_list_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/features/watchlist/widgets/pinned_title_chip.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ItemList extends StatefulWidget {
  final TmdbBaseListService listService;
  final TmdbTitleListService? titleListServiceSupport;

  const ItemList(this.listService, {super.key, this.titleListServiceSupport});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends SearchableListState<ItemList> {
  late final ListController _controller;
  final _refreshController = IndicatorController();
  bool _isPinnedSectionExpanded =
      PreferencesService().prefs.getBool('isPinnedSectionExpanded') ?? true;

  @override
  FocusNode get searchFocusNode => _controller.searchFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = ListController(widget.listService);
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    if (providerService.isInitialized) {
      _controller.setProviderListIds(providerService.enabledProviderIds);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.setupFilters();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  List<Widget> _buildTypeAndCountWidgets(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;
    final typeOption = _controller.selectedType;

    final textColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterForeground
        : titleTheme.infoLineActiveFilterForeground;
    final backgroundColor = typeOption == ''
        ? titleTheme.infoLineInactiveFilterBackground
        : titleTheme.infoLineActiveFilterBackground;

    return [
      ValueListenableBuilder<bool>(
        valueListenable: widget.listService.isLoading,
        builder: (context, isLoading, child) {
          return ValueListenableBuilder<int?>(
            valueListenable: widget.listService.selectedItemCount,
            builder: (context, count, child) {
              final hasValidActiveFilter = widget.listService.hasActiveFilter &&
                  (!_controller.filterByProviders ||
                      _controller.providerListIds.isNotEmpty);
              final showCount = count != null &&
                  (count > 0 || (hasValidActiveFilter && !isLoading));
              final itemTextStyle = theme.textTheme.bodyLarge?.copyWith(
                color: textColor,
              );
              return DropdownSelector(
                backgroundColor: backgroundColor,
                textStyle: itemTextStyle,
                borderRadius: AppRadius.borderSm,
                leading: showCount
                    ? Text(
                        count.toString(),
                        style: itemTextStyle,
                      )
                    : null,
                selectedOption: _controller.getSelectedTypeLabel(localizations),
                options: _controller.titleTypes,
                onSelected: (value) =>
                    _controller.setSelectedType(context, value),
                arrowIcon: Icon(
                  Icons.arrow_drop_down,
                  color: textColor,
                ),
              );
            },
          );
        },
      ),
    ];
  }

  Widget _sortSelector(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DropdownSelector(
      selectedOption: _controller.getSelectedSortLabel(localizations),
      options: _controller.titleSorts,
      onSelected: (value) => _controller.setSelectedSort(context, value),
      arrowIcon: _controller.isSortAsc
          ? const Icon(Icons.arrow_drop_down)
          : const Icon(Icons.arrow_drop_up),
    );
  }

  Widget _buildItemCard(BuildContext context, Object item) {
    final service = widget.listService;
    final supportService = widget.titleListServiceSupport ??
        widget.listService as TmdbTitleListService;

    if (item is TmdbTitle) {
      if (service is TmdbPersonTitlesService) {
        return PersonTitleCard(
          title: item,
          tmdbListService: supportService,
          role: service.role,
        );
      }
      return TitleCard(
        title: item,
        tmdbListService: supportService,
      );
    } else if (item is TmdbPerson) {
      return PersonCard(
        person: item,
        tmdbListService: supportService,
      );
    } else if (item is TmdbCollection) {
      return CollectionCard(
        collection: item,
        tmdbListService: supportService,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _itemList() {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.listService,
        widget.listService.isLoading,
        if (widget.listService is TmdbDiscoverlistService)
          (widget.listService as TmdbDiscoverlistService).isRefreshing,
      ]),
      builder: (context, _) {
        final service = widget.listService;
        final bool showEmptyMessage = !service.isDataLoading &&
            service.loadedItemCount == 0 &&
            (service is TmdbDiscoverlistService || service.hasActiveFilter);

        final scrollPhysics = AlwaysScrollableScrollPhysics(
          parent: BottomClampingScrollPhysics(
            topRefreshController: _refreshController,
            parent: ClampingWithOverscrollPhysics(
              state: _refreshController,
            ),
          ),
        );

        Widget listView;
        if (showEmptyMessage) {
          listView = LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              controller: _controller.scrollController,
              physics: scrollPhysics,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: AppEmptyState(
                  icon: Icons.movie_filter_outlined,
                  message: AppLocalizations.of(context)!.emptyList,
                ),
              ),
            ),
          );
        } else {
          listView = LayoutBuilder(
            builder: (context, constraints) {
              final isGrid = constraints.maxWidth >= AppBreakpoints.compact;
              final titleTheme = Theme.of(context).extension<CustomColors>()!;

              if (isGrid) {
                return Scrollbar(
                  controller: _controller.scrollController,
                  child: GridView.builder(
                    key: const PageStorageKey('TitleListView'),
                    controller: _controller.scrollController,
                    padding: AppSpacing.screenPadding,
                    physics: scrollPhysics,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: AppBreakpoints.maxGridCardExtent,
                      mainAxisExtent: TitleCard.cardHeight,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: service.loadedItemCount,
                    itemBuilder: (context, index) {
                      final item = service.getItem(index);
                      if (item == null) {
                        return const SizedBox.shrink();
                      }
                      return Builder(
                        builder: (innerContext) {
                          final mediaQuery = MediaQuery.of(innerContext);
                          return MediaQuery(
                            data: mediaQuery.copyWith(
                              textScaler:
                                  UiUtils.clampedTextScaler(innerContext),
                            ),
                            child: _buildItemCard(innerContext, item),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return Scrollbar(
                controller: _controller.scrollController,
                child: ListView.builder(
                  key: const PageStorageKey('TitleListView'),
                  controller: _controller.scrollController,
                  physics: scrollPhysics,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: service.loadedItemCount,
                  itemBuilder: (context, index) {
                    final item = service.getItem(index);
                    if (item == null) {
                      return const SizedBox.shrink();
                    }
                    return Builder(
                      builder: (innerContext) {
                        final mediaQuery = MediaQuery.of(innerContext);
                        return MediaQuery(
                          data: mediaQuery.copyWith(
                            textScaler: UiUtils.clampedTextScaler(innerContext),
                          ),
                          child: Column(
                            children: [
                              _buildItemCard(innerContext, item),
                              Divider(
                                height: AppSizes.borderWidthRegular,
                                color: titleTheme.dividerColor,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }

        Widget content = NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            _controller.onScrollNotification(scrollInfo, TitleCard.cardHeight);
            return false;
          },
          child: listView,
        );

        if (service.isRefreshable) {
          content = CustomRefreshIndicator(
            controller: _refreshController,
            offsetToArmed: AppSizes.refreshOffsetToArmed,
            onRefresh: () async {
              if (widget.listService.isLoading.value) {
                return;
              }
              final service = widget.listService;
              if (service is TmdbTitleListService) {
                await service.syncFromServer(
                  locale: Localizations.localeOf(context),
                  forceUpdate: true,
                );
              }
            },
            builder: customRefreshBuilder,
            child: content,
          );
        }

        return content;
      },
    );
  }

  Widget _pinnedTitlesRow() {
    return ListenableBuilder(
      listenable: widget.listService,
      builder: (context, _) {
        final service = widget.listService;
        if (service is! TmdbTitleListService ||
            service.pinnedTitles.isEmpty ||
            service.listName != AppConstants.watchlist) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        final titleTheme = theme.extension<CustomColors>()!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isPinnedSectionExpanded = !_isPinnedSectionExpanded;
                  PreferencesService().prefs.setBool(
                      'isPinnedSectionExpanded', _isPinnedSectionExpanded);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xxs,
                  right: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.watchingNow,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      _isPinnedSectionExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: AppSizes.iconMd,
                    ),
                  ],
                ),
              ),
            ),
            if (_isPinnedSectionExpanded)
              SizedBox(
                height: PinnedTitleChip.cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  itemCount: service.pinnedTitles.length,
                  itemBuilder: (context, index) {
                    return PinnedTitleChip(
                      title: service.pinnedTitles[index],
                      listService: service,
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            Divider(
              height: AppSizes.borderWidthRegular,
              color: titleTheme.dividerColor,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          _controller.initializeControlLocalizations(context);
          return Consumer<TmdbProviderService>(
            builder: (context, providerService, _) {
              if (providerService.isInitialized) {
                final providerList = providerService.enabledProviderIds;

                if (!const ListEquality()
                    .equals(providerList, _controller.providerListIds)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.setProviderListIds(providerList);
                  });
                }

                if (widget.listService is TmdbDiscoverlistService) {
                  final discoverService =
                      widget.listService as TmdbDiscoverlistService;
                  if (!const ListEquality().equals(
                      providerList, discoverService.enabledProviderIds)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      discoverService.setEnabledProviderIds(providerList);
                    });
                  }
                }
              }

              final isDiscoverList =
                  widget.listService is TmdbDiscoverlistService;
              final anyFilterActive = isDiscoverList
                  ? (widget.listService as TmdbDiscoverlistService)
                      .anyFilterActive
                  : _controller.anyFilterActive;

              return ChangeNotifierProvider<TmdbBaseListService>.value(
                value: widget.listService,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListInfoLine(
                      leadingWidgets: _buildTypeAndCountWidgets(context),
                      isLoading: widget.listService.isLoading,
                      sortSelector: _sortSelector(context),
                      onSwapSort: () => _controller.toggleSortDirection(),
                      onToggleFilters: () => _controller.toggleFilters(),
                      showFilters: _controller.showFilters,
                      anyFilterActive: anyFilterActive,
                    ),
                    if (_controller.showFilters)
                      isDiscoverList
                          ? DiscoveryControlPanel(
                              discoverlistService:
                                  widget.listService as TmdbDiscoverlistService,
                            )
                          : ListControlPanel(
                              controller: _controller,
                              listService: widget.listService,
                              showRatingFilter:
                                  widget.listService is RateslistService,
                            ),
                    _pinnedTitlesRow(),
                    Expanded(child: _itemList()),
                  ],
                ),
              );
            },
          );
        });
  }
}
