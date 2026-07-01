import 'package:flutter/widgets.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:math' as math;

class BottomClampingScrollPhysics extends ScrollPhysics {
  final IndicatorController? topRefreshController;

  const BottomClampingScrollPhysics({super.parent, this.topRefreshController});

  @override
  BottomClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BottomClampingScrollPhysics(
      parent: buildParent(ancestor),
      topRefreshController: topRefreshController,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (topRefreshController != null && topRefreshController!.value > 0.0) {
      final double multiplier = math.exp(-topRefreshController!.value);
      return super.applyPhysicsToUserOffset(position, offset * multiplier);
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              '$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.',
          ),
        ]);
      }
      return true;
    }());

    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Overscroll at bottom. Clamp it.
      return value - position.pixels;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge. Clamp it.
      return value - position.maxScrollExtent;
    }
    return super.applyBoundaryConditions(position, value);
  }
}
