import 'package:moviescout/utils/url_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/core/tmdb_base_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_pinned_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_following_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  }

  Future<void> setup() async {
    if (isUserLoggedIn) return;

    _accessToken = PreferencesService().prefs.getString('accessToken') ?? '';
    if (_accessToken.isNotEmpty) {
      _accountId = PreferencesService().prefs.getString('accountId') ?? '';
      _sessionId = PreferencesService().prefs.getString('sessionId') ?? '';
      if (_accountId.isNotEmpty) {
        await _setupUserDetails();
        if (Firebase.apps.isNotEmpty &&
            FirebaseAuth.instance.currentUser == null) {
          await _firebaseSignIn();
        }
        notifyListeners();
      }
    }
  }

  Future<Map> completeLogin() async {
    if (_requestToken == null) {
      return {
        AppConstants.success: false,
        AppConstants.message: 'Error: _requestToken is null'
      };
    }

    int status = await _exchangeToken(_requestToken!);
    if (status != 200) {
      return {
        AppConstants.success: false,
        AppConstants.message:
            'Error $status in _exchangeToken with token $_requestToken',
      };
    }

    status = await _getSession();
    if (status != 200) {
      return {
        AppConstants.success: false,
        AppConstants.message: 'Error $status in _getSession (convert/4)',
      };
    }

    await _setupUserDetails();
    await _firebaseSignIn();
    notifyListeners();

    return {AppConstants.success: true};
  }

  Future<int> _getSession() async {
    String accessToken =
        PreferencesService().prefs.getString('accessToken') ?? '';

    final response = await post(
      '/authentication/session/convert/4',
      {AppConstants.accessToken: accessToken},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _sessionId = json[AppConstants.sessionId];
      PreferencesService().prefs.setString('sessionId', _sessionId);
    }

    return response.statusCode;
  }

  Future<int> _exchangeToken(String requestToken) async {
    final response = await post(
      '/auth/access_token',
      {AppConstants.requestToken: requestToken},
      version: ApiVersion.v4,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final accessToken = json[AppConstants.accessToken];
      final accountId = json[AppConstants.accountId];

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
      _requestToken = json[AppConstants.requestToken];

      final authUrl = UrlConstants.tmdbAuthAccessWebTemplate
          .replaceFirst('{REQUEST_TOKEN}', _requestToken!);

      try {
        await launchUrl(
          Uri.parse(authUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (error, stackTrace) {
        ErrorService.log(
          'Error launching URL: $error',
          stackTrace: stackTrace,
          userMessage: 'Error launching authorization URL',
        );
        return {
          AppConstants.success: false,
          AppConstants.message: 'Error launching URL: $error',
        };
      }
    } else {
      ErrorService.log(
        'Error ${response.statusCode} in _startLogin: ${response.body}',
        userMessage: 'Error starting login process',
      );
      return {
        AppConstants.success: false,
        AppConstants.message: 'Error ${response.statusCode} in _startLogin',
      };
    }

    return {
      AppConstants.success: true,
    };
  }

  Future<dynamic> _getUserDetails() async {
    final response = await get('/account/$_accountId?session_id=$_sessionId');
    if (response.statusCode == 200) {
      return body(response);
    }
  }

  Future<void> _firebaseSignIn() async {
    if (Firebase.apps.isEmpty) return;
    try {
      final authUrl = dotenv.env[AppConstants.firebaseAuthUrl];
      if (authUrl == null || authUrl.isEmpty) return;

      final response = await http.post(
        Uri.parse(authUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          AppConstants.accountId: _accountId,
          AppConstants.sessionId: _sessionId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customToken = data[AppConstants.token];
        if (customToken != null) {
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
        }
      } else {
        ErrorService.log(
          'Firebase Custom Auth Failed: ${response.body}',
          userMessage: 'Error connecting to sync server',
        );
      }
    } catch (e, stackTrace) {
      ErrorService.log(
        e,
        stackTrace: stackTrace,
        userMessage: 'Error in Firebase Authentication',
      );
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
    final followingService =
        Provider.of<TmdbFollowingService>(context, listen: false);
    followingService.clearFollowingStatus();
    PreferencesService().prefs.clear();
    if (Firebase.apps.isNotEmpty) {
      await FirebaseAuth.instance.signOut();
    }
    notifyListeners();
  }
}
