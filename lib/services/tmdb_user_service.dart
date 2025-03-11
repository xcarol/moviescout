import 'package:flutter/foundation.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  String sessionId = '';
  int get accountId => user?['id'] ?? 0;
  Map? user;
  bool get isUserLoggedIn => sessionId.isNotEmpty;

  Future<void> setup() async {
    sessionId = PreferencesService().prefs.getString('sessionId') ?? '';
    if (sessionId.isNotEmpty) {
      user = await getUserDetails();
    }
  }

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

  Future<dynamic> getUserDetails() async {
    final response = await get('/account');
    return response;
  }

  Future<bool> login(String username, String password) async {
    final requestToken = await getRequestToken();

    final isValid = await validateWithLogin(username, password, requestToken);
    if (isValid) {
      final newSessionId = await createSession(requestToken);
      sessionId = newSessionId;
      PreferencesService().prefs.setString('sessionId', sessionId);
      user = await getUserDetails();
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await delete('/authentication/session', {'session_id': sessionId});
    sessionId = '';
    user = null;
    PreferencesService().prefs.remove('sessionId');
    notifyListeners();
  }
}
