import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/widgets/custom_refresh_builder.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/bottom_clamping_scroll_physics.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/person_title_card.dart';
import 'package:moviescout/widgets/list_info_line.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/list_control_panel.dart';
import 'package:moviescout/services/tmdb_person_titles_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/widgets/list_controller.dart';
import 'package:moviescout/services/tmdb_base_list_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/pinned_title_chip.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/widgets/searchable_list_state.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/widgets/person_card.dart';
import 'package:moviescout/utils/ui_utils.dart';

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
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final localizations = AppLocalizations.of(context)!;
    final typeOption = _controller.selectedType;

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
          valueListenable: widget.listService.selectedItemCount,
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
        selectedOption: _controller.getSelectedTypeLabel(localizations),
        options: _controller.titleTypes,
        onSelected: (value) => _controller.setSelectedType(context, value),
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
      selectedOption: _controller.getSelectedSortLabel(localizations),
      options: _controller.titleSorts,
      onSelected: (value) => _controller.setSelectedSort(context, value),
      arrowIcon: _controller.isSortAsc
          ? const Icon(Icons.arrow_drop_down)
          : const Icon(Icons.arrow_drop_up),
    );
  }

  Widget _itemList() {
    return ListenableBuilder(
      listenable: widget.listService,
      builder: (context, _) {
        final service = widget.listService;
        Widget listView = Scrollbar(
          controller: _controller.scrollController,
          child: ListView.builder(
            key: const PageStorageKey('TitleListView'),
            controller: _controller.scrollController,
            physics: AlwaysScrollableScrollPhysics(
              parent: BottomClampingScrollPhysics(
                topRefreshController: _refreshController,
                parent: ClampingWithOverscrollPhysics(
                  state: _refreshController,
                ),
              ),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: service.loadedItemCount,
            itemBuilder: (context, index) {
              final item = service.getItem(index);
              if (item == null) {
                return const SizedBox.shrink();
              }
              return Builder(
                builder: (innerContext) {
                  final mediaQuery = MediaQuery.of(innerContext);

                  final titleTheme =
                      Theme.of(context).extension<CustomColors>()!;

                  TmdbTitleListService supportService =
                      widget.titleListServiceSupport ??
                          widget.listService as TmdbTitleListService;
                  Widget card;
                  if (item is TmdbTitle) {
                    if (service is TmdbPersonTitlesService) {
                      card = PersonTitleCard(
                        title: item,
                        tmdbListService: supportService,
                        role: service.role,
                      );
                    } else {
                      card = TitleCard(
                        title: item,
                        tmdbListService: supportService,
                      );
                    }
                  } else if (item is TmdbPerson) {
                    card = PersonCard(
                      person: item,
                      tmdbListService: supportService,
                    );
                  } else {
                    card = const SizedBox.shrink();
                  }

                  return MediaQuery(
                    data: mediaQuery.copyWith(
                      textScaler: TextScaler.linear(
                          UiUtils.scaleFactor(innerContext, 1.0, 1.0, 1.3)),
                    ),
                    child: Column(
                      children: [
                        card,
                        Divider(
                          height: 1,
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
            offsetToArmed: 100,
            onRefresh: () async {
              if (widget.listService.isLoading.value) {
                return;
              }
              final userService =
                  Provider.of<TmdbUserService>(context, listen: false);
              final service = widget.listService;
              if (service is TmdbTitleListService) {
                await service.syncFromServer(
                  accountId: userService.accountId,
                  sessionId: userService.sessionId,
                  locale: Localizations.localeOf(context),
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

        final titleTheme = Theme.of(context).extension<CustomColors>()!;

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
                    left: 12.0, top: 8.0, bottom: 4.0, right: 12.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.watchingNow,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isPinnedSectionExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: service.pinnedTitles.length,
                  itemBuilder: (context, index) {
                    return PinnedTitleChip(
                      title: service.pinnedTitles[index],
                      listService: service,
                    );
                  },
                ),
              ),
            const SizedBox(height: 8.0),
            Divider(
              height: 1,
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
              final providerList = providerService.enabledProviderIds;

              if (!const ListEquality()
                  .equals(providerList, _controller.providerListIds)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _controller.setProviderListIds(providerList);
                });
              }

              final anyFilterActive = _controller.selectedGenres.isNotEmpty ||
                  _controller.filterByProviders ||
                  _controller.textFilterController.text.isNotEmpty;

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
                      ListControlPanel(
                        controller: _controller,
                        listService: widget.listService,
                        showRatingFilter:
                            widget.listService is TmdbRateslistService,
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
