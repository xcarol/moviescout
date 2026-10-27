import 'package:flutter/foundation.dart';
import 'package:moviescout/models/user_profile.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/utils/app_constants.dart';

class UserFollowingService with ChangeNotifier {
  List<UserProfile> _followingUsers = [];
  final Set<String> _followingIds = {};
  bool _isLoading = false;
  String? _lastUserId = CloudDatabaseService.currentUser?.id;

  List<UserProfile> get followingUsers => _followingUsers;
  Set<String> get followingIds => _followingIds;
  bool get isLoading => _isLoading;

  bool isFollowing(String userId) => _followingIds.contains(userId);

  Future<void> fetchFollowingUsers({bool forceUpdate = false}) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) {
      _followingUsers = [];
      _followingIds.clear();
      notifyListeners();
      return;
    }

    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final followsResponse = await CloudDatabaseService.retryOnFutureJwt(
        () => CloudDatabaseService.instance
            .from('user_follows')
            .select('following_id')
            .eq('follower_id', user.id)
            .order('created_at', ascending: false),
      );

      final List<dynamic> rows = followsResponse as List<dynamic>;
      final List<String> followingIdsList = rows
          .map((row) => (row as Map<String, dynamic>)['following_id'] as String)
          .toList();

      _followingIds
        ..clear()
        ..addAll(followingIdsList);

      if (followingIdsList.isEmpty) {
        _followingUsers = [];
      } else {
        final profilesResponse = await CloudDatabaseService.retryOnFutureJwt(
          () => CloudDatabaseService.instance
              .from('profiles')
              .select('id, username, avatar_url, is_public, created_at')
              .inFilter('id', followingIdsList),
        );

        final profileMap = <String, UserProfile>{};
        for (final item in profilesResponse as List<dynamic>) {
          final profile = UserProfile.fromMap(item as Map<String, dynamic>);
          profileMap[profile.id] = profile;
        }

        _followingUsers = followingIdsList
            .where((id) => profileMap.containsKey(id))
            .map((id) => profileMap[id]!)
            .toList();
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error fetching following users',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> follow(UserProfile targetUser) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null || user.id == targetUser.id) return false;

    if (_followingIds.contains(targetUser.id)) return true;

    _followingIds.add(targetUser.id);
    _followingUsers.insert(0, targetUser);
    notifyListeners();

    try {
      await CloudDatabaseService.retryOnFutureJwt(
        () => CloudDatabaseService.instance.from('user_follows').insert({
          'follower_id': user.id,
          'following_id': targetUser.id,
        }),
      );
      return true;
    } catch (e, stackTrace) {
      _followingIds.remove(targetUser.id);
      _followingUsers.removeWhere((u) => u.id == targetUser.id);
      notifyListeners();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error following user',
        showSnackBar: true,
      );
      return false;
    }
  }

  Future<bool> unfollow(String targetUserId) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) return false;

    if (!_followingIds.contains(targetUserId)) return true;

    final removedIndex =
        _followingUsers.indexWhere((u) => u.id == targetUserId);
    final removedUser =
        removedIndex != -1 ? _followingUsers[removedIndex] : null;

    _followingIds.remove(targetUserId);
    if (removedIndex != -1) {
      _followingUsers.removeAt(removedIndex);
    }
    notifyListeners();

    try {
      await CloudDatabaseService.retryOnFutureJwt(
        () => CloudDatabaseService.instance
            .from('user_follows')
            .delete()
            .eq('follower_id', user.id)
            .eq('following_id', targetUserId),
      );
      return true;
    } catch (e, stackTrace) {
      _followingIds.add(targetUserId);
      if (removedUser != null) {
        _followingUsers.insert(removedIndex, removedUser);
      }
      notifyListeners();
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error unfollowing user',
        showSnackBar: true,
      );
      return false;
    }
  }

  Future<List<UserProfile>> searchUsers(String query) async {
    final term = query.trim();
    if (term.isEmpty) return [];

    try {
      final currentUser = CloudDatabaseService.currentUser;
      var filterBuilder = CloudDatabaseService.instance
          .from('profiles')
          .select('id, username, avatar_url, is_public, created_at')
          .ilike('username', '%$term%')
          .eq('is_public', true);

      if (currentUser != null) {
        filterBuilder = filterBuilder.neq('id', currentUser.id);
      }

      final response = await CloudDatabaseService.retryOnFutureJwt(
        () => filterBuilder.limit(20),
      );

      return (response as List<dynamic>)
          .map((row) => UserProfile.fromMap(row as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error searching users',
      );
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(
    String userId, {
    int ratedLimit = 5,
  }) async {
    int watchlistCount = 0;
    int rateslistCount = 0;
    List<TmdbTitle> pinnedTitles = [];
    List<TmdbTitle> latestRatedTitles = [];
    UserProfile? profile;

    try {
      final profileResponse = await CloudDatabaseService.retryOnFutureJwt(
        () => CloudDatabaseService.instance
            .from('profiles')
            .select('id, username, avatar_url, is_public, created_at')
            .eq('id', userId)
            .maybeSingle(),
      );

      if (profileResponse != null) {
        profile = UserProfile.fromMap(profileResponse);
      }

      final currentUser = CloudDatabaseService.currentUser;
      final isSelf = currentUser?.id == userId;
      final isAllowed = profile != null && (profile.isPublic || isSelf);

      if (!isAllowed) {
        return {
          'profile': profile,
          'watchlistCount': 0,
          'rateslistCount': 0,
          'pinnedTitles': <TmdbTitle>[],
          'latestRatedTitles': <TmdbTitle>[],
          'isPublic': false,
        };
      }

      final countsResponse = await Future.wait([
        CloudDatabaseService.retryOnFutureJwt(
          () => CloudDatabaseService.instance
              .from('user_titles')
              .count()
              .eq('user_id', userId)
              .eq('list_name', AppConstants.watchlist),
        ),
        CloudDatabaseService.retryOnFutureJwt(
          () => CloudDatabaseService.instance
              .from('user_titles')
              .count()
              .eq('user_id', userId)
              .eq('list_name', AppConstants.rateslist),
        ),
      ]);

      watchlistCount = countsResponse[0];
      rateslistCount = countsResponse[1];

      final titlesResponse = await Future.wait([
        CloudDatabaseService.retryOnFutureJwt(
          () => CloudDatabaseService.instance
              .from('user_titles')
              .select(
                  'tmdb_id, media_type, rating, is_pinned, name, poster_path, vote_average, rated_date, created_at')
              .eq('user_id', userId)
              .eq('list_name', AppConstants.watchlist)
              .eq('is_pinned', true)
              .order('created_at', ascending: false),
        ),
        CloudDatabaseService.retryOnFutureJwt(
          () => CloudDatabaseService.instance
              .from('user_titles')
              .select(
                  'tmdb_id, media_type, rating, is_pinned, name, poster_path, vote_average, rated_date, created_at')
              .eq('user_id', userId)
              .eq('list_name', AppConstants.rateslist)
              .order('rated_date', ascending: false)
              .limit(ratedLimit),
        ),
      ]);

      pinnedTitles = _mapUserTitles(titlesResponse[0] as List<dynamic>);
      latestRatedTitles = _mapUserTitles(titlesResponse[1] as List<dynamic>);
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error fetching user details for $userId',
      );
    }

    return {
      'profile': profile?.copyWith(
        watchlistCount: watchlistCount,
        rateslistCount: rateslistCount,
      ),
      'watchlistCount': watchlistCount,
      'rateslistCount': rateslistCount,
      'pinnedTitles': pinnedTitles,
      'latestRatedTitles': latestRatedTitles,
      'isPublic': profile?.isPublic ?? false,
    };
  }

  List<TmdbTitle> _mapUserTitles(List<dynamic> rows) {
    return rows.map((row) {
      final r = row as Map<String, dynamic>;
      final dateRated = r['rated_date'] != null
          ? DateTime.tryParse(r['rated_date'] as String) ??
              DateTime.parse(AppConstants.defaultDate)
          : DateTime.parse(AppConstants.defaultDate);
      final createdAt = r['created_at'] != null
          ? DateTime.tryParse(r['created_at'] as String)
          : null;

      return TmdbTitle(
        tmdbId: r['tmdb_id'] as int,
        mediaType: r['media_type'] as String,
        name: r['name'] as String? ?? '',
        posterPathSuffix: r['poster_path'] as String?,
        voteAverage: (r['vote_average'] as num?)?.toDouble() ?? 0.0,
        lastUpdated: AppConstants.defaultDate,
        dateRated: dateRated,
        createdAt: createdAt,
      )
        ..isPinned = r['is_pinned'] as bool? ?? false
        ..rating = (r['rating'] as num?)?.toDouble() ?? 0.0;
    }).toList();
  }

  void updateAuth(SupabaseAuthService authService) {
    final user = authService.currentUser;
    if (user != null && _lastUserId != user.id) {
      _lastUserId = user.id;
      fetchFollowingUsers(forceUpdate: true);
    } else if (user == null && _lastUserId != null) {
      _lastUserId = null;
      _followingUsers = [];
      _followingIds.clear();
      notifyListeners();
    }
  }
}
