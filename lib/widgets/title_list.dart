import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show ListEquality;
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_list_info_line.dart';
import 'package:moviescout/widgets/title_list_control_panel.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/widgets/title_list_controller.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/widgets/rating_filter_tabs.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/widgets/pinned_title_chip.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/utils/app_constants.dart';

class TitleList extends StatefulWidget {
  final TmdbListService listService;

  const TitleList(this.listService, {super.key});

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  late final TitleListController _controller;
  bool _isPinnedSectionExpanded = true;

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
    return Consumer<TmdbListService>(
      builder: (context, service, _) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            _controller.onScrollNotification(scrollInfo, TitleCard.cardHeight);
            return false;
          },
          child: Flexible(
            child: Scrollbar(
              controller: _controller.scrollController,
              child: ListView.builder(
                key: const PageStorageKey('TitleListView'),
                controller: _controller.scrollController,
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                ratingFilter: widget.listService is TmdbRateslistService
                    ? RatingFilterTabs(controller: _controller)
                    : null,
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

  Widget _pinnedTitlesRow() {
    return Consumer<TmdbListService>(
      builder: (context, service, _) {
        if (service.pinnedTitles.isEmpty ||
            service.listName != AppConstants.watchlist) {
          return const SizedBox.shrink();
        }

        final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

        return Container(
          color: titleTheme.listBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isPinnedSectionExpanded = !_isPinnedSectionExpanded;
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
                          color: titleTheme.listDividerColor
                              .withValues(alpha: 0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isPinnedSectionExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            titleTheme.listDividerColor.withValues(alpha: 0.7),
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
              Divider(height: 1, color: titleTheme.listDividerColor),
            ],
          ),
        );
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
                child: ChangeNotifierProvider<TmdbListService>.value(
                  value: widget.listService,
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
                        TitleListInfoLine(
                          controller: _controller,
                          listService: widget.listService,
                        ),
                        Divider(
                          height: 1,
                          color: titleTheme.listDividerColor,
                        ),
                        if (_controller.showFilters) _controlPanel(),
                        _pinnedTitlesRow(),
                        _titleList(),
                      ],
                    ),
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
