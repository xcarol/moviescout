import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/widgets/cards/person_card.dart';
import 'package:moviescout/widgets/chips/person_chip.dart';
import 'package:moviescout/widgets/lists/person_list_control_panel.dart';
import 'package:moviescout/widgets/lists/person_list_info_line.dart';
import 'package:moviescout/widgets/lists/person_list_controller.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_person_list_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/widgets/lists/searchable_list_state.dart';
import 'package:moviescout/utils/ui_utils.dart';

class PersonList extends StatefulWidget {
  final TmdbPersonListService personListService;
  final String type;
  final TmdbTitleListService titleListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  const PersonList({
    super.key,
    required this.personListService,
    required this.type,
    required this.titleListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  });

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends SearchableListState<PersonList> {
  late final PersonListController _controller;

  @override
  FocusNode get searchFocusNode => _controller.searchFocusNode;

  @override
  void initState() {
    super.initState();
    _controller = PersonListController(widget.personListService, widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeControlLocalizations(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildListView() {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _controller.scrollController,
      itemCount: widget.personListService.loadedItemCount,
      itemBuilder: (context, index) {
        return Builder(
          builder: (innerContext) {
            final person = widget.personListService.getItem(index);
            if (person == null) return const SizedBox.shrink();

            final titleTheme = Theme.of(context).extension<CustomColors>()!;

            final mediaQuery = MediaQuery.of(innerContext);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                    UiUtils.scaleFactor(innerContext, 1.0, 1.0, 1.3)),
              ),
              child: Column(
                children: [
                  PersonCard(
                    person: person,
                    tmdbListService: widget.titleListService,
                    titleContext: widget.titleContext,
                    seasonContext: widget.seasonContext,
                    episodeContext: widget.episodeContext,
                  ),
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
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _controller.scrollController,
      itemCount: widget.personListService.loadedItemCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 140.0,
        childAspectRatio: CARD_WIDTH / CARD_HEIGHT,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        return Builder(
          builder: (innerContext) {
            final person = widget.personListService.getItem(index);
            if (person == null) return const SizedBox.shrink();

            final mediaQuery = MediaQuery.of(innerContext);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                    UiUtils.scaleFactor(innerContext, 1.0, 1.0, 1.3)),
              ),
              child: PersonChip(
                person: person,
                tmdbListService: widget.titleListService,
                titleContext: widget.titleContext,
                seasonContext: widget.seasonContext,
                episodeContext: widget.episodeContext,
              ),
            );
          },
        );
      },
    );
  }

  Widget _personList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        _controller.onScrollNotification(scrollInfo);
        return false;
      },
      child: Scrollbar(
        controller: _controller.scrollController,
        child: _controller.isGridView ? _buildGridView() : _buildListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final titleTheme = Theme.of(context).extension<CustomColors>()!;
        return Column(
          children: [
            PersonListInfoLine(controller: _controller),
            Divider(
              height: 1,
              color: titleTheme.dividerColor,
            ),
            if (_controller.showFilters)
              PersonListControlPanel(
                textFilterController: _controller.textFilterController,
                focusNode: _controller.searchFocusNode,
                onTextChanged: (value) => _controller.setTextFilter(value),
              ),
            Expanded(child: _personList()),
          ],
        );
      },
    );
  }
}
