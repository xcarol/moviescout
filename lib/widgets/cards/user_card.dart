import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/models/user_profile.dart';
import 'package:moviescout/screens/user_details.dart';

class UserCard extends StatelessWidget {
  final UserProfile user;

  static double cardHeight = 120.0;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: cardHeight,
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetails(user: user),
                ),
              );
            },
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
        child: (avatarUrl != null && avatarUrl.isNotEmpty)
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholder: (context, url) => Icon(
                    Icons.person,
                    size: 36,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 36,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : Icon(
                Icons.person,
                size: 36,
                color: colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }

  Widget _details(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.username.isNotEmpty ? user.username : 'Anonymous',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
