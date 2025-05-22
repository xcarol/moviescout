import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color inWatchlist;
  final Color notInWatchlist;
  final Color ratedTitle;
  final Color selected;
  final Color notSelected;

  const CustomColors({
    required this.inWatchlist,
    required this.notInWatchlist,
    required this.ratedTitle,
    required this.selected,
    required this.notSelected,
  });

  @override
  CustomColors copyWith({
    Color? inWatchlist,
    Color? notInWatchlist,
    Color? ratedTitle,
    Color? selected,
    Color? notSelected,
  }) {
    return CustomColors(
      inWatchlist: inWatchlist ?? this.inWatchlist,
      notInWatchlist: notInWatchlist ?? this.notInWatchlist,
      ratedTitle: ratedTitle ?? this.ratedTitle,
      selected: selected ?? this.selected,
      notSelected: notSelected ?? this.notSelected,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      inWatchlist: Color.lerp(inWatchlist, other.inWatchlist, t)!,
      notInWatchlist: Color.lerp(notInWatchlist, other.notInWatchlist, t)!,
      ratedTitle: Color.lerp(ratedTitle, other.ratedTitle, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      notSelected: Color.lerp(notSelected, other.notSelected, t)!,
    );
  }
}
