import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/auth/models/user_profile.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class UserCard extends StatelessWidget {
  final UserProfile user;

  static double cardHeight = AppSizes.userCardHeight;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isPrivate = !user.isPublic;

    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              context.toUserDetails(user);
            },
            child: Opacity(
              opacity: isPrivate ? AppOpacity.disabled : AppOpacity.opaque,
              child: Row(
                children: [
                  _avatar(),
                  const SizedBox(width: AppSpacing.sm),
                  _details(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: AppCachedImage(
        imageUrl: user.avatarUrl,
        type: AppImageType.avatar,
        width: AppSizes.userCardAvatarSize,
        height: AppSizes.userCardAvatarSize,
        isCircular: true,
        fallbackIconSize: AppSizes.iconXl,
      ),
    );
  }

  Widget _details(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    final isPrivate = !user.isPublic;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.username.isNotEmpty ? user.username : loc.anonymousUser,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isPrivate) ...[
              const SizedBox(height: AppSpacing.xxs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: AppSizes.iconXs,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    loc.settingsProfilePrivate,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
