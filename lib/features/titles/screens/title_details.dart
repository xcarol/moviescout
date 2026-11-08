import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/repositories/local_title_repository.dart';
import 'package:moviescout/core/services/omdb_service.dart';
import 'package:moviescout/core/services/tmdb_translation_service.dart';
import 'package:moviescout/features/watchlist/services/rateslist_service.dart';
import 'package:moviescout/core/navigation/home_screen_shortcut_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_service.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/widgets/action_menu.dart';
import 'package:moviescout/features/titles/widgets/title_comments_section.dart';
import 'package:moviescout/features/notifications/widgets/notify_dialog.dart';
import 'package:moviescout/features/titles/widgets/title_header_section.dart';
import 'package:moviescout/features/titles/widgets/title_media_lists_section.dart';
import 'package:moviescout/features/titles/widgets/title_metadata_section.dart';
import 'package:moviescout/features/titles/widgets/title_rating_section.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _currentTitle = widget._title;
    _initializeRatings();
    _updateDetails();
  }

  void _initializeRatings() {
    _omdbRatings = _currentTitle.omdbRatings;

    final bool wasUpToDate = TmdbTitleService.isUpToDate(_currentTitle);
    if (_omdbRatings == null || _omdbRatings!.isEmpty || !wasUpToDate) {
      _isUpdatingRatings = true;
    }
  }

  Future<void> _updateTitleRate(TmdbTitle title, double rating) async {
    final rateslistService =
        Provider.of<RateslistService>(context, listen: false);

    await rateslistService.updateTitleRate(title, rating);

    if (rating > AppConstants.seenRating &&
        title.status == TitleStatus.returning &&
        !title.notifyNewSeasons) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => NotifyDialog(title: title),
        );
      }
    }
  }

  Future<void> _updateDetails() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updated = await TmdbTitleService().updateTitleDetails(
        _currentTitle,
        force: true,
        includeYoutubeSearch: true,
      );

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
          if (mounted && updated.omdbRatings.isNotEmpty) {
            setState(() {
              _omdbRatings = updated.omdbRatings;
            });
          }
        }

        await LocalTitleRepository.instance.updateTitlesMetadata([updated]);
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

  @override
  Widget build(BuildContext context) {
    final String appTitle = _currentTitle.name;
    final String editUrl = UrlConstants.tmdbTitleEditWebTemplate
        .replaceFirst('{MEDIA_TYPE}', _currentTitle.mediaType)
        .replaceFirst('{ID}', _currentTitle.tmdbId.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          ActionMenu(
            editUrl: editUrl,
            fetchTranslations: () => TmdbTranslationService().getTranslations(
              _currentTitle.mediaType,
              _currentTitle.tmdbId,
            ),
            originalTitle: _currentTitle.originalName.isNotEmpty
                ? _currentTitle.originalName
                : _currentTitle.name,
            originalDescription: _currentTitle.overview,
            shareUrl: UrlConstants.moviescoutTitleWebTemplate
                .replaceFirst('{MEDIA_TYPE}', _currentTitle.mediaType)
                .replaceFirst('{ID}', _currentTitle.tmdbId.toString()),
            onPin: () async {
              final loc = AppLocalizations.of(context)!;
              final success = await HomeScreenShortcutService.pinTitleShortcut(
                  _currentTitle);
              if (!success) {
                SnackMessage.showSnackBar(loc.shortcutFailed);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _detailsBody(_currentTitle),
      ),
    );
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

    final dividerColor =
        Theme.of(context).extension<CustomColors>()!.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeaderSection(
          title: title,
          tmdbListService: widget._tmdbListService,
          isUpdating: _isUpdating,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TitleRatingSection(
                title: title,
                omdbRatings: _omdbRatings,
                isUpdatingRatings: _isUpdatingRatings,
                onRatingChanged: (rating) => _updateTitleRate(title, rating),
              ),
              const SizedBox(height: 10),
              TitleMetadataSection(
                title: title,
                tmdbListService: widget._tmdbListService,
              ),
              const SizedBox(height: 15),
              TitleMediaListsSection(
                title: title,
                tmdbListService: widget._tmdbListService,
              ),
              const SizedBox(height: 20),
              Divider(color: dividerColor),
              const SizedBox(height: 10),
              TitleCommentsSection(title: title),
            ],
          ),
        ),
      ],
    );
  }
}
