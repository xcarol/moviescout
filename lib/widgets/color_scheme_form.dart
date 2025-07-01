import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/services/theme_service.dart';

class ColorSchemeForm extends Dialog {
  const ColorSchemeForm(
      {super.key, required this.onSubmit, required this.currentScheme});

  final ThemeSchemes currentScheme;
  final Function(ThemeSchemes) onSubmit;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> scheme = ValueNotifier(currentScheme.name);

    if (currentScheme == ThemeSchemes.defaultScheme) {
      scheme.value = AppLocalizations.of(context)!.defaultScheme;
    } else if (currentScheme == ThemeSchemes.blueScheme) {
      scheme.value = AppLocalizations.of(context)!.blueScheme;
    } else if (currentScheme == ThemeSchemes.redScheme) {
      scheme.value = AppLocalizations.of(context)!.redScheme;
    }

    List<String> schemes = [
      AppLocalizations.of(context)!.defaultScheme,
      AppLocalizations.of(context)!.blueScheme,
      AppLocalizations.of(context)!.redScheme,
    ];

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.schemeSelectTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: ValueListenableBuilder(
        valueListenable: scheme,
        builder: (context, value, child) {
          List<Widget> schemeWidgets = [];
          for (String item in schemes) {
            ColorScheme colorScheme;

            if (item == AppLocalizations.of(context)!.defaultScheme) {
              if (Theme.of(context).brightness == Brightness.dark) {
                colorScheme = ThemeService.darkColorSchemeDefault;
              } else {
                colorScheme = ThemeService.lightColorSchemeDefault;
              }
            } else if (item == AppLocalizations.of(context)!.blueScheme) {
              if (Theme.of(context).brightness == Brightness.dark) {
                colorScheme = ThemeService.darkColorSchemeBlue;
              } else {
                colorScheme = ThemeService.lightColorSchemeBlue;
              }
            } else if (item == AppLocalizations.of(context)!.redScheme) {
              if (Theme.of(context).brightness == Brightness.dark) {
                colorScheme = ThemeService.darkColorSchemeRed;
              } else {
                colorScheme = ThemeService.lightColorSchemeRed;
              }
            } else {
              continue; // Skip if the item is not recognized
            }

            schemeWidgets.add(
              RadioListTile<String>(
                title: Text(item,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                    )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // visualDensity: VisualDensity.compact,
                // dense: true,
                tileColor: colorScheme.primary,
                fillColor: WidgetStateProperty.all(colorScheme.onPrimary),
                overlayColor: WidgetStateProperty.all(colorScheme.primary),
                selectedTileColor: colorScheme.primary,
                activeColor: colorScheme.primary,
                controlAffinity: ListTileControlAffinity.trailing,
                value: item,
                selected: scheme.value == item,
                groupValue: scheme.value,
                onChanged: (value) {
                  if (value != null) {
                    scheme.value = value;
                  }
                },
              ),
            );
            schemeWidgets.add(
              const SizedBox(height: 10),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(children: schemeWidgets),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.cancel)),
                TextButton(
                    onPressed: () {
                      onSubmit(scheme.value ==
                              AppLocalizations.of(context)!.defaultScheme
                          ? ThemeSchemes.defaultScheme
                          : scheme.value ==
                                  AppLocalizations.of(context)!.blueScheme
                              ? ThemeSchemes.blueScheme
                              : ThemeSchemes.redScheme);
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.select)),
              ]),
            ],
          );
        },
      ),
    );
  }
}
