import 'package:flutter/material.dart';

class UiUtils {
  static double scaleFactor(
      BuildContext context, double fontSize, double min, double max) {
    return MediaQuery.of(context).textScaler.scale(fontSize).clamp(min, max);
  }
}
