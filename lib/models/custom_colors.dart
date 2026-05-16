import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color inWatchlist;
  final Color notInWatchlist;
  final Color ratedTitle;
  final Color userRatedTitle;
  final Color pinnedTitle;
  final Color selected;
  final Color notSelected;
  final Color chipCardBackground;
  final Color dividerColor;
  final Color bottomNavigationBarBackground;
  final Color appBarBackground;
  final Color titleAppBar;
  final Color controlPanelBackground;

  const CustomColors({
    required this.inWatchlist,
    required this.notInWatchlist,
    required this.ratedTitle,
    required this.userRatedTitle,
    required this.pinnedTitle,
    required this.selected,
    required this.notSelected,
    required this.chipCardBackground,
    required this.dividerColor,
    required this.bottomNavigationBarBackground,
    required this.appBarBackground,
    required this.titleAppBar,
    required this.controlPanelBackground,
  });

  @override
  CustomColors copyWith({
    Color? inWatchlist,
    Color? notInWatchlist,
    Color? ratedTitle,
    Color? userRatedTitle,
    Color? pinnedTitle,
    Color? selected,
    Color? notSelected,
    Color? chipCardBackground,
    Color? dividerColor,
    Color? bottomNavigationBarBackground,
    Color? appBar,
    Color? titleAppBar,
    Color? controlPanelBackground,
  }) {
    return CustomColors(
      inWatchlist: inWatchlist ?? this.inWatchlist,
      notInWatchlist: notInWatchlist ?? this.notInWatchlist,
      ratedTitle: ratedTitle ?? this.ratedTitle,
      userRatedTitle: userRatedTitle ?? this.userRatedTitle,
      pinnedTitle: pinnedTitle ?? this.pinnedTitle,
      selected: selected ?? this.selected,
      notSelected: notSelected ?? this.notSelected,
      chipCardBackground: chipCardBackground ?? this.chipCardBackground,
      dividerColor: dividerColor ?? this.dividerColor,
      bottomNavigationBarBackground:
          bottomNavigationBarBackground ?? this.bottomNavigationBarBackground,
      appBarBackground: appBar ?? this.appBarBackground,
      titleAppBar: titleAppBar ?? this.titleAppBar,
      controlPanelBackground: controlPanelBackground ?? this.controlPanelBackground,
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
      pinnedTitle: Color.lerp(pinnedTitle, other.pinnedTitle, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      notSelected: Color.lerp(notSelected, other.notSelected, t)!,
      chipCardBackground:
          Color.lerp(chipCardBackground, other.chipCardBackground, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      bottomNavigationBarBackground: Color.lerp(bottomNavigationBarBackground,
          other.bottomNavigationBarBackground, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      titleAppBar: Color.lerp(titleAppBar, other.titleAppBar, t)!,
      controlPanelBackground: Color.lerp(controlPanelBackground, other.controlPanelBackground, t)!,
    );
  }
}
