import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class ThemeForm extends StatefulWidget {
  const ThemeForm({super.key, required this.currentThemeMode});

  final ThemeMode currentThemeMode;

  @override
  State<ThemeForm> createState() => _ThemeFormState();
}

class _ThemeFormState extends State<ThemeForm> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
  }

  Widget _buildRadioTile({
    required ThemeMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedThemeMode == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return RadioListTile<ThemeMode>(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      secondary: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      value: mode,
      selected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.selectTheme,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: RadioGroup<ThemeMode>(
          groupValue: _selectedThemeMode,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedThemeMode = newValue;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRadioTile(
                mode: ThemeMode.dark,
                label: l10n.themeDark,
                icon: Icons.dark_mode_outlined,
              ),
              const SizedBox(height: 4),
              _buildRadioTile(
                mode: ThemeMode.light,
                label: l10n.themeLight,
                icon: Icons.light_mode_outlined,
              ),
              const SizedBox(height: 4),
              _buildRadioTile(
                mode: ThemeMode.system,
                label: l10n.themeSystem,
                icon: Icons.brightness_auto_outlined,
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedThemeMode);
          },
          child: Text(l10n.select),
        ),
      ],
    );
  }
}
