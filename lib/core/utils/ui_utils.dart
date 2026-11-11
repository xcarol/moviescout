import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

class UiUtils {
  static double scaleFactor(
    BuildContext context, [
    double fontSize = AppSizes.textScaleMin,
    double min = AppSizes.textScaleMin,
    double max = AppSizes.textScaleMax,
  ]) {
    return MediaQuery.of(context).textScaler.scale(fontSize).clamp(min, max);
  }

  static TextScaler clampedTextScaler(BuildContext context) {
    return TextScaler.linear(scaleFactor(context));
  }
}
