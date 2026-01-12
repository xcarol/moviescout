import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/utils/app_constants.dart';

class LanguageForm extends Dialog {
  const LanguageForm({super.key, required this.currentLanguage});

  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> language = ValueNotifier(currentLanguage);

    Map<String, String> languages = {
      AppConstants.catalan: AppLocalizations.of(context)!.catalan,
      AppConstants.spanish: AppLocalizations.of(context)!.spanish,
      AppConstants.english: AppLocalizations.of(context)!.english,
    };

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.selectLanguage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: ValueListenableBuilder<String>(
        valueListenable: language,
        builder: (context, value, child) {
          List<Widget> languageWidgets = [];
          languages.forEach((code, name) {
            languageWidgets.add(
              RadioListTile<String>(
                title: Text(name),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                value: code,
                selected: language.value == code,
              ),
            );
            languageWidgets.add(
              const SizedBox(height: 10),
            );
          });

          return RadioGroup<String>(
            groupValue: language.value,
            onChanged: (newValue) {
              if (newValue != null) {
                language.value = newValue;
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(children: languageWidgets),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.cancel)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(language.value);
                          },
                          child: Text(AppLocalizations.of(context)!.select)),
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
