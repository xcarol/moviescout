import 'package:flutter/material.dart';

class SettingsInfoItem {
  final IconData icon;
  final String title;
  final String description;

  const SettingsInfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class SettingsInfoSheet extends StatelessWidget {
  final IconData headerIcon;
  final String title;
  final String? subtitle;
  final List<SettingsInfoItem> items;
  final String? note;
  final String closeButtonLabel;

  const SettingsInfoSheet({
    super.key,
    required this.headerIcon,
    required this.title,
    this.subtitle,
    required this.items,
    this.note,
    this.closeButtonLabel = 'Entesos',
  });

  static Future<void> show({
    required BuildContext context,
    required IconData headerIcon,
    required String title,
    String? subtitle,
    required List<SettingsInfoItem> items,
    String? note,
    String? closeButtonLabel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => SettingsInfoSheet(
        headerIcon: headerIcon,
        title: title,
        subtitle: subtitle,
        items: items,
        note: note,
        closeButtonLabel: closeButtonLabel ?? 'Entesos',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16.0,
          left: 20.0,
          right: 20.0,
          top: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(
                      headerIcon,
                      size: 24,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2.0),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              for (int i = 0; i < items.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(
                        items[i].icon,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(
                              text: '${items[i].title}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: items[i].description,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < items.length - 1) const SizedBox(height: 16.0),
              ],
              if (note != null) ...[
                const SizedBox(height: 18.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24.0),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(closeButtonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
