import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviescout/models/title_list_theme.dart';

void main() {
  const sampleTheme = TitleListTheme(
    controlPanelBackground: Color(0xFF100000),
    controlPanelForeground: Color(0xFF200000),
    infoLineBackground: Color(0xFF300000),
    infoLineActiveFilterBackground: Color(0xFF400000),
    infoLineActiveFilterForeground: Color(0xFF500000),
    infoLineInactiveFilterBackground: Color(0xFF600000),
    infoLineInactiveFilterForeground: Color(0xFF700000),
    controlPanelActiveFilterBackground: Color(0xFF800000),
    controlPanelActiveFilterForeground: Color(0xFF900000),
    controlPanelInactiveFilterBackground: Color(0xFFA00000),
    controlPanelInactiveFilterForeground: Color(0xFFB00000),
    searchCursorColor: Color(0xFFC00000),
    searchHintColor: Color(0xFFD00000),
    searchSelectionColor: Color(0xFFE00000),
  );

  group('TitleListTheme', () {
    test('instantiates with all required properties', () {
      expect(sampleTheme.controlPanelBackground, const Color(0xFF100000));
      expect(sampleTheme.controlPanelForeground, const Color(0xFF200000));
      expect(sampleTheme.infoLineBackground, const Color(0xFF300000));
      expect(sampleTheme.infoLineActiveFilterBackground, const Color(0xFF400000));
      expect(sampleTheme.infoLineActiveFilterForeground, const Color(0xFF500000));
      expect(sampleTheme.infoLineInactiveFilterBackground, const Color(0xFF600000));
      expect(sampleTheme.infoLineInactiveFilterForeground, const Color(0xFF700000));
      expect(sampleTheme.controlPanelActiveFilterBackground, const Color(0xFF800000));
      expect(sampleTheme.controlPanelActiveFilterForeground, const Color(0xFF900000));
      expect(sampleTheme.controlPanelInactiveFilterBackground, const Color(0xFFA00000));
      expect(sampleTheme.controlPanelInactiveFilterForeground, const Color(0xFFB00000));
      expect(sampleTheme.searchCursorColor, const Color(0xFFC00000));
      expect(sampleTheme.searchHintColor, const Color(0xFFD00000));
      expect(sampleTheme.searchSelectionColor, const Color(0xFFE00000));
    });

    test('copyWith preserves existing colors when arguments are null', () {
      final copy = sampleTheme.copyWith();
      expect(copy.controlPanelBackground, sampleTheme.controlPanelBackground);
      expect(copy.controlPanelForeground, sampleTheme.controlPanelForeground);
      expect(copy.infoLineBackground, sampleTheme.infoLineBackground);
      expect(copy.infoLineActiveFilterBackground, sampleTheme.infoLineActiveFilterBackground);
      expect(copy.infoLineActiveFilterForeground, sampleTheme.infoLineActiveFilterForeground);
      expect(copy.infoLineInactiveFilterBackground, sampleTheme.infoLineInactiveFilterBackground);
      expect(copy.infoLineInactiveFilterForeground, sampleTheme.infoLineInactiveFilterForeground);
      expect(copy.controlPanelActiveFilterBackground, sampleTheme.controlPanelActiveFilterBackground);
      expect(copy.controlPanelActiveFilterForeground, sampleTheme.controlPanelActiveFilterForeground);
      expect(copy.controlPanelInactiveFilterBackground, sampleTheme.controlPanelInactiveFilterBackground);
      expect(copy.controlPanelInactiveFilterForeground, sampleTheme.controlPanelInactiveFilterForeground);
      expect(copy.searchCursorColor, sampleTheme.searchCursorColor);
      expect(copy.searchHintColor, sampleTheme.searchHintColor);
      expect(copy.searchSelectionColor, sampleTheme.searchSelectionColor);
    });

    test('copyWith overrides specified colors', () {
      final updated = sampleTheme.copyWith(
        controlPanelBackground: const Color(0xFF001000),
        controlPanelForeground: const Color(0xFF002000),
        infoLineBackground: const Color(0xFF003000),
        infoLineActiveFilterBackground: const Color(0xFF004000),
        infoLineActiveFilterForeground: const Color(0xFF005000),
        infoLineInactiveFilterBackground: const Color(0xFF006000),
        infoLineInactiveFilterForeground: const Color(0xFF007000),
        controlPanelActiveFilterBackground: const Color(0xFF008000),
        controlPanelActiveFilterForeground: const Color(0xFF009000),
        controlPanelInactiveFilterBackground: const Color(0xFF00A000),
        controlPanelInactiveFilterForeground: const Color(0xFF00B000),
        searchCursorColor: const Color(0xFF00C000),
        searchHintColor: const Color(0xFF00D000),
        searchSelectionColor: const Color(0xFF00E000),
      );

      expect(updated.controlPanelBackground, const Color(0xFF001000));
      expect(updated.controlPanelForeground, const Color(0xFF002000));
      expect(updated.infoLineBackground, const Color(0xFF003000));
      expect(updated.infoLineActiveFilterBackground, const Color(0xFF004000));
      expect(updated.infoLineActiveFilterForeground, const Color(0xFF005000));
      expect(updated.infoLineInactiveFilterBackground, const Color(0xFF006000));
      expect(updated.infoLineInactiveFilterForeground, const Color(0xFF007000));
      expect(updated.controlPanelActiveFilterBackground, const Color(0xFF008000));
      expect(updated.controlPanelActiveFilterForeground, const Color(0xFF009000));
      expect(updated.controlPanelInactiveFilterBackground, const Color(0xFF00A000));
      expect(updated.controlPanelInactiveFilterForeground, const Color(0xFF00B000));
      expect(updated.searchCursorColor, const Color(0xFF00C000));
      expect(updated.searchHintColor, const Color(0xFF00D000));
      expect(updated.searchSelectionColor, const Color(0xFF00E000));
    });

    test('lerp returns this when other is null or incompatible', () {
      final lerpedNull = sampleTheme.lerp(null, 0.5);
      expect(identical(lerpedNull, sampleTheme), isTrue);
    });

    test('lerp interpolates between two TitleListTheme instances', () {
      const otherTheme = TitleListTheme(
        controlPanelBackground: Color(0xFFFFFFFF),
        controlPanelForeground: Color(0xFFFFFFFF),
        infoLineBackground: Color(0xFFFFFFFF),
        infoLineActiveFilterBackground: Color(0xFFFFFFFF),
        infoLineActiveFilterForeground: Color(0xFFFFFFFF),
        infoLineInactiveFilterBackground: Color(0xFFFFFFFF),
        infoLineInactiveFilterForeground: Color(0xFFFFFFFF),
        controlPanelActiveFilterBackground: Color(0xFFFFFFFF),
        controlPanelActiveFilterForeground: Color(0xFFFFFFFF),
        controlPanelInactiveFilterBackground: Color(0xFFFFFFFF),
        controlPanelInactiveFilterForeground: Color(0xFFFFFFFF),
        searchCursorColor: Color(0xFFFFFFFF),
        searchHintColor: Color(0xFFFFFFFF),
        searchSelectionColor: Color(0xFFFFFFFF),
      );

      final lerpedZero = sampleTheme.lerp(otherTheme, 0.0);
      expect(lerpedZero.controlPanelBackground, sampleTheme.controlPanelBackground);
      expect(lerpedZero.searchSelectionColor, sampleTheme.searchSelectionColor);

      final lerpedOne = sampleTheme.lerp(otherTheme, 1.0);
      expect(lerpedOne.controlPanelBackground, otherTheme.controlPanelBackground);
      expect(lerpedOne.searchSelectionColor, otherTheme.searchSelectionColor);

      final lerpedMid = sampleTheme.lerp(otherTheme, 0.5);
      expect(
        lerpedMid.controlPanelBackground,
        Color.lerp(sampleTheme.controlPanelBackground, otherTheme.controlPanelBackground, 0.5),
      );
      expect(
        lerpedMid.searchSelectionColor,
        Color.lerp(sampleTheme.searchSelectionColor, otherTheme.searchSelectionColor, 0.5),
      );
    });
  });
}
