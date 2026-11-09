import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/utils/url_constants.dart';
import 'package:moviescout/core/widgets/app_cached_image.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<SupabaseAuthService>(context).isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _userProfileTile(context),
          _settingsTile(context),
          if (isLoggedIn) _notificationsHistoryTile(context),
          _aboutTile(context),
          const Divider(),
          _userSessionTile(context, isLoggedIn),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: Text(AppLocalizations.of(context)!.settings),
      onTap: () {
        Navigator.of(context).pop();
        context.toSettings();
      },
    );
  }

  Widget _notificationsHistoryTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(AppLocalizations.of(context)!.notificationsHistory),
      onTap: () {
        Navigator.of(context).pop();
        context.toNotifications();
      },
    );
  }

  Widget _userProfileTile(BuildContext context) {
    final supabaseAuth = Provider.of<SupabaseAuthService>(context);
    final theme = Theme.of(context);

    String? avatarUrl;
    String? userName;

    if (supabaseAuth.isLoggedIn) {
      final profile = supabaseAuth.userProfile;
      final metadata = supabaseAuth.currentUser?.userMetadata;

      final profileAvatar = profile?['avatar_url'] as String?;
      final metadataAvatar =
          (metadata?['avatar_url'] ?? metadata?['picture']) as String?;
      avatarUrl = (profileAvatar != null && profileAvatar.isNotEmpty)
          ? profileAvatar
          : metadataAvatar;

      final profileUsername = profile?['username'] as String?;
      final metadataName =
          (metadata?['full_name'] ?? metadata?['name']) as String?;
      userName = (profileUsername != null && profileUsername.isNotEmpty)
          ? profileUsername
          : metadataName;
    }

    userName ??= AppLocalizations.of(context)!.anonymousUser;

    return DrawerHeader(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCachedImage(
              imageUrl: avatarUrl,
              type: AppImageType.avatar,
              width: AppSizes.avatarMd,
              height: AppSizes.avatarMd,
              isCircular: true,
              fallbackIconSize: AppSizes.iconXl,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              userName,
              style: theme.textTheme.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutTile(BuildContext context) {
    final theme = Theme.of(context);
    return AboutListTile(
      icon: const Icon(Icons.info),
      applicationName: 'MovieScout',
      applicationVersion: dotenv.env['VERSION'] ?? 'x.x.x',
      applicationIcon: SizedBox(
        width: AppSizes.avatarMd,
        height: AppSizes.avatarMd,
        child: Image.asset('assets/logo-icon.png'),
      ),
      aboutBoxChildren: [
        Text(AppLocalizations.of(context)!.aboutDescription),
        const SizedBox(height: AppSpacing.xs),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: AppLocalizations.of(context)!.aboutGithub),
              TextSpan(
                text: 'github',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => launchUrl(Uri.parse(UrlConstants.githubRepoUrl)),
              ),
            ],
          ),
        ),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.privacyDisclaimerPrefix),
              TextSpan(
                text: AppLocalizations.of(context)!.privacyDisclaimer,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => launchUrl(Uri.parse(UrlConstants.privacyPolicyUrl)),
              ),
              const TextSpan(text: ' • '),
              TextSpan(
                text: AppLocalizations.of(context)!.termsOfService,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrl(Uri.parse(UrlConstants.termsOfServiceUrl)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppLocalizations.of(context)!.apiDisclaimer,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (kDebugMode || dotenv.env[AppConstants.enableLogs] == 'true')
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  context.toLogs();
                },
                icon: const Icon(Icons.history),
                label: const Text('App logs'),
              ),
            ],
          ),
      ],
      child: Text(AppLocalizations.of(context)!.about),
    );
  }

  Widget _userSessionTile(BuildContext context, bool isUserLoggedIn) {
    return ListTile(
      leading: Icon(isUserLoggedIn ? Icons.logout : Icons.login),
      title: Text(isUserLoggedIn
          ? AppLocalizations.of(context)!.logout
          : AppLocalizations.of(context)!.login),
      onTap: () {
        Navigator.of(context).pop();
        if (isUserLoggedIn) {
          _logout(context);
        } else {
          context.toLogin();
        }
      },
    );
  }

  void _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final logoutSuccessText = AppLocalizations.of(context)!.logoutSuccess;

    await SupabaseAuthService().signOut();
    await AppService().clearUserData();

    SnackMessage.showSnackBar(logoutSuccessText);
    navigator.popUntil((route) => route.isFirst);
  }
}
