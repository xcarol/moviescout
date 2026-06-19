import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_people_list.dart';
import 'package:moviescout/services/tmdb_episode_service.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:moviescout/widgets/person_chip.dart';
import 'package:moviescout/utils/date_formatter.dart';

class EpisodeDetails extends StatefulWidget {
  final TmdbTitle title;
  final int seasonNumber;
  final int episodeNumber;
  final TmdbTitleListService tmdbListService;
  final TmdbEpisode?
      initialEpisode; // allows fast-loading before API call finishes
  final int? totalEpisodes;

  const EpisodeDetails({
    super.key,
    required this.title,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.tmdbListService,
    this.initialEpisode,
    this.totalEpisodes,
  });

  @override
  State<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  TmdbEpisode? _currentEpisode;
  bool _isUpdating = false;
  late int _currentEpisodeNumber;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.initialEpisode;
    _currentEpisodeNumber = widget.episodeNumber;
    _pageController = PageController(initialPage: _currentEpisodeNumber - 1);
    _updateDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _updateDetails() async {
    final requestedEpNumber = _currentEpisodeNumber;
    setState(() {
      _isUpdating = true;
    });

    try {
      final updated = await TmdbEpisodeService().getEpisodeDetails(
          widget.title.tmdbId, widget.seasonNumber, requestedEpNumber);

      if (mounted && _currentEpisodeNumber == requestedEpNumber) {
        setState(() {
          if (updated != null) {
            _currentEpisode = updated;
          }
          _isUpdating = false;
        });
      }
    } catch (e) {
      if (mounted && _currentEpisodeNumber == requestedEpNumber) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget.title.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.totalEpisodes,
        onPageChanged: (index) {
          final newEpNumber = index + 1;
          if (newEpNumber != _currentEpisodeNumber) {
            setState(() {
              _currentEpisodeNumber = newEpNumber;
            });
            _updateDetails();
          }
        },
        itemBuilder: (context, index) {
          if (index + 1 == _currentEpisodeNumber) {
            if (_isUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (_currentEpisode == null) {
              return const Center(child: Text('Failed to load episode details'));
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _detailsBody(_currentEpisode!),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _goToPreviousEpisode() {
    if (_currentEpisodeNumber > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextEpisode() {
    if (widget.totalEpisodes == null ||
        _currentEpisodeNumber < widget.totalEpisodes!) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _detailsBody(TmdbEpisode episode) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediaCarousel(
            images: episode.images,
            videos: episode.videos,
            backdropPath: '',
            posterPath: episode.stillPath, // Usually episodes have stills
            isMovie: false,
            isLoading: _isUpdating),
        const SizedBox(height: 20),
        _details(episode),
      ],
    );
  }

  Widget _details(TmdbEpisode episode) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleLine(episode),
          const SizedBox(height: 10),
          _durationDateAndRating(episode),
          const SizedBox(height: 10),
          _description(episode),
          const SizedBox(height: 30),
          _castAndCrew(episode, PersonAttributes.cast),
          const SizedBox(height: 30),
          _castAndCrew(episode, PersonAttributes.crew),
        ],
      ),
    );
  }

  Widget _titleLine(TmdbEpisode episode) {
    if (episode.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            '${episode.episodeNumber}. ${episode.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentEpisodeNumber > 1 ? _goToPreviousEpisode : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (widget.totalEpisodes == null ||
                  _currentEpisodeNumber < widget.totalEpisodes!)
              ? _goToNextEpisode
              : null,
        ),
      ],
    );
  }

  Widget _durationDateAndRating(TmdbEpisode episode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (episode.airDate.isNotEmpty)
                  Text(
                    DateFormatter.formatDate(context, episode.airDate),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (episode.airDate.isNotEmpty && episode.runtime > 0)
                  Text(
                    ' - ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (episode.runtime > 0)
                  Text(
                    '${episode.runtime} min',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Icon(
          Icons.star,
          size: 16,
          color: Theme.of(context).extension<CustomColors>()!.ratedTitle,
        ),
        const SizedBox(width: 5),
        Text(episode.voteAverage.toStringAsFixed(1)),
      ],
    );
  }

  Widget _description(TmdbEpisode episode) {
    if (episode.overview.isEmpty) {
      return const SizedBox.shrink();
    }

    return SelectableText(
      episode.overview,
      textAlign: TextAlign.justify,
    );
  }

  Widget _castAndCrew(TmdbEpisode episode, String type) {
    if (type == PersonAttributes.cast && episode.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    if (type == PersonAttributes.crew && episode.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    List<TmdbPerson> people;
    if (type == PersonAttributes.cast) {
      people = episode.cast;
    } else {
      people = episode.crew;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type == PersonAttributes.cast
                    ? AppLocalizations.of(context)!.cast
                    : AppLocalizations.of(context)!.crew,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TitlePeopleList(
                            title: widget.title,
                            type: type,
                            tmdbListService: widget.tmdbListService,
                            episode: episode,
                          )),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: people
                .map((person) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _personChip(context, person)))
                .take(20)
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _personChip(BuildContext context, TmdbPerson tmdbPerson) {
    return Builder(
      builder: (innerContext) {
        final mediaQuery = MediaQuery.of(innerContext);
        final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: PersonChip(
            person: tmdbPerson,
            tmdbListService: widget.tmdbListService,
            titleContext: widget.title,
            episodeContext: _currentEpisode,
          ),
        );
      },
    );
  }
}
