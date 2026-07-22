import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart'
    show TmdbTitleRepository;
import 'package:moviescout/screens/season_details.dart';
import 'package:moviescout/screens/title_people_list.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/settings/region_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/widgets/buttons/trailer_buttons.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_title_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/widgets/chips/person_chip.dart';
import 'package:moviescout/widgets/text_and_info/social_link.dart';
import 'package:moviescout/widgets/layout/boxed_widget.dart';
import 'package:moviescout/widgets/buttons/edit_button.dart';
import 'package:moviescout/widgets/buttons/translations_button.dart';
import 'package:moviescout/services/api/tmdb_translation_service.dart';
import 'package:moviescout/services/system/home_screen_shortcut_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/widgets/dialogs_and_forms/rate_form.dart';
import 'package:moviescout/widgets/dialogs_and_forms/notify_dialog.dart';
import 'package:moviescout/widgets/chips/title_chip.dart';
import 'package:moviescout/widgets/buttons/watchlist_button.dart';
import 'package:moviescout/widgets/inputs_and_filters/drop_down_selector.dart';
import 'package:moviescout/widgets/media/media_carousel.dart';
import 'package:moviescout/widgets/text_and_info/omdb_rating_widget.dart';
import 'package:moviescout/widgets/text_and_info/expandable_description.dart';
import 'package:moviescout/widgets/text_and_info/clickable_names.dart';
import 'package:moviescout/widgets/buttons/pin_button.dart';
import 'package:moviescout/widgets/buttons/notify_button.dart';
import 'package:moviescout/services/api/omdb_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/widgets/layout/custom_refresh_builder.dart';
import 'package:moviescout/widgets/misc/bottom_clamping_scroll_physics.dart';

class TitleDetails extends StatefulWidget {
  final TmdbTitle _title;
  final TmdbTitleListService _tmdbListService;

  const TitleDetails({
    super.key,
    required TmdbTitle title,
    required TmdbTitleListService tmdbListService,
  })  : _title = title,
        _tmdbListService = tmdbListService;

  @override
  State<TitleDetails> createState() => _TitleDetailsState();
}

class _TitleDetailsState extends State<TitleDetails> {
  late TmdbTitle _currentTitle;
  bool _isUpdating = false;
  bool _isUpdatingRatings = false;
  List<Map<String, dynamic>>? _omdbRatings;
  String _selectedSeason = '';
  final _refreshController = IndicatorController();

  @override
  void initState() {
    super.initState();
    _currentTitle = widget._title;
    _initializeRatings();
    _updateDetails();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _initializeRatings() {
    if (_currentTitle.omdbRatingsJson != null &&
        _currentTitle.omdbRatingsJson!.isNotEmpty) {
      try {
        _omdbRatings = List<Map<String, dynamic>>.from(
            jsonDecode(_currentTitle.omdbRatingsJson!));
      } catch (_) {}
    }

    final bool wasUpToDate = TmdbTitleService.isUpToDate(_currentTitle);
    if (_omdbRatings == null || _omdbRatings!.isEmpty || !wasUpToDate) {
      _isUpdatingRatings = true;
    }
  }

  Future<void> _updateTitleRate(TmdbTitle title, double rating) async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);

    await rateslistService.updateTitleRate(
      userService.accountId,
      userService.sessionId,
      title,
      rating,
    );

