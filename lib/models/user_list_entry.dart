import 'package:isar_community/isar.dart';

part 'user_list_entry.g.dart';

@collection
class UserListEntry {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('tmdbId')], unique: true, replace: true)
  late String listName;

  late int tmdbId;

  @Index()
  late int addedOrder;

  UserListEntry({
    required this.listName,
    required this.tmdbId,
    required this.addedOrder,
  });
}
