import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/core/utils/app_constants.dart';

class LanguageForm extends StatefulWidget {
  const LanguageForm({super.key, required this.currentLanguage});

  final String currentLanguage;

  @override
  State<LanguageForm> createState() => _LanguageFormState();
}

class _LanguageFormState extends State<LanguageForm> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  Widget _buildRadioTile(String code, String name) {
    final isSelected = _selectedLanguage == code;
    return RadioListTile<String>(
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMd,
      ),
      value: code,
      selected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> languages = {
      AppConstants.catalan: AppLocalizations.of(context)!.catalan,
      AppConstants.spanish: AppLocalizations.of(context)!.spanish,
      AppConstants.spanishLatam: AppLocalizations.of(context)!.spanishLatam,
      AppConstants.english: AppLocalizations.of(context)!.english,
      AppConstants.french: AppLocalizations.of(context)!.french,
      AppConstants.german: AppLocalizations.of(context)!.german,
      AppConstants.italian: AppLocalizations.of(context)!.italian,
      AppConstants.portugueseBr: AppLocalizations.of(context)!.portugueseBr,
      AppConstants.portuguesePt: AppLocalizations.of(context)!.portuguesePt,
      AppConstants.basque: AppLocalizations.of(context)!.basque,
      AppConstants.galician: AppLocalizations.of(context)!.galician,
    };

    final entries = languages.entries.toList();

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.selectLanguage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * AppSizes.dialogHeightFactor,
        child: RadioGroup<String>(
          groupValue: _selectedLanguage,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }
          },
          child: ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildRadioTile(entry.key, entry.value);
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedLanguage);
          },
          child: Text(AppLocalizations.of(context)!.select),
        ),
      ],
    );
  }
}
