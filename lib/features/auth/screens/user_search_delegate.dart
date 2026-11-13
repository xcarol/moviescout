import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/theme/custom_colors.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/app_error_view.dart';
import 'package:moviescout/features/auth/models/user_profile.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import 'package:moviescout/features/auth/widgets/user_card.dart';

class UserSearchDelegate extends SearchDelegate<UserProfile?> {
  final UserFollowingService followingService;

  UserSearchDelegate(this.followingService, {super.searchFieldLabel});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>();
    final appBarBg = customColors?.appBarBackground ??
        theme.appBarTheme.backgroundColor ??
        theme.colorScheme.surface;
    final appBarFg = customColors?.appBarText ??
        theme.appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: appBarBg,
        foregroundColor: appBarFg,
        iconTheme: IconThemeData(color: appBarFg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: appBarFg.withValues(alpha: 0.7),
        ),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return _buildEmptyPrompt(context);
    }
    return _buildResultsOrSuggestions(context);
  }

  Widget _buildEmptyPrompt(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            loc.searchUsersPlaceholder,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsOrSuggestions(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>();
    final dividerColor =
        customColors?.dividerColor ?? Theme.of(context).dividerColor;
    final trimmedQuery = query.trim();

    return FutureBuilder<List<UserProfile>>(
      future: followingService.searchUsers(trimmedQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: AppErrorView(
              imageAsset: 'assets/error-network.png',
              title: loc.errorMessageGeneric,
              message: loc.networkErrorMessage,
            ),
          );
        }

        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return Center(
            child: AppEmptyState(
              imageAsset: 'assets/empty-community.png',
              title: loc.noUsersFound,
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Column(
              children: [
                UserCard(user: user),
                Divider(
                  height: 1,
                  color: dividerColor,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
