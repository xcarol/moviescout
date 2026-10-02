import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/services/import/tmdb_import_service.dart';
import 'package:moviescout/services/lists/rateslist_service.dart';
import 'package:moviescout/services/lists/watchlist_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/utils/url_constants.dart';
import 'package:provider/provider.dart';

enum ImportState { idle, importing, success, error }

class ImportTmdbScreen extends StatefulWidget {
  const ImportTmdbScreen({super.key});

  @override
  State<ImportTmdbScreen> createState() => _ImportTmdbScreenState();
}

class _ImportTmdbScreenState extends State<ImportTmdbScreen> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  ImportState _state = ImportState.idle;
  ImportProgressStage? _currentStage;
  int? _watchlistCount;
  int? _rateslistCount;
  int? _episodesCount;
  String? _errorMessage;
  double _uploadProgress = 0.0;
  int _currentUpload = 0;
  int _totalUpload = 0;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenForRedirect();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _listenForRedirect() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      try {
        if (!mounted) return;
        if (uri.scheme == 'moviescout' && uri.host == 'auth') {
          if (uri.queryParameters['error'] != null) {
            throw Exception(uri.queryParameters['error']);
          }
          await _completeTmdbLogin();
        }
      } catch (error, stackTrace) {
        ErrorService.log(error, stackTrace: stackTrace);
      }
    });
  }

  Future<void> _loginTmdb() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final result = await userService.login();
    if (result['success'] == false && mounted) {
      ErrorService.log(
        result['message'],
        userMessage: AppLocalizations.of(context)!.tmdbImportError,
      );
    }
  }

  // This is a workaround for the Linux & Windows platforms
  //
  // When login in Linux, the TMDB Auth web page will try to open
  // the Android app (in Windows does nothing), but it will not work on Linux/Windows,
  // so close the browser (or tab) and complete the login by clicking this button.
  Future<void> _completeTmdbLogin() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final result = await userService.completeLogin();
    if (result['success'] != true && mounted) {
      setState(() {
        _state = ImportState.error;
        _errorMessage = result['message']?.toString();
      });
    }
  }

  Future<void> _startImport() async {
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    final repository =
        Provider.of<LocalTitleRepository>(context, listen: false);
    final watchlistService =
        Provider.of<WatchlistService>(context, listen: false);
    final rateslistService =
        Provider.of<RateslistService>(context, listen: false);
    final locale = Localizations.localeOf(context);

    setState(() {
      _state = ImportState.importing;
      _currentStage = ImportProgressStage.fetchingWatchlist;
      _watchlistCount = null;
      _rateslistCount = null;
      _episodesCount = null;
      _errorMessage = null;
      _uploadProgress = 0.0;
      _currentUpload = 0;
      _totalUpload = 0;
    });

    try {
      final importService = TmdbImportService(repository);
      await importService.importFromTmdb(
        accountId: userService.accountId,
        sessionId: userService.sessionId,
        locale: locale,
        onProgress: ({
          required stage,
          count,
          current,
          total,
          progress,
        }) {
          if (mounted) {
            setState(() {
              _currentStage = stage;
              if (stage == ImportProgressStage.fetchingWatchlist &&
                  count != null) {
                _watchlistCount = count;
              } else if (stage == ImportProgressStage.fetchingRateslist &&
                  count != null) {
                _rateslistCount = count;
              } else if (stage == ImportProgressStage.fetchingEpisodes &&
                  count != null) {
                _episodesCount = count;
              } else if (stage == ImportProgressStage.uploadingCloud) {
                if (progress != null) _uploadProgress = progress;
                if (current != null) _currentUpload = current;
                if (total != null) _totalUpload = total;
              }
            });
          }
        },
      );

      if (mounted) {
        // Automatically close TMDB session once import completes
        await userService.logout(context);

        // Refresh local lists from cloud
        await watchlistService.syncFromServer(
          locale: locale,
          forceUpdate: true,
        );
        await rateslistService.syncFromServer(
          locale: locale,
          forceUpdate: true,
        );

        if (mounted) {
          setState(() {
            _state = ImportState.success;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ImportState.error;
          _errorMessage = AppLocalizations.of(context)!.tmdbImportError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<TmdbUserService>(context);
    final isTmdbLoggedIn = userService.isUserLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tmdbImportScreenTitle),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Icon(
                      _state == ImportState.success
                          ? Icons.cloud_done
                          : Icons.cloud_download,
                      size: 96,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _state == ImportState.success
                          ? AppLocalizations.of(context)!.tmdbImportSuccess
                          : AppLocalizations.of(context)!
                              .tmdbImportScreenHeader,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (_state == ImportState.idle)
                      Text(
                        AppLocalizations.of(context)!.tmdbImportScreenBody,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    if (_state == ImportState.idle && isTmdbLoggedIn) ...[
                      const SizedBox(height: 20),
                      _buildTmdbUserCard(context, userService.user),
                    ],
                    if (_state == ImportState.importing ||
                        _state == ImportState.success)
                      _buildProgressIndicators(context),
                    if (_state == ImportState.error &&
                        _errorMessage != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const Spacer(),
                    _buildActionButtons(context, isTmdbLoggedIn),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTmdbUserCard(
      BuildContext context, Map<dynamic, dynamic>? tmdbUser) {
    String userName = tmdbUser?['username'] ?? '';
    if (tmdbUser?['name'] != null &&
        tmdbUser!['name'].toString().trim().isNotEmpty) {
      userName = tmdbUser['name'];
    }

    ImageProvider? userImage;
    if (tmdbUser != null) {
      if (tmdbUser['avatar']?['tmdb']?['avatar_path'] != null) {
        userImage = CachedNetworkImageProvider(
          UrlConstants.tmdbImageW185Template.replaceFirst(
            '{PATH}',
            '/${tmdbUser['avatar']['tmdb']['avatar_path']}',
          ),
        );
      } else if (tmdbUser['avatar']?['gravatar']?['hash'] != null) {
        userImage = CachedNetworkImageProvider(
          UrlConstants.gravatarTemplate
              .replaceFirst('{HASH}', tmdbUser['avatar']['gravatar']['hash'])
              .replaceFirst('{SIZE}', '200'),
        );
      }
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: userImage,
          child: userImage == null ? const Icon(Icons.person) : null,
        ),
        title: Text(userName),
        subtitle: Text(AppLocalizations.of(context)!.tmdbAccount),
      ),
    );
  }

  Widget _buildProgressIndicators(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSuccess = _state == ImportState.success;

    final isWatchlistDone = isSuccess || _watchlistCount != null;
    final isWatchlistActive = _state == ImportState.importing &&
        !isWatchlistDone &&
        _currentStage == ImportProgressStage.fetchingWatchlist;

    final isRateslistDone = isSuccess || _rateslistCount != null;
    final isRateslistActive = _state == ImportState.importing &&
        !isRateslistDone &&
        _currentStage == ImportProgressStage.fetchingRateslist;

    final isEpisodesDone = isSuccess || _episodesCount != null;
    final isEpisodesActive = _state == ImportState.importing &&
        !isEpisodesDone &&
        _currentStage == ImportProgressStage.fetchingEpisodes;

    final isUploadDone =
        isSuccess || (_totalUpload > 0 && _currentUpload >= _totalUpload);
    final isUploadActive = _state == ImportState.importing &&
        !isUploadDone &&
        _currentStage == ImportProgressStage.uploadingCloud;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildStepTile(
              context: context,
              isActive: isWatchlistActive,
              isCompleted: isWatchlistDone,
              pendingText: l10n.watchlistTitle,
              activeText: l10n.tmdbImportDownloadingWatchlist,
              completedText:
                  l10n.tmdbImportWatchlistCount(_watchlistCount ?? 0),
            ),
            const Divider(height: 1),
            _buildStepTile(
              context: context,
              isActive: isRateslistActive,
              isCompleted: isRateslistDone,
              pendingText: l10n.rateslistTitle,
              activeText: l10n.tmdbImportDownloadingRateslist,
              completedText:
                  l10n.tmdbImportRateslistCount(_rateslistCount ?? 0),
            ),
            const Divider(height: 1),
            _buildStepTile(
              context: context,
              isActive: isEpisodesActive,
              isCompleted: isEpisodesDone,
              pendingText: l10n.episodes,
              activeText: l10n.tmdbImportDownloadingEpisodes,
              completedText: l10n.tmdbImportEpisodesCount(_episodesCount ?? 0),
            ),
            const Divider(height: 1),
            _buildStepTile(
              context: context,
              isActive: isUploadActive,
              isCompleted: isUploadDone,
              pendingText: l10n.tmdbImportUploadTitle,
              activeText: l10n.tmdbImportUploading,
              completedText: l10n.tmdbImportUploadedCount(_totalUpload),
              subtitle: isUploadActive
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _uploadProgress > 0 ? _uploadProgress : null,
                        ),
                        if (_totalUpload > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$_currentUpload / $_totalUpload',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile({
    required BuildContext context,
    required bool isActive,
    required bool isCompleted,
    required String pendingText,
    required String activeText,
    required String completedText,
    Widget? subtitle,
  }) {
    final theme = Theme.of(context);
    Widget leading;
    Color? textColor;

    if (isCompleted) {
      leading = Icon(Icons.check_circle, color: theme.colorScheme.primary);
      textColor = theme.textTheme.bodyMedium?.color;
    } else if (isActive) {
      leading = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
      textColor = theme.colorScheme.primary;
    } else {
      leading = Icon(Icons.radio_button_unchecked, color: theme.disabledColor);
      textColor = theme.disabledColor;
    }

    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Center(child: leading),
      ),
      title: Text(
        isCompleted
            ? completedText
            : isActive
                ? activeText
                : pendingText,
        style: TextStyle(
          color: textColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: subtitle,
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isTmdbLoggedIn) {
    switch (_state) {
      case ImportState.idle:
      case ImportState.error:
        if (!isTmdbLoggedIn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: _loginTmdb,
                icon: const Icon(Icons.login),
                label: Text(AppLocalizations.of(context)!.loginToTmdb),
              ),
              if (defaultTargetPlatform == TargetPlatform.linux ||
                  defaultTargetPlatform == TargetPlatform.windows) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _completeTmdbLogin,
                  child:
                      Text(AppLocalizations.of(context)!.completeLoginToTmdb),
                ),
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                AppLocalizations.of(context)!.tmdbImportConsentText,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              onPressed: _startImport,
              child: Text(AppLocalizations.of(context)!.tmdbImportStartButton),
            ),
          ],
        );
      case ImportState.importing:
        return const SizedBox.shrink();
      case ImportState.success:
        return FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.close),
        );
    }
  }
}
