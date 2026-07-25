import 'package:flutter/material.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/utils/app_constants.dart';

class UserRateButton extends StatelessWidget {
  final bool isUserLoggedIn;
  final double rating;
  final VoidCallback? onPressed;
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const UserRateButton({
    super.key,
    required this.isUserLoggedIn,
    required this.rating,
    this.onPressed,
    this.iconSize = 32,
    this.fontSize = 22,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: !isUserLoggedIn
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.onSurfaceVariant,
          width: 2,
        ),
        shape: const StadiumBorder(),
        padding: padding,
        minimumSize: const Size(0, 0),
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
          const SizedBox(width: 8),
          Text(
            rating > AppConstants.seenRating
                ? (rating == 10.0 ? '10' : rating.toStringAsFixed(1))
                : '-.-',
            style: TextStyle(
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
