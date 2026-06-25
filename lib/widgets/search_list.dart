import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/services/tmdb_search_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/search_list_info_line.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/person_card.dart';

class SearchList extends StatefulWidget {
  final TmdbSearchService searchService;
  final TmdbTitleListService titleListServiceSupport;

  const SearchList({
    super.key,
    required this.searchService,
    required this.titleListServiceSupport,
  });

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.searchService,
      builder: (context, _) {
        final customColors = Theme.of(context).extension<CustomColors>()!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchListInfoLine(
              searchService: widget.searchService,
              onFilterChanged: () {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(0.0);
                }
              },
            ),
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
                        final clampedScale =
                            mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

                        return MediaQuery(
                          data: mediaQuery.copyWith(
                            textScaler: TextScaler.linear(clampedScale),
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
  }
}
