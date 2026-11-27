import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_dimensions.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/widgets/app_error_view.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/features/seasons/services/tmdb_season_service.dart';
import 'package:moviescout/features/seasons/widgets/episode_card.dart';
import 'package:moviescout/core/widgets/media_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:moviescout/core/utils/date_formatter.dart';
import 'package:moviescout/core/widgets/action_menu.dart';
import 'package:moviescout/core/services/tmdb_translation_service.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/core/models/translations_pager.dart';
import 'package:moviescout/features/titles/widgets/trailer_buttons.dart';
import 'package:moviescout/core/widgets/boxed_widget.dart';
import 'package:moviescout/core/widgets/expandable_description.dart';
import 'package:moviescout/core/widgets/clickable_names.dart';
import 'package:moviescout/core/navigation/home_screen_shortcut_service.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/models/translation_context.dart';

class SeasonDetails extends StatefulWidget {
  final TmdbTitle title;
  final int seasonNumber;
  final TmdbTitleListService tmdbListService;

  const SeasonDetails({
    super.key,
    required this.title,
    required this.seasonNumber,
    required this.tmdbListService,
  });

  @override
  State<SeasonDetails> createState() => _SeasonDetailsState();
}

class _SeasonDetailsState extends State<SeasonDetails> {
  final Map<int, TmdbSeason> _loadedSeasons = {};
  final Set<int> _errorSeasons = {};
  bool _isLoading = true;
  late int _currentSeasonNumber;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentSeasonNumber = widget.seasonNumber;
    _pageController = PageController(initialPage: _currentSeasonNumber - 1);
    _loadSeasonDetails(_currentSeasonNumber);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSeasonDetails(int seasonNumber) async {
    if (!_loadedSeasons.containsKey(seasonNumber)) {
      if (mounted && _currentSeasonNumber == seasonNumber) {
        setState(() {
          _isLoading = true;
        });
      }
    }

    final season = await TmdbSeasonService().getSeasonDetails(
        widget.title.tmdbId, seasonNumber,
        includeYoutubeSearch: false);

    if (mounted) {
      setState(() {
        if (season != null) {
          _loadedSeasons[seasonNumber] = season;
          _errorSeasons.remove(seasonNumber);
        } else {
          _errorSeasons.add(seasonNumber);
        }
        if (_currentSeasonNumber == seasonNumber) {
          _isLoading = false;
        }
      });
    }
  }

