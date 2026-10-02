import 'package:flutter/foundation.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/error_service.dart';

class FollowingService with ChangeNotifier {
  final LocalTitleRepository repository;
  final CloudTitleRepository _cloudRepository;

  FollowingService(this.repository, {CloudTitleRepository? cloudRepository})
      : _cloudRepository = cloudRepository ?? CloudTitleRepository();

  void clearFollowingStatus() {
    notifyListeners();
  }

  Future<bool> addFollowingToServer(TmdbTitle title) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) return false;

    try {
      return await _cloudRepository.updateNotification(
        userId: user.id,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
        notifyNewSeasons: true,
      );
    } catch (e, stackTrace) {
      ErrorService.log(e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> removeFollowingFromServer(TmdbTitle title) async {
    final user = CloudDatabaseService.currentUser;
    if (user == null) return false;

    try {
      return await _cloudRepository.updateNotification(
        userId: user.id,
        tmdbId: title.tmdbId,
        mediaType: title.mediaType,
        notifyNewSeasons: false,
      );
    } catch (e, stackTrace) {
      ErrorService.log(e, stackTrace: stackTrace);
      return false;
    }
  }
}
