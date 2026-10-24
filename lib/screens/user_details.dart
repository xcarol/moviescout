import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/models/user_profile.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/lists/user_following_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/widgets/chips/user_title_chip.dart';
import 'package:moviescout/widgets/chips/title_chip.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  final UserProfile user;

  const UserDetails({
    super.key,
    required this.user,
  });

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late UserProfile _user;
  bool _isLoading = true;
  List<TmdbTitle> _pinnedTitles = [];
  List<TmdbTitle> _latestRatedTitles = [];

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final followingService =
        Provider.of<UserFollowingService>(context, listen: false);
    final data = await followingService.fetchUserDetails(_user.id);

    if (mounted) {
      setState(() {
        if (data['profile'] is UserProfile) {
          _user = data['profile'] as UserProfile;
        }
        _pinnedTitles = (data['pinnedTitles'] as List<TmdbTitle>?) ?? [];
        _latestRatedTitles =
            (data['latestRatedTitles'] as List<TmdbTitle>?) ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final isCurrentUser = CloudDatabaseService.currentUser?.id == _user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _user.username.isNotEmpty ? _user.username : 'User',
          style: TextStyle(color: customColors.appBarText),
        ),
        backgroundColor: customColors.appBarBackground,
        iconTheme: IconThemeData(color: customColors.appBarText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileHeader(context, isCurrentUser),
            Divider(color: customColors.dividerColor),
            if (_pinnedTitles.isNotEmpty) ...[
              _pinnedSection(context),
              Divider(color: customColors.dividerColor),
            ],
            _ratedSection(context),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, bool isCurrentUser) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final email = _user.email;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 46,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: (_user.avatarUrl != null && _user.avatarUrl!.isNotEmpty)
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _user.avatarUrl!,
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholder: (context, url) => Icon(
                          Icons.person,
                          size: 46,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 46,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 46,
                      color: colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _user.username.isNotEmpty ? _user.username : 'Anonymous',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (email != null && email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _countBadge(
                context,
                icon: Icons.remove_red_eye,
                count: _user.watchlistCount,
                label: loc.watchlistTitle,
              ),
              _countBadge(
                context,
                icon: Icons.rate_review,
                count: _user.rateslistCount,
                label: loc.rateslistTitle,
              ),
            ],
          ),
          if (!isCurrentUser) ...[
            const SizedBox(height: 16),
            _followButton(context),
          ],
        ],
      ),
    );
  }

  Widget _countBadge(
    BuildContext context, {
    required IconData icon,
    required int count,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _followButton(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Consumer<UserFollowingService>(
      builder: (context, followingService, _) {
        final isFollowing = followingService.isFollowing(_user.id);

        return SizedBox(
          width: 180,
          child: ElevatedButton.icon(
            onPressed: () async {
              final authService =
                  Provider.of<SupabaseAuthService>(context, listen: false);
              if (!authService.isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
                return;
              }

              if (isFollowing) {
                await followingService.unfollow(_user.id);
              } else {
                await followingService.follow(_user);
              }
            },
            icon: Icon(
              isFollowing ? Icons.check : Icons.person_add,
              size: 18,
            ),
            label: Text(
              isFollowing ? loc.following : loc.follow,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.primary,
              foregroundColor: isFollowing
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget _pinnedSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.push_pin,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                loc.watchingNow,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: CARD_HEIGHT + 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: _pinnedTitles.length,
            itemBuilder: (context, index) {
              final watchlistService =
                  Provider.of<WatchlistService>(context, listen: false);
              return UserTitleChip(
                title: _pinnedTitles[index],
                tmdbListService: watchlistService,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _ratedSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                loc.latestRatedTitles,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_latestRatedTitles.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                loc.messageEmptyList,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: CARD_HEIGHT + 10,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _latestRatedTitles.length,
              itemBuilder: (context, index) {
                final watchlistService =
                    Provider.of<WatchlistService>(context, listen: false);
                final title = _latestRatedTitles[index];
                return UserTitleChip(
                  title: title,
                  tmdbListService: watchlistService,
                  userRating: title.rating,
                );
              },
            ),
          ),
      ],
    );
  }
}
