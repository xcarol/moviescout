import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/widgets/chips/title_chip.dart';

class UserTitleChip extends TitleChip {
  final double? userRating;

  const UserTitleChip({
    super.key,
    required super.title,
    required super.tmdbListService,
    super.isDimmed,
    this.userRating,
  });

  @override
  State<UserTitleChip> createState() => _UserTitleChipState();
}

class _UserTitleChipState extends TitleChipState<UserTitleChip> {
  @override
  Widget buildContent(BuildContext context, TmdbTitle titleToDisplay) {
    return UserTitleChipContent(
      title: titleToDisplay,
      tmdbListService: widget.tmdbListService,
      userRating: widget.userRating ?? titleToDisplay.rating,
      isDimmed: shouldDim,
      onReturnFromDetails: loadLocalTitle,
    );
  }
}

class UserTitleChipContent extends TitleChipContent {
  final double userRating;

  const UserTitleChipContent({
    super.key,
    required super.title,
    required super.tmdbListService,
    required this.userRating,
    super.onReturnFromDetails,
    super.isDimmed,
  });

  @override
  Widget titleBottomDetails(BuildContext context, TmdbTitle tmdbTitle) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final ratingWidgets = buildRatingWidgets(
      context,
      rating: userRating,
      color: customColors.followingUserRatedTitle,
      isCompact: true,
    );

    if (ratingWidgets.isNotEmpty) {
      return SizedBox(
        height: 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: ratingWidgets),
        ),
      );
    }

    return super.titleBottomDetails(context, tmdbTitle);
  }
}
