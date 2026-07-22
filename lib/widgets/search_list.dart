import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:provider/provider.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/widgets/searchable_list_state.dart';
import 'package:moviescout/widgets/search_list_info_line.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:moviescout/widgets/title_list_controller.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/person_card.dart';
import 'package:moviescout/utils/ui_utils.dart';

class SearchList extends StatefulWidget {
  final TmdbSearchService searchService;
  final TmdbTitleListService titleListServiceSupport;

  const SearchList({
    super.key,
    required this.searchService,
    required this.titleListServiceSupport,
  });

  @override
  SearchableListState<SearchList> createState() => _SearchListState();
}

class _SearchListState extends SearchableListState<SearchList> {
  @override
  FocusNode get searchFocusNode => _controller.searchFocusNode;
  final ScrollController _scrollController = ScrollController();
  late final TitleListController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = TitleListController(widget.titleListServiceSupport);
    _controller.addListener(_onControllerChanged);
    _controller.textFilterController.text =
        widget.searchService.currentFilterText;
  }

  void _onControllerChanged() {
    widget.searchService.updateFilters(
      genres: TmdbGenreService().getIdsFromNames(_controller.selectedGenres),
      excludeGenres: _controller.excludeGenres,
      filterByProviders: _controller.filterByProviders,
      providerListIds: _controller.providerListIds,
      sort: _controller.selectedSort,
      isSortAsc: _controller.isSortAsc,
      type: _controller.selectedType,
      localFilterText: _controller.textFilterController.text,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.searchService.loadNextPage();
    }
  }

  List<int> _retrieveUserProviders(TmdbProviderService providerService) {
    if (providerService.isInitialized == false) {
      return [];
    }

    final map = providerService.providers;

    final enabledProviders = map.entries
        .where((entry) => entry.value[TmdbProvider.providerEnabled] == 'true')
        .map((entry) => int.parse(entry.value[TmdbProvider.providerId]!))
        .toList();

    return enabledProviders;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.searchService, _controller]),
      builder: (context, _) {
        _controller.initializeControlLocalizations(context);

        return Consumer<TmdbProviderService>(
          builder: (context, providerService, _) {
            final providerList = _retrieveUserProviders(providerService);

            if (!const ListEquality()
                .equals(providerList, _controller.providerListIds)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.setProviderListIds(providerList);
              });
            }

            final customColors = Theme.of(context).extension<CustomColors>()!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchListInfoLine(
                  controller: _controller,
                  searchService: widget.searchService,
                  onFilterChanged: () {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0.0);
                    }
                  },
                ),
                if (_controller.showFilters) _controlPanel(),
                Divider(
                  height: 1,
                  color: customColors.dividerColor,
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      key: const PageStorageKey('SearchListView'),
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: widget.searchService.loadedItemCount,
                      itemBuilder: (context, index) {
                        final item = widget.searchService.getItem(index);
                        if (item == null) {
                          return const SizedBox.shrink();
                        }

                        return Builder(
                          builder: (innerContext) {
                            final mediaQuery = MediaQuery.of(innerContext);

                            return MediaQuery(
                              data: mediaQuery.copyWith(
                                textScaler: TextScaler.linear(
                                    UiUtils.scaleFactor(
                                        innerContext, 1.0, 1.0, 1.3)),
                              ),
                              child: Column(
                                children: [
                                  if (item is TmdbTitle)
                                    TitleCard(
                                      title: item,
                                      tmdbListService:
                                          widget.titleListServiceSupport,
                                    )
                                  else if (item is TmdbPerson)
                                    PersonCard(
                                      person: item,
                                      tmdbListService:
                                          widget.titleListServiceSupport,
                                    ),
                                  Divider(
                                    height: 1,
                                    color: customColors.dividerColor,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _controlPanel() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: widget.titleListServiceSupport.listGenres,
      builder: (context, genres, child) {
        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
        return Container(
          color: titleTheme.controlPanelBackground,
          child: Column(
            children: [
              TitleListControlPanel(
                textFilterChanged: (newTextFilter) {
                  _controller.setTextFilter(newTextFilter);
                },
                textFilterController: _controller.textFilterController,
                selectedGenres: _controller.selectedGenres.toList(),
                excludeGenres: _controller.excludeGenres,
                genresList: genres,
                genresChanged:
                    (List<String> genresChanged, bool excludeGenres) {
                  _controller.setGenres(genresChanged, excludeGenres);
                },
                filterByProviders: _controller.filterByProviders,
                providersChanged: (bool providersChanged) {
                  _controller.setFilterByProviders(providersChanged);
                },
                focusNode: _controller.searchFocusNode,
              ),
            ],
          ),
        );
      },
    );
  }
}
