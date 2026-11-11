import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import "package:moviescout/features/auth/services/supabase_auth_service.dart";
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/seasons/services/tmdb_episode_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/core/widgets/media_carousel.dart';
import 'package:moviescout/features/people/widgets/person_chip.dart';
import 'package:moviescout/core/utils/date_formatter.dart';
import 'package:moviescout/core/widgets/expandable_description.dart';
import 'package:moviescout/core/widgets/action_menu.dart';
import 'package:moviescout/features/titles/widgets/rate_form.dart';
import 'package:moviescout/core/services/tmdb_translation_service.dart';
import 'package:moviescout/features/titles/widgets/user_rate_button.dart';
import 'package:provider/provider.dart';

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
    final String editUrl = UrlConstants.tmdbTvEpisodeEditWebTemplate
        .replaceFirst('{ID}', widget.title.tmdbId.toString())
        .replaceFirst('{SEASON_NUMBER}', widget.seasonNumber.toString())
        .replaceFirst('{EPISODE_NUMBER}', _currentEpisodeNumber.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          ActionMenu(
            editUrl: editUrl,
            fetchTranslations: () => TmdbTranslationService()
                .getEpisodeTranslations(widget.title.tmdbId,
                    widget.seasonNumber, _currentEpisodeNumber),
            originalTitle: cachedEpisode?.name ?? '',
            originalDescription: cachedEpisode?.overview ?? '',
          ),
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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppBreakpoints.maxContentWidth,
                  ),
                  child: _detailsBody(cachedEpisode),
                ),
              ),
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
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextEpisode() {
    if (widget.totalEpisodes == null ||
        _currentEpisodeNumber < widget.totalEpisodes!) {
      _pageController.nextPage(
        duration: AppDurations.normal,
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
          posterPath: episode.stillPath,
          mediaType: ApiConstants.tv,
          isLoading: _isUpdating,
        ),
        const SizedBox(height: AppSpacing.md),
        _details(episode),
      ],
    );
  }

  Widget _details(TmdbEpisode episode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.bottomSafeMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleLine(episode),
          const SizedBox(height: AppSpacing.xs),
          _durationDateAndRating(episode),
          const SizedBox(height: AppSpacing.xs),
          _description(episode),
          const SizedBox(height: AppSpacing.xl),
          _castAndCrew(episode, PersonAttributes.cast),
          const SizedBox(height: AppSpacing.xl),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              '${episode.episodeNumber}. ${episode.name}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentEpisodeNumber > 1 ? _goToPreviousEpisode : null,
        ),
        const SizedBox(width: AppSpacing.md),
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

  Future<void> _updateEpisodeRate(TmdbEpisode episode, double rating) async {
    await TmdbEpisodeService().updateEpisodeRate(
      episode,
      rating,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Widget _durationDateAndRating(TmdbEpisode episode) {
    final isUserLoggedIn =
        Provider.of<SupabaseAuthService>(context, listen: false).isLoggedIn;
    final metaStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Wrap(
            children: [
              if (episode.airDate.isNotEmpty)
                Text(
                  DateFormatter.formatDate(context, episode.airDate),
                  style: metaStyle,
                ),
              if (episode.airDate.isNotEmpty && episode.runtime > 0)
                Text(
                  ' - ',
                  style: metaStyle,
                ),
              if (episode.runtime > 0)
                Text(
                  '${episode.runtime} min',
                  style: metaStyle,
                ),
            ],
          ),
        ),
        UserRateButton(
          isUserLoggedIn: isUserLoggedIn,
          rating: episode.rating,
          iconSize: AppSizes.iconSm,
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.micro,
            horizontal: AppSpacing.xs,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return RateForm(
                title: episode.name.isNotEmpty
                    ? episode.name
                    : AppLocalizations.of(context)!
                        .episodeLabel(episode.episodeNumber),
                initialRate: episode.rating,
                initialDate: episode.rating > 0 &&
                        episode.dateRated.millisecondsSinceEpoch > 0
                    ? episode.dateRated
                    : null,
                onSubmit: (double rating) async {
                  await _updateEpisodeRate(episode, rating);
                },
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(
          Icons.star,
          size: AppSizes.iconSm,
          color: Theme.of(context).extension<CustomColors>()!.ratedTitle,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          episode.voteAverage == 10.0
              ? '10'
              : episode.voteAverage.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _description(TmdbEpisode episode) {
    if (episode.overview.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExpandableDescription(
      text: episode.overview,
      initialMaxLines: 5,
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
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toTitlePeopleList(
                  widget.title,
                  type,
                  widget.tmdbListService,
                );
              },
              child: Text(
                AppLocalizations.of(context)!.seeThemAll,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: AppSizes.chipCarouselHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: people.length > 20 ? 20 : people.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
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
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: UiUtils.clampedTextScaler(innerContext),
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
