import 'package:flutter/widgets.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await IsarService.init();
  final repo = TmdbTitleRepository();
  final titles = await repo.getTitles(listName: AppConstants.watchlist, limit: 100);
  for (var t in titles) {
    print('${t.name}: "${t.status}" (isSerie: ${t.isSerie})');
  }
}
