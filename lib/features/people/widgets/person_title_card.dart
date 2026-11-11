import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/people/widgets/person_title_chip.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';

class PersonTitleCard extends TitleCard {
  final TmdbTitle _title;
  final PersonTitleRole role;

  const PersonTitleCard({
    super.key,
    required super.title,
    required super.tmdbListService,
    this.role = PersonTitleRole.character,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: TitleCard.cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              context.toTitleDetails(_title, tmdbListService);
            },
            child: Row(
              children: [
                titlePoster(_title.posterPath),
                const SizedBox(width: AppSpacing.sm),
                _personTitleDetails(context, _title),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _personTitleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final theme = Theme.of(context);
    final roleText = tmdbTitle.getRoleString(context, role: role);
    final dateString = titleSubtitle(context, tmdbTitle);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.xs,
          right: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            titleHeader(
              tmdbTitle.name,
              style: theme.textTheme.titleMedium,
            ),
            if (dateString.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                dateString,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (roleText.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                roleText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxs),
            titleRating(context, tmdbTitle),
          ],
        ),
      ),
    );
  }
}
