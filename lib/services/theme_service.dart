import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/title_list_theme.dart';

class ThemeService with ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ColorScheme _lightColorScheme = lightColorSchemeDefault;
  CustomColors _lightCustomColors = lightCustomColorsDefault;
  TitleListTheme _lightTitleListTheme =
      _createTitleListTheme(lightColorSchemeDefault, lightCustomColorsDefault);

  ColorScheme get lightColorScheme => _lightColorScheme;
  CustomColors get lightCustomColors => _lightCustomColors;
  TitleListTheme get lightTitleListTheme => _lightTitleListTheme;

  ColorScheme _darkColorScheme = darkColorSchemeDefault;
  CustomColors _darkCustomColors = darkCustomColorsDefault;
  TitleListTheme _darkTitleListTheme =
      _createTitleListTheme(darkColorSchemeDefault, darkCustomColorsDefault);

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
    _lightTitleListTheme =
        _createTitleListTheme(lightColorScheme, lightCustomColors);
    _darkColorScheme = darkColorScheme;
    _darkCustomColors = darkCustomColors;
    _darkTitleListTheme =
        _createTitleListTheme(darkColorScheme, darkCustomColors);
  }

  static TitleListTheme _createTitleListTheme(
      ColorScheme colorScheme, CustomColors customColors) {
    return TitleListTheme(
      listBackground: colorScheme.onPrimaryContainer,
      listDividerColor: customColors.dividerColor,
      controlPanelBackground: customColors.controlPanelBackground,
      controlPanelInternalBackground: colorScheme.primaryContainer,
      controlPanelForeground: colorScheme.onPrimary,
      infoLineBackground: colorScheme.onPrimaryContainer,
      infoLineActiveFilterBackground: colorScheme.primary,
      infoLineActiveFilterForeground: colorScheme.onPrimary,
      infoLineInactiveFilterBackground: colorScheme.onPrimary,
      infoLineInactiveFilterForeground: colorScheme.primary,
      controlPanelActiveFilterBackground: colorScheme.onPrimary,
      controlPanelActiveFilterForeground: customColors.controlPanelBackground,
      controlPanelInactiveFilterBackground: customColors.controlPanelBackground,
      controlPanelInactiveFilterForeground: colorScheme.onPrimary,
      searchCursorColor: colorScheme.onPrimary,
      searchHintColor: colorScheme.onPrimary,
      searchSelectionColor: colorScheme.onPrimary.withValues(alpha: 0.5),
      sortArrowColor: colorScheme.primary,
      swapSortIconColor: colorScheme.primary,
    );
  }

  static ColorScheme lightColorSchemeDefault = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(0xFF, 0XE6, 0XF4, 0XEA),
    onPrimary: Color.fromARGB(0xFF, 0x12, 0x12, 0x12),
    secondary: Color.fromARGB(0xFF, 0xA0, 0xA0, 0xA0),
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.grey,
    surface: Color.fromARGB(0xFF, 0x1E, 0x1E, 0x1E),
    onSurface: Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5),
  );

  static CustomColors lightCustomColorsDefault = CustomColors(
    inWatchlist: Color.fromARGB(0xFF, 0x10, 0xB9, 0x81),
    notInWatchlist: Colors.grey,
    ratedTitle: Color.fromARGB(0xFF, 0xE5, 0xBA, 0x73),
    userRatedTitle: Color.fromARGB(0xFF, 0x10, 0xB9, 0x81),
    pinnedTitle: Colors.amber,
    selected: Color.fromARGB(0xFF, 0x10, 0xB9, 0x81),
    notSelected: Color.fromARGB(0xFF, 0x8E, 0x8E, 0x93),
    chipCardBackground: Color.fromARGB(0xFF, 0x30, 0x25, 0x1B),
    dividerColor: Color.fromARGB(0xFF, 0x39, 0x39, 0x39),
    bottomNavigationBarBackground: Color.fromARGB(0xFF, 0x33, 0x33, 0x33),
    appBarBackground: Color.fromARGB(0xFF, 0x12, 0x12, 0x12),
    titleAppBar: Color.fromARGB(0xFF, 0XE6, 0XF4, 0XEA),
    controlPanelBackground: Color.fromARGB(0xFF, 0xE5, 0xBA, 0x73),
  );

  static ColorScheme darkColorSchemeDefault =
      lightColorSchemeDefault.copyWith(brightness: Brightness.dark);
  static CustomColors darkCustomColorsDefault = lightCustomColorsDefault;
}
