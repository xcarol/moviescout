import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/snack_bar.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
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
  bool _loginInProgress = false;
  late TextEditingController _userController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _passwordController = TextEditingController();
    _userController.addListener(updateLoginButtonState);
    _passwordController.addListener(updateLoginButtonState);
    _userController.text =
        PreferencesService().prefs.getString('username') ?? '';
  }

  @override
  void dispose() {
    _userController.removeListener(updateLoginButtonState);
    _passwordController.removeListener(updateLoginButtonState);
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.loginTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: back,
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(child: loginBody()),
    );
  }

  back() async {
    Navigator.pop(context);
  }

  loginBody() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.loginDescription,
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: TextField(
            controller: _userController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.username,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.password,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => launchUrlString(
                    'https://www.themoviedb.org/account/signup'),
                child: Text(AppLocalizations.of(context)!.signup),
              ),
              ElevatedButton(
                onPressed: _userController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? () => login(context)
                    : null,
                child: _loginInProgress == true
                    ? CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.login),
              ),
            ],
          ),
        ),
      ],
    );
  }

  updateLoginButtonState() {
    setState(() {});
  }

  login(context) async {
    setState(() {
      _loginInProgress = true;
    });
    bool success = await Provider.of<TmdbUserService>(context, listen: false)
        .login(
      _userController.text,
      _passwordController.text,
    )
        .catchError((error) {
      setState(() {
        _loginInProgress = false;
      });
      SnackMessage.showSnackBar(
        error.toString(),
      );
      return false;
    });
    if (success) {
      PreferencesService().prefs.setString('username', _userController.text);
      await Provider.of<TmdbWatchlistService>(context, listen: false)
          .retrieveWatchlist(
              Provider.of<TmdbUserService>(context, listen: false).accountId);
      await Provider.of<TmdbRateslistService>(context, listen: false)
          .retrieveRateslist(
              Provider.of<TmdbUserService>(context, listen: false).accountId);
      SnackMessage.showSnackBar(AppLocalizations.of(context)!.loginSuccess);
      Navigator.pop(context);
    } else {
      SnackMessage.showSnackBar(AppLocalizations.of(context)!.loginFailed);
    }
    setState(() {
      _loginInProgress = false;
    });
  }
}
