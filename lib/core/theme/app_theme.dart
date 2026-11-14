import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_radius.dart';
import 'package:moviescout/core/theme/app_typography.dart';
import 'package:moviescout/core/theme/theme_service.dart';

abstract final class AppTheme {
  static ThemeData buildTheme({
    required Brightness brightness,
    required ThemeService themeService,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        isDark ? themeService.darkColorScheme : themeService.lightColorScheme;
    final customColors =
        isDark ? themeService.darkCustomColors : themeService.lightCustomColors;
    final titleListTheme = isDark
        ? themeService.darkTitleListTheme
        : themeService.lightTitleListTheme;
    final scrollbarTheme = isDark
        ? themeService.darkScrollbarTheme
        : themeService.lightScrollbarTheme;

    final textTheme = AppTypography.createTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      scrollbarTheme: scrollbarTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: customColors.appBarBackground,
        foregroundColor: customColors.appBarText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: customColors.appBarText),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: customColors.appBarText,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1.0,
        margin: const EdgeInsets.all(4.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.none,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor:
            isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface,
        elevation: 6.0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface,
        modalBackgroundColor:
            isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.bottomSheet,
        ),
        showDragHandle: false,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: customColors.bottomNavigationBarBackground,
        elevation: 2.0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: customColors.bottomNavigationBarBackground,
        elevation: 1.0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
        backgroundColor: colorScheme.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        actionTextColor: colorScheme.primary,
        elevation: 4.0,
      ),
      dividerTheme: DividerThemeData(
        color: customColors.dividerColor,
        space: 16.0,
        thickness: 1.0,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: customColors.badgeColor,
        textColor: colorScheme.onError,
        textStyle: textTheme.labelSmall,
      ),
      extensions: <ThemeExtension<dynamic>>[
        customColors,
        titleListTheme,
      ],
    );
  }
}
