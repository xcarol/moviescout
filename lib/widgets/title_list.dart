import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/drop_down_selector.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';

class TitleList extends StatefulWidget {
  final TmdbListService listService;

  const TitleList(this.listService, {super.key});

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isSortAsc = true;
  late bool _showFilters;
  late String _showFiltersPreferencesName;
  late String _textFilterPreferencesName;
  late String _selectedGenresPreferencesName;
  late String _selectedTypePreferencesName;
  late String _filterByProvidersPreferencesName;
  String _selectedType = '';
  late List<String> _titleTypes;
  String _selectedSort = '';
  late List<String> _titleSorts;
  List<String> _selectedGenres = [];
  late bool _filterByProviders = false;
  List<int> _providerListIds = [];
  late TextEditingController _textFilterController;

  @override
  void initState() {
    super.initState();
    _textFilterController = TextEditingController();

    _textFilterPreferencesName = '${widget.listService.listName}_TextFilter';
    _textFilterController.text =
        PreferencesService().prefs.getString(_textFilterPreferencesName) ?? '';

    _showFiltersPreferencesName = '${widget.listService.listName}_ShowFilters';
    _showFilters =
        PreferencesService().prefs.getBool(_showFiltersPreferencesName) ??
            false;

    _selectedTypePreferencesName =
        '${widget.listService.listName}_SelectedType';
    _selectedType =
        PreferencesService().prefs.getString(_selectedTypePreferencesName) ??
            '';

    _selectedGenresPreferencesName =
        '${widget.listService.listName}_SelectedGenres';
    _selectedGenres = PreferencesService()
            .prefs
            .getStringList(_selectedGenresPreferencesName) ??
        [];

    _filterByProvidersPreferencesName =
        '${widget.listService.listName}_FilterByProviders';
    _filterByProviders =
        PreferencesService().prefs.getBool(_filterByProvidersPreferencesName) ??
            false;

    widget.listService.addListener(_onListServiceChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _setupFilters();
    });
  }

  @override
  void dispose() {
    widget.listService.removeListener(_onListServiceChanged);
    _textFilterController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent && _searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
    _initilizeControlLocalizations();
  }

  void _onListServiceChanged() {
    if (mounted) {
      _initilizeControlLocalizations();
    }
  }

  void _initilizeControlLocalizations() {
    setState(() {
      final localizations = AppLocalizations.of(context)!;
      if (_selectedType.isEmpty) {
        _selectedType = localizations.allTypes;
      }
      _titleTypes = [
        localizations.allTypes,
        localizations.movies,
        localizations.tvshows,
      ];
      if (_selectedSort.isEmpty) {
        _selectedSort = localizations.sortAlphabetically;
      }
      _titleSorts = [
        localizations.sortAlphabetically,
        localizations.sortRating,
        if (widget.listService.userRatingAvailable)
          localizations.sortUserRating,
        if (widget.listService.userRatedDateAvailable)
          localizations.sortDateRated,
        localizations.sortReleaseDate,
        localizations.sortRuntime,
      ];
    });
  }

  Future<void> _setupFilters() async {
    try {
      await widget.listService.setFilters(
        text: _textFilterController.text,
        type: _titleTypeToOption(_selectedType),
        genres: _selectedGenres,
        filterByProviders: _filterByProviders,
        providerListIds: _providerListIds,
      );
    } catch (_) {}
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

  Widget _titleList() {
    return ChangeNotifierProvider<TmdbListService>.value(
      value: widget.listService,
      child: Consumer<TmdbListService>(
        builder: (context, service, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              final metrics = scrollInfo.metrics;
              final currentScroll = metrics.pixels;

              final itemHeight = TitleCard.cardHeight;
              final firstVisibleIndex = (currentScroll / itemHeight).floor();
              final visibleItemCount =
                  (metrics.viewportDimension / itemHeight).ceil();
              final lastVisibleIndex = firstVisibleIndex + visibleItemCount;

              if (!service.isLoading.value &&
                  service.hasMore &&
                  lastVisibleIndex >= service.loadedTitleCount - 3) {
                service.loadNextPage();
              }
              return false;
            },
            child: Flexible(
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  key: const PageStorageKey('TitleListView'),
                  controller: _scrollController,
                  shrinkWrap: true,
                  cacheExtent: 2000.0,
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
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
        return Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              TitleListControlPanel(
                textFilterChanged: (newTextFilter) {
                  setState(() {
                    widget.listService.setTextFilter(newTextFilter);
                  });
                  PreferencesService()
                      .prefs
                      .setString(_textFilterPreferencesName, newTextFilter);
                },
                textFilterController: _textFilterController,
                selectedGenres: _selectedGenres.toList(),
                genresList: genres,
                genresChanged: (List<String> genresChanged) {
                  setState(() {
                    _selectedGenres = genresChanged.toList();
                    widget.listService.setGenresFilter(_selectedGenres);
                  });
                  PreferencesService().prefs.setStringList(
                      _selectedGenresPreferencesName, _selectedGenres);
                },
                filterByProviders: _filterByProviders,
                providersChanged: (bool providersChanged) {
                  setState(() {
                    _filterByProviders = providersChanged;
                    widget.listService.setProvidersFilter(
                        _filterByProviders, _providerListIds);
                  });
                  PreferencesService().prefs.setBool(
                      _filterByProvidersPreferencesName, _filterByProviders);
                },
                focusNode: _searchFocusNode,
              ),
              Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Divider(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoLine() {
    return Container(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
                PreferencesService()
                    .prefs
                    .setBool(_showFiltersPreferencesName, _showFilters);
              });
            },
            icon:
                Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
          ),
        ],
      ),
    );
  }

  String _titleTypeToOption(String type) {
    String selectedType = '';

    if (type == AppLocalizations.of(context)!.movies) {
      selectedType = 'movie';
    } else if (type == AppLocalizations.of(context)!.tvshows) {
      selectedType = 'tv';
    }

    return selectedType;
  }

  List<Widget> _buildTypeAndCountWidgets() {
    final selectedType = _titleTypeToOption(_selectedType);
    final textColor = selectedType == ''
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;
    final backgroundColor = selectedType == ''
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primary;

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
        selectedOption: _selectedType,
        options: _titleTypes,
        onSelected: (value) => setState(() {
          _selectedType = value;
          widget.listService.setTypeFilter(selectedType);
          PreferencesService()
              .prefs
              .setString(_selectedTypePreferencesName, _selectedType);
        }),
        arrowIcon: Icon(
          Icons.arrow_drop_down,
          color: textColor,
        ),
      )
    ];
  }

  String _sortNameToOption(BuildContext context, String name) {
    if (name == AppLocalizations.of(context)!.sortAlphabetically) {
      return SortOption.alphabetically;
    } else if (name == AppLocalizations.of(context)!.sortRating) {
      return SortOption.rating;
    } else if (name == AppLocalizations.of(context)!.sortUserRating) {
      return SortOption.userRating;
    } else if (name == AppLocalizations.of(context)!.sortDateRated) {
      return SortOption.dateRated;
    } else if (name == AppLocalizations.of(context)!.sortReleaseDate) {
      return SortOption.releaseDate;
    } else if (name == AppLocalizations.of(context)!.sortRuntime) {
      return SortOption.runtime;
    } else {
      return SortOption.alphabetically;
    }
  }

  Widget _sortSelector() {
    return DropdownSelector(
      selectedOption: _selectedSort,
      options: _titleSorts,
      onSelected: (value) => setState(() {
        _selectedSort = value;
        widget.listService
            .setSort(_sortNameToOption(context, value), _isSortAsc);
      }),
      arrowIcon: _isSortAsc
          ? Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(
              Icons.arrow_drop_up,
              color: Theme.of(context).colorScheme.primary,
            ),
    );
  }

  Widget _swapSortButton(BuildContext context) {
    return IconButton(
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(Icons.swap_vert),
      onPressed: () {
        setState(() {
          _isSortAsc = !_isSortAsc;
          widget.listService
              .setSort(_sortNameToOption(context, _selectedSort), _isSortAsc);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TmdbProviderService>(
      builder: (context, providerService, _) {
        final providerList = _retrieveUserProviders(providerService);

        if (!const ListEquality().equals(providerList, _providerListIds)) {
          _providerListIds = providerList;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.listService
                .setProvidersFilter(_filterByProviders, _providerListIds);
          });
        }

        return Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Divider(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                _infoLine(),
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                if (_showFilters) _controlPanel(),
                _titleList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
