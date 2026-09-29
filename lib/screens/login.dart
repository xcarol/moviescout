import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/utils/snack_bar.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> _loginWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginTitle),
      ),
      body: Center(child: loginBody(context)),
    );
  }

  Widget loginBody(BuildContext context) {
    final isGoogleLoggedIn =
        Provider.of<SupabaseAuthService>(context).isLoggedIn;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isGoogleLoggedIn) ...[
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
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SelectableText.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!.loginConsentText),
                      TextSpan(
                        text: AppLocalizations.of(context)!.privacyDisclaimer,
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse(UrlConstants.privacyPolicyUrl)),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
