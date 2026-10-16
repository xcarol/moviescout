import "package:moviescout/services/auth/supabase_auth_service.dart";
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _isLoading = false;

  Future<void> _loginWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) {
      SnackMessage.showSnackBar('Platform not supported');
      return;
    }

    setState(() => _isLoading = true);
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final success = await authService.signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        SnackMessage.showSnackBar(AppLocalizations.of(context)!.loginSuccess);
        Navigator.pop(context);
      } else {
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isGoogleLoggedIn) ...[
                  Text(
                    AppLocalizations.of(context)!.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _loginWithGoogle,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : SvgPicture.asset(
                            'assets/google-logo.svg',
                            width: 18,
                            height: 18,
                          ),
                    label:
                        Text(AppLocalizations.of(context)!.googleSignInButton),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SelectableText.rich(
                      TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .loginConsentText),
                          TextSpan(
                            text:
                                AppLocalizations.of(context)!.privacyDisclaimer,
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(
                                  Uri.parse(UrlConstants.privacyPolicyUrl)),
                          ),
                          TextSpan(text: AppLocalizations.of(context)!.andThe),
                          TextSpan(
                            text: AppLocalizations.of(context)!.termsOfService,
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(
                                  Uri.parse(UrlConstants.termsOfServiceUrl)),
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
        ),
      ),
    );
  }
}
