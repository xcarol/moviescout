import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:moviescout/main.dart';
import 'package:moviescout/features/titles/models/tmdb_title.dart';
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:moviescout/core/theme/theme_service.dart';
import 'package:moviescout/core/utils/api_constants.dart';
import 'package:moviescout/features/watchlist/widgets/watchlist_button.dart';

class MockWatchlistService extends Mock implements WatchlistService {}

class MockSupabaseAuthService extends Mock implements SupabaseAuthService {}

class FakeTmdbTitle extends Fake implements TmdbTitle {}

void main() {
  late MockWatchlistService mockWatchlistService;
  late MockAuthServiceWrapper mockAuthService;
  late TmdbTitle testTitle;

  setUpAll(() {
    registerFallbackValue(FakeTmdbTitle());
  });

  setUp(() {
    mockWatchlistService = MockWatchlistService();
    mockAuthService = MockAuthServiceWrapper();
    testTitle = TmdbTitle(
      tmdbId: 42,
      name: 'Test Movie',
      mediaType: ApiConstants.movie,
      lastUpdated: '2026-01-01',
      dateRated: DateTime.fromMillisecondsSinceEpoch(0),
    );
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WatchlistService>.value(
          value: mockWatchlistService,
        ),
        ChangeNotifierProvider<SupabaseAuthService>.value(
          value: mockAuthService,
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(extensions: [ThemeService.lightCustomColorsDefault]),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: Builder(
            builder: (context) => watchlistButton(context, testTitle),
          ),
        ),
      ),
    );
  }

  group('watchlistButton Widget Tests', () {
    testWidgets('shows highlight_off icon when user is logged out',
        (tester) async {
      mockAuthService.loggedInState = false;
      when(() => mockWatchlistService.contains(testTitle))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.highlight_off), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(
          find.text('User must be logged in to add titles.'), findsOneWidget);
      verifyNever(
          () => mockWatchlistService.updateWatchlistTitle(any(), any()));
    });

    testWidgets(
        'calls updateWatchlistTitle(title, true) when logged in and not in watchlist',
        (tester) async {
      mockAuthService.loggedInState = true;
      when(() => mockWatchlistService.contains(testTitle))
          .thenAnswer((_) async => false);
      when(() => mockWatchlistService.updateWatchlistTitle(testTitle, true))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.remove_red_eye);
      expect(iconFinder, findsOneWidget);

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.color,
          ThemeService.lightCustomColorsDefault.notInWatchlist);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(() => mockWatchlistService.updateWatchlistTitle(testTitle, true))
          .called(1);
    });

    testWidgets(
        'calls updateWatchlistTitle(title, false) when logged in and in watchlist',
        (tester) async {
      mockAuthService.loggedInState = true;
      when(() => mockWatchlistService.contains(testTitle))
          .thenAnswer((_) async => true);
      when(() => mockWatchlistService.updateWatchlistTitle(testTitle, false))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(Icons.remove_red_eye);
      expect(iconFinder, findsOneWidget);

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(
          iconButton.color, ThemeService.lightCustomColorsDefault.inWatchlist);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(() => mockWatchlistService.updateWatchlistTitle(testTitle, false))
          .called(1);
    });
  });
}

class MockAuthServiceWrapper extends ChangeNotifier
    implements SupabaseAuthService {
  bool loggedInState = false;

  @override
  bool get isLoggedIn => loggedInState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
