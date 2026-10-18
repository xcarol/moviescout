class TitleComment {
  final String id;
  final String userId;
  final String? username;
  final int tmdbId;
  final String mediaType;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  TitleComment({
    required this.id,
    required this.userId,
    this.username,
    required this.tmdbId,
    required this.mediaType,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TitleComment.fromMap(Map<String, dynamic> map) {
    String? username;
    final profile = map['profiles'];
    if (profile is Map<String, dynamic>) {
      username = profile['username'] as String?;
    } else if (map['username'] is String) {
      username = map['username'] as String;
    }

    return TitleComment(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      username: username,
      tmdbId: (map['tmdb_id'] as num?)?.toInt() ?? 0,
      mediaType: map['media_type']?.toString() ?? '',
      comment: map['comment']?.toString() ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'tmdb_id': tmdbId,
      'media_type': mediaType,
      'comment': comment,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  TitleComment copyWith({
    String? id,
    String? userId,
    String? username,
    int? tmdbId,
    String? mediaType,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TitleComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      tmdbId: tmdbId ?? this.tmdbId,
      mediaType: mediaType ?? this.mediaType,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
