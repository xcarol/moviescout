class UserListEntry {
  late String listName;

  late int tmdbId;
  late String mediaType;

  late int addedOrder;

  UserListEntry({
    required this.listName,
    required this.tmdbId,
    required this.mediaType,
    required this.addedOrder,
  });
}
