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
                      TitleListInfoLine(
                        controller: _controller,
                        listService: widget.listService,
                      ),
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
