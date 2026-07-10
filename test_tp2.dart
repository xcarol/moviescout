import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TextPainter test 2', (WidgetTester tester) async {
    final text = 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5\n\n\n\n\n\n\n\n';
    final span = TextSpan(text: text, style: TextStyle(fontSize: 14));
    final tp = TextPainter(
      text: span,
      maxLines: 10,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: 300);
    debugPrint('didExceedMaxLines: ${tp.didExceedMaxLines}');
    debugPrint('line metrics length: ${tp.computeLineMetrics().length}');
  });
}