  TranslationsPager? _buildTranslationsPager() {
    if (widget.title.numberOfSeasons <= 1) return null;
    return TranslationsPager(
      itemCount: widget.title.numberOfSeasons,
      initialIndex: _currentSeasonNumber - 1,
      pageTitleBuilder: (index, l10n) => l10n.seasonLabel(index + 1),
      loadPage: (index) async {
        final seasonNumber = index + 1;
        final cached = _loadedSeasons[seasonNumber];
        final results = await Future.wait([
          TmdbTranslationService()
              .getSeasonTranslations(widget.title.tmdbId, seasonNumber),
          if (cached != null)
            Future.value(cached)
          else
            TmdbSeasonService().getSeasonDetails(
              widget.title.tmdbId,
              seasonNumber,
              includeYoutubeSearch: false,
            ),
        ]);

        final translations = results[0] as List<TmdbTranslation>;
        final season = results[1] as TmdbSeason?;
        if (season != null && mounted) {
          _loadedSeasons[seasonNumber] = season;
        }
        final pageEditUrl = UrlConstants.tmdbTvSeasonEditWebTemplate
            .replaceFirst('{ID}', widget.title.tmdbId.toString())
            .replaceFirst('{SEASON_NUMBER}', seasonNumber.toString());

        return TranslationPageData(
          translations: translations,
          editUrl: pageEditUrl,
          translationContext: TranslationContext.fromItem(
            season,
            type: TranslationContentType.tvSeason,
            series: widget.title,
            seasonNumber: seasonNumber,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget.title.name;
    final cachedSeason = _loadedSeasons[_currentSeasonNumber];
    final String editUrl = UrlConstants.tmdbTvSeasonEditWebTemplate
        .replaceFirst('{ID}', widget.title.tmdbId.toString())
        .replaceFirst('{SEASON_NUMBER}', _currentSeasonNumber.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          ActionMenu(
            editUrl: editUrl,
            fetchTranslations: () => TmdbTranslationService()
                .getSeasonTranslations(
                    widget.title.tmdbId, _currentSeasonNumber),
            translationContext: TranslationContext.fromItem(
              cachedSeason,
              type: TranslationContentType.tvSeason,
              series: widget.title,
              seasonNumber: _currentSeasonNumber,
            ),
            translationsPager: _buildTranslationsPager(),
            shareUrl: UrlConstants.moviescoutTvSeasonWebTemplate
                .replaceFirst('{ID}', widget.title.tmdbId.toString())
                .replaceFirst(
                    '{SEASON_NUMBER}', _currentSeasonNumber.toString()),
            onPin: () async {
              final loc = AppLocalizations.of(context)!;
              final success = await HomeScreenShortcutService.pinSeasonShortcut(
                  widget.title,
                  _currentSeasonNumber,
                  cachedSeason?.name ?? '',
                  cachedSeason?.posterPath ?? '');
              if (!success) {
                SnackMessage.showSnackBar(loc.shortcutFailed);
              }
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.title.numberOfSeasons,
        onPageChanged: (index) {
          final newSeasonNumber = index + 1;
          if (newSeasonNumber != _currentSeasonNumber) {
            setState(() {
              _currentSeasonNumber = newSeasonNumber;
            });
            _loadSeasonDetails(newSeasonNumber);
          }
        },
        itemBuilder: (context, index) {
          final seasonNumber = index + 1;
          final cachedSeason = _loadedSeasons[seasonNumber];

          if (cachedSeason != null) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: AppBreakpoints.maxContentWidth),
                  child: _detailsBody(cachedSeason),
                ),
              ),
            );
          } else if (_errorSeasons.contains(seasonNumber)) {
            final loc = AppLocalizations.of(context)!;
            return Center(
              child: AppErrorView(
                title: loc.errorMessageGeneric,
                message: loc.networkErrorMessage,
                onRetry: () => _loadSeasonDetails(seasonNumber),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  !_loadedSeasons.containsKey(seasonNumber) &&
                  !_errorSeasons.contains(seasonNumber)) {
                _loadSeasonDetails(seasonNumber);
              }
            });
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _goToPreviousSeason() {
    if (_currentSeasonNumber > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextSeason() {
    if (_currentSeasonNumber < widget.title.numberOfSeasons) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _detailsBody(TmdbSeason season) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth <= AppBreakpoints.largeScreenMinWidth;

        return Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            top: AppSpacing.md,
            bottom: AppSpacing.detailBottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSection(season, isCompact: isCompact),
              if (isCompact && season.overview.isNotEmpty) ...[
                AppSpacing.gapMd,
                _description(season),
              ],
              _creditsInfo(season),
              AppSpacing.gapMd,
              Divider(
                  color:
                      Theme.of(context).extension<CustomColors>()!.dividerColor),
              _externalLinks(),
              Divider(
                  color:
                      Theme.of(context).extension<CustomColors>()!.dividerColor),
              AppSpacing.gapMd,
              _episodesList(season),
            ],
          ),
        );
      },
    );
  }

  Widget _headerSection(TmdbSeason season, {required bool isCompact}) {
    final double posterWidth = isCompact
        ? AppDimensions.detailPosterWidthCompact
        : AppDimensions.detailPosterWidthWide;
    final double posterHeight = posterWidth * AppDimensions.posterHeightRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: posterWidth,
          height: posterHeight,
          child: MediaCarousel(
            images: season.images,
            backdropPath: '',
            posterPath: season.posterPath,
            mediaType: ApiConstants.tv,
            isLoading: _isLoading,
            aspectRatio: 2 / 3,
          ),
        ),
        SizedBox(width: isCompact ? AppSpacing.md : AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleLine(season, showNavButtons: !isCompact),
              AppSpacing.gapSm,
              _dateAndRatingLine(season),
              AppSpacing.gapMd,
              _headerActions(season, showNavButtons: isCompact),
              if (!isCompact && season.overview.isNotEmpty) ...[
                AppSpacing.gapMd,
                _description(season),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _seasonNavButtons() {
    return [
      IconButton(
        icon: const Icon(Icons.chevron_left),
        visualDensity: VisualDensity.compact,
        onPressed: _currentSeasonNumber > 1 ? _goToPreviousSeason : null,
      ),
      IconButton(
        icon: const Icon(Icons.chevron_right),
        visualDensity: VisualDensity.compact,
        onPressed: _currentSeasonNumber < widget.title.numberOfSeasons
            ? _goToNextSeason
            : null,
      ),
    ];
  }

  Widget _headerActions(TmdbSeason season, {required bool showNavButtons}) {
    final hasNav = showNavButtons && widget.title.numberOfSeasons > 1;
    if (!hasNav) {
      return Align(
        alignment: Alignment.centerRight,
        child: TrailerButtons(videos: season.videos),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _seasonNavButtons(),
          ),
          TrailerButtons(videos: season.videos),
        ],
      ),
    );
  }

  Widget _titleLine(TmdbSeason season, {required bool showNavButtons}) {
    if (season.name.isEmpty && !showNavButtons) {
      return const SizedBox.shrink();
    }

    final titleWidget = season.name.isEmpty
        ? const SizedBox.shrink()
        : Text(
            season.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );

    if (!showNavButtons || widget.title.numberOfSeasons <= 1) {
      return titleWidget;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: titleWidget,
          ),
        ),
        ..._seasonNavButtons(),
      ],
    );
  }

  Widget _dateAndRatingLine(TmdbSeason season) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            DateFormatter.formatDate(context, season.airDate),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (season.voteAverage > 0)
          Row(
            children: [
              Icon(
                Icons.star,
                color: customColors.ratedTitle,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                season.voteAverage == 10.0
                    ? '10'
                    : season.voteAverage.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }

  Widget _description(TmdbSeason season) {
    return ExpandableDescription(
      text: season.overview,
      initialMaxLines: 5,
    );
  }

  Widget _infoColumn(String label, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        value,
      ],
    );
  }

  Widget _creditsInfo(TmdbSeason season) {
    if (season.creditsJson == null) return const SizedBox.shrink();

    final creators = season.crew
        .where((c) => c.job == 'Executive Producer' || c.job == 'Creator')
        .take(3)
        .toList();

    Widget? creatorsWidget;
    if (creators.isNotEmpty) {
      creatorsWidget = _infoColumn(
        AppLocalizations.of(context)!.creator,
        ClickableNames(
          people: creators,
          tmdbListService: widget.tmdbListService,
        ),
      );
    }

    final writers = season.crew
        .where((c) =>
            c.job == 'Writer' || c.job == 'Screenplay' || c.job == 'Author')
        .toList();

    Widget? writersWidget;
    if (writers.isNotEmpty) {
      writersWidget = _infoColumn(
        AppLocalizations.of(context)!.writer,
        ClickableNames(
          people: writers,
          tmdbListService: widget.tmdbListService,
        ),
      );
    }

    if (creatorsWidget == null && writersWidget == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (creatorsWidget != null) creatorsWidget,
          if (creatorsWidget != null && writersWidget != null)
            AppSpacing.gapSm,
          if (writersWidget != null) writersWidget,
        ],
      ),
    );
  }

  Widget _externalLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.watchOn,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BoxedWidget(
              onPressed: () {
                launchUrl(
                  Uri.parse(UrlConstants.tmdbTvSeasonWebTemplate
                      .replaceFirst('{ID}', widget.title.tmdbId.toString())
                      .replaceFirst(
                          '{SEASON_NUMBER}', widget.seasonNumber.toString())),
                  mode: LaunchMode.externalApplication,
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SizedBox(
                height: 20,
                child: Image.asset(
                  'assets/tmdb-logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _episodesList(TmdbSeason season) {
    if (season.episodes.isEmpty) return const SizedBox.shrink();

    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${season.episodes.length} ${AppLocalizations.of(context)!.episodes}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Divider(),
        ...season.episodes.map((episode) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: EpisodeCard(
                  title: widget.title,
                  seasonNumber: _currentSeasonNumber,
                  episode: episode,
                  tmdbListService: widget.tmdbListService,
                  totalEpisodes: season.episodes.length,
                ),
              ),
              Divider(
                height: 1,
                color: customColors.dividerColor,
              ),
            ],
          );
        }),
      ],
    );
  }
}
