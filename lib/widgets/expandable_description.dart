import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class ExpandableDescription extends StatefulWidget {
  final String text;
  final int initialMaxLines;

  const ExpandableDescription({
    super.key,
    required this.text,
    this.initialMaxLines = 3,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;
  double? _lastMaxWidth;
  bool _isOverflowing = false;

  bool _checkOverflow(double maxWidth, String text, TextStyle style) {
    if (_lastMaxWidth == maxWidth) {
      return _isOverflowing;
    }

    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      maxLines: widget.initialMaxLines,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
    );
    tp.layout(maxWidth: maxWidth);

    _lastMaxWidth = maxWidth;
    _isOverflowing = tp.didExceedMaxLines;

    return _isOverflowing;
  }

  @override
  void didUpdateWidget(ExpandableDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.initialMaxLines != widget.initialMaxLines) {
      _lastMaxWidth = null; // Reset cache if content changes
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.isEmpty
        ? AppLocalizations.of(context)!.missingDescription
        : widget.text;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textStyle = TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

          final bool isOverflowing =
              _checkOverflow(constraints.maxWidth, displayText, textStyle);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                displayText,
                maxLines: _isExpanded ? null : widget.initialMaxLines,
                overflow: _isExpanded ? null : TextOverflow.clip,
                style: textStyle,
                textAlign: TextAlign.justify,
              ),
              if (isOverflowing)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Icon(
                    Icons.more_horiz,
                    color: _isExpanded
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
