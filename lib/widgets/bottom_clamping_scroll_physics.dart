import 'package:flutter/widgets.dart';

class BottomClampingScrollPhysics extends ScrollPhysics {
  const BottomClampingScrollPhysics({super.parent});

  @override
  BottomClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BottomClampingScrollPhysics(parent: buildParent(ancestor));
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
          // DiagnosticsProperty<ScrollPhysics>('The physics object in question was', this,
          //     style: DiagnosticsTreeStyle.errorProperty),
          // DiagnosticsProperty<ScrollMetrics>('The position object in question was', position,
          //     style: DiagnosticsTreeStyle.errorProperty),
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
