import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/services/legacy/legacy_watchlist_service.dart';
import 'package:moviescout/services/legacy/legacy_rateslist_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/migration/tmdb_migration_service.dart';
import 'package:moviescout/repositories/title_repository.dart';
import 'package:moviescout/screens/login.dart';

enum MigrationState { idle, downloadingLocal, uploadingCloud, success, error }

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  MigrationState _state = MigrationState.idle;
  String? _errorMessage;
  double _uploadProgress = 0.0;
  int _currentUpload = 0;
  int _totalUpload = 0;

  Future<void> _startMigration() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);

    if (!userService.isUserLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Login(isMigrationFlow: true)),
      );
      return;
    }

    setState(() {
      _state = MigrationState.downloadingLocal;
      _errorMessage = null;
    });

    try {
      final watchlistService =
          Provider.of<LegacyWatchlistService>(context, listen: false);
      final rateslistService =
          Provider.of<LegacyRateslistService>(context, listen: false);
      final locale = Localizations.localeOf(context);

      await watchlistService.syncFromServer(
        accountId: userService.accountId,
        sessionId: userService.sessionId,
        locale: locale,
      );
      await rateslistService.syncFromServer(
        accountId: userService.accountId,
        sessionId: userService.sessionId,
        locale: locale,
      );

      if (!mounted) return;

      setState(() {
        _state = MigrationState.uploadingCloud;
      });

      final repository = Provider.of<TitleRepository>(context, listen: false);
      final providerService =
          Provider.of<TmdbProviderService>(context, listen: false);
      final migrationService = TmdbMigrationService(repository);

      await migrationService.migrateLocalDataToSupabase(
        providers: providerService.enabledProviderIds.join(','),
        onProgress: (progress, current, total) {
          if (mounted) {
            setState(() {
              _uploadProgress = progress;
              _currentUpload = current;
              _totalUpload = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _state = MigrationState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = MigrationState.error;
          _errorMessage = AppLocalizations.of(context)!.migrationError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.migrationScreenTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                _state == MigrationState.success
                    ? Icons.cloud_done
                    : Icons.cloud_sync,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                _state == MigrationState.success
                    ? AppLocalizations.of(context)!.migrationScreenSuccess
                    : AppLocalizations.of(context)!.migrationScreenHeader,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_state == MigrationState.idle)
                Text(
                  AppLocalizations.of(context)!.migrationScreenBody,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              if (_state != MigrationState.idle &&
                  _state != MigrationState.success)
                _buildProgressIndicators(context),
              if (_state == MigrationState.error && _errorMessage != null) ...[
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onError),
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicators(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        ListTile(
          leading: _state == MigrationState.downloadingLocal
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                )
              : Icon(Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary),
          title: Text(AppLocalizations.of(context)!.migrationScreenDownloading),
        ),
        if (_state == MigrationState.uploadingCloud) ...[
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.cloud_upload,
                color: Theme.of(context).colorScheme.primary),
            title: Text(AppLocalizations.of(context)!.migrationScreenUploading),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(
                    value: _totalUpload > 0 ? _uploadProgress : null),
                const SizedBox(height: 4),
                if (_totalUpload > 0)
                  Text('$_currentUpload / $_totalUpload',
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (_state) {
      case MigrationState.idle:
      case MigrationState.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: _startMigration,
              child: Text(
                  AppLocalizations.of(context)!.migrationScreenStartButton),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                  AppLocalizations.of(context)!.migrationScreenLaterButton),
            ),
          ],
        );
      case MigrationState.downloadingLocal:
      case MigrationState.uploadingCloud:
        return const SizedBox.shrink();
      case MigrationState.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  Text(AppLocalizations.of(context)!.migrationScreenContinue),
            ),
          ],
        );
    }
  }
}
