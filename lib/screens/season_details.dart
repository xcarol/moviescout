import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_season.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/person_details.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/services/tmdb_season_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/episode_card.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SeasonDetails extends StatefulWidget {
  final TmdbTitle title;
  final int seasonNumber;
  final TmdbListService tmdbListService;

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
  TmdbSeason? _season;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeasonDetails();
  }

  Future<void> _loadSeasonDetails() async {
    final season = await TmdbSeasonService().getSeasonDetails(
        widget.title.tmdbId, widget.seasonNumber,
        includeYoutubeSearch: false);

    if (mounted) {
      setState(() {
        _season = season;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget.title.name;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: appTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String link =
                  'https://www.themoviedb.org/tv/${widget.title.tmdbId}/season/${widget.seasonNumber}';
              SharePlus.instance.share(
                ShareParams(text: '$appTitle\n$link'),
              );
            },
            tooltip: AppLocalizations.of(context)!.shareLink,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _season == null
              ? const Center(child: Text('Failed to load season details'))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _detailsBody(_season!),
                ),
    );
  }

  Widget _detailsBody(TmdbSeason season) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediaCarousel(
          images: season.images,
          videos: season.videos,
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
          const Divider(),
          _externalLinks(),
          const Divider(),
          // const SizedBox(height: 10),
          _episodesList(season),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _titleLine(TmdbSeason season) {
    if (season.name.isEmpty) return const SizedBox.shrink();

    return Text(
      season.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.start,
    );
  }

  Widget _dateAndRatingLine(TmdbSeason season) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              season.airDate,
              maxLines: 1,
            ),
          ),
        ),
        if (season.voteAverage > 0)
          Row(
            children: [
              Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.onSurface,
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
    return Text(
      season.overview.isEmpty
          ? AppLocalizations.of(context)!.missingDescription
          : season.overview,
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
            AppLocalizations.of(context)!.creator, _clickableNames(creators)),
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
            AppLocalizations.of(context)!.writer, _clickableNames(writers)),
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

  Widget _clickableNames(List<TmdbPerson> people) {
    return Row(
      children: people.asMap().entries.map((entry) {
        final index = entry.key;
        final person = entry.value;
        final isLast = index == people.length - 1;

        return Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetails(
                      person: person,
                      tmdbListService: widget.tmdbListService,
                    ),
                  ),
                );
              },
              child: Text(
                person.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (!isLast) const Text(', '),
          ],
        );
      }).toList(),
    );
  }

  Widget _externalLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            launchUrl(
              Uri.parse(
                  'https://www.themoviedb.org/tv/${widget.title.tmdbId}/season/${widget.seasonNumber}'),
              mode: LaunchMode.inAppWebView,
            );
          },
          child: SizedBox(
            height: 30,
            child: Image.asset(
              'assets/tmdb-logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _episodesList(TmdbSeason season) {
    if (season.episodes.isEmpty) return const SizedBox.shrink();

    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

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
                  seasonNumber: widget.seasonNumber,
                  episode: episode,
                  tmdbListService: widget.tmdbListService,
                ),
              ),
              Divider(
                height: 1,
                color: titleTheme.listDividerColor,
              ),
            ],
          );
        }),
      ],
    );
  }
}
