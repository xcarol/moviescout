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
import 'package:moviescout/widgets/edit_button.dart';
import 'package:moviescout/widgets/translations_button.dart';
import 'package:moviescout/services/tmdb_translation_service.dart';

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
  final Map<int, TmdbEpisode> _loadedEpisodes = {};
  bool _isUpdating = false;
  late int _currentEpisodeNumber;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentEpisodeNumber = widget.episodeNumber;
    _pageController = PageController(initialPage: _currentEpisodeNumber - 1);
    if (widget.initialEpisode != null) {
      _loadedEpisodes[_currentEpisodeNumber] = widget.initialEpisode!;
    }
    _updateDetails(_currentEpisodeNumber);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _updateDetails(int episodeNumber) async {
    if (!_loadedEpisodes.containsKey(episodeNumber)) {
      if (mounted && _currentEpisodeNumber == episodeNumber) {
        setState(() {
          _isUpdating = true;
        });
      }
    }

    try {
      final updated = await TmdbEpisodeService().getEpisodeDetails(
          widget.title.tmdbId, widget.seasonNumber, episodeNumber);

      if (mounted) {
        setState(() {
          if (updated != null) {
            _loadedEpisodes[episodeNumber] = updated;
          }
          if (_currentEpisodeNumber == episodeNumber) {
            _isUpdating = false;
          }
        });
      }
    } catch (e) {
      if (mounted && _currentEpisodeNumber == episodeNumber) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = widget.title.name;
    final cachedEpisode = _loadedEpisodes[_currentEpisodeNumber];
    final String editUrl =
        'https://www.themoviedb.org/tv/${widget.title.tmdbId}/season/${widget.seasonNumber}/episode/$_currentEpisodeNumber/edit';

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          EditButton(url: editUrl),
          TranslationsButton(
              editUrl: editUrl,
              fetchTranslations: () => TmdbTranslationService()
                  .getEpisodeTranslations(widget.title.tmdbId,
                      widget.seasonNumber, _currentEpisodeNumber),
              originalTitle: cachedEpisode?.name ?? '',
              originalDescription: cachedEpisode?.overview ?? ''),
        ],
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
            _updateDetails(newEpNumber);
          }
        },
        itemBuilder: (context, index) {
          final epNumber = index + 1;
          final cachedEpisode = _loadedEpisodes[epNumber];

          if (cachedEpisode != null) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _detailsBody(cachedEpisode),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_loadedEpisodes.containsKey(epNumber)) {
                _updateDetails(epNumber);
              }
            });
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

    return Text(
      episode.overview.isEmpty
          ? AppLocalizations.of(context)!.missingDescription
          : episode.overview,
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
        SizedBox(
          height: 336.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: people.length > 20 ? 20 : people.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _personChip(context, people[index]),
              );
            },
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
            episodeContext: _loadedEpisodes[_currentEpisodeNumber],
          ),
        );
      },
    );
  }
}
