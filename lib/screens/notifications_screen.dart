import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/models/saved_notification.dart';
import 'package:moviescout/services/deep_link_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/widgets/app_drawer.dart';
import 'package:moviescout/widgets/app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<SavedNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = PreferencesService().prefs;
    final listStr = prefs.getStringList(AppConstants.savedNotifications) ?? [];
    setState(() {
      _notifications =
          listStr.map((e) => SavedNotification.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: localizations.notificationsHistory,
      ),
      drawer: const AppDrawer(),
      body: _notifications.isEmpty
          ? Center(
              child: Text(localizations.emptyList),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];

                return ListTile(
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
                  subtitle: Text(
                    DateFormat.yMMMd(Localizations.localeOf(context).toString())
                        .format(notification.timestamp.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
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
                );
              },
            ),
    );
  }
}
