import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/theme/app_breakpoints.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/auth/screens/user_search_delegate.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/features/auth/widgets/user_card.dart';
import 'package:moviescout/core/widgets/custom_refresh_builder.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late Future<void> _init;
  late UserFollowingService _followingService;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  Future<void> _loadData() async {
    _followingService =
        Provider.of<UserFollowingService>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _followingService.fetchFollowingUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        return body();
      },
    );
  }

  Widget body() {
    final authService = Provider.of<SupabaseAuthService>(context);

    if (!authService.isLoggedIn) {
      return emptyBody(isNotLoggedIn: true);
    }

    if (!authService.isPublicProfile) {
      return emptyBody(isNotLoggedIn: false);
    }

    return Consumer<UserFollowingService>(
      builder: (context, followingService, _) {
        if (followingService.isLoading &&
            followingService.followingUsers.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        if (followingService.followingUsers.isEmpty) {
          return emptyBody(isNotLoggedIn: false);
        }

        return followingBody(followingService);
      },
    );
  }

  Widget emptyBody({required bool isNotLoggedIn}) {
    final loc = AppLocalizations.of(context)!;

    Widget content;

    if (isNotLoggedIn) {
      content = AppEmptyState(
        icon: Icons.people_outline,
        title: loc.emptyFollowingList,
        message: loc.messageEmptyOptions,
        customAction: Column(
          children: [
            OutlinedButton(
              onPressed: () => context.toLogin(),
              child: Text(loc.messageEmptyLogin),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              loc.emptyFollowingCommunityHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    } else {
      final authService = Provider.of<SupabaseAuthService>(context);
      if (!authService.isPublicProfile) {
        content = _publicProfileBanner(context);
      } else {
        content = AppEmptyState(
          icon: Icons.people_alt_outlined,
          title: loc.emptyFollowingList,
          message: loc.emptyFollowingSearchHint,
          customAction: Column(
            children: [
              FilledButton.icon(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: UserSearchDelegate(
                      _followingService,
                      searchFieldLabel: loc.searchUsersPlaceholder,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: Text(loc.searchUsers),
              ),
              const SizedBox(height: AppSpacing.md),
              _shareAppBox(context),
            ],
          ),
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget followingBody(UserFollowingService followingService) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final users = followingService.followingUsers;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth > AppBreakpoints.largeScreenMinWidth;
        final Widget listWidget;

        if (isWide) {
          listWidget = GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.lg,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: AppBreakpoints.maxGridCrossAxisExtent,
              mainAxisExtent: UserCard.cardHeight,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(user: user);
            },
          );
        } else {
          listWidget = ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Column(
                children: [
                  UserCard(user: user),
                  Divider(
                    height: 1,
                    color: customColors.dividerColor,
                  ),
                ],
              );
            },
          );
        }

        return CustomRefreshIndicator(
          onRefresh: () async {
            await _followingService.fetchFollowingUsers(forceUpdate: true);
          },
          builder: customRefreshBuilder,
          child: listWidget,
        );
      },
    );
  }

  Future<void> _shareApp(BuildContext buttonContext) async {
    try {
      final loc = AppLocalizations.of(context)!;
      final box = buttonContext.findRenderObject() as RenderBox?;
      final origin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      final shareText = '${loc.shareAppMessage}\n\n'
          '${UrlConstants.moviescoutWebUrl}\n\n'
          '${loc.shareAppGooglePlay}\n'
          '${UrlConstants.googlePlayUrl}';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'MovieScout',
          sharePositionOrigin: origin,
        ),
      );
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error sharing app',
      );
    }
  }

  Widget _publicProfileBanner(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.public, color: colorScheme.onSurface, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loc.publicProfileTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            loc.enablePublicProfileBanner,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: () async {
                await authService.setPublicProfile(true);
              },
              child: Text(loc.enablePublicProfileButton),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.emptyFollowingCommunityHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareAppBox(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.shareAppCommunityPrompt,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Builder(
              builder: (btnContext) => FilledButton.tonalIcon(
                onPressed: () => _shareApp(btnContext),
                icon: const Icon(Icons.share, size: 18),
                label: Text(loc.shareAppButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
