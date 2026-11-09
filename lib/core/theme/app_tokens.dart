import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double bottomSafeMargin = 80.0;

  static const EdgeInsets screenHorizontal =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.all(sm);
  static const EdgeInsets chipPadding = EdgeInsets.all(xs);
}

abstract final class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static final BorderRadius borderXs = BorderRadius.circular(xs);
  static final BorderRadius borderSm = BorderRadius.circular(sm);
  static final BorderRadius borderMd = BorderRadius.circular(md);
  static final BorderRadius borderLg = BorderRadius.circular(lg);
  static final BorderRadius borderXl = BorderRadius.circular(xl);
  static final BorderRadius borderFull = BorderRadius.circular(full);
}

abstract final class AppSizes {
  static const double aspectRatioPoster = 2 / 3;
  static const double aspectRatioBackdrop = 16 / 9;

  static const double listCardHeight = 168.0;
  static const double episodeCardHeight = 116.0;
  static const double userCardHeight = 96.0;

  static const double posterChipWidth = 152.0;
  static const double posterChipHeight = 320.0;

  static const double pinnedChipWidth = 104.0;
  static const double pinnedChipHeight = 172.0;

  static const double providerLogoSize = 28.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double emptyStateIconSize = 64.0;
  static const double minTouchTarget = 48.0;
}

abstract final class AppBreakpoints {
  static const double compact = 600.0;
  static const double medium = 840.0;
  static const double expanded = 1200.0;

  static const double maxContentWidth = 900.0;
  static const double maxFormWidth = 480.0;
  static const double maxEmptyStateWidth = 360.0;
  static const double maxGridCardExtent = 450.0;
  static const double maxBannerHeight = 360.0;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration snackBarShort = Duration(seconds: 4);
  static const Duration snackBarAction = Duration(seconds: 8);
}
