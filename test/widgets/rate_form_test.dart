import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/features/titles/widgets/rate_form.dart';

void main() {
  Widget createWidgetUnderTest({
    required String title,
    double? initialRate,
    DateTime? initialDate,
    required Function(double) onSubmit,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: RateForm(
          title: title,
          initialRate: initialRate,
          initialDate: initialDate,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  group('RateForm Widget Tests', () {
    testWidgets('renders title and initial rating', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Interstellar',
        initialRate: 8.5,
        onSubmit: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Rate Interstellar'), findsOneWidget);
      expect(find.text('Your rating: 8.5'), findsOneWidget);
    });

    testWidgets('tapping a star updates rating and submitting calls onSubmit',
        (tester) async {
      double submittedRate = -1;
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'The Matrix',
        initialRate: 5.0,
        onSubmit: (val) => submittedRate = val,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Your rating: 5.0'), findsOneWidget);

      final starIcons = find.byType(IconButton);
      expect(starIcons, findsNWidgets(10));
      await tester.tap(starIcons.at(7));
      await tester.pumpAndSettle();

      expect(find.text('Your rating: 8.0'), findsOneWidget);

      final submitButton = find.widgetWithText(FilledButton, 'Rate');
      expect(submitButton, findsOneWidget);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(submittedRate, 8.0);
    });

    testWidgets('tapping reset rate button submits 0.0', (tester) async {
      double submittedRate = -1;
      await tester.pumpWidget(createWidgetUnderTest(
        title: 'Gladiator',
        initialRate: 9.0,
        onSubmit: (val) => submittedRate = val,
      ));
      await tester.pumpAndSettle();

      final resetButton = find.widgetWithText(FilledButton, 'Reset rating');
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      expect(submittedRate, 0.0);
    });
  });
}
