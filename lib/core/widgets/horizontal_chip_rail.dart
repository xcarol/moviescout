import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/utils/ui_utils.dart';

class HorizontalChipRail extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const HorizontalChipRail({
    super.key,
    required this.children,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final mediaQuery = MediaQuery.of(context);
    final clampedScale = UiUtils.clampedTextScale(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: TextScaler.linear(clampedScale),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(children.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < children.length - 1 ? spacing : 0,
                ),
                child: children[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
