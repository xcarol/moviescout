import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/people/widgets/person_card.dart';
import 'package:moviescout/features/people/widgets/person_chip.dart';
import 'package:moviescout/features/people/widgets/person_list_control_panel.dart';
import 'package:moviescout/features/people/widgets/person_list_info_line.dart';
import 'package:moviescout/features/people/widgets/person_list_controller.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/people/services/tmdb_person_list_service.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/core/widgets/searchable_list_state.dart';
import 'package:moviescout/core/utils/ui_utils.dart';

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

  Widget _buildPersonCard(
    BuildContext context,
    dynamic person, {
    required bool showDivider,
  }) {
    if (person == null) return const SizedBox.shrink();

    final titleTheme = Theme.of(context).extension<CustomColors>()!;

    return Builder(
      builder: (innerContext) {
        final mediaQuery = MediaQuery.of(innerContext);
        final card = MediaQuery(
          data: mediaQuery.copyWith(
            textScaler:
                TextScaler.linear(UiUtils.clampedTextScale(innerContext)),
          ),
          child: PersonCard(
            person: person,
            tmdbListService: widget.titleListService,
            titleContext: widget.titleContext,
            seasonContext: widget.seasonContext,
            episodeContext: widget.episodeContext,
          ),
        );

        if (!showDivider) return card;

        return Column(
          children: [
            card,
            Divider(
              height: 1,
              color: titleTheme.dividerColor,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardsView(bool isWide) {
    if (isWide) {
      return GridView.builder(
        key: const PageStorageKey('PersonCardsGridView'),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _controller.scrollController,
        itemCount: widget.personListService.loadedItemCount,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.lg,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppBreakpoints.maxGridCrossAxisExtent,
          mainAxisExtent: PersonCard.cardHeight,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemBuilder: (context, index) {
          final person = widget.personListService.getItem(index);
          return _buildPersonCard(context, person, showDivider: false);
        },
      );
    }

    return ListView.builder(
      key: const PageStorageKey('PersonCardsListView'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _controller.scrollController,
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: widget.personListService.loadedItemCount,
      itemBuilder: (context, index) {
        final person = widget.personListService.getItem(index);
        return _buildPersonCard(context, person, showDivider: true);
      },
    );
  }

  Widget _buildChipsView() {
    return GridView.builder(
      key: const PageStorageKey('PersonChipsGridView'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _controller.scrollController,
      itemCount: widget.personListService.loadedItemCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 140.0,
        childAspectRatio: CARD_WIDTH / CARD_HEIGHT,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      itemBuilder: (context, index) {
        return Builder(
          builder: (innerContext) {
            final person = widget.personListService.getItem(index);
            if (person == null) return const SizedBox.shrink();

            final mediaQuery = MediaQuery.of(innerContext);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler:
                    TextScaler.linear(UiUtils.clampedTextScale(innerContext)),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth > AppBreakpoints.largeScreenMinWidth;

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            _controller.onScrollNotification(scrollInfo);
            return false;
          },
          child: Scrollbar(
            controller: _controller.scrollController,
            child: _controller.isGridView
                ? _buildChipsView()
                : _buildCardsView(isWide),
          ),
        );
      },
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
