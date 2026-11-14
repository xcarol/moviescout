import 'package:flutter/material.dart';

class UiUtils {
  static const double minTextScale = 1.0;
  static const double maxTextScale = 1.3;

  static double scaleFactor(
      BuildContext context, double fontSize, double min, double max) {
    return MediaQuery.textScalerOf(context).scale(fontSize).clamp(min, max);
  }

  static double clampedTextScale(
    BuildContext context, {
    double min = minTextScale,
    double max = maxTextScale,
  }) {
    return scaleFactor(context, 1.0, min, max);
  }
}
