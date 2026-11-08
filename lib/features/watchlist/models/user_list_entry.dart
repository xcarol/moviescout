class UserListEntry {
  late String listName;

  late int tmdbId;
  late String mediaType;

  late DateTime createdAt;

  UserListEntry({
    required this.listName,
    required this.tmdbId,
    required this.mediaType,
    required this.createdAt,
  });
}
