import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_collection.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/app_navigator.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/utils/country_translator.dart';
import 'package:moviescout/utils/status_translator.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:moviescout/widgets/layout/boxed_widget.dart';
import 'package:moviescout/widgets/text_and_info/clickable_names.dart';
import 'package:moviescout/widgets/text_and_info/expandable_description.dart';
import 'package:moviescout/widgets/text_and_info/social_link.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TitleMetadataSection extends StatelessWidget {
  final TmdbTitle title;
  final TmdbTitleListService tmdbListService;

  const TitleMetadataSection({
    super.key,
    required this.title,
    required this.tmdbListService,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor =
        Theme.of(context).extension<CustomColors>()!.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _description(context, dividerColor),
        const SizedBox(height: 10),
        _infoLine(context),
        const SizedBox(height: 10),
        _creditsInfo(context),
        if (title.belongsToCollection != null) ...[
          Divider(color: dividerColor),
          _collectionLink(context),
        ],
        Divider(color: dividerColor),
        _externalLinks(context),
        if (title.providers.isNotEmpty) ...[
          Divider(color: dividerColor),
          _providers(context),
        ],
      ],
    );
  }

  Widget _description(BuildContext context, Color? dividerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: dividerColor),
        ExpandableDescription(
          text: title.overview,
          initialMaxLines: 3,
        ),
        Divider(color: dividerColor),
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

  Widget _infoLine(BuildContext context) {
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
                Text(
                  title.originalName,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              _infoColumn(
                AppLocalizations.of(context)!.originalLanguage,
                Text(
                  LanguageService().getLanguageName(title.originalLanguage),
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              _infoColumn(
                AppLocalizations.of(context)!.originCountry,
                Text(
                  title.originCountry
                      .map((c) => CountryTranslator.translate(
                          c,
                          Provider.of<LanguageService>(context, listen: false)
                              .currentLanguage))
                      .join(', '),
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              if (title.status.isNotEmpty)
                _infoColumn(
                  AppLocalizations.of(context)!.status,
                  Text(
                    StatusTranslator.translate(
                      title.status,
                      Provider.of<LanguageService>(context, listen: false)
                          .currentLanguage,
                    ),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _creditsInfo(BuildContext context) {
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
            tmdbListService: tmdbListService,
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
            tmdbListService: tmdbListService,
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
          tmdbListService: tmdbListService,
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

  Widget _externalLinks(BuildContext context) {
    List<Widget> links = [];

    links.add(
      SocialLink.image(
        url: UrlConstants.tmdbTitleWebTemplate
            .replaceFirst('{MEDIA_TYPE}', title.mediaType)
            .replaceFirst('{ID}', title.tmdbId.toString()),
        assetPath: 'assets/tmdb-logo.png',
        launchMode: LaunchMode.inAppBrowserView,
      ),
    );

    if (title.imdbId.isNotEmpty) {
      links.add(
        SocialLink.image(
          url: UrlConstants.imdbTitleTemplate
              .replaceFirst('{ID}', title.imdbId.toString()),
          assetPath: 'assets/imdb-logo.png',
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

  Widget _providers(BuildContext context) {
    List<Widget> providers = [];

    if (title.providers.free.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.freeProviders,
        title.providers.free,
      ));
    }

    if (title.providers.ads.isNotEmpty) {
      providers.add(_providersByType(
        AppLocalizations.of(context)!.adsProviders,
        title.providers.ads,
      ));
    }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          typeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: providers
              .map<Widget>((provider) => _providerLogo(provider))
              .toList(),
        ),
      ],
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
              return Image.asset(
                'assets/movie.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _collectionLink(BuildContext context) {
    if (title.belongsToCollection == null) {
      return const SizedBox.shrink();
    }

    final collection = title.belongsToCollection!;

    return BoxedWidget(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        AppLocalizations.of(context)!.seeCollection,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        context.toCollectionDetails(
          TmdbCollection.fromMap(collection: collection),
          tmdbListService,
        );
      },
    );
  }
}
