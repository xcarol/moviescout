import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

enum ThemeSchemes {
  defaultScheme,
  blackScheme,
  blueScheme,
  redScheme,
}

class ThemeService with ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ThemeSchemes _currentScheme = ThemeSchemes.values.firstWhere(
    (e) =>
        e.name ==
        (PreferencesService().prefs.getString(AppConstants.themeScheme) ??
            ThemeSchemes.defaultScheme.name),
    orElse: () => ThemeSchemes.defaultScheme,
  );

  ThemeSchemes get currentScheme => _currentScheme;

  ColorScheme _lightColorScheme = lightColorSchemeDefault;
  CustomColors _lightCustomColors = lightCustomColorsDefault;
  TitleListTheme _lightTitleListTheme =
      _createTitleListTheme(lightColorSchemeDefault);

  ColorScheme get lightColorScheme => _lightColorScheme;
  CustomColors get lightCustomColors => _lightCustomColors;
  TitleListTheme get lightTitleListTheme => _lightTitleListTheme;

  ColorScheme _darkColorScheme = darkColorSchemeDefault;
  CustomColors _darkCustomColors = darkCustomColorsDefault;
  TitleListTheme _darkTitleListTheme =
      _createTitleListTheme(darkColorSchemeDefault);

  ColorScheme get darkColorScheme => _darkColorScheme;
  CustomColors get darkCustomColors => _darkCustomColors;
  TitleListTheme get darkTitleListTheme => _darkTitleListTheme;

  ScrollbarThemeData get lightScrollbarTheme => ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return _lightColorScheme.primary.withValues(alpha: 0.8);
          }
          return _lightColorScheme.primary.withValues(alpha: 0.5);
        }),
        thickness: WidgetStateProperty.all(5.0),
        radius: const Radius.circular(8),
        thumbVisibility: WidgetStateProperty.all(false),
        trackVisibility: WidgetStateProperty.all(false),
        interactive: true,
      );

  ScrollbarThemeData get darkScrollbarTheme => ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return _darkColorScheme.primary.withValues(alpha: 0.8);
          }
          return _darkColorScheme.primary.withValues(alpha: 0.5);
        }),
        thickness: WidgetStateProperty.all(5.0),
        radius: const Radius.circular(8),
        thumbVisibility: WidgetStateProperty.all(false),
        trackVisibility: WidgetStateProperty.all(false),
        interactive: true,
      );

  void setupTheme() {
    switch (_currentScheme) {
      case ThemeSchemes.defaultScheme:
        _setColorScheme(
          lightColorSchemeDefault,
          lightCustomColorsDefault,
          darkColorSchemeDefault,
          darkCustomColorsDefault,
        );
        break;
      case ThemeSchemes.blackScheme:
        _setColorScheme(
          lightColorSchemeBlack,
          lightCustomColorsBlack,
          darkColorSchemeBlack,
          darkCustomColorsBlack,
        );
        break;
      case ThemeSchemes.blueScheme:
        _setColorScheme(
          lightColorSchemeBlue,
          lightCustomColorsBlue,
          darkColorSchemeBlue,
          darkCustomColorsBlue,
        );
        break;
      case ThemeSchemes.redScheme:
        _setColorScheme(
          lightColorSchemeRed,
          lightCustomColorsRed,
          darkColorSchemeRed,
          darkCustomColorsRed,
        );
        break;
    }
  }

  void _setColorScheme(
    ColorScheme lightColorScheme,
    CustomColors lightCustomColors,
    ColorScheme darkColorScheme,
    CustomColors darkCustomColors,
  ) {
    _lightColorScheme = lightColorScheme;
    _lightCustomColors = lightCustomColors;
    _lightTitleListTheme = _createTitleListTheme(lightColorScheme);
    _darkColorScheme = darkColorScheme;
    _darkCustomColors = darkCustomColors;
    _darkTitleListTheme = _createTitleListTheme(darkColorScheme);
  }

  static TitleListTheme _createTitleListTheme(ColorScheme colorScheme) {
    return TitleListTheme(
      listBackground: colorScheme.onPrimaryContainer,
      listDividerColor: colorScheme.primaryContainer,
      controlPanelBackground: colorScheme.primary,
      controlPanelInternalBackground: colorScheme.primaryContainer,
      controlPanelDividerColor: colorScheme.onPrimaryContainer,
      controlPanelForeground: colorScheme.onPrimary,
      infoLineBackground: colorScheme.onPrimaryContainer,
      infoLineActiveFilterBackground: colorScheme.primary,
      infoLineActiveFilterForeground: colorScheme.onPrimary,
      infoLineInactiveFilterBackground: colorScheme.onPrimary,
      infoLineInactiveFilterForeground: colorScheme.primary,
      controlPanelActiveFilterBackground: colorScheme.onPrimary,
      controlPanelActiveFilterForeground: colorScheme.primary,
      controlPanelInactiveFilterBackground: colorScheme.primary,
      controlPanelInactiveFilterForeground: colorScheme.onPrimary,
      searchCursorColor: colorScheme.onPrimary,
      searchHintColor: colorScheme.onPrimary,
      searchSelectionColor: colorScheme.onPrimary.withValues(alpha: 0.5),
      sortArrowColor: colorScheme.primary,
      swapSortIconColor: colorScheme.primary,
    );
  }

  void setColorScheme(ThemeSchemes scheme) {
    switch (scheme) {
      case ThemeSchemes.defaultScheme:
        _setColorScheme(
          lightColorSchemeDefault,
          lightCustomColorsDefault,
          darkColorSchemeDefault,
          darkCustomColorsDefault,
        );
        _currentScheme = ThemeSchemes.defaultScheme;
        break;
      case ThemeSchemes.blackScheme:
        _setColorScheme(
          lightColorSchemeBlack,
          lightCustomColorsBlack,
          darkColorSchemeBlack,
          darkCustomColorsBlack,
        );
        _currentScheme = ThemeSchemes.blackScheme;
        break;
      case ThemeSchemes.blueScheme:
        _setColorScheme(
          lightColorSchemeBlue,
          lightCustomColorsBlue,
          darkColorSchemeBlue,
          darkCustomColorsBlue,
        );
        _currentScheme = ThemeSchemes.blueScheme;
        break;
      case ThemeSchemes.redScheme:
        _setColorScheme(
          lightColorSchemeRed,
          lightCustomColorsRed,
          darkColorSchemeRed,
          darkCustomColorsRed,
        );
        _currentScheme = ThemeSchemes.redScheme;
        break;
    }
    PreferencesService()
        .prefs
        .setString(AppConstants.themeScheme, _currentScheme.name);
    notifyListeners();
  }

  static ColorScheme lightColorSchemeDefault = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(0xFF, 0xd3, 0x9a, 0x54),
    onPrimary: Color.fromARGB(0xFF, 0x2B, 0x20, 0x16),
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.grey,
    surface: Color.fromARGB(0xFF, 0x2B, 0x20, 0x16),
    onSurface: Color.fromARGB(0xFF, 0xd3, 0x9a, 0x54),
  );

  static CustomColors lightCustomColorsDefault = CustomColors(
    inWatchlist: Color.fromARGB(0xFF, 0xFF, 0xC5, 0x00),
    notInWatchlist: Colors.grey,
    ratedTitle: Color.fromARGB(0xFF, 0xFF, 0xC5, 0x00),
    pinnedTitle: Colors.amber,
    selected: Color.fromARGB(0xFF, 0xd3, 0x9a, 0x54),
    notSelected: Colors.grey,
    chipCardBackground: Color.fromARGB(0xFF, 0x30, 0x25, 0x1B),
  );

  static ColorScheme darkColorSchemeDefault =
      lightColorSchemeDefault.copyWith(brightness: Brightness.dark);
  static CustomColors darkCustomColorsDefault = lightCustomColorsDefault;

  static ColorScheme lightColorSchemeBlack = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.grey,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.grey,
  );

  static CustomColors lightCustomColorsBlack = CustomColors(
    inWatchlist: Colors.orange,
    notInWatchlist: Colors.blueGrey,
    ratedTitle: Colors.orange,
    pinnedTitle: Colors.amber,
    selected: Colors.orange,
    notSelected: Colors.blueGrey,
    chipCardBackground: Colors.grey.shade200,
  );

  static ColorScheme darkColorSchemeBlack = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.grey,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.grey,
    surface: Colors.black,
    onSurface: Colors.grey,
  );

  static CustomColors darkCustomColorsBlack = CustomColors(
    inWatchlist: Colors.amber,
    notInWatchlist: Colors.grey,
    ratedTitle: Colors.amber,
    pinnedTitle: Colors.amber,
    selected: Colors.white,
    notSelected: Colors.grey,
    chipCardBackground: Colors.grey.shade900,
  );

  static ColorScheme lightColorSchemeBlue = ColorScheme(
    brightness: Brightness.light,
    primary: Color.from(
        alpha: 1.0000,
        red: 0.3333,
        green: 0.3490,
        blue: 0.5725,
        colorSpace: ColorSpace.sRGB),
    onPrimary: Color.from(
        alpha: 1.0000,
        red: 0.7451,
        green: 0.7608,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    secondary: Color.from(
        alpha: 1.0000,
        red: 0.3608,
        green: 0.3647,
        blue: 0.4471,
        colorSpace: ColorSpace.sRGB),
    onSecondary: Color.from(
        alpha: 1.0000,
        red: 1.0000,
        green: 1.0000,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    surface: Color.from(
        alpha: 1.0000,
        red: 0.7451,
        green: 0.7608,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    onSurface: Color.from(
        alpha: 1.0000,
        red: 0.3333,
        green: 0.3490,
        blue: 0.5725,
        colorSpace: ColorSpace.sRGB),
    error: Color.from(
        alpha: 1.0000,
        red: 0.7294,
        green: 0.1020,
        blue: 0.1020,
        colorSpace: ColorSpace.sRGB),
    onError: Color.from(
        alpha: 1.0000,
        red: 1.0000,
        green: 1.0000,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
  );

  static CustomColors lightCustomColorsBlue = CustomColors(
    inWatchlist: Colors.orange,
    notInWatchlist: Colors.grey,
    ratedTitle: Colors.orange,
    pinnedTitle: Colors.amber,
    selected: Colors.orange,
    notSelected: Colors.grey,
    chipCardBackground: Color.from(
        alpha: 0.8000,
        red: 0.7451,
        green: 0.7608,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
  );

  static ColorScheme darkColorSchemeBlue = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.from(
        alpha: 1.0000,
        red: 0.7451,
        green: 0.7608,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    onPrimary: Color.from(
        alpha: 1.0000,
        red: 0.1529,
        green: 0.1686,
        blue: 0.3765,
        colorSpace: ColorSpace.sRGB),
    secondary: Color.from(
        alpha: 1.0000,
        red: 0.7725,
        green: 0.7686,
        blue: 0.8667,
        colorSpace: ColorSpace.sRGB),
    onSecondary: Color.from(
        alpha: 1.0000,
        red: 0.1804,
        green: 0.1843,
        blue: 0.2588,
        colorSpace: ColorSpace.sRGB),
    surface: Color.from(
        alpha: 1.0000,
        red: 0.1529,
        green: 0.1686,
        blue: 0.3765,
        colorSpace: ColorSpace.sRGB),
    onSurface: Color.from(
        alpha: 1.0000,
        red: 0.7451,
        green: 0.7608,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    error: Color.from(
        alpha: 1.0000,
        red: 1.0000,
        green: 0.7059,
        blue: 0.6706,
        colorSpace: ColorSpace.sRGB),
    onError: Color.from(
        alpha: 1.0000,
        red: 0.4118,
        green: 0.0000,
        blue: 0.0196,
        colorSpace: ColorSpace.sRGB),
  );

  static CustomColors darkCustomColorsBlue = CustomColors(
    inWatchlist: Colors.amber,
    notInWatchlist: Colors.grey,
    ratedTitle: Colors.amber,
    pinnedTitle: Colors.amber,
    selected: Colors.amber,
    notSelected: Colors.grey,
    chipCardBackground: Color.from(
        alpha: 0.200,
        red: 0.1629,
        green: 0.1786,
        blue: 0.3865,
        colorSpace: ColorSpace.sRGB),
  );

  static ColorScheme lightColorSchemeRed = ColorScheme(
    brightness: Brightness.light,
    primary: Color.from(
        alpha: 1.0000,
        red: 0.5569,
        green: 0.2863,
        blue: 0.3412,
        colorSpace: ColorSpace.sRGB),
    onPrimary: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    secondary: Color.from(
        alpha: 1.0000,
        red: 0.4588,
        green: 0.3373,
        blue: 0.3569,
        colorSpace: ColorSpace.sRGB),
    onSecondary: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    surface: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    onSurface: Color.from(
        alpha: 1.0000,
        red: 0.5569,
        green: 0.2863,
        blue: 0.3412,
        colorSpace: ColorSpace.sRGB),
    error: Color.from(
        alpha: 1.0000,
        red: 0.7294,
        green: 0.1020,
        blue: 0.1020,
        colorSpace: ColorSpace.sRGB),
    onError: Color.from(
        alpha: 1.0000,
        red: 1.0000,
        green: 1.0000,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
  );

  static CustomColors lightCustomColorsRed = CustomColors(
    inWatchlist: Colors.red,
    notInWatchlist: Colors.grey,
    ratedTitle: Colors.red,
    pinnedTitle: Colors.amber,
    selected: Colors.red,
    notSelected: Colors.grey,
    chipCardBackground: Color.from(
        alpha: 0.800,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
  );

  static ColorScheme darkColorSchemeRed = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    onPrimary: Color.from(
        alpha: 1.0000,
        red: 0.5569,
        green: 0.2863,
        blue: 0.3412,
        colorSpace: ColorSpace.sRGB),
    secondary: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    onSecondary: Color.from(
        alpha: 1.0000,
        red: 0.4588,
        green: 0.3373,
        blue: 0.3569,
        colorSpace: ColorSpace.sRGB),
    surface: Color.from(
        alpha: 1.0000,
        red: 0.5569,
        green: 0.2863,
        blue: 0.3412,
        colorSpace: ColorSpace.sRGB),
    onSurface: Color.from(
        alpha: 1.000,
        red: 1.000,
        green: 0.7800,
        blue: 0.8270,
        colorSpace: ColorSpace.sRGB),
    error: Color.from(
        alpha: 1.0000,
        red: 1.0000,
        green: 1.0000,
        blue: 1.0000,
        colorSpace: ColorSpace.sRGB),
    onError: Color.from(
        alpha: 1.0000,
        red: 0.7294,
        green: 0.1020,
        blue: 0.1020,
        colorSpace: ColorSpace.sRGB),
  );

  static CustomColors darkCustomColorsRed = CustomColors(
    inWatchlist: Colors.orange,
    notInWatchlist: Colors.grey,
    ratedTitle: Colors.orange,
    pinnedTitle: Colors.amber,
    selected: Colors.orange,
    notSelected: Colors.grey,
    chipCardBackground: Color.from(
      alpha: 0.2000,
      red: 0.5569,
      green: 0.2863,
      blue: 0.3412,
    ),
  );
}
