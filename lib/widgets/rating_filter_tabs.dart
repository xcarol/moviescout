import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/tmdb_title_list_service.dart'
    show RatingFilter;
import 'package:moviescout/widgets/title_list_controller.dart';

class RatingFilterTabs extends StatelessWidget {
  final TitleListController controller;

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
      width: 150,
      height: 40,
      child: DefaultTabController(
        key: ValueKey(controller.ratingFilter),
        length: 4,
        initialIndex: controller.ratingFilter.index,
        child: TabBar(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: (index) {
            controller.setRatingFilter(RatingFilter.values[index]);
          },
          padding: const EdgeInsets.symmetric(vertical: 4),
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          dividerColor: Colors.transparent,
          labelColor: ratedTitleColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          tabs: [
            Tooltip(
              message: localizations.titles,
              child: const Tab(icon: Icon(Icons.all_inclusive, size: 20)),
            ),
            Tooltip(
              message: localizations.ratedOnly,
              child: const Tab(icon: Icon(Icons.star, size: 20)),
            ),
            Tooltip(
              message: localizations.seenOnly,
              child: const Tab(icon: Icon(Symbols.done_outline, size: 20)),
            ),
            Tooltip(
              message: localizations.snoozedOnly,
              child:
                  const Tab(icon: Icon(Icons.pause_circle_outline, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
