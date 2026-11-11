import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/core/widgets/searchable_list_state.dart';
import 'package:moviescout/features/people/services/tmdb_person_list_service.dart';
import 'package:moviescout/features/people/widgets/person_card.dart';
import 'package:moviescout/features/people/widgets/person_chip.dart';
import 'package:moviescout/features/people/widgets/person_list_control_panel.dart';
import 'package:moviescout/features/people/widgets/person_list_controller.dart';
import 'package:moviescout/features/people/widgets/person_list_info_line.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= AppBreakpoints.compact;
        final titleTheme = Theme.of(context).extension<CustomColors>()!;

        if (isWide) {
          return GridView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _controller.scrollController,
            padding: AppSpacing.screenPadding,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: AppBreakpoints.maxGridCardExtent,
              mainAxisExtent: PersonCard.cardHeight,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: widget.personListService.loadedItemCount,
            itemBuilder: (context, index) {
              return Builder(
                builder: (innerContext) {
                  final person = widget.personListService.getItem(index);
                  if (person == null) return const SizedBox.shrink();
                  final mediaQuery = MediaQuery.of(innerContext);
                  return MediaQuery(
                    data: mediaQuery.copyWith(
                      textScaler: UiUtils.clampedTextScaler(innerContext),
                    ),
                    child: PersonCard(
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

        return ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _controller.scrollController,
          itemCount: widget.personListService.loadedItemCount,
          itemBuilder: (context, index) {
            return Builder(
              builder: (innerContext) {
                final person = widget.personListService.getItem(index);
                if (person == null) return const SizedBox.shrink();

                final mediaQuery = MediaQuery.of(innerContext);

                return MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: UiUtils.clampedTextScaler(innerContext),
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
                        height: AppSizes.borderWidthRegular,
                        color: titleTheme.dividerColor,
                      ),
                    ],
                  ),
                );
              },
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
        maxCrossAxisExtent: AppSizes.personGridMaxExtent,
        childAspectRatio: CARD_WIDTH / CARD_HEIGHT,
        crossAxisSpacing: AppSpacing.xs,
        mainAxisSpacing: AppSpacing.xs,
      ),
      padding: AppSpacing.chipPadding,
      itemBuilder: (context, index) {
        return Builder(
          builder: (innerContext) {
            final person = widget.personListService.getItem(index);
            if (person == null) return const SizedBox.shrink();

            final mediaQuery = MediaQuery.of(innerContext);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: UiUtils.clampedTextScaler(innerContext),
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
              height: AppSizes.borderWidthRegular,
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
