import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/preferences_service.dart';

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
        (PreferencesService().prefs.getString('ThemeScheme') ??
            ThemeSchemes.defaultScheme.name),
    orElse: () => ThemeSchemes.defaultScheme,
  );

  ThemeSchemes get currentScheme => _currentScheme;

  ColorScheme _lightColorScheme = lightColorSchemeDefault;
  CustomColors _lightCustomColors = lightCustomColorsDefault;

  ColorScheme get lightColorScheme => _lightColorScheme;
  CustomColors get lightCustomColors => _lightCustomColors;

  ColorScheme _darkColorScheme = darkColorSchemeDefault;
  CustomColors _darkCustomColors = darkCustomColorsDefault;

  ColorScheme get darkColorScheme => _darkColorScheme;
  CustomColors get darkCustomColors => _darkCustomColors;

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
    _darkColorScheme = darkColorScheme;
    _darkCustomColors = darkCustomColors;
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
    PreferencesService().prefs.setString('ThemeScheme', _currentScheme.name);
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
    selected: Colors.white,
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
