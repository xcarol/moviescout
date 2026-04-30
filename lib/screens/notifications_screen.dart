import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/main.dart';
import 'package:moviescout/models/saved_notification.dart';
import 'package:moviescout/models/title_list_theme.dart';
import 'package:moviescout/services/deep_link_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/models/tmdb_provider.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver, RouteAware {
  List<SavedNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadNotifications();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    await PreferencesService().refresh();
    final prefs = PreferencesService().prefs;
    final listStr = prefs.getStringList(AppConstants.savedNotifications) ?? [];
    if (mounted) {
      setState(() {
        _notifications =
            listStr.map((e) => SavedNotification.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final providerService = Provider.of<TmdbProviderService>(context);
    final allProviders = providerService.providers;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notificationsHistory),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(localizations.emptyList),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];

                return Column(
                  children: [
                    if (index == 0)
                      Divider(
                        height: 1,
                        color: Theme.of(context)
                            .extension<TitleListTheme>()!
                            .listDividerColor,
                      ),
                    ListTile(
                      leading: notification.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CachedNetworkImage(
                                imageUrl: notification.imageUrl!,
                                width: 50,
                                height: 75,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.movie),
                              ),
                            )
                          : const Icon(Icons.notifications),
                      title: Text(notification.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMd(
                                    Localizations.localeOf(context).toString())
                                .format(notification.timestamp.toLocal()),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                    ),
                          ),
                          if (notification.providerIds.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: notification.providerIds.map((id) {
                                  final providerData = allProviders[id];
                                  if (providerData == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return _providerLogo(providerData);
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onTap: notification.payload != null
                          ? () {
                              final parts = notification.payload!.split('|');
                              if (parts.length == 2) {
                                final type = parts[0];
                                final id = int.tryParse(parts[1]);
                                if (id != null) {
                                  DeepLinkService().navigateTo(type, id);
                                }
                              }
                            }
                          : null,
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .extension<TitleListTheme>()!
                          .listDividerColor,
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _providerLogo(Map<String, String> providerData) {
    final provider = TmdbProvider(provider: providerData);
    final logoPath = provider.logoPath;
    final name = provider.name;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Tooltip(
        message: name,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: CachedNetworkImage(
            imageUrl: logoPath,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(
              Icons.broken_image,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
