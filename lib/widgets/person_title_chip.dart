import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/models/tmdb_person.dart';
import 'package:moviescout/screens/title_details.dart';
import 'package:moviescout/widgets/title_card.dart';
import 'package:moviescout/widgets/title_chip.dart';
import 'package:moviescout/utils/person_translator.dart';

extension TmdbTitleRoleTranslation on TmdbTitle {
  String localizedJob(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return PersonTranslator.translateJob(job, locale);
  }

  String localizedDepartment(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return PersonTranslator.translateDepartment(department, locale);
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
    final clampedScale = mediaQuery.textScaler.scale(1.0).clamp(1.0, 1.3);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: MediaQuery(
        data: mediaQuery.copyWith(textScaler: TextScaler.linear(clampedScale)),
        child: SizedBox(
          height: CARD_HEIGHT,
          width: CARD_WIDTH,
          child: Card(
            color:
                Theme.of(context).extension<CustomColors>()!.chipCardBackground,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TitleDetails(
                            title: _title,
                            tmdbListService: tmdbListService,
                          )),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: titlePoster(_title.posterPath),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Theme.of(context)
                              .extension<CustomColors>()!
                              .chipCardBackground
                              .withValues(alpha: 0.8),
                          padding: const EdgeInsets.all(8.0),
                          child: _personTitleDetails(context, _title),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _personTitleDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final roleText = tmdbTitle.getRoleString(context, role: role);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tmdbTitle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (roleText.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            roleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
