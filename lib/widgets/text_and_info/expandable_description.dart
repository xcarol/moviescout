import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/widgets/text_and_info/expandable_text.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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

  bool _checkOverflow(
    double maxWidth,
    String plainText,
    TextStyle style,
    TextScaler textScaler,
    TextDirection textDirection,
  ) {
    final span = TextSpan(text: plainText, style: style);
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

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          AppLocalizations.of(context)!.missingDescription,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final hasHtml = widget.text.contains(RegExp(r'<[a-z][\s\S]*>'));
    final textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    if (!hasHtml) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ExpandableText(
          text: widget.text,
          initialMaxLines: widget.initialMaxLines,
          style: textStyle,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final plainText = _stripHtml(widget.text);
          final textScaler = MediaQuery.textScalerOf(context);
          final textDirection = Directionality.of(context);
          final isOverflowing = _checkOverflow(
            constraints.maxWidth,
            plainText,
            textStyle,
            textScaler,
            textDirection,
          );

          final htmlWidget = HtmlWidget(widget.text, textStyle: textStyle);

          // Approximate height based on line height
          final fontSize = textStyle.fontSize ?? 14.0;
          final lineHeight = textStyle.height ?? 1.2;
          final approxMaxHeight =
              widget.initialMaxLines *
              fontSize *
              lineHeight *
              textScaler.scale(1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: _isExpanded || !isOverflowing
                        ? double.infinity
                        : approxMaxHeight,
                  ),
                  child: _isExpanded || !isOverflowing
                      ? htmlWidget
                      : ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent],
                              stops: [0.7, 1.0],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstIn,
                          child: ClipRect(
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: htmlWidget,
                            ),
                          ),
                        ),
                ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.more_horiz,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
