import 'package:flutter/foundation.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  String sessionId = '';
  Map? user;
  bool get isUserLoggedIn => sessionId.isNotEmpty;

  Future<dynamic> getRequestToken() async {
    final response = await get('authentication/token/new');
    return response['request_token'];
  }

  Future<bool> validateWithLogin(
    String username,
    String password,
    String requestToken,
  ) async {
    final response = await post('/authentication/token/validate_with_login', {
      'username': username,
      'password': password,
      'request_token': requestToken,
    });
    return response['success'];
  }

  Future<String> createSession(String requestToken) async {
    final response = await post(
        '/authentication/session/new', {'request_token': requestToken});
    return response['session_id'];
  }

  Future<bool> login(String username, String password) async {
    final requestToken = await getRequestToken();

    final isValid = await validateWithLogin(username, password, requestToken);
    if (isValid) {
      final sessionId = await createSession(requestToken);
      this.sessionId = sessionId;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await delete('/authentication/session', {'session_id': sessionId});
    sessionId = '';
    notifyListeners();
  }
}
