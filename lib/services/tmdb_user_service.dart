import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  String accountId = '';
  Map? user;
  bool get isUserLoggedIn => accessToken.isNotEmpty;
  String? _requestToken;
  final String redirectTo = 'moviescout://auth/callback';

  Future<void> setup() async {
    accessToken = PreferencesService().prefs.getString('accessToken') ?? '';
    if (accessToken.isNotEmpty) {
      accountId = PreferencesService().prefs.getString('accountId') ?? '';
      if (accountId.isNotEmpty) {
        user = await getUserDetails(accountId);
      }
    }
  }

  Future<Map> completeLogin(dynamic uri) async {
    if (uri.queryParameters['error'] != null) {
      return {
        'success': false,
        'message': uri.queryParameters['error'],
      };
    }

    if (_requestToken != null) {
      int status = await _exchangeToken(_requestToken!);
      if (status != 200) {
        return {
          'success': false,
          'message': 'Error $status in exchangeToken with token $_requestToken',
        };
      }
      user = await getUserDetails(accountId);
      notifyListeners();
      return {'success': true};
    }

    return {
      'success': false,
      'message': 'Error: _requestToken is null',
    };
  }

  Future<int> _exchangeToken(String requestToken) async {
    final response = await post(
        '/auth/access_token', {'request_token': requestToken},
        version: ApiVersion.v4);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      accessToken = json['access_token'];
      accountId = json['account_id'];
      PreferencesService().prefs.setString('accessToken', accessToken);
      PreferencesService().prefs.setString('accountId', accountId);
    }

    return response.statusCode;
  }

  Future<Map> _startLogin() async {
    final response = await post(
        '/auth/request_token', {'redirect_to': redirectTo},
        version: ApiVersion.v4);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _requestToken = json['request_token'];

      final authUrl =
          'https://www.themoviedb.org/auth/access?request_token=$_requestToken';

      try {
        await launchUrl(Uri.parse(authUrl),
            mode: LaunchMode.externalApplication);
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

  Future<dynamic> getUserDetails(String accountId) async {
    final response = await get('/account/$accountId');
    if (response.statusCode == 200) {
      return body(response);
    }
  }

  Future<Map> login() async {
    return _startLogin();
  }

  Future<void> logout() async {
    accessToken = '';
    accountId = '';
    user = null;
    PreferencesService().prefs.remove('accessToken');
    PreferencesService().prefs.remove('accountId');
    notifyListeners();
  }
}
