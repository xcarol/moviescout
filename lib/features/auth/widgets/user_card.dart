import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/auth/models/user_profile.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/widgets/app_poster_image.dart';

class UserCard extends StatelessWidget {
  final UserProfile user;

  static double cardHeight = 120.0;

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
              opacity: isPrivate ? 0.6 : 1.0,
              child: Row(
                children: [
                  _avatar(context),
                  const SizedBox(width: 12),
                  _details(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    final avatarUrl = user.avatarUrl;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircleAvatar(
        radius: 36,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: ClipOval(
          child: AppPosterImage(
            imageUrl: avatarUrl,
            fallbackType: PosterFallbackType.user,
            aspectRatio: 1.0,
            fit: BoxFit.cover,
            fallbackFit: BoxFit.cover,
            memCacheWidth: 144,
            memCacheHeight: 144,
          ),
        ),
      ),
    );
  }

  Widget _details(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final isPrivate = !user.isPublic;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.username.isNotEmpty ? user.username : 'Anonymous',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isPrivate) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    loc.settingsProfilePrivate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
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
