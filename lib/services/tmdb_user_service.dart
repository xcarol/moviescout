import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  final String redirectTo = 'moviescout://auth/callback';

  String _accountId = '';
  String _sessionId = '';
  String? _requestToken;
  Map? user;

  bool get isUserLoggedIn => accessToken.isNotEmpty;
  String get accountId => _accountId;

  Future<void> setup() async {
    accessToken = PreferencesService().prefs.getString('accessToken') ?? '';
    if (accessToken.isNotEmpty) {
      _accountId = PreferencesService().prefs.getString('accountId') ?? '';
      _sessionId = PreferencesService().prefs.getString('sessionId') ?? '';
      if (_accountId.isNotEmpty) {
        user = await _getUserDetails();
      }
    }
  }

  Future<Map> completeLogin() async {
    if (_requestToken != null) {
      int status = await _exchangeToken(_requestToken!);
      if (status != 200) {
        return {
          'success': false,
          'message': 'Error $status in completeLogin with token $_requestToken',
        };
      }
      status = await _getSession();
      if (status != 200) {
        return {
          'success': false,
          'message': 'Error $status in completeLogin with token $_requestToken',
        };
      }
      user = await _getUserDetails();
      notifyListeners();
      return {'success': true};
    }

    return {
      'success': false,
      'message': 'Error: _requestToken is null',
    };
  }

  Future<int> _getSession() async {
    String accessToken =
        PreferencesService().prefs.getString('accessToken') ?? '';

    final response = await post(
      '/authentication/session/convert/4',
      {'access_token': accessToken},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _sessionId = json['session_id'];
      PreferencesService().prefs.setString('sessionId', _sessionId);
    }

    return response.statusCode;
  }

  Future<int> _exchangeToken(String requestToken) async {
    final response = await post(
        '/auth/access_token', {'request_token': requestToken},
        version: ApiVersion.v4);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      accessToken = json['access_token'];
      _accountId = json['account_id'];
      PreferencesService().prefs.setString('accessToken', accessToken);
      PreferencesService().prefs.setString('accountId', _accountId);
    }

    return response.statusCode;
  }

  Future<Map> _startLogin() async {
    final response = await post(
      '/auth/request_token',
      {'redirect_to': redirectTo},
      version: ApiVersion.v4,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _requestToken = json['request_token'];

      final authUrl =
          'https://www.themoviedb.org/auth/access?request_token=$_requestToken';

      try {
        await launchUrl(
          Uri.parse(authUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        return {
          'success': false,
          'message': 'Error launching URL: $e',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Error ${response.statusCode} in _startLogin',
      };
    }

    return {
      'success': true,
    };
  }

  Future<dynamic> _getUserDetails() async {
    final response = await get('/account/$_accountId?session_id=$_sessionId');
    if (response.statusCode == 200) {
      return body(response);
    }
  }

  Future<Map> login() async {
    return _startLogin();
  }

  Future<void> logout() async {
    accessToken = '';
    _accountId = '';
    user = null;
    PreferencesService().prefs.remove('accessToken');
    PreferencesService().prefs.remove('accountId');
    PreferencesService().prefs.remove('sessionId');
    notifyListeners();
  }
}
