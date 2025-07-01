import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class RateForm extends Dialog {
  const RateForm(
      {super.key,
      required this.onSubmit,
      required this.title,
      this.initialRate});

  final String title;
  final int? initialRate;
  final Function(int) onSubmit;

  @override
  Widget build(BuildContext context) {
    String rate = AppLocalizations.of(context)!.rate;
    ValueNotifier<int> rating = ValueNotifier(initialRate ?? 0);

    return AlertDialog(
      title: Text(
        '$rate $title',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: ValueListenableBuilder(
        valueListenable: rating,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                if (rating.value > 0)
                  Text(
                    '${AppLocalizations.of(context)!.your_rate}: ${rating.value}',
                  )
                else
                  Text('${AppLocalizations.of(context)!.your_rate}: '),
              ]),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: List.generate(10, (index) {
                  return IconButton(
                    icon: rating.value >= index + 1
                        ? Icon(Icons.star)
                        : Icon(Icons.star_border),
                    onPressed: () {
                      rating.value = index + 1;
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                    onPressed: () {
                      onSubmit(0);
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.reset_rate)),
                TextButton(
                    onPressed: () {
                      onSubmit(rating.value);
                      Navigator.of(context).pop();
                    },
                    child: Text(rate)),
              ]),
            ],
          );
        },
      ),
    );
  }
}
