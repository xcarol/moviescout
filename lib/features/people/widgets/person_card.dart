import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/seasons/models/tmdb_episode.dart';
import 'package:moviescout/features/seasons/models/tmdb_season.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/services/tmdb_title_list_service.dart';

class PersonCard extends StatelessWidget {
  final TmdbPerson _person;
  final TmdbTitleListService _tmdbListService;
  final TmdbTitle? titleContext;
  final TmdbSeason? seasonContext;
  final TmdbEpisode? episodeContext;

  static double cardHeight = AppSizes.listCardHeight;

  const PersonCard({
    super.key,
    required TmdbPerson person,
    required TmdbTitleListService tmdbListService,
    this.titleContext,
    this.seasonContext,
    this.episodeContext,
  })  : _person = person,
        _tmdbListService = tmdbListService;

  TmdbTitleListService get tmdbListService => _tmdbListService;

  @override
  Widget build(BuildContext context) {
    final tmdbPerson = _person;

    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              context.toPersonDetails(
                tmdbPerson,
                tmdbListService,
                titleContext: titleContext,
                seasonContext: seasonContext,
                episodeContext: episodeContext,
              );
            },
            child: Row(
              children: [
                personPoster(tmdbPerson.posterPath),
                const SizedBox(width: AppSpacing.sm),
                _personDetails(context, tmdbPerson),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget personPoster(String? posterPath) {
    return AppCachedImage(
      imageUrl: posterPath,
      type: AppImageType.avatar,
      aspectRatio: AppSizes.aspectRatioPoster,
      memCacheWidth: AppSizes.posterCacheWidth,
      memCacheHeight: AppSizes.posterCacheHeight,
    );
  }

  Widget _personRoleDetails(BuildContext context, TmdbPerson tmdbPerson) {
    final theme = Theme.of(context);
    final List<String> roles = [];
    if (tmdbPerson.character.isNotEmpty) {
      roles.add(tmdbPerson.character);
    } else {
      if (tmdbPerson.job.isNotEmpty) {
        roles.add(tmdbPerson.localizedJob(context));
      }
      if (tmdbPerson.knownForDepartment.isNotEmpty) {
        roles.add(tmdbPerson.localizedDepartment(context));
      }
    }

    if (roles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxs),
        ...roles.map(
          (role) => Text(
            role,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _personDetails(BuildContext context, TmdbPerson tmdbPerson) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.xs,
          right: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tmdbPerson.name,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _personRoleDetails(context, tmdbPerson),
          ],
        ),
      ),
    );
  }
}
