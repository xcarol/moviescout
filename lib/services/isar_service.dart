import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/tmdb_title.dart';

class IsarService {
  static late final Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    _isar = await Isar.open(
      [TmdbTitleSchema],
      directory: dir.path,
      inspector: kDebugMode,
    );
  }

  static Isar get instance => _isar;

  static Future<void> close() async {
    await _isar.close();
  }
}
