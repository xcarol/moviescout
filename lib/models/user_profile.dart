import 'package:moviescout/models/tmdb_item.dart';

class UserProfile implements TmdbItem {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? email;
  final int watchlistCount;
  final int rateslistCount;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.email,
    this.watchlistCount = 0,
    this.rateslistCount = 0,
    this.createdAt,
  });

  @override
  int get tmdbId => id.hashCode;

  @override
  String get name => username;

  @override
  String get lastUpdated => '';

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? '',
      username: map['username'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      email: map['email'] as String?,
      watchlistCount: (map['watchlist_count'] as num?)?.toInt() ?? 0,
      rateslistCount: (map['rateslist_count'] as num?)?.toInt() ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'email': email,
      'watchlist_count': watchlistCount,
      'rateslist_count': rateslistCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? email,
    int? watchlistCount,
    int? rateslistCount,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      watchlistCount: watchlistCount ?? this.watchlistCount,
      rateslistCount: rateslistCount ?? this.rateslistCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
