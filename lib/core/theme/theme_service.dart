import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';

class ThemeService with ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ThemeMode get themeMode => ThemeMode.dark;

  void init() {
    setupTheme();
  }

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
    notifyListeners();
  }

  static TitleListTheme _createTitleListTheme(
      ColorScheme colorScheme, CustomColors customColors) {
    if (colorScheme.brightness == Brightness.light) {
      return TitleListTheme(
        infoLineBackground: colorScheme.surfaceContainerHighest,
        infoLineActiveFilterBackground: colorScheme.primaryContainer,
        infoLineActiveFilterForeground: colorScheme.onPrimaryContainer,
        infoLineInactiveFilterBackground: colorScheme.surface,
        infoLineInactiveFilterForeground: colorScheme.onSurfaceVariant,
        controlPanelBackground: colorScheme.surfaceContainerHighest,
        controlPanelForeground: colorScheme.onSurface,
        controlPanelActiveFilterBackground: colorScheme.primary,
        controlPanelActiveFilterForeground: colorScheme.onPrimary,
        controlPanelInactiveFilterBackground: colorScheme.surface,
        controlPanelInactiveFilterForeground: colorScheme.onSurface,
        searchCursorColor: colorScheme.primary,
        searchHintColor: colorScheme.onSurfaceVariant,
        searchSelectionColor: colorScheme.primary.withValues(alpha: 0.25),
      );
    }
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

  static const ColorScheme darkColorSchemeDefault = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF10B981),
    onPrimary: Color(0xFF121212),
    primaryContainer: Color(0xFF121212),
    onPrimaryContainer: Color(0xFFF5F5F5),
    secondary: Color(0xFF333333),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF262626),
    onSecondaryContainer: Color(0xFFE5E5E5),
    tertiary: Color(0xFFE5BA73),
    onTertiary: Color(0xFF333333),
    tertiaryContainer: Color(0xFF3D321F),
    onTertiaryContainer: Color(0xFFFCEBC7),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF9E9E9E),
    surfaceContainerHighest: Color(0xFF2B2B2B),
    outline: Color(0xFF404040),
    outlineVariant: Color(0xFF2E2E2E),
  );

  static const CustomColors darkCustomColorsDefault = CustomColors(
    inWatchlist: Color(0xFF10B981),
    notInWatchlist: Color(0xFF9E9E9E),
    ratedTitle: Color(0xFFE5BA73),
    userRatedTitle: Color(0xFF10B981),
    followingTitle: Color(0xFF10B981),
    pinnedTitle: Color(0xFFE5BA73),
    navigationBarSelected: Color(0xFF10B981),
    navigationBarNotSelected: Color(0xFF8E8E8E),
    chipCardBackground: Color(0xFF2B2B2B),
    dividerColor: Color(0xFF333333),
    bottomNavigationBarBackground: Color(0xFF333333),
    appBarBackground: Color(0xFF121212),
    appBarText: Color(0xFFF5F5F5),
    watchedOverlayColor: Colors.black54,
    destructiveAction: Color(0xFFFF5252),
    followingUserRatedTitle: Color(0xFF2DD4BF),
    badgeColor: Color(0xFFFF5252),
  );

  // MovieScout has only one color scheme
  static const ColorScheme lightColorSchemeDefault = darkColorSchemeDefault;
  static const CustomColors lightCustomColorsDefault = darkCustomColorsDefault;
}
