import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_colors.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/app_typography.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';

abstract final class AppTheme {
  static ThemeData light({
    ColorScheme? colorScheme,
    CustomColors? customColors,
    TitleListTheme? titleListTheme,
  }) {
    final effectiveColorScheme = colorScheme ?? AppColors.lightColorScheme;
    final effectiveCustomColors = customColors ?? AppColors.lightCustomColors;
    return _buildTheme(
      colorScheme: effectiveColorScheme,
      customColors: effectiveCustomColors,
      titleListTheme: titleListTheme ??
          TitleListTheme.fromColorScheme(
              effectiveColorScheme, effectiveCustomColors),
    );
  }

  static ThemeData dark({
    ColorScheme? colorScheme,
    CustomColors? customColors,
    TitleListTheme? titleListTheme,
  }) {
    final effectiveColorScheme = colorScheme ?? AppColors.darkColorScheme;
    final effectiveCustomColors = customColors ?? AppColors.darkCustomColors;
    return _buildTheme(
      colorScheme: effectiveColorScheme,
      customColors: effectiveCustomColors,
      titleListTheme: titleListTheme ??
          TitleListTheme.fromColorScheme(
              effectiveColorScheme, effectiveCustomColors),
    );
  }

  static ScrollbarThemeData buildScrollbarTheme(ColorScheme colorScheme) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged)) {
          return colorScheme.onSurfaceVariant
              .withValues(alpha: AppOpacity.scrollbarDragged);
        }
        return colorScheme.onSurfaceVariant.withValues(alpha: AppOpacity.half);
      }),
      thickness: WidgetStateProperty.all(AppSizes.scrollbarThickness),
      radius: const Radius.circular(AppRadius.sm),
      thumbVisibility: WidgetStateProperty.all(false),
      trackVisibility: WidgetStateProperty.all(false),
      interactive: true,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required CustomColors customColors,
    required TitleListTheme titleListTheme,
  }) {
    final textTheme = AppTypography.buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      scrollbarTheme: buildScrollbarTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: customColors.appBarBackground,
        foregroundColor: customColors.appBarText,
        elevation: 0,
        scrolledUnderElevation: AppSizes.elevationSubtle,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: customColors.appBarText,
        ),
        iconTheme: IconThemeData(color: customColors.appBarText),
        actionsIconTheme: IconThemeData(color: customColors.appBarText),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderXl,
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        closeIconColor: colorScheme.onInverseSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderSm,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest
            .withValues(alpha: AppOpacity.backdropOverlay),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSizes.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: customColors.dividerColor,
        thickness: AppSizes.borderWidthRegular,
        space: AppSizes.borderWidthRegular,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: customColors.bottomNavigationBarBackground,
        selectedItemColor: customColors.navigationBarSelected,
        unselectedItemColor: customColors.navigationBarNotSelected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: customColors.bottomNavigationBarBackground,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: customColors.bottomNavigationBarBackground,
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(
          color: customColors.navigationBarSelected,
        ),
        unselectedIconTheme: IconThemeData(
          color: customColors.navigationBarNotSelected,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: customColors.navigationBarSelected,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: customColors.navigationBarNotSelected,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: customColors.badgeColor,
      ),
      extensions: <ThemeExtension<dynamic>>[
        customColors,
        titleListTheme,
      ],
    );
  }
}