    if (rating > AppConstants.seenRating &&
        title.status == TvShowStatus.returning &&
        !title.notifyNewSeasons) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => NotifyDialog(title: title),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = _currentTitle.name;
    final String editUrl = UrlConstants.tmdbTitleEditWebTemplate
        .replaceFirst('{MEDIA_TYPE}', _currentTitle.mediaType)
        .replaceFirst('{ID}', _currentTitle.tmdbId.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          EditButton(url: editUrl),
          TranslationsButton(
            editUrl: editUrl,
            fetchTranslations: () => TmdbTranslationService()
                .getTranslations(_currentTitle.mediaType, _currentTitle.tmdbId),
            originalTitle: _currentTitle.originalName.isNotEmpty
                ? _currentTitle.originalName
                : _currentTitle.name,
            originalDescription: _currentTitle.overview,
          ),
          IconButton(
            icon: const Icon(Icons.add_to_home_screen),
            onPressed: () async {
              final loc = AppLocalizations.of(context)!;
              final success = await HomeScreenShortcutService.pinTitleShortcut(
                  _currentTitle);
              if (!success) {
                SnackMessage.showSnackBar(loc.shortcutFailed);
              }
            },
            tooltip: AppLocalizations.of(context)!.addToHomeScreen,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String link = UrlConstants.moviescoutTitleWebTemplate
                  .replaceFirst('{MEDIA_TYPE}', _currentTitle.mediaType)
                  .replaceFirst('{ID}', _currentTitle.tmdbId.toString());
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse(link)),
              );
            },
            tooltip: AppLocalizations.of(context)!.shareLink,
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        controller: _refreshController,
        offsetToArmed: 100,
        onRefresh: () async {
          if (!_isUpdating) {
            await _updateDetails();
          }
        },
        builder: customRefreshBuilder,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(
            parent: BottomClampingScrollPhysics(
              topRefreshController: _refreshController,
              parent: ClampingWithOverscrollPhysics(
                state: _refreshController,
              ),
            ),
          ),
          child: _detailsBody(_currentTitle),
        ),
      ),
    );
  }

  Future<void> _updateDetails() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updated = await TmdbTitleService().updateTitleDetails(_currentTitle,
          force: true, includeYoutubeSearch: true);

      if (mounted) {
        setState(() {
          _currentTitle = updated;
          _isUpdating = false;
        });

        if (_isUpdatingRatings) {
          if (updated.imdbId.isNotEmpty) {
            final ratings = await OmdbService().getRatings(updated.imdbId);
            updated.omdbRatingsJson = jsonEncode(ratings);
            if (mounted) {
              setState(() {
                _omdbRatings = ratings;
                _isUpdatingRatings = false;
              });
            }
          } else if (mounted) {
            setState(() {
              _isUpdatingRatings = false;
            });
          }
        } else {
          if (mounted &&
              updated.omdbRatingsJson != null &&
              updated.omdbRatingsJson!.isNotEmpty) {
            try {
              setState(() {
                _omdbRatings = List<Map<String, dynamic>>.from(
                    jsonDecode(updated.omdbRatingsJson!));
              });
            } catch (_) {}
          }
        }

        final repository = TmdbTitleRepository();
        await repository.updateTitleMetadata(updated);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdating = false;
          _isUpdatingRatings = false;
        });
      }
    }
  }

  Widget _detailsBody(TmdbTitle title) {
    if (title.lastUpdated == AppConstants.defaultDate && _isUpdating) {
      return const Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            MediaCarousel(
                images: title.images,
                backdropPath: title.backdropPath,
                posterPath: title.posterPath,
                mediaType: title.isMovie ? ApiConstants.movie : ApiConstants.tv,
                isLoading: _isUpdating),
            Positioned(
              left: 8,
              bottom: -150,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 4,
                  ),
                ),
                child: title.posterPath.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: UrlConstants.tmdbImageW500Template
                            .replaceFirst('{PATH}', title.posterPath),
                        width: 120,
                        height: 170,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          title.isMovie
                              ? 'assets/movie_poster.png'
                              : 'assets/tvshow_poster.png',
                          width: 120,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        title.isMovie
                            ? 'assets/movie_poster.png'
                            : 'assets/tvshow_poster.png',
                        width: 120,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 150),
          padding:
              const EdgeInsets.only(left: 144, right: 5, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleLine(title),
                  _dateAndDuration(title),
                  _primaryCreator(title),
                ],
              ),
              _genres(title),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _details(title),
      ],
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

  Widget _infoLine(TmdbTitle title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _infoColumn(
                  AppLocalizations.of(context)!.originaTitle,
                  Text(title.originalName,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ))),
              _infoColumn(
                  AppLocalizations.of(context)!.originalLanguage,
                  Text(
                      LanguageService().getLanguageName(title.originalLanguage),
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ))),
              _infoColumn(
                  AppLocalizations.of(context)!.originCountry,
                  Text(
                      title.originCountry
                          .map((c) => RegionService().getRegionName(c))
                          .join(', '),
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _creditsInfo(TmdbTitle title) {
    if (title.creditsJson == null) return const SizedBox.shrink();

    Widget? creatorsWidget;
    if (title.isMovie) {
      final directors = title.crew
          .where((c) => c.job.split(', ').contains(CrewJobs.director))
          .toList();
      if (directors.isNotEmpty) {
        creatorsWidget = _infoColumn(
          AppLocalizations.of(context)!.director,
          ClickableNames(
            people: directors,
            tmdbListService: widget._tmdbListService,
          ),
        );
      }
    } else {
      final creators = title.crew
          .where((c) {
            final jobs = c.job.split(', ');
            return jobs.contains(CrewJobs.executiveProducer) ||
                jobs.contains(CrewJobs.creator);
          })
          .take(3)
          .toList();
      if (creators.isNotEmpty) {
        creatorsWidget = _infoColumn(
          AppLocalizations.of(context)!.creator,
          ClickableNames(
            people: creators,
            tmdbListService: widget._tmdbListService,
          ),
        );
      }
    }

    Widget? writersWidget;
    final writers = title.crew.where((c) {
      final jobs = c.job.split(', ');
      return jobs.contains(CrewJobs.writer) ||
          jobs.contains(CrewJobs.screenplay) ||
          jobs.contains(CrewJobs.author);
    }).toList();

    if (writers.isNotEmpty) {
      writersWidget = _infoColumn(
        AppLocalizations.of(context)!.writer,
        ClickableNames(
          people: writers,
          tmdbListService: widget._tmdbListService,
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

  Widget _externalLinks(TmdbTitle title) {
    List<Widget> links = [];

    links.add(
      SocialLink.image(
        url: UrlConstants.tmdbTitleWebTemplate
            .replaceFirst('{MEDIA_TYPE}', title.mediaType)
            .replaceFirst('{ID}', title.tmdbId.toString()),
        assetPath: 'assets/tmdb-logo-square.png',
        launchMode: LaunchMode.inAppWebView,
      ),
    );

    if (title.imdbId.isNotEmpty) {
      links.add(
        SocialLink.image(
          url: UrlConstants.imdbTitleTemplate
              .replaceFirst('{ID}', title.imdbId.toString()),
          assetPath: 'assets/imdb-logo-square.png',
          launchMode: LaunchMode.inAppBrowserView,
        ),
      );
    }

    final externalIds = title.externalIds;
    _addSocialLink(links, externalIds['wikidata_id'],
        'https://www.wikidata.org/wiki/{ID}', 'assets/wikidata.png');
    _addSocialLink(links, externalIds['facebook_id'],
        'https://facebook.com/{ID}', 'assets/facebook.png');
    _addSocialLink(links, externalIds['instagram_id'],
        'https://instagram.com/{ID}', 'assets/instagram.png');
    _addSocialLink(
        links, externalIds['twitter_id'], 'https://x.com/{ID}', 'assets/X.png');
    _addSocialLink(links, externalIds['tiktok_id'], 'https://tiktok.com/@{ID}',
        'assets/tiktok.png');
    _addSocialLink(links, externalIds['youtube_id'], 'https://youtube.com/{ID}',
        'assets/youtube.png');

    if (title.homepage.isNotEmpty) {
      links.add(
        SocialLink.icon(
          url: title.homepage,
          iconData: Icons.language,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.watchOn,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: links,
        ),
      ],
    );
  }

  void _addSocialLink(
      List<Widget> links, String? id, String urlTemplate, String logo) {
    if (id != null && id.isNotEmpty) {
      links.add(
        SocialLink.image(
          url: urlTemplate.replaceFirst('{ID}', id),
          assetPath: logo,
        ),
      );
    }
  }

  Widget _details(TmdbTitle title) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tagLine(title),
          _actionButtons(title),
          const SizedBox(height: 10),
          _rating(title),
          const SizedBox(height: 10),
          _description(title),
          if (!title.isMovie && title.numberOfSeasons > 0) ...[
            const SizedBox(height: 15),
            _seasonsDropdown(title),
          ],
          const SizedBox(height: 10),
          _infoLine(title),
          const SizedBox(height: 10),
          _creditsInfo(title),
          Divider(
            color: Theme.of(context).extension<CustomColors>()!.dividerColor,
          ),
          _externalLinks(title),
          if (_isAnyProvider(title))
            Divider(
              color: Theme.of(context).extension<CustomColors>()!.dividerColor,
            ),
          _providers(title),
          Divider(
            color: Theme.of(context).extension<CustomColors>()!.dividerColor,
          ),
          _recommended(title),
          const SizedBox(height: 30),
          _castAndCrew(title, PersonAttributes.cast),
          const SizedBox(height: 30),
          _castAndCrew(title, PersonAttributes.crew),
        ],
      ),
    );
  }

  bool _isAnyProvider(TmdbTitle title) {
    return title.providers.flatrate.isNotEmpty ||
        title.providers.rent.isNotEmpty ||
        title.providers.buy.isNotEmpty;
  }

  Widget _titleLine(TmdbTitle title) {
    if (title.name.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateAndDuration(TmdbTitle title) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${_releaseDates(title)} - ${_duration(title)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (title.certification.isNotEmpty) ...[
          const SizedBox(width: 8),
          _certificationBadge(title),
        ],
      ],
    );
  }

  Widget _certificationBadge(TmdbTitle title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title.certification,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _primaryCreator(TmdbTitle title) {
    if (title.creditsJson == null) return const SizedBox.shrink();

    String label = '';
    List<TmdbPerson> people = [];

    final directors = title.crew
        .where((c) => c.job.split(', ').contains(CrewJobs.director))
        .toList();
    final creators = title.crew.where((c) {
      final jobs = c.job.split(', ');
      return jobs.contains(CrewJobs.executiveProducer) ||
          jobs.contains(CrewJobs.creator);
    }).toList();
    final writers = title.crew.where((c) {
      final jobs = c.job.split(', ');
      return jobs.contains(CrewJobs.writer) ||
          jobs.contains(CrewJobs.screenplay) ||
          jobs.contains(CrewJobs.author);
    }).toList();

    if (directors.isNotEmpty) {
      label = AppLocalizations.of(context)!.director;
      people = [directors.first];
    } else if (creators.isNotEmpty) {
      label = AppLocalizations.of(context)!.creator;
      people = [creators.first];
    } else if (writers.isNotEmpty) {
      label = AppLocalizations.of(context)!.writer;
      people = [writers.first];
    }

    if (people.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoColumn(
            label,
            ClickableNames(
              people: people,
              tmdbListService: widget._tmdbListService,
              useEllipsis: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagLine(TmdbTitle title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.tagline,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _actionButtons(TmdbTitle title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        watchlistButton(context, title),
        const SizedBox(width: 8),
        pinButton(context, title),
        const SizedBox(width: 8),
        notifyButton(context, title),
        const Spacer(),
        TrailerButtons(videos: title.videos),
      ],
    );
  }

  Widget _rating(TmdbTitle title) {
    String titleVoteAverage = '-.-';
    final titleTheme = Theme.of(context).extension<CustomColors>()!;

    if (title.firstAirDate.isNotEmpty &&
        DateTime.parse(title.firstAirDate).isAfter(DateTime.now())) {
      return Text(AppLocalizations.of(context)!.notReleasedYet);
    }
    if (title.voteAverage > 0) {
      titleVoteAverage = title.voteAverage == 10.0
          ? '10'
          : title.voteAverage.toStringAsFixed(1);
    }

    List<Widget> topChildren = [];
    if (title.voteAverage > 0) {
      topChildren.addAll([
        Tooltip(
          message: 'The Movie Database',
          child: BoxedWidget(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/tmdb-logo-square.png', height: 16),
                const SizedBox(width: 5),
                Text(
                  titleVoteAverage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    if (_omdbRatings != null && _omdbRatings!.isNotEmpty) {
      for (var rating in _omdbRatings!) {
        topChildren.add(OmdbRatingWidget(rating: rating));
      }
    }

    if (_isUpdatingRatings) {
      topChildren.add(
        const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      );
    }

    List<Widget> leftColChildren = [];
    List<Widget> rightColChildren = [];
    for (int i = 0; i < 2; i++) {
      if (i > 0) {
        leftColChildren.add(const SizedBox(height: 12));
        rightColChildren.add(const SizedBox(height: 12));
      }
      leftColChildren.add(topChildren.length > i * 2
          ? topChildren[i * 2]
          : const SizedBox(height: 24));
      rightColChildren.add(topChildren.length > i * 2 + 1
          ? topChildren[i * 2 + 1]
          : const SizedBox(height: 24));
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        runSpacing: 15,
        children: [
          if (topChildren.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leftColChildren,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: rightColChildren,
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
          Consumer<TmdbRateslistService>(
            builder: (context, ratingService, child) {
              return FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  ratingService.getRatingDate(title.tmdbId, title.mediaType),
                  ratingService.contains(title),
                  ratingService.getRatingAsync(title.tmdbId, title.mediaType),
                ]),
                builder: (context, snapshot) {
                  final isUserLoggedIn =
                      Provider.of<TmdbUserService>(context).isUserLoggedIn;
                  final titleRatingDate = snapshot.data?[0] as DateTime? ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  final titleRating = snapshot.data?[2] as double? ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.your_rate.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: !isUserLoggedIn
                                    ? Theme.of(context).disabledColor
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                width: 2,
                              ),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: !isUserLoggedIn
                                ? null
                                : () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return RateForm(
                                          title: title.name,
                                          initialRate: titleRating,
                                          initialDate: titleRatingDate,
                                          onSubmit: (double rating) async {
                                            await _updateTitleRate(
                                                title, rating);
                                          },
                                        );
                                      },
                                    ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 32,
                                  color: !isUserLoggedIn
                                      ? Theme.of(context).disabledColor
                                      : titleTheme.userRatedTitle,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  titleRating > AppConstants.seenRating
                                      ? (titleRating == 10.0
                                          ? '10'
                                          : titleRating.toStringAsFixed(1))
                                      : '-.-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: !isUserLoggedIn
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: !isUserLoggedIn ||
                                        titleRating > AppConstants.seenRating
                                    ? Theme.of(context).disabledColor
                                    : (titleRating == AppConstants.seenRating
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: !isUserLoggedIn ||
                                    titleRating > AppConstants.seenRating
                                ? null
                                : () async {
                                    final newRating =
                                        titleRating == AppConstants.seenRating
                                            ? 0.0
                                            : AppConstants.seenRating;

                                    await _updateTitleRate(title, newRating);
                                  },
                            child: Tooltip(
                              message: titleRating == AppConstants.seenRating
                                  ? AppLocalizations.of(context)!.seen
                                  : AppLocalizations.of(context)!.markAsSeen,
                              child: Icon(
                                titleRating > 0
                                    ? Symbols.done_outline
                                    : Symbols.check,
                                size: 16,
                                color: titleRating > 0
                                    ? (!isUserLoggedIn ||
                                            titleRating >
                                                AppConstants.seenRating
                                        ? Theme.of(context).disabledColor
                                        : Theme.of(context).colorScheme.primary)
                                    : (isUserLoggedIn
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Theme.of(context).disabledColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _genres(TmdbTitle title) {
    if (title.genres.isEmpty) {
      return const SizedBox.shrink();
    }

    final String genresText = title.genres.map((g) => g.name).join(', ');

    return Text(
      genresText,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  String _releaseDates(TmdbTitle title) {
    String text;

    if (title.isMovie) {
      text = _movieDate(title);
    } else {
      text = _tvShowDates(title);
    }

    return text;
  }

  String _movieDate(TmdbTitle title) {
    return title.releaseDate.isNotEmpty
        ? title.releaseDate.substring(0, 4)
        : '';
  }

  String _tvShowDates(TmdbTitle title) {
    String text =
        title.firstAirDate.isNotEmpty ? title.firstAirDate.substring(0, 4) : '';

    if (!title.isMiniSerie) {
      if (title.isOnAir) {
        text += ' - ...';
      } else if (title.lastAirDate.isNotEmpty) {
        text += ' - ${title.lastAirDate.substring(0, 4)}';
      }
    } else if (title.isOnAir) {
      text += ' - ...';
    }

    return text;
  }

  String _duration(TmdbTitle title) {
    String text = title.duration.isNotEmpty
        ? title.duration
        : AppLocalizations.of(context)!.unknownDuration;

    if (title.isSerie && title.numberOfSeasons > 0) {
      text +=
          ' - ${AppLocalizations.of(context)!.seasonsCount(title.numberOfSeasons)}';
    }
    return text;
  }

  Widget _description(TmdbTitle title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Theme.of(context).extension<CustomColors>()!.dividerColor,
        ),
        ExpandableDescription(
          text: title.overview,
          initialMaxLines: 3,
        ),
        Divider(
          color: Theme.of(context).extension<CustomColors>()!.dividerColor,
        ),
      ],
    );
  }

  Widget _providers(TmdbTitle title) {
    List<Widget> providers = [];

    if (title.providers.flatrate.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.flatrateProviders,
        title.providers.flatrate,
      ));
    }

    if (title.providers.rent.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.rentProviders,
        title.providers.rent,
      ));
    }

    if (title.providers.buy.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.buyProviders,
        title.providers.buy,
      ));
    }

    return Wrap(
      spacing: 50,
      runSpacing: 20,
      children: providers,
    );
  }

  Widget _providersByType(String typeName, List<TmdbProvider> providers) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        typeName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      _providersRow(providers),
    ]);
  }

  Widget _providersRow(List<TmdbProvider> providers) {
    if (providers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children:
          providers.map<Widget>((provider) => _providerLogo(provider)).toList(),
    );
  }

  Widget _providerLogo(TmdbProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Tooltip(
        message: provider.name,
        child: SizedBox(
          width: 30,
          height: 30,
          child: CachedNetworkImage(
            imageUrl: provider.logoPath,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) {
              return SvgPicture.asset(
                'assets/movie.svg',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
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
            tmdbListService: widget._tmdbListService,
            titleContext: widget._title,
          ),
        );
      },
    );
  }

  Widget _seasonsDropdown(TmdbTitle title) {
    if (title.isMovie || title.numberOfSeasons == 0) {
      return const SizedBox.shrink();
    }

    final selectSeasonText = AppLocalizations.of(context)!.selectSeason;

    final List<String> seasonOptions = [selectSeasonText];
    for (int i = 1; i <= title.numberOfSeasons; i++) {
      seasonOptions.add(AppLocalizations.of(context)!.seasonLabel(i));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BoxedWidget(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: DropdownSelector(
            maxMenuHeight: 250,
            isExpanded: true,
            selectedOption:
                _selectedSeason.isEmpty ? selectSeasonText : _selectedSeason,
            options: seasonOptions,
            onSelected: (option) {
              if (option == selectSeasonText) return;

              // Reconstruct the season number by matching the option inside seasonOptions
              final seasonIndex = seasonOptions.indexOf(option);
              if (seasonIndex < 1) return;
              final seasonNumber = seasonIndex;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeasonDetails(
                    title: title,
                    seasonNumber: seasonNumber,
                    tmdbListService: widget._tmdbListService,
                  ),
                ),
              ).then((_) {
                if (mounted) {
                  setState(() {
                    _selectedSeason = '';
                  });
                }
              });

              setState(() {
                _selectedSeason = option;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _castAndCrew(TmdbTitle title, String type) {
    if (type == PersonAttributes.cast && title.cast.isEmpty) {
      return const SizedBox.shrink();
    }

    if (type == PersonAttributes.crew && title.crew.isEmpty) {
      return const SizedBox.shrink();
    }

    List<TmdbPerson> people;
    if (type == PersonAttributes.cast) {
      people = title.cast;
    } else {
      people = title.crew;
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
                            title: title,
                            type: type,
                            tmdbListService: widget._tmdbListService,
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

  Widget _recommended(TmdbTitle title) {
    if (title.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recommended,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 336.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: title.recommendations.length,
            itemBuilder: (context, index) {
              return TitleChip(
                title: title.recommendations[index],
                tmdbListService: widget._tmdbListService,
              );
            },
          ),
        ),
      ],
    );
  }
}
