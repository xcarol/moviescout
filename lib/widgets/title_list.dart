import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/widgets/title_list_controller.dart';
import 'package:moviescout/models/title_list_theme.dart';

class TitleList extends StatefulWidget {
  final TmdbListService listService;

  const TitleList(this.listService, {super.key});

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  late final TitleListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TitleListController(widget.listService);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controller.initializeControlLocalizations(context);
      await _controller.setupFilters();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && _controller.searchFocusNode.hasFocus) {
      _controller.searchFocusNode.unfocus();
    }
    if (mounted) {
      _controller.initializeControlLocalizations(context);
    }
  }

  Widget _titleList() {
    return ChangeNotifierProvider<TmdbListService>.value(
      value: widget.listService,
      child: Consumer<TmdbListService>(
        builder: (context, service, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              _controller.onScrollNotification(
                  scrollInfo, TitleCard.cardHeight);
              return false;
            },
            child: Flexible(
              child: Scrollbar(
                controller: _controller.scrollController,
                child: ListView.builder(
                  key: const PageStorageKey('TitleListView'),
                  controller: _controller.scrollController,
                  shrinkWrap: true,
                  itemCount: service.loadedTitleCount,
                  itemBuilder: (context, index) {
                    final title = service.getItem(index);
                    if (title == null) {
                      return SizedBox.shrink();
                    }
                    final clampedScale = MediaQuery.of(context)
                        .textScaler
                        .scale(1.0)
                        .clamp(1.0, 1.3);

                    final titleTheme =
                        Theme.of(context).extension<TitleListTheme>()!;

                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(clampedScale),
                      ),
                      child: Column(
                        children: [
                          TitleCard(
                            title: title,
                            tmdbListService: widget.listService,
                          ),
                          Divider(
                            height: 1,
                            color: titleTheme.listDividerColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _controlPanel() {
    return ValueListenableBuilder(
      valueListenable: widget.listService.listGenres,
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
                genresList: genres,
                genresChanged: (List<String> genresChanged) {
                  _controller.setGenres(genresChanged);
                },
                filterByProviders: _controller.filterByProviders,
                providersChanged: (bool providersChanged) {
                  _controller.setFilterByProviders(providersChanged);
                },
                focusNode: _controller.searchFocusNode,
              ),
              Container(
                color: titleTheme.controlPanelInternalBackground,
                child: Divider(
                  color: titleTheme.controlPanelDividerColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoLine() {
    final anyFilterActive = _controller.selectedGenres.isNotEmpty ||
        _controller.filterByProviders ||
        _controller.textFilterController.text.isNotEmpty;

    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return Container(
      color: titleTheme.infoLineBackground,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          ..._buildTypeAndCountWidgets(),
          const SizedBox(width: 8),
          ValueListenableBuilder(
            valueListenable: widget.listService.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: _sortSelector(),
            ),
          ),
          _swapSortButton(context),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                anyFilterActive
                    ? titleTheme.infoLineActiveFilterBackground
                    : titleTheme.infoLineInactiveFilterBackground,
              ),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () {
              _controller.toggleFilters();
            },
            icon: Icon(
              _controller.showFilters
                  ? Icons.filter_list_off
                  : Icons.filter_list,
              color: anyFilterActive
                  ? titleTheme.infoLineActiveFilterForeground
                  : titleTheme.infoLineInactiveFilterForeground,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTypeAndCountWidgets() {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    final typeOption = _titleTypeToOption(_controller.selectedType);

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
          valueListenable: widget.listService.selectedTitleCount,
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
        selectedOption: _controller.selectedType,
        options: _controller.titleTypes,
        onSelected: (value) => _controller.setSelectedType(context, value),
        arrowIcon: Icon(
          Icons.arrow_drop_down,
          color: textColor,
        ),
      )
    ];
  }

  String _titleTypeToOption(String type) {
    final localizations = AppLocalizations.of(context);
    if (type == localizations?.movies) return ApiConstants.movie;
    if (type == localizations?.tvshows) return ApiConstants.tv;
    return '';
  }

  Widget _sortSelector() {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    return DropdownSelector(
      selectedOption: _controller.selectedSort,
      options: _controller.titleSorts,
      onSelected: (value) => _controller.setSelectedSort(context, value),
      arrowIcon: _controller.isSortAsc
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

  Widget _swapSortButton(BuildContext context) {
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
    return IconButton(
      color: titleTheme.swapSortIconColor,
      icon: Icon(Icons.swap_vert),
      onPressed: () {
        _controller.toggleSortDirection(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          final titleTheme = Theme.of(context).extension<TitleListTheme>()!;
          return Consumer<TmdbProviderService>(
            builder: (context, providerService, _) {
              final providerList = _retrieveUserProviders(providerService);

              if (!const ListEquality()
                  .equals(providerList, _controller.providerListIds)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _controller.setProviderListIds(providerList);
                });
              }

              return Expanded(
                child: Container(
                  color: titleTheme.listBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: titleTheme.listBackground,
                        child: Divider(
                          color: titleTheme.listDividerColor,
                        ),
                      ),
                      _infoLine(),
                      Divider(
                        height: 1,
                        color: titleTheme.listDividerColor,
                      ),
                      if (_controller.showFilters) _controlPanel(),
                      _titleList(),
                    ],
                  ),
                ),
              );
            },
          );
        });
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
}
