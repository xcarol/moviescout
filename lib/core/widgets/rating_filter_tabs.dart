import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/list_controller.dart';
import 'package:moviescout/features/titles/services/tmdb_base_list_service.dart'
    show RatingFilter;
import 'package:moviescout/l10n/app_localizations.dart';

class RatingFilterTabs extends StatelessWidget {
  final ListController controller;

  const RatingFilterTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final ratedTitleColor =
        Theme.of(context).extension<CustomColors>()!.userRatedTitle;

    return SizedBox(
      width: AppSizes.ratingFilterWidth,
      height: AppSizes.ratingFilterHeight,
      child: DefaultTabController(
        key: ValueKey(controller.ratingFilter),
        length: RatingFilter.values.length,
        initialIndex: controller.ratingFilter.index,
        child: TabBar(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: (index) {
            controller.setRatingFilter(RatingFilter.values[index]);
          },
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: AppRadius.borderSm,
          ),
          dividerColor: Colors.transparent,
          labelColor: ratedTitleColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          tabs: [
            Tooltip(
              message: localizations.titles,
              child: const Tab(
                icon: Icon(Icons.all_inclusive, size: AppSizes.iconMd),
              ),
            ),
            Tooltip(
              message: localizations.ratedOnly,
              child: const Tab(
                icon: Icon(Icons.star, size: AppSizes.iconMd),
              ),
            ),
            Tooltip(
              message: localizations.seenOnly,
              child: const Tab(
                icon: Icon(Symbols.done_outline, size: AppSizes.iconMd),
              ),
            ),
            Tooltip(
              message: localizations.followingOnly,
              child: const Tab(
                icon: Icon(Icons.notifications_active, size: AppSizes.iconMd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
