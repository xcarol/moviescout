import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double micro = 2.0;
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
  static const double episodeThumbnailWidth = 192.0;
  static const double userCardHeight = 104.0;
  static const double userCardAvatarSize = 68.0;

  static const double posterChipWidth = 156.0;
  static const double posterChipHeight = 328.0;
  static const double chipCarouselHeight = 336.0;
  static const double personGridMaxExtent = 148.0;

  static const double pinnedChipWidth = 104.0;
  static const double pinnedChipHeight = 172.0;

  static const double headerPosterWidth = 120.0;
  static const double headerPosterHeight = 170.0;
  static const double headerPosterOverlap = 28.0;
  static const double headerPosterBorderWidth = 4.0;
  static const double headerInfoMinHeight = 150.0;
  static const double headerInfoLeftPadding = 144.0;

  static const double personBannerMaxPosterBaseWidth = 150.0;
  static const double personBannerPosterExtraWidth = 30.0;
  static const double personBannerPosterWidthFraction = 0.4;
  static const double personGalleryHeight = 200.0;

  static const double userProfileAvatarRadius = 46.0;
  static const double userProfileAvatarSize = 92.0;
  static const double followButtonWidth = 180.0;

  static const double notificationThumbWidth = 50.0;
  static const double notificationThumbHeight = 75.0;

  static const double importStatusCellWidth = 40.0;
  static const double importIdCellWidth = 100.0;
  static const double importHeroIconSize = 96.0;

  static const double infoSheetHeaderBoxSize = 44.0;
  static const double settingsDividerIndent = 56.0;
  static const double dialogHeightFactor = 0.65;
  static const double trailerButtonHeight = 32.0;

  static const double refreshIndicatorBaseOffset = -40.0;
  static const double refreshIndicatorDragRange = 80.0;

  static const double providerLogoSize = 28.0;

  static const int posterCacheWidth = 200;
  static const int posterCacheHeight = 300;
  static const int stillCacheWidth = 320;
  static const int stillCacheHeight = 180;
  static const int providerCacheSize = 56;
  static const int tmdbAvatarCacheSize = 200;

  static const double iconXs = 14.0;
  static const double iconSm = 16.0;
  static const double iconSubtle = 18.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconDialog = 28.0;
  static const double iconXl = 32.0;
  static const double iconHero = 48.0;
  static const double iconEmptyState = 64.0;
  static const double emptyStateIconSize = 64.0;

  static const double avatarSm = 36.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 56.0;

  static const double filterControlHeight = 34.0;
  static const double ratingFilterWidth = 150.0;
  static const double ratingFilterHeight = 40.0;

  static const double compactActionSize = 28.0;
  static const double minTouchTarget = 48.0;

  static const BoxConstraints compactActionConstraints = BoxConstraints(
    minWidth: compactActionSize,
    minHeight: compactActionSize,
  );
  static const BoxConstraints suffixIconConstraints = BoxConstraints(
    minWidth: iconXl,
    minHeight: iconXl,
  );

  static const double borderWidthThin = 0.5;
  static const double borderWidthRegular = 1.0;
  static const double borderWidthFocused = 1.5;
  static const double borderWidthThick = 2.0;
  static const double strokeWidthSm = 2.0;

  static const double carouselDotSize = 8.0;
  static const double carouselDotActiveWidth = 16.0;
  static const double carouselBlurSigma = 15.0;

  static const double badgeDotSize = 8.0;
  static const double refreshOffsetToArmed = 100.0;
  static const double dropdownMaxMenuHeight = 320.0;
  static const double searchOverlayOffset = 65.0;

  static const double floatingPlayerWidth = 300.0;
  static const double floatingPlayerHeaderHeight = 30.0;
  static const double floatingPlayerInitialX = 16.0;
  static const double floatingPlayerInitialY = 100.0;
  static const double floatingPlayerElevation = 12.0;
  static const double overlayElevation = 4.0;
  static const double elevationSubtle = 1.0;
  static const double scrollbarThickness = 5.0;
  static const double defaultLineHeight = 1.2;

  static const double textScaleMin = 1.0;
  static const double textScaleMax = 1.3;
}

abstract final class AppOpacity {
  static const double tint = 0.12;
  static const double loadingPlaceholder = 0.25;
  static const double scrimLight = 0.3;
  static const double surfaceSubtle = 0.35;
  static const double backdropOverlay = 0.4;
  static const double muted = 0.45;
  static const double half = 0.5;
  static const double disabled = 0.6;
  static const double subtle = 0.7;
  static const double scrollbarDragged = 0.8;
  static const double chipBadge = 0.85;
  static const double chipFooter = 0.95;
  static const double opaque = 1.0;
}

abstract final class AppBreakpoints {
  static const double inlineDropdown = 350.0;
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
  static const Duration feedback = Duration(seconds: 2);
  static const Duration snackBarShort = Duration(seconds: 4);
  static const Duration snackBarInfo = Duration(seconds: 4);
  static const Duration snackBarAction = Duration(seconds: 8);
}
