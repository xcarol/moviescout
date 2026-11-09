import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/custom_colors.dart';

abstract final class AppColors {
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald100 = Color(0xFFD1FAE5);

  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color teal600 = Color(0xFF0D9488);

  static const Color gold400 = Color(0xFFE5BA73);
  static const Color amber600 = Color(0xFFD97706);

  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: emerald500,
    onPrimary: Color(0xFF06281E),
    primaryContainer: Color(0xFF064E3B),
    onPrimaryContainer: emerald200,
    secondary: Color(0xFF262626),
    onSecondary: Color(0xFFF5F5F5),
    secondaryContainer: Color(0xFF333333),
    onSecondaryContainer: Color(0xFFF5F5F5),
    tertiary: gold400,
    onTertiary: Color(0xFF2A1E08),
    tertiaryContainer: Color(0xFF423010),
    onTertiaryContainer: Color(0xFFFDE68A),
    error: red500,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF451A1A),
    onErrorContainer: Color(0xFFFECACA),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFF5F5F5),
    surfaceContainerLowest: Color(0xFF0A0A0A),
    surfaceContainerLow: Color(0xFF1A1A1A),
    surfaceContainer: Color(0xFF222222),
    surfaceContainerHigh: Color(0xFF282828),
    surfaceContainerHighest: Color(0xFF2E2E2E),
    onSurfaceVariant: Color(0xFFA3A3A3),
    outline: Color(0xFF404040),
    outlineVariant: Color(0xFF2E2E2E),
    inverseSurface: Color(0xFFF5F5F5),
    onInverseSurface: Color(0xFF171717),
    inversePrimary: emerald600,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: emerald600,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: emerald100,
    onPrimaryContainer: emerald900,
    secondary: Color(0xFFE5E7EB),
    onSecondary: Color(0xFF1F2937),
    secondaryContainer: Color(0xFFD1D5DB),
    onSecondaryContainer: Color(0xFF111827),
    tertiary: amber600,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF78350F),
    error: red600,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: Color(0xFFF9FAFB),
    onSurface: Color(0xFF111827),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFF3F4F6),
    surfaceContainerHigh: Color(0xFFE5E7EB),
    surfaceContainerHighest: Color(0xFFD1D5DB),
    onSurfaceVariant: Color(0xFF4B5563),
    outline: Color(0xFF9CA3AF),
    outlineVariant: Color(0xFFE5E7EB),
    inverseSurface: Color(0xFF1F2937),
    onInverseSurface: Color(0xFFF9FAFB),
    inversePrimary: emerald500,
  );

  static final CustomColors darkCustomColors = CustomColors(
    inWatchlist: darkColorScheme.primary,
    notInWatchlist: darkColorScheme.onSurfaceVariant,
    ratedTitle: darkColorScheme.tertiary,
    userRatedTitle: darkColorScheme.primary,
    followingTitle: darkColorScheme.primary,
    pinnedTitle: darkColorScheme.tertiary,
    navigationBarSelected: darkColorScheme.primary,
    navigationBarNotSelected: darkColorScheme.onSurfaceVariant,
    chipCardBackground: darkColorScheme.surfaceContainer,
    dividerColor: darkColorScheme.outlineVariant,
    bottomNavigationBarBackground: darkColorScheme.surfaceContainer,
    appBarBackground: darkColorScheme.surface,
    appBarText: darkColorScheme.onSurface,
    watchedOverlayColor: Colors.black54,
    destructiveAction: darkColorScheme.error,
    followingUserRatedTitle: teal400,
    badgeColor: darkColorScheme.error,
  );

  static final CustomColors lightCustomColors = CustomColors(
    inWatchlist: lightColorScheme.primary,
    notInWatchlist: lightColorScheme.onSurfaceVariant,
    ratedTitle: lightColorScheme.tertiary,
    userRatedTitle: lightColorScheme.primary,
    followingTitle: lightColorScheme.primary,
    pinnedTitle: lightColorScheme.tertiary,
    navigationBarSelected: lightColorScheme.primary,
    navigationBarNotSelected: lightColorScheme.onSurfaceVariant,
    chipCardBackground: lightColorScheme.surfaceContainerLow,
    dividerColor: lightColorScheme.outlineVariant,
    bottomNavigationBarBackground: lightColorScheme.surfaceContainer,
    appBarBackground: lightColorScheme.surface,
    appBarText: lightColorScheme.onSurface,
    watchedOverlayColor: Colors.black45,
    destructiveAction: lightColorScheme.error,
    followingUserRatedTitle: teal600,
    badgeColor: lightColorScheme.error,
  );
}
