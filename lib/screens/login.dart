import 'dart:io';
import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/legacy/legacy_rateslist_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:app_links/app_links.dart';
import 'package:moviescout/services/legacy/legacy_watchlist_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final AppLinks _appLinks;
  late String loginFailedMessage;
  late String loginSuccessMessage;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenForRedirect();
  }

  void _listenForRedirect() {
    _appLinks.uriLinkStream.listen((uri) async {
      try {
        if (!mounted) return;

        // Only handle our custom scheme for login completion
        if (uri.scheme == 'moviescout' && uri.host == 'auth') {
          if (uri.queryParameters['error'] != null) {
            throw Exception(uri.queryParameters['error']);
          }

          _completeLogin();
        }
      } catch (error, stackTrace) {
        ErrorService.log(
          error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  void _completeLogin() async {
    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: false);
    LegacyWatchlistService watchlistService =
        Provider.of<LegacyWatchlistService>(context, listen: false);
    LegacyRateslistService rateslistService =
        Provider.of<LegacyRateslistService>(context, listen: false);
    TmdbProviderService providerService =
        Provider.of<TmdbProviderService>(context, listen: false);

    Map result = await userService.completeLogin();

    if (result['success']) {
      if (mounted) {
        watchlistService.retrieveWatchlist(
          userService.accountId,
          userService.sessionId,
          Localizations.localeOf(context),
        );
        rateslistService.retrieveRateslist(
          userService.accountId,
          userService.sessionId,
          Localizations.localeOf(context),
        );
        providerService.setup(userService.accountId, userService.sessionId,
            userService.accessToken);
      }

      SnackMessage.showSnackBar(loginSuccessMessage);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      throw Exception(result['message']);
    }
  }

  Future<void> login() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final result = await userService.login();

    if (result['success'] == false) {
      ErrorService.log(
        result['message'],
        userMessage: loginFailedMessage,
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    if (!Platform.isAndroid) {
      SnackMessage.showSnackBar('Platform not supported');
      return;
    }

    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final success = await authService.signInWithGoogle();

    if (success) {
      if (mounted) {
        SnackMessage.showSnackBar(AppLocalizations.of(context)!.loginSuccess);
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ErrorService.log(
          'Failed to sign in with Google',
          userMessage: AppLocalizations.of(context)!.loginFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loginFailedMessage = AppLocalizations.of(context)!.loginFailed;
    loginSuccessMessage = AppLocalizations.of(context)!.loginSuccess;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginTitle),
      ),
      body: Center(child: loginBody()),
    );
  }

  // This is a workaround for the Linux & Windows platforms
  //
  // When login in Linux, the TMDB Auth web page will try to open
  // the Android app (in Windows does nothing), but it will not work on Linux/Windows,
  // so close the browser (or tab) and complete the login by clicking this button.
  Widget _completeLoginButton() {
    return OutlinedButton(
      onPressed: _completeLogin,
      child: Text(AppLocalizations.of(context)!.completeLoginToTmdb),
    );
  }

  Widget loginBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signInWithGoogle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loginWithGoogle,
              icon: const Icon(Icons.login),
              label: Text(AppLocalizations.of(context)!.googleSignInButton),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            Text(
              AppLocalizations.of(context)!.alreadyUsingMovieScout,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.importTmdbData,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: login,
              child: Text(AppLocalizations.of(context)!.loginToTmdb),
            ),
            const SizedBox(height: 20),
            if (defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.windows)
              _completeLoginButton(),
          ],
        ),
      ),
    );
  }
}
