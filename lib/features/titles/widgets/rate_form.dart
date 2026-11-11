import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class RateForm extends Dialog {
  const RateForm({
    super.key,
    required this.onSubmit,
    required this.title,
    this.initialRate,
    this.initialDate,
  });

  final String title;
  final double? initialRate;
  final DateTime? initialDate;
  final Function(double) onSubmit;

  @override
  Widget build(BuildContext context) {
    final String rate = AppLocalizations.of(context)!.rate;
    final ValueNotifier<double> rating = ValueNotifier(
      initialRate == null || initialRate! < 1.0 ? 1.0 : initialRate!,
    );
    final metaStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (value > 0)
                    Text(
                      '${AppLocalizations.of(context)!.your_rate}: ${value.toStringAsFixed(1)}',
                      style: metaStyle,
                    ),
                  if (initialDate != null &&
                      !initialDate!.isAtSameMomentAs(
                          DateTime.fromMillisecondsSinceEpoch(0)))
                    Text(
                      '${AppLocalizations.of(context)!.rate_date}: ${DateFormat.yMMMMd(Localizations.localeOf(context).toLanguageTag()).format(initialDate!)}',
                      style: metaStyle,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                alignment: WrapAlignment.start,
                children: List.generate(10, (index) {
                  return IconButton(
                    icon: rating.value >= index + 1
                        ? Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(Icons.star_border),
                    onPressed: () {
                      rating.value = (index + 1).toDouble();
                    },
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xs),
              Slider(
                value: rating.value,
                min: 1.0,
                max: 10.0,
                divisions: 18,
                label: rating.value.toStringAsFixed(1),
                onChanged: (double newValue) {
                  rating.value = newValue;
                },
              ),
            ],
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            onSubmit(0.0);
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.reset_rate),
        ),
        FilledButton(
          onPressed: () {
            onSubmit(rating.value);
            Navigator.of(context).pop();
          },
          child: Text(rate),
        ),
      ],
    );
  }
}
