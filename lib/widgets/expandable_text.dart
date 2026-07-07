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
  double? _lastMaxWidth;
  bool _isOverflowing = false;

  bool _checkOverflow(double maxWidth, InlineSpan span) {
    if (_lastMaxWidth == maxWidth) {
      return _isOverflowing;
    }

    final tp = TextPainter(
      text: span,
      maxLines: widget.initialMaxLines,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
    );
    tp.layout(maxWidth: maxWidth);

    _lastMaxWidth = maxWidth;
    _isOverflowing = tp.didExceedMaxLines;

    return _isOverflowing;
  }

  @override
  void didUpdateWidget(ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.textSpan != widget.textSpan ||
        oldWidget.initialMaxLines != widget.initialMaxLines ||
        oldWidget.style != widget.style) {
      _lastMaxWidth = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = widget.style ?? DefaultTextStyle.of(context).style;

        final InlineSpan span = widget.textSpan ??
            TextSpan(text: widget.text ?? '', style: textStyle);

        final bool isOverflowing = _checkOverflow(constraints.maxWidth, span);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
    );
  }
}
