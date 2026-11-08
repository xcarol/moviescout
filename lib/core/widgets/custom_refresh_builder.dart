import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

Widget customRefreshBuilder(
  BuildContext context,
  Widget child,
  IndicatorController controller,
) {
  return Stack(
    children: [
      child,
      if (!controller.side.isNone)
        Positioned(
          top: -40.0 + (80.0 * controller.value),
          left: 0,
          right: 0,
          child: Center(
            child: RefreshProgressIndicator(
              value: controller.isLoading || controller.isFinalizing
                  ? null
                  : controller.value.clamp(0.0, 1.0),
            ),
          ),
        ),
    ],
  );
}
