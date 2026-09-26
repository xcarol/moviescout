import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/custom_colors.dart';

void main() {
  const sampleColors = CustomColors(
    inWatchlist: Color(0xFF111111),
    notInWatchlist: Color(0xFF222222),
    ratedTitle: Color(0xFF333333),
    userRatedTitle: Color(0xFF444444),
    followingTitle: Color(0xFF555555),
    pinnedTitle: Color(0xFF666666),
    navigationBarSelected: Color(0xFF777777),
    navigationBarNotSelected: Color(0xFF888888),
    chipCardBackground: Color(0xFF999999),
    dividerColor: Color(0xFFAAAAAA),
    bottomNavigationBarBackground: Color(0xFFBBBBBB),
    appBarBackground: Color(0xFFCCCCCC),
    appBarText: Color(0xFFDDDDDD),
    watchedOverlayColor: Color(0xFFEEEEEE),
  );

  group('CustomColors', () {
    test('instantiates with all required colors', () {
      expect(sampleColors.inWatchlist, const Color(0xFF111111));
      expect(sampleColors.notInWatchlist, const Color(0xFF222222));
      expect(sampleColors.ratedTitle, const Color(0xFF333333));
      expect(sampleColors.userRatedTitle, const Color(0xFF444444));
      expect(sampleColors.followingTitle, const Color(0xFF555555));
      expect(sampleColors.pinnedTitle, const Color(0xFF666666));
      expect(sampleColors.navigationBarSelected, const Color(0xFF777777));
      expect(sampleColors.navigationBarNotSelected, const Color(0xFF888888));
      expect(sampleColors.chipCardBackground, const Color(0xFF999999));
      expect(sampleColors.dividerColor, const Color(0xFFAAAAAA));
      expect(sampleColors.bottomNavigationBarBackground, const Color(0xFFBBBBBB));
      expect(sampleColors.appBarBackground, const Color(0xFFCCCCCC));
      expect(sampleColors.appBarText, const Color(0xFFDDDDDD));
      expect(sampleColors.watchedOverlayColor, const Color(0xFFEEEEEE));
    });

    test('copyWith preserves existing colors when arguments are null', () {
      final copy = sampleColors.copyWith();
      expect(copy.inWatchlist, sampleColors.inWatchlist);
      expect(copy.notInWatchlist, sampleColors.notInWatchlist);
      expect(copy.ratedTitle, sampleColors.ratedTitle);
      expect(copy.userRatedTitle, sampleColors.userRatedTitle);
      expect(copy.followingTitle, sampleColors.followingTitle);
      expect(copy.pinnedTitle, sampleColors.pinnedTitle);
      expect(copy.navigationBarSelected, sampleColors.navigationBarSelected);
      expect(copy.navigationBarNotSelected, sampleColors.navigationBarNotSelected);
      expect(copy.chipCardBackground, sampleColors.chipCardBackground);
      expect(copy.dividerColor, sampleColors.dividerColor);
      expect(copy.bottomNavigationBarBackground, sampleColors.bottomNavigationBarBackground);
      expect(copy.appBarBackground, sampleColors.appBarBackground);
      expect(copy.appBarText, sampleColors.appBarText);
      expect(copy.watchedOverlayColor, sampleColors.watchedOverlayColor);
    });

    test('copyWith overrides specified colors', () {
      final updated = sampleColors.copyWith(
        inWatchlist: const Color(0xFF000001),
        notInWatchlist: const Color(0xFF000002),
        ratedTitle: const Color(0xFF000003),
        userRatedTitle: const Color(0xFF000004),
        followingTitle: const Color(0xFF000005),
        pinnedTitle: const Color(0xFF000006),
        navigationBarSelected: const Color(0xFF000007),
        navigationBarNotSelected: const Color(0xFF000008),
        chipCardBackground: const Color(0xFF000009),
        dividerColor: const Color(0xFF00000A),
        bottomNavigationBarBackground: const Color(0xFF00000B),
        appBarBackground: const Color(0xFF00000C),
        appBarText: const Color(0xFF00000D),
        watchedOverlayColor: const Color(0xFF00000E),
      );

      expect(updated.inWatchlist, const Color(0xFF000001));
      expect(updated.notInWatchlist, const Color(0xFF000002));
      expect(updated.ratedTitle, const Color(0xFF000003));
      expect(updated.userRatedTitle, const Color(0xFF000004));
      expect(updated.followingTitle, const Color(0xFF000005));
      expect(updated.pinnedTitle, const Color(0xFF000006));
      expect(updated.navigationBarSelected, const Color(0xFF000007));
      expect(updated.navigationBarNotSelected, const Color(0xFF000008));
      expect(updated.chipCardBackground, const Color(0xFF000009));
      expect(updated.dividerColor, const Color(0xFF00000A));
      expect(updated.bottomNavigationBarBackground, const Color(0xFF00000B));
      expect(updated.appBarBackground, const Color(0xFF00000C));
      expect(updated.appBarText, const Color(0xFF00000D));
      expect(updated.watchedOverlayColor, const Color(0xFF00000E));
    });

    test('lerp returns this when other is not CustomColors or null', () {
      final lerpedNull = sampleColors.lerp(null, 0.5);
      expect(identical(lerpedNull, sampleColors), isTrue);
    });

    test('lerp correctly interpolates between two CustomColors instances', () {
      const otherColors = CustomColors(
        inWatchlist: Color(0xFFFFFFFF),
        notInWatchlist: Color(0xFFFFFFFF),
        ratedTitle: Color(0xFFFFFFFF),
        userRatedTitle: Color(0xFFFFFFFF),
        followingTitle: Color(0xFFFFFFFF),
        pinnedTitle: Color(0xFFFFFFFF),
        navigationBarSelected: Color(0xFFFFFFFF),
        navigationBarNotSelected: Color(0xFFFFFFFF),
        chipCardBackground: Color(0xFFFFFFFF),
        dividerColor: Color(0xFFFFFFFF),
        bottomNavigationBarBackground: Color(0xFFFFFFFF),
        appBarBackground: Color(0xFFFFFFFF),
        appBarText: Color(0xFFFFFFFF),
        watchedOverlayColor: Color(0xFFFFFFFF),
      );

      final lerpedZero = sampleColors.lerp(otherColors, 0.0);
      expect(lerpedZero.inWatchlist, sampleColors.inWatchlist);
      expect(lerpedZero.watchedOverlayColor, sampleColors.watchedOverlayColor);

      final lerpedOne = sampleColors.lerp(otherColors, 1.0);
      expect(lerpedOne.inWatchlist, otherColors.inWatchlist);
      expect(lerpedOne.watchedOverlayColor, otherColors.watchedOverlayColor);

      final lerpedMid = sampleColors.lerp(otherColors, 0.5);
      expect(
        lerpedMid.inWatchlist,
        Color.lerp(sampleColors.inWatchlist, otherColors.inWatchlist, 0.5),
      );
      expect(
        lerpedMid.watchedOverlayColor,
        Color.lerp(sampleColors.watchedOverlayColor, otherColors.watchedOverlayColor, 0.5),
      );
    });
  });
}
