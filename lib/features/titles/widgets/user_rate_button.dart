import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/app_constants.dart';

class UserRateButton extends StatelessWidget {
  final bool isUserLoggedIn;
  final double rating;
  final VoidCallback? onPressed;
  final double iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry padding;

  const UserRateButton({
    super.key,
    required this.isUserLoggedIn,
    required this.rating,
    this.onPressed,
    this.iconSize = AppSizes.iconXl,
    this.fontSize,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppSpacing.xs,
      horizontal: AppSpacing.sm,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final baseStyle = Theme.of(context).textTheme.titleLarge;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: !isUserLoggedIn
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.onSurfaceVariant,
          width: AppSizes.borderWidthThick,
        ),
        shape: const StadiumBorder(),
        padding: padding,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: !isUserLoggedIn ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: iconSize,
            color: !isUserLoggedIn
                ? Theme.of(context).disabledColor
                : customColors.userRatedTitle,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            rating > AppConstants.seenRating
                ? (rating == 10.0 ? '10' : rating.toStringAsFixed(1))
                : '-.-',
            style: baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: !isUserLoggedIn
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
