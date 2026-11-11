import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/metadata_translator.dart';
import 'package:moviescout/core/utils/ui_utils.dart';
import 'package:moviescout/features/people/models/tmdb_person.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/titles/widgets/title_card.dart';
import 'package:moviescout/features/titles/widgets/title_chip.dart';

extension TmdbTitleRoleTranslation on TmdbTitle {
  String localizedJob(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return MetadataTranslator.translateJob(job, locale);
  }

  String localizedDepartment(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return MetadataTranslator.translateDepartment(department, locale);
  }

  String getRoleString(BuildContext context,
      {PersonTitleRole role = PersonTitleRole.character}) {
    if (role == PersonTitleRole.crew) {
      if (job.isNotEmpty) return localizedJob(context);
      if (department.isNotEmpty) return localizedDepartment(context);
      if (character.isNotEmpty) return character;
      return '';
    }

    if (character.isNotEmpty) return character;
    if (job.isNotEmpty) return localizedJob(context);
    if (department.isNotEmpty) return localizedDepartment(context);
    return '';
  }
}

class PersonTitleChip extends TitleCard {
  final TmdbTitle _title;
  final PersonTitleRole role;

  const PersonTitleChip({
    super.key,
    required super.title,
    required super.tmdbListService,
    this.role = PersonTitleRole.character,
  }) : _title = title;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: UiUtils.clampedTextScaler(context),
        ),
        child: RepaintBoundary(
          child: SizedBox(
            height: CARD_HEIGHT,
            width: CARD_WIDTH,
            child: Card(
              color: customColors.chipCardBackground,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderMd,
              ),
              child: InkWell(
                onTap: () async {
                  await context.toTitleDetails(_title, tmdbListService);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.borderMd,
                      child: titlePoster(_title.posterPath),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppRadius.md),
                          bottomRight: Radius.circular(AppRadius.md),
                        ),
                        child: Container(
                          color: customColors.chipCardBackground
                              .withValues(alpha: AppOpacity.chipFooter),
                          padding: AppSpacing.chipPadding,
                          child: _personTitleDetails(context, _title),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _personTitleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final theme = Theme.of(context);
    final roleText = tmdbTitle.getRoleString(context, role: role);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbTitle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall,
        ),
        if (roleText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            roleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
