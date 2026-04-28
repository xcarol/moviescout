import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_episode.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/title_people_list.dart';
import 'package:moviescout/services/tmdb_episode_service.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/media_carousel.dart';
import 'package:moviescout/widgets/person_chip.dart';

class EpisodeDetails extends StatefulWidget {
  final TmdbTitle title;
  final int seasonNumber;
  final int episodeNumber;
  final TmdbListService tmdbListService;
  final TmdbEpisode? initialEpisode; // allows fast-loading before API call finishes

  const EpisodeDetails({
    super.key,
    required this.title,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.tmdbListService,
    this.initialEpisode,
  });

  @override
  State<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  TmdbEpisode? _currentEpisode;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentEpisode = widget.initialEpisode;
    _updateDetails();
  }

  Future<void> _updateDetails() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updated = await TmdbEpisodeService().getEpisodeDetails(
          widget.title.tmdbId, widget.seasonNumber, widget.episodeNumber);

      if (mounted) {
        setState(() {
          if (updated != null) {
            _currentEpisode = updated;
          }
          _isUpdating = false;
        });
      }
    } catch (e) {
      if (mounted) {
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
      appBar: MainAppBar(
        context: context,
        title: appTitle,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _detailsBody(),
      ),
    );
  }

  Widget _detailsBody() {
    if (_currentEpisode == null && _isUpdating) {
      return const Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final episode = _currentEpisode;
    if (episode == null) {
      return const Center(child: Text('Failed to load episode details'));
    }

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
          _durationAndDate(episode),
          const SizedBox(height: 10),
          _rating(episode),
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

    return Text(
      '${episode.episodeNumber}. ${episode.name}',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: TextAlign.start,
    );
  }

  Widget _durationAndDate(TmdbEpisode episode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (episode.airDate.isNotEmpty) Text(episode.airDate),
                if (episode.airDate.isNotEmpty && episode.runtime > 0)
                  const Text(' - '),
                if (episode.runtime > 0) Text('${episode.runtime} min'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rating(TmdbEpisode episode) {
    if (episode.voteAverage == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
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
    final clampedScale =
        MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(clampedScale),
      ),
      child: PersonChip(
        person: tmdbPerson,
        tmdbListService: widget.tmdbListService,
      ),
    );
  }
}
