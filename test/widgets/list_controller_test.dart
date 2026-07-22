import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviescout/widgets/lists/list_controller.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockTmdbTitleListService extends Mock implements TmdbTitleListService {}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'watchlist_SelectedSort': SortOption.userRating,
    });
    await PreferencesService().init();
  });

  testWidgets(
      'ListController resets sort option when userRating is no longer available',
      (WidgetTester tester) async {
    final mockService = MockTmdbTitleListService();
    when(() => mockService.listName).thenReturn('watchlist');
    when(() => mockService.defaultSortAsc).thenReturn(false);
    when(() => mockService.defaultSort).thenReturn(SortOption.addedOrder);
    when(() => mockService.userRatingAvailable).thenReturn(false);
    when(() => mockService.setSort(any(), any())).thenAnswer((_) {});

    // Force SharedPreferences specifically for this test
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('watchlist_SelectedSort', SortOption.userRating);

    final controller = ListController(mockService);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Builder(
          builder: (context) {
            if (AppLocalizations.of(context) == null) {
              return const SizedBox();
            }
            controller.initializeControlLocalizations(context);
            return const SizedBox();
          },
        ),
      ),
    );

    // After post frame callback, it should reset to alphabetically
    await tester.pumpAndSettle();
    expect(controller.selectedSort, SortOption.alphabetically);
    verify(() => mockService.setSort(SortOption.alphabetically, any()))
        .called(1);
  });
}
