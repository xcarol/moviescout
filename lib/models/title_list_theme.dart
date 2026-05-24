import 'package:flutter/material.dart';

@immutable
class TitleListTheme extends ThemeExtension<TitleListTheme> {
  final Color controlPanelBackground;
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

  const TitleListTheme({
    required this.controlPanelBackground,
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
  });

  @override
  TitleListTheme copyWith({
    Color? listBackground,
    Color? controlPanelBackground,
    Color? controlPanelInternalBackground,
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
  }) {
    return TitleListTheme(
      controlPanelBackground:
          controlPanelBackground ?? this.controlPanelBackground,
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
    );
  }

  @override
  TitleListTheme lerp(ThemeExtension<TitleListTheme>? other, double t) {
    if (other is! TitleListTheme) {
      return this;
    }
    return TitleListTheme(
      controlPanelBackground:
          Color.lerp(controlPanelBackground, other.controlPanelBackground, t)!,
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
    );
  }
}
