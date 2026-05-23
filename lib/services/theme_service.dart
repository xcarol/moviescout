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
            return _lightColorScheme.onSurfaceVariant.withValues(alpha: 0.8);
          }
          return _lightColorScheme.onSurfaceVariant.withValues(alpha: 0.5);
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
            return _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.8);
          }
          return _darkColorScheme.onSurfaceVariant.withValues(alpha: 0.5);
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
      infoLineBackground: colorScheme.primaryContainer,
      infoLineActiveFilterBackground: colorScheme.surface,
      infoLineActiveFilterForeground: colorScheme.primary,
      infoLineInactiveFilterBackground: colorScheme.surface,
      infoLineInactiveFilterForeground: colorScheme.onSurface,
      controlPanelBackground: colorScheme.secondary,
      controlPanelForeground: colorScheme.onSurface,
      controlPanelActiveFilterBackground: colorScheme.primary,
      controlPanelActiveFilterForeground: colorScheme.onSurface,
      controlPanelInactiveFilterBackground: colorScheme.secondary,
      controlPanelInactiveFilterForeground: colorScheme.onSurface,
      searchCursorColor: colorScheme.onSurface,
      searchHintColor: colorScheme.onSurface,
      searchSelectionColor: colorScheme.onSurface.withValues(alpha: 0.5),
    );
  }

  static ColorScheme lightColorSchemeDefault = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(0xFF, 0x10, 0xB9, 0x81),
    onPrimary: Color.fromARGB(0xFF, 0x12, 0x12, 0x12),
    primaryContainer: Color.fromARGB(0xFF, 0x12, 0x12, 0x12),
    onPrimaryContainer: Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5),
    secondary: Color.fromARGB(0xFF, 0x33, 0x33, 0x33),
    onSecondary: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
    tertiary: Color.fromARGB(0xFF, 0xE5, 0xBA, 0x73),
    onTertiary: Color.fromARGB(0xFF, 0x33, 0x33, 0x33),
    error: Colors.red,
    onError: Colors.grey,
    surface: Color.fromARGB(0xFF, 0x1E, 0x1E, 0x1E),
    onSurface: Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5),
    onSurfaceVariant: Color.fromARGB(0xFF, 0x9E, 0x9E, 0x9E),
  );

  static CustomColors lightCustomColorsDefault = CustomColors(
    inWatchlist: lightColorSchemeDefault.primary,
    notInWatchlist: lightColorSchemeDefault.onSurfaceVariant,
    ratedTitle: lightColorSchemeDefault.tertiary,
    userRatedTitle: lightColorSchemeDefault.primary,
    snoozedTitle: lightColorSchemeDefault.primary,
    pinnedTitle: lightColorSchemeDefault.tertiary,
    navigationBarSelected: lightColorSchemeDefault.primary,
    navigationBarNotSelected: Color.fromARGB(0xFF, 0x8E, 0x8E, 0x8E),
    chipCardBackground: Color.fromARGB(0xFF, 0x2B, 0x2B, 0x2B),
    dividerColor: lightColorSchemeDefault.secondary,
    bottomNavigationBarBackground: lightColorSchemeDefault.secondary,
    appBarBackground: lightColorSchemeDefault.primaryContainer,
    appBarText: lightColorSchemeDefault.onSurface,
  );

  static ColorScheme darkColorSchemeDefault =
      lightColorSchemeDefault.copyWith(brightness: Brightness.dark);
  static CustomColors darkCustomColorsDefault = lightCustomColorsDefault;
}
