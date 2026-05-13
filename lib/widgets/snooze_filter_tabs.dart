import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/tmdb_list_service.dart';
import 'package:moviescout/widgets/title_list_controller.dart';

class SnoozeFilterTabs extends StatelessWidget {
  final TitleListController controller;

  const SnoozeFilterTabs({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final ratedTitleColor =
        Theme.of(context).extension<CustomColors>()!.ratedTitle;

    return SizedBox(
      width: 150,
      height: 40,
      child: DefaultTabController(
        key: ValueKey(controller.snoozeFilter),
        length: 3,
        initialIndex: controller.snoozeFilter.index,
        child: TabBar(
          onTap: (index) {
            controller.setSnoozeFilter(SnoozeFilter.values[index]);
          },
          padding: const EdgeInsets.symmetric(vertical: 4),
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ratedTitleColor.withValues(alpha: 0.2),
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
              message: localizations.snoozedOnly,
              child: const Tab(icon: Icon(Icons.nights_stay, size: 20)),
            ),
            Tooltip(
              message: localizations.pendingOnly,
              child: const Tab(icon: Icon(Symbols.pending, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
