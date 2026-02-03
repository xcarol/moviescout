import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:app_links/app_links.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      } catch (error) {
        SnackMessage.showSnackBar(error.toString());
      }
    });
  }

  void _completeLogin() async {
    TmdbUserService userService =
        Provider.of<TmdbUserService>(context, listen: false);
    TmdbWatchlistService watchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    TmdbRateslistService rateslistService =
        Provider.of<TmdbRateslistService>(context, listen: false);
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
      SnackMessage.showSnackBar(loginFailedMessage);
      SnackMessage.showSnackBar(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    loginFailedMessage = AppLocalizations.of(context)!.loginFailed;
    loginSuccessMessage = AppLocalizations.of(context)!.loginSuccess;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.loginTitle,
      ),
      drawer: AppDrawer(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: login,
          child: Text(AppLocalizations.of(context)!.loginToTmdb),
        ),
        const SizedBox(height: 20),
        if (defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.windows)
          _completeLoginButton(),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => launchUrlString(
            'https://www.themoviedb.org/account/signup',
            mode: LaunchMode.externalApplication,
          ),
          child: Text(AppLocalizations.of(context)!.signupToTmdb),
        ),
      ],
    );
  }
}
