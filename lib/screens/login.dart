import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:app_links/app_links.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final AppLinks _appLinks;
  late final String loginFailedMessage;
  late final String loginSuccessMessage;

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

        Map result = await Provider.of<TmdbUserService>(context, listen: false)
            .completeLogin(uri);

        if (result['success']) {
          if (mounted) {
            await Provider.of<TmdbWatchlistService>(context, listen: false)
                .retrieveWatchlist(
                    Provider.of<TmdbUserService>(context, listen: false)
                        .accountId);
          }

          if (mounted) {
            await Provider.of<TmdbRateslistService>(context, listen: false)
                .retrieveRateslist(
                    Provider.of<TmdbUserService>(context, listen: false)
                        .accountId);
          }

          SnackMessage.showSnackBar(loginSuccessMessage);
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          throw Exception(result['message']);
        }
      } catch (error) {
        SnackMessage.showSnackBar(error.toString());
      }
    });
  }

  Future<void> login() async {
    loginFailedMessage = AppLocalizations.of(context)!.loginFailed;
    loginSuccessMessage = AppLocalizations.of(context)!.loginSuccess;
    final tmdbService = Provider.of<TmdbUserService>(context, listen: false);
    final result = await tmdbService.login();

    if (result['success'] == false) {
      SnackMessage.showSnackBar(loginFailedMessage);
      SnackMessage.showSnackBar(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: login,
        child: const Text('Inicia sessió amb TMDb'),
      ),
    );
  }
}
