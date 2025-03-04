import 'package:flutter/foundation.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  Map? user;

  Future<void> login() async {}

  Future<void> logout() async {}
}
