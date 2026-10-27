import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/screens/login.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/services/lists/user_following_service.dart';
import 'package:moviescout/widgets/cards/user_card.dart';
import 'package:moviescout/widgets/layout/custom_refresh_builder.dart';
import 'package:provider/provider.dart';

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
        return CustomRefreshIndicator(
          onRefresh: () async {
            await _followingService.fetchFollowingUsers(forceUpdate: true);
          },
          builder: customRefreshBuilder,
          child: body(),
        );
      },
    );
  }

  Widget body() {
    final authService = Provider.of<SupabaseAuthService>(context);

    if (!authService.isLoggedIn) {
      return emptyBody(isNotLoggedIn: true);
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
    final colorScheme = Theme.of(context).colorScheme;

    List<Widget> children = [];

    if (isNotLoggedIn) {
      children.addAll([
        Icon(
          Icons.people_outline,
          size: 64,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text(
          loc.emptyFollowingList,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          loc.messageEmptyOptions,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: Text(loc.messageEmptyLogin),
        ),
        Text(
          loc.emptyFollowingCommunityHint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ]);
    } else {
      final authService = Provider.of<SupabaseAuthService>(context);
      if (authService.isLoggedIn && !authService.isPublicProfile) {
        children.addAll([
          _publicProfileBanner(context),
          const SizedBox(height: 16),
        ]);
      }

      children.addAll([
        Icon(
          Icons.people_alt_outlined,
          size: 64,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text(
          loc.emptyFollowingList,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          loc.emptyFollowingSearchHint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        if (authService.isLoggedIn && !authService.isPublicProfile)
          Text(
            loc.emptyFollowingCommunityHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
      ]);
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget followingBody(UserFollowingService followingService) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final authService = Provider.of<SupabaseAuthService>(context);
    final users = followingService.followingUsers;
    final showBanner = authService.isLoggedIn && !authService.isPublicProfile;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: users.length + (showBanner ? 1 : 0),
      itemBuilder: (context, index) {
        if (showBanner && index == 0) {
          return _publicProfileBanner(context);
        }
        final user = users[showBanner ? index - 1 : index];
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
              Icon(Icons.public, color: colorScheme.primary, size: 22),
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
        ],
      ),
    );
  }
}
