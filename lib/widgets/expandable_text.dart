import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String? text;
  final TextSpan? textSpan;
  final int initialMaxLines;
  final TextStyle? style;

  const ExpandableText({
    super.key,
    this.text,
    this.textSpan,
    this.initialMaxLines = 3,
    this.style,
  }) : assert(text != null || textSpan != null);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _checkOverflow(double maxWidth, InlineSpan span, TextScaler textScaler,
      TextDirection textDirection) {
    final tp = TextPainter(
      text: span,
      maxLines: widget.initialMaxLines,
      textDirection: textDirection,
      textAlign: TextAlign.start,
      textScaler: textScaler,
    );
    tp.layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultTextStyle = DefaultTextStyle.of(context).style;
        final textStyle = widget.style != null
            ? defaultTextStyle.merge(widget.style)
            : defaultTextStyle;

        final InlineSpan span = widget.textSpan ??
            TextSpan(text: widget.text ?? '', style: textStyle);

        final textScaler = MediaQuery.textScalerOf(context);
        final textDirection = Directionality.of(context);

        final bool isOverflowing = _checkOverflow(
            constraints.maxWidth, span, textScaler, textDirection);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              span,
              maxLines: _isExpanded ? null : widget.initialMaxLines,
              overflow: _isExpanded ? null : TextOverflow.clip,
              style: textStyle,
              textAlign: TextAlign.start,
            ),
            if (isOverflowing)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Center(
                  child: Icon(
                    Icons.more_horiz,
                    color: _isExpanded
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
