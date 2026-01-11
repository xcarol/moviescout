import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class LanguageForm extends Dialog {
  const LanguageForm(
      {super.key, required this.onSubmit, required this.currentLanguage});

  final String currentLanguage;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> language = ValueNotifier(currentLanguage);

    if (currentLanguage == AppLocalizations.of(context)!.catalan) {
      language.value = AppLocalizations.of(context)!.catalan;
    } else if (currentLanguage == AppLocalizations.of(context)!.spanish) {
      language.value = AppLocalizations.of(context)!.spanish;
    } else if (currentLanguage == AppLocalizations.of(context)!.english) {
      language.value = AppLocalizations.of(context)!.english;
    }

    List<String> languages = [
      AppLocalizations.of(context)!.catalan,
      AppLocalizations.of(context)!.spanish,
      AppLocalizations.of(context)!.english,
    ];

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.selectLanguage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: ValueListenableBuilder(
        valueListenable: language,
        builder: (context, value, child) {
          List<Widget> languageWidgets = [];
          for (String item in languages) {
            languageWidgets.add(
              RadioListTile<String>(
                title: Text(item),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                value: item,
                selected: language.value == item,
              ),
            );
            languageWidgets.add(
              const SizedBox(height: 10),
            );
          }

          return RadioGroup<String>(
            groupValue: language.value,
            onChanged: (value) {
              if (value != null) {
                language.value = value;
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
                            onSubmit(language.value);
                            Navigator.of(context).pop();
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
