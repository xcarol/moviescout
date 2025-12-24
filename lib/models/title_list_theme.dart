import 'package:flutter/material.dart';

@immutable
class TitleListTheme extends ThemeExtension<TitleListTheme> {
  final Color listBackground;
  final Color listDividerColor;
  final Color controlPanelBackground;
  final Color controlPanelInternalBackground;
  final Color controlPanelDividerColor;
  final Color controlPanelForeground;
  final Color infoLineBackground;

  // InfoLine Filter Colors
  final Color infoLineActiveFilterBackground;
  final Color infoLineActiveFilterForeground;
  final Color infoLineInactiveFilterBackground;
  final Color infoLineInactiveFilterForeground;

  // ControlPanel Filter Colors
  final Color controlPanelActiveFilterBackground;
  final Color controlPanelActiveFilterForeground;
  final Color controlPanelInactiveFilterBackground;
  final Color controlPanelInactiveFilterForeground;

  final Color searchCursorColor;
  final Color searchHintColor;
  final Color searchSelectionColor;
  final Color sortArrowColor;
  final Color swapSortIconColor;

  const TitleListTheme({
    required this.listBackground,
    required this.listDividerColor,
    required this.controlPanelBackground,
    required this.controlPanelInternalBackground,
    required this.controlPanelDividerColor,
    required this.controlPanelForeground,
    required this.infoLineBackground,
    required this.infoLineActiveFilterBackground,
    required this.infoLineActiveFilterForeground,
    required this.infoLineInactiveFilterBackground,
    required this.infoLineInactiveFilterForeground,
    required this.controlPanelActiveFilterBackground,
    required this.controlPanelActiveFilterForeground,
    required this.controlPanelInactiveFilterBackground,
    required this.controlPanelInactiveFilterForeground,
    required this.searchCursorColor,
    required this.searchHintColor,
    required this.searchSelectionColor,
    required this.sortArrowColor,
    required this.swapSortIconColor,
  });

  @override
  TitleListTheme copyWith({
    Color? listBackground,
    Color? listDividerColor,
    Color? controlPanelBackground,
    Color? controlPanelInternalBackground,
    Color? controlPanelDividerColor,
    Color? controlPanelForeground,
    Color? infoLineBackground,
    Color? infoLineActiveFilterBackground,
    Color? infoLineActiveFilterForeground,
    Color? infoLineInactiveFilterBackground,
    Color? infoLineInactiveFilterForeground,
    Color? controlPanelActiveFilterBackground,
    Color? controlPanelActiveFilterForeground,
    Color? controlPanelInactiveFilterBackground,
    Color? controlPanelInactiveFilterForeground,
    Color? searchCursorColor,
    Color? searchHintColor,
    Color? searchSelectionColor,
    Color? sortArrowColor,
    Color? swapSortIconColor,
  }) {
    return TitleListTheme(
      listBackground: listBackground ?? this.listBackground,
      listDividerColor: listDividerColor ?? this.listDividerColor,
      controlPanelBackground:
          controlPanelBackground ?? this.controlPanelBackground,
      controlPanelInternalBackground:
          controlPanelInternalBackground ?? this.controlPanelInternalBackground,
      controlPanelDividerColor:
          controlPanelDividerColor ?? this.controlPanelDividerColor,
      controlPanelForeground:
          controlPanelForeground ?? this.controlPanelForeground,
      infoLineBackground: infoLineBackground ?? this.infoLineBackground,
      infoLineActiveFilterBackground:
          infoLineActiveFilterBackground ?? this.infoLineActiveFilterBackground,
      infoLineActiveFilterForeground:
          infoLineActiveFilterForeground ?? this.infoLineActiveFilterForeground,
      infoLineInactiveFilterBackground: infoLineInactiveFilterBackground ??
          this.infoLineInactiveFilterBackground,
      infoLineInactiveFilterForeground: infoLineInactiveFilterForeground ??
          this.infoLineInactiveFilterForeground,
      controlPanelActiveFilterBackground: controlPanelActiveFilterBackground ??
          this.controlPanelActiveFilterBackground,
      controlPanelActiveFilterForeground: controlPanelActiveFilterForeground ??
          this.controlPanelActiveFilterForeground,
      controlPanelInactiveFilterBackground:
          controlPanelInactiveFilterBackground ??
              this.controlPanelInactiveFilterBackground,
      controlPanelInactiveFilterForeground:
          controlPanelInactiveFilterForeground ??
              this.controlPanelInactiveFilterForeground,
      searchCursorColor: searchCursorColor ?? this.searchCursorColor,
      searchHintColor: searchHintColor ?? this.searchHintColor,
      searchSelectionColor: searchSelectionColor ?? this.searchSelectionColor,
      sortArrowColor: sortArrowColor ?? this.sortArrowColor,
      swapSortIconColor: swapSortIconColor ?? this.swapSortIconColor,
    );
  }

  @override
  TitleListTheme lerp(ThemeExtension<TitleListTheme>? other, double t) {
    if (other is! TitleListTheme) return this;
    return TitleListTheme(
      listBackground: Color.lerp(listBackground, other.listBackground, t)!,
      listDividerColor:
          Color.lerp(listDividerColor, other.listDividerColor, t)!,
      controlPanelBackground:
          Color.lerp(controlPanelBackground, other.controlPanelBackground, t)!,
      controlPanelInternalBackground: Color.lerp(controlPanelInternalBackground,
          other.controlPanelInternalBackground, t)!,
      controlPanelDividerColor: Color.lerp(
          controlPanelDividerColor, other.controlPanelDividerColor, t)!,
      controlPanelForeground:
          Color.lerp(controlPanelForeground, other.controlPanelForeground, t)!,
      infoLineBackground:
          Color.lerp(infoLineBackground, other.infoLineBackground, t)!,
      infoLineActiveFilterBackground: Color.lerp(infoLineActiveFilterBackground,
          other.infoLineActiveFilterBackground, t)!,
      infoLineActiveFilterForeground: Color.lerp(infoLineActiveFilterForeground,
          other.infoLineActiveFilterForeground, t)!,
      infoLineInactiveFilterBackground: Color.lerp(
          infoLineInactiveFilterBackground,
          other.infoLineInactiveFilterBackground,
          t)!,
      infoLineInactiveFilterForeground: Color.lerp(
          infoLineInactiveFilterForeground,
          other.infoLineInactiveFilterForeground,
          t)!,
      controlPanelActiveFilterBackground: Color.lerp(
          controlPanelActiveFilterBackground,
          other.controlPanelActiveFilterBackground,
          t)!,
      controlPanelActiveFilterForeground: Color.lerp(
          controlPanelActiveFilterForeground,
          other.controlPanelActiveFilterForeground,
          t)!,
      controlPanelInactiveFilterBackground: Color.lerp(
          controlPanelInactiveFilterBackground,
          other.controlPanelInactiveFilterBackground,
          t)!,
      controlPanelInactiveFilterForeground: Color.lerp(
          controlPanelInactiveFilterForeground,
          other.controlPanelInactiveFilterForeground,
          t)!,
      searchCursorColor:
          Color.lerp(searchCursorColor, other.searchCursorColor, t)!,
      searchHintColor: Color.lerp(searchHintColor, other.searchHintColor, t)!,
      searchSelectionColor:
          Color.lerp(searchSelectionColor, other.searchSelectionColor, t)!,
      sortArrowColor: Color.lerp(sortArrowColor, other.sortArrowColor, t)!,
      swapSortIconColor:
          Color.lerp(swapSortIconColor, other.swapSortIconColor, t)!,
    );
  }
}
