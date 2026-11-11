import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/features/auth/models/user_profile.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/core/services/cloud_database_service.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:moviescout/features/watchlist/widgets/user_title_chip.dart';
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
  bool _isPublic = true;
  List<TmdbTitle> _pinnedTitles = [];
  List<TmdbTitle> _latestRatedTitles = [];

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _isPublic = widget.user.isPublic;
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
        _isPublic = (data['isPublic'] as bool?) ?? _user.isPublic;
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.bottomSafeMargin),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileHeader(context, isCurrentUser),
                Divider(color: customColors.dividerColor),
                if (!isCurrentUser && !_isPublic)
                  _privateProfileNotice(context)
                else ...[
                  _pinnedSection(context),
                  Divider(color: customColors.dividerColor),
                  _ratedSection(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privateProfileNotice(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AppEmptyState(
      icon: Icons.lock_outline,
      message: loc.privateProfileMessage,
    );
  }

  Widget _profileHeader(BuildContext context, bool isCurrentUser) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: AppSizes.userProfileAvatarRadius,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: ClipOval(
                child: AppCachedImage(
                  imageUrl: _user.avatarUrl,
                  width: AppSizes.userProfileAvatarSize,
                  height: AppSizes.userProfileAvatarSize,
                  type: AppImageType.avatar,
                  fallbackIconSize: AppSizes.userProfileAvatarRadius,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _user.username.isNotEmpty ? _user.username : 'Anonymous',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (isCurrentUser || _isPublic) ...[
            const SizedBox(height: AppSpacing.md),
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
          ],
          if (!isCurrentUser) ...[
            const SizedBox(height: AppSpacing.md),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: AppOpacity.half),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.iconSubtle, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$count',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.micro),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          width: AppSizes.followButtonWidth,
          child: FilledButton.icon(
            onPressed: () async {
              final authService =
                  Provider.of<SupabaseAuthService>(context, listen: false);
              if (!authService.isLoggedIn) {
                context.toLogin();
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
              size: AppSizes.iconSubtle,
            ),
            label: Text(
              isFollowing ? loc.following : loc.follow,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                Icons.push_pin,
                size: AppSizes.iconSubtle,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                loc.watchingNow,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_pinnedTitles.isEmpty)
          Padding(
            padding: AppSpacing.screenPadding,
            child: Center(
              child: Text(
                loc.noWatchingNowTitles,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          )
        else
          SizedBox(
            height: AppSizes.chipCarouselHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
        const SizedBox(height: AppSpacing.xs),
      ],
    );
  }

  Widget _ratedSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: AppSizes.iconSubtle,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                loc.latestRatedTitles,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_latestRatedTitles.isEmpty)
          Padding(
            padding: AppSpacing.screenPadding,
            child: Center(
              child: Text(
                loc.noRatedTitles,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          )
        else
          SizedBox(
            height: AppSizes.chipCarouselHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
