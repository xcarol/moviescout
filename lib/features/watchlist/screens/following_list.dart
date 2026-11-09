import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/custom_refresh_builder.dart';
import 'package:moviescout/features/auth/screens/user_search_delegate.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/auth/widgets/user_card.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget content;

    if (isNotLoggedIn) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppEmptyState(
            icon: Icons.people_outline,
            message: loc.emptyFollowingList,
            subtitle: loc.messageEmptyOptions,
            action: OutlinedButton(
              onPressed: () {
                context.toLogin();
              },
              child: Text(loc.messageEmptyLogin),
            ),
          ),
          Text(
            loc.emptyFollowingCommunityHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    } else {
      final authService = Provider.of<SupabaseAuthService>(context);
      if (!authService.isPublicProfile) {
        content = _publicProfileBanner(context);
      } else {
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(
              icon: Icons.people_alt_outlined,
              message: loc.emptyFollowingList,
              subtitle: loc.emptyFollowingSearchHint,
              action: FilledButton.icon(
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
            ),
            _shareAppBox(context),
          ],
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
                maxWidth: AppBreakpoints.maxFormWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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

    final listView = LayoutBuilder(
      builder: (context, constraints) {
        final isGrid = constraints.maxWidth >= AppBreakpoints.compact;
        if (isGrid) {
          return GridView.builder(
            padding: AppSpacing.screenPadding,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: AppBreakpoints.maxGridCardExtent,
              mainAxisExtent: UserCard.cardHeight,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) => UserCard(user: users[index]),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Column(
              children: [
                UserCard(user: user),
                Divider(
                  height: AppSizes.borderWidthRegular,
                  color: customColors.dividerColor,
                ),
              ],
            );
          },
        );
      },
    );

    return CustomRefreshIndicator(
      onRefresh: () async {
        await _followingService.fetchFollowingUsers(forceUpdate: true);
      },
      builder: customRefreshBuilder,
      child: listView,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.public,
                color: colorScheme.onSurface,
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  loc.publicProfileTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            loc.enablePublicProfileBanner,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: () async {
                await authService.setPublicProfile(true);
              },
              child: Text(loc.enablePublicProfileButton),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            loc.emptyFollowingCommunityHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _shareAppBox(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.shareAppCommunityPrompt,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Builder(
              builder: (btnContext) => FilledButton.tonalIcon(
                onPressed: () => _shareApp(btnContext),
                icon: const Icon(Icons.share, size: AppSizes.iconSm),
                label: Text(loc.shareAppButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
