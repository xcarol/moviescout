import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:app_links/app_links.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/bottom_bar.dart';
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

        if (uri.queryParameters['error'] != null) {
          throw Exception(uri.queryParameters['error']);
        }

        _completeLogin();
      } catch (error) {
        SnackMessage.showSnackBar(error.toString());
      }
    });
  }

  void _completeLogin() async {
    Map result = await Provider.of<TmdbUserService>(context, listen: false)
        .completeLogin();

    if (result['success']) {
      if (mounted) {
        await Provider.of<TmdbWatchlistService>(context, listen: false)
            .retrieveWatchlist(
          Provider.of<TmdbUserService>(context, listen: false).accountId,
          Localizations.localeOf(context),
          notify: true,
        );
      }

      if (mounted) {
        await Provider.of<TmdbRateslistService>(context, listen: false)
            .retrieveRateslist(
                Provider.of<TmdbUserService>(context, listen: false).accountId,
                notify: true);
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
    final tmdbService = Provider.of<TmdbUserService>(context, listen: false);
    final result = await tmdbService.login();

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
      bottomNavigationBar:
          BottomBar(currentIndex: BottomBarIndex.indexWatchlist),
    );
  }

  // This is a workaround for the Linux platform
  //
  // When login in Linux, the TMDB Auth web page will try to open
  // the Android app, but it will not work on Linux,
  // so close the browser (or tab) and complete the login by clicking this button.
  Widget _linuxCompleteLoginButton() {
    return ElevatedButton(
      onPressed: _completeLogin,
      child: Text(AppLocalizations.of(context)!.completeLoginToTmdb),
    );
  }

  Widget loginBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: login,
          child: Text(AppLocalizations.of(context)!.loginToTmdb),
        ),
        const SizedBox(height: 20),
        if (defaultTargetPlatform == TargetPlatform.linux)
          _linuxCompleteLoginButton(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () =>
              launchUrlString('https://www.themoviedb.org/account/signup'),
          child: Text(AppLocalizations.of(context)!.signupToTmdb),
        ),
      ],
    );
  }
}
