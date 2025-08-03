import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/tmdb_title.dart'; // adapta el path si cal

class IsarService {
  static late final Isar _isar;

  /// Inicialitza la base de dades Isar amb els esquemes necessaris
  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    _isar = await Isar.open(
      [TmdbTitleSchema],
      directory: dir.path,
      inspector: true, // Pots posar false si no vols el debugger
    );
  }

  /// Retorna la instància singleton de Isar
  static Isar get instance => _isar;

  /// Tanca la connexió amb la base de dades
  static Future<void> close() async {
    await _isar.close();
  }
}
