import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_colors.dart';
import 'package:moviescout/core/theme/app_theme.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';

class ThemeService with ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ColorScheme _lightColorScheme = lightColorSchemeDefault;
  CustomColors _lightCustomColors = lightCustomColorsDefault;
  TitleListTheme _lightTitleListTheme = TitleListTheme.fromColorScheme(
    lightColorSchemeDefault,
    lightCustomColorsDefault,
  );

  ColorScheme get lightColorScheme => _lightColorScheme;
  CustomColors get lightCustomColors => _lightCustomColors;
  TitleListTheme get lightTitleListTheme => _lightTitleListTheme;

  ColorScheme _darkColorScheme = darkColorSchemeDefault;
  CustomColors _darkCustomColors = darkCustomColorsDefault;
  TitleListTheme _darkTitleListTheme = TitleListTheme.fromColorScheme(
    darkColorSchemeDefault,
    darkCustomColorsDefault,
  );

  ColorScheme get darkColorScheme => _darkColorScheme;
  CustomColors get darkCustomColors => _darkCustomColors;
  TitleListTheme get darkTitleListTheme => _darkTitleListTheme;

  ScrollbarThemeData get lightScrollbarTheme =>
      AppTheme.buildScrollbarTheme(_lightColorScheme);

  ScrollbarThemeData get darkScrollbarTheme =>
      AppTheme.buildScrollbarTheme(_darkColorScheme);

  ThemeData get lightTheme => AppTheme.light(
        colorScheme: _lightColorScheme,
        customColors: _lightCustomColors,
        titleListTheme: _lightTitleListTheme,
      );

  ThemeData get darkTheme => AppTheme.dark(
        colorScheme: _darkColorScheme,
        customColors: _darkCustomColors,
        titleListTheme: _darkTitleListTheme,
      );

  void setupTheme() {
    _setColorScheme(
      lightColorSchemeDefault,
      lightCustomColorsDefault,
      darkColorSchemeDefault,
      darkCustomColorsDefault,
    );
  }

  void _setColorScheme(
    ColorScheme lightColorScheme,
    CustomColors lightCustomColors,
    ColorScheme darkColorScheme,
    CustomColors darkCustomColors,
  ) {
    _lightColorScheme = lightColorScheme;
    _lightCustomColors = lightCustomColors;
    _lightTitleListTheme = TitleListTheme.fromColorScheme(
      lightColorScheme,
      lightCustomColors,
    );
    _darkColorScheme = darkColorScheme;
    _darkCustomColors = darkCustomColors;
    _darkTitleListTheme = TitleListTheme.fromColorScheme(
      darkColorScheme,
      darkCustomColors,
    );
  }

  static ColorScheme lightColorSchemeDefault = AppColors.lightColorScheme;
  static CustomColors lightCustomColorsDefault = AppColors.lightCustomColors;

  static ColorScheme darkColorSchemeDefault = AppColors.darkColorScheme;
  static CustomColors darkCustomColorsDefault = AppColors.darkCustomColors;
}
