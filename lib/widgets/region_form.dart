import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class RegionForm extends Dialog {
  const RegionForm({super.key, required this.currentRegion});

  final String? currentRegion;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String?> region = ValueNotifier(currentRegion);

    Map<String?, String> regions = {
      null: AppLocalizations.of(context)!.regionAuto,
      'ES': AppLocalizations.of(context)!.regionSpain,
      'US': AppLocalizations.of(context)!.regionUSA,
      'GB': AppLocalizations.of(context)!.regionUK,
      'FR': AppLocalizations.of(context)!.regionFrance,
      'DE': AppLocalizations.of(context)!.regionGermany,
      'IT': AppLocalizations.of(context)!.regionItaly,
    };

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.selectRegion,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: ValueListenableBuilder<String?>(
        valueListenable: region,
        builder: (context, value, child) {
          List<Widget> regionWidgets = [];
          regions.forEach((code, name) {
            regionWidgets.add(
              RadioListTile<String?>(
                title: Text(name),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                value: code,
                selected: region.value == code,
              ),
            );
            regionWidgets.add(
              const SizedBox(height: 10),
            );
          });

          return RadioGroup<String?>(
            groupValue: region.value,
            onChanged: (newValue) {
              region.value = newValue;
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(children: regionWidgets),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(region.value);
                        },
                        child: Text(AppLocalizations.of(context)!.select),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
