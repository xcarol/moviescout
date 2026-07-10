import 'package:moviescout/utils/url_constants.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_season_service.dart';
import 'package:moviescout/widgets/episode_card.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moviescout/utils/date_formatter.dart';
import 'package:moviescout/widgets/edit_button.dart';
import 'package:moviescout/widgets/translations_button.dart';
import 'package:moviescout/services/tmdb_translation_service.dart';
import 'package:moviescout/widgets/trailer_buttons.dart';
import 'package:moviescout/widgets/boxed_widget.dart';
import 'package:moviescout/widgets/expandable_description.dart';
import 'package:moviescout/widgets/clickable_names.dart';
import 'package:moviescout/services/home_screen_shortcut_service.dart';
import 'package:moviescout/utils/snack_bar.dart';

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
        }
        if (_currentSeasonNumber == seasonNumber) {
          _isLoading = false;
        }
      });
    }
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
          EditButton(url: editUrl),
          TranslationsButton(
              editUrl: editUrl,
              fetchTranslations: () => TmdbTranslationService()
                  .getSeasonTranslations(
                      widget.title.tmdbId, _currentSeasonNumber),
              originalTitle: cachedSeason?.name ?? '',
              originalDescription: cachedSeason?.overview ?? ''),
          IconButton(
            icon: const Icon(Icons.add_to_home_screen),
            onPressed: () async {
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
            tooltip: AppLocalizations.of(context)!.addToHomeScreen,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String link = UrlConstants.moviescoutTvSeasonWebTemplate
                  .replaceFirst('{ID}', widget.title.tmdbId.toString())
                  .replaceFirst(
                      '{SEASON_NUMBER}', _currentSeasonNumber.toString());
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse(link)),
              );
            },
            tooltip: AppLocalizations.of(context)!.shareLink,
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
              child: _detailsBody(cachedSeason),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_loadedSeasons.containsKey(seasonNumber)) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediaCarousel(
          images: season.images,
          backdropPath: '',
          posterPath: season.posterPath,
          isMovie: false,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 20),
        _details(season),
      ],
    );
  }

  Widget _details(TmdbSeason season) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleLine(season),
          const SizedBox(height: 10),
          _dateAndRatingLine(season),
          const SizedBox(height: 10),
          _description(season),
          const SizedBox(height: 30),
          _creditsInfo(season),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TrailerButtons(videos: season.videos),
            ),
          ),
          Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor),
          _externalLinks(),
          Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor),
          const SizedBox(height: 10),
          _episodesList(season),
        ],
      ),
    );
  }

  Widget _titleLine(TmdbSeason season) {
    if (season.name.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: Text(
            season.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentSeasonNumber > 1 ? _goToPreviousSeason : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentSeasonNumber < widget.title.numberOfSeasons
              ? _goToNextSeason
              : null,
        ),
      ],
    );
  }

  Widget _dateAndRatingLine(TmdbSeason season) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              DateFormatter.formatDate(context, season.airDate),
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
                season.voteAverage.toStringAsFixed(1),
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
      creatorsWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _infoColumn(
          AppLocalizations.of(context)!.creator,
          ClickableNames(
            people: creators,
            tmdbListService: widget.tmdbListService,
          ),
        ),
      );
    }

    final writers = season.crew
        .where((c) =>
            c.job == 'Writer' || c.job == 'Screenplay' || c.job == 'Author')
        .toList();

    Widget? writersWidget;
    if (writers.isNotEmpty) {
      writersWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _infoColumn(
          AppLocalizations.of(context)!.writer,
          ClickableNames(
            people: writers,
            tmdbListService: widget.tmdbListService,
          ),
        ),
      );
    }

    if (creatorsWidget == null && writersWidget == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (creatorsWidget != null) creatorsWidget,
        if (creatorsWidget != null && writersWidget != null)
          const SizedBox(height: 10),
        if (writersWidget != null) writersWidget,
      ],
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
                  mode: LaunchMode.inAppWebView,
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
