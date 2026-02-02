import 'dart:convert';

// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/services/tmdb_pinned_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmdb_base_service.dart';

class TmdbUserService extends TmdbBaseService with ChangeNotifier {
  final String redirectTo = 'moviescout://auth/callback';

  String _accountId = '';
  String _sessionId = '';
  String _accessToken = '';
  String? _requestToken;
  Map? user;

  bool get isUserLoggedIn => _accessToken.isNotEmpty;
  String get accountId => _accountId;
  String get sessionId => _sessionId;
  String get accessToken => _accessToken;

  Future<void> _setupUserDetails() async {
    if (user != null) return;

    user = await _getUserDetails();
    notifyListeners();
  }

  Future<void> setup() async {
    if (isUserLoggedIn) return;

    _accessToken = PreferencesService().prefs.getString('accessToken') ?? '';
    if (_accessToken.isNotEmpty) {
      _accountId = PreferencesService().prefs.getString('accountId') ?? '';
      _sessionId = PreferencesService().prefs.getString('sessionId') ?? '';
      if (_accountId.isNotEmpty) {
        await _setupUserDetails();
      }
    }
  }

  Future<Map> completeLogin() async {
    if (_requestToken == null) {
      return {'success': false, 'message': 'Error: _requestToken is null'};
    }

    int status = await _exchangeToken(_requestToken!);
    if (status != 200) {
      return {
        'success': false,
        'message': 'Error $status in _exchangeToken with token $_requestToken',
      };
    }

    status = await _getSession();
    if (status != 200) {
      return {
        'success': false,
        'message': 'Error $status in _getSession (convert/4)',
      };
    }

    await _setupUserDetails();

    return {'success': true};
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
      '/auth/access_token',
      {'request_token': requestToken},
      version: ApiVersion.v4,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final accessToken = json['access_token'];
      final accountId = json['account_id'];

      _accessToken = accessToken;
      _accountId = accountId;
      PreferencesService().prefs.setString('accessToken', _accessToken);
      PreferencesService().prefs.setString('accountId', accountId);
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
    PreferencesService().prefs.clear();
    return _startLogin();
  }

  Future<void> logout(BuildContext context) async {
    _accountId = '';
    _sessionId = '';
    _accessToken = '';
    user = null;
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    providerService.clearProvidersStatus();
    final pinnedService =
        Provider.of<TmdbPinnedService>(context, listen: false);
    pinnedService.clearPinnedStatus();
    PreferencesService().prefs.clear();
    notifyListeners();
  }
}
