import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';

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
          top: AppSizes.refreshIndicatorBaseOffset +
              (AppSizes.refreshIndicatorDragRange * controller.value),
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
