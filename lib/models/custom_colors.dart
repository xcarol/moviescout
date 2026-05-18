import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color inWatchlist;
  final Color notInWatchlist;
  final Color ratedTitle;
  final Color userRatedTitle;
  final Color snoozedTitle;
  final Color pinnedTitle;
  final Color navigationBarSelected;
  final Color navigationBarNotSelected;
  final Color chipCardBackground;
  final Color dividerColor;
  final Color bottomNavigationBarBackground;
  final Color appBarBackground;
  final Color appBarText;

  const CustomColors({
    required this.inWatchlist,
    required this.notInWatchlist,
    required this.ratedTitle,
    required this.userRatedTitle,
    required this.snoozedTitle,
    required this.pinnedTitle,
    required this.navigationBarSelected,
    required this.navigationBarNotSelected,
    required this.chipCardBackground,
    required this.dividerColor,
    required this.bottomNavigationBarBackground,
    required this.appBarBackground,
    required this.appBarText,
  });

  @override
  CustomColors copyWith({
    Color? inWatchlist,
    Color? notInWatchlist,
    Color? ratedTitle,
    Color? userRatedTitle,
    Color? snoozedTitle,
    Color? pinnedTitle,
    Color? selected,
    Color? notSelected,
    Color? chipCardBackground,
    Color? dividerColor,
    Color? bottomNavigationBarBackground,
    Color? appBar,
    Color? titleAppBar,
  }) {
    return CustomColors(
      inWatchlist: inWatchlist ?? this.inWatchlist,
      notInWatchlist: notInWatchlist ?? this.notInWatchlist,
      ratedTitle: ratedTitle ?? this.ratedTitle,
      userRatedTitle: userRatedTitle ?? this.userRatedTitle,
      snoozedTitle: snoozedTitle ?? this.snoozedTitle,
      pinnedTitle: pinnedTitle ?? this.pinnedTitle,
      navigationBarSelected: selected ?? this.navigationBarSelected,
      navigationBarNotSelected: notSelected ?? this.navigationBarNotSelected,
      chipCardBackground: chipCardBackground ?? this.chipCardBackground,
      dividerColor: dividerColor ?? this.dividerColor,
      bottomNavigationBarBackground:
          bottomNavigationBarBackground ?? this.bottomNavigationBarBackground,
      appBarBackground: appBar ?? this.appBarBackground,
      appBarText: titleAppBar ?? this.appBarText,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      inWatchlist: Color.lerp(inWatchlist, other.inWatchlist, t)!,
      notInWatchlist: Color.lerp(notInWatchlist, other.notInWatchlist, t)!,
      ratedTitle: Color.lerp(ratedTitle, other.ratedTitle, t)!,
      userRatedTitle: Color.lerp(userRatedTitle, other.userRatedTitle, t)!,
      snoozedTitle: Color.lerp(snoozedTitle, other.snoozedTitle, t)!,
      pinnedTitle: Color.lerp(pinnedTitle, other.pinnedTitle, t)!,
      navigationBarSelected:
          Color.lerp(navigationBarSelected, other.navigationBarSelected, t)!,
      navigationBarNotSelected: Color.lerp(
          navigationBarNotSelected, other.navigationBarNotSelected, t)!,
      chipCardBackground:
          Color.lerp(chipCardBackground, other.chipCardBackground, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      bottomNavigationBarBackground: Color.lerp(bottomNavigationBarBackground,
          other.bottomNavigationBarBackground, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      appBarText: Color.lerp(appBarText, other.appBarText, t)!,
    );
  }
}
