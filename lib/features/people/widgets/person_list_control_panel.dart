import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/theme/title_list_theme.dart';
import 'package:moviescout/core/widgets/text_filter_widget.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class PersonListControlPanel extends StatelessWidget {
  final TextEditingController textFilterController;
  final FocusNode focusNode;
  final Function(String) onTextChanged;

  const PersonListControlPanel({
    super.key,
    required this.textFilterController,
    required this.focusNode,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final titleTheme = Theme.of(context).extension<TitleListTheme>()!;

    return Container(
      color: titleTheme.controlPanelBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: Column(
        children: [
          TextFilterWidget(
            controller: textFilterController,
            focusNode: focusNode,
            hintText: localizations.searchPerson,
            onChanged: onTextChanged,
          ),
        ],
      ),
    );
  }
}
