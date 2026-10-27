import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviescout/widgets/lists/list_controller.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_title_list_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_base_list_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/models/tmdb_title.dart';
import 'package:moviescout/utils/api_constants.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockTitleListService extends Mock implements TmdbTitleListService {}

class FakeScrollNotification extends Fake implements ScrollNotification {
  @override
  final ScrollMetrics metrics;

  FakeScrollNotification(this.metrics);
}

Widget buildTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: child,
  );
}

void main() {
  late MockTitleListService mockService;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(RatingFilter.all);
    SharedPreferences.setMockInitialValues({});
    await PreferencesService().init();
  });

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    mockService = MockTitleListService();
    when(() => mockService.listName).thenReturn('watchlist');
    when(() => mockService.defaultSortAsc).thenReturn(true);
    when(() => mockService.defaultSort).thenReturn(SortOption.alphabetically);
    when(() => mockService.userRatingAvailable).thenReturn(true);
    when(() => mockService.setSort(any(), any())).thenAnswer((_) {});
    when(() => mockService.setTypeFilter(any())).thenAnswer((_) {});
    when(() => mockService.setTextFilter(any())).thenAnswer((_) {});
    when(() => mockService.setRatingFilter(any())).thenAnswer((_) {});
    when(() => mockService.setProvidersFilter(any(), any())).thenAnswer((_) {});
    when(() => mockService.setGenresFilter(any(), any())).thenAnswer((_) {});
    when(() => mockService.applySortProperties(any(), any()))
        .thenAnswer((_) {});
    when(() => mockService.addListener(any())).thenAnswer((_) {});
    when(() => mockService.removeListener(any())).thenAnswer((_) {});
    when(() => mockService.hasMore).thenReturn(true);
    when(() => mockService.isLoading).thenReturn(ValueNotifier<bool>(false));
    when(() => mockService.loadedItemCount).thenReturn(20);
    when(() => mockService.loadNextPage()).thenAnswer((_) async {});
  });

  testWidgets(
      'ListController resets sort option when userRating is no longer available',
      (WidgetTester tester) async {
    when(() => mockService.userRatingAvailable).thenReturn(false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('watchlist_SelectedSort', SortOption.userRating);

    final controller = ListController(mockService);

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            controller.initializeControlLocalizations(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(controller.selectedSort, SortOption.alphabetically);
    verify(() => mockService.setSort(SortOption.alphabetically, true))
        .called(1);
    controller.dispose();
  });

  testWidgets(
      'ListController resets sort option to relevance when searchList and dateRated no longer available',
      (WidgetTester tester) async {
    when(() => mockService.listName).thenReturn(AppConstants.searchList);
    when(() => mockService.userRatingAvailable).thenReturn(false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${AppConstants.searchList}_SelectedSort', SortOption.dateRated);

    final controller = ListController(mockService);

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            controller.initializeControlLocalizations(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(controller.selectedSort, SortOption.relevance);
    verify(() => mockService.setSort(SortOption.relevance, true)).called(1);
    controller.dispose();
  });

  testWidgets(
      'initializeControlLocalizations sets types and sorts for standard and search list',
      (WidgetTester tester) async {
    final standardController = ListController(mockService);
    late AppLocalizations loc;

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            loc = AppLocalizations.of(context)!;
            standardController.initializeControlLocalizations(context);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(standardController.titleTypes,
        containsAll([loc.allTypes, loc.movies, loc.tvshows, loc.miniseries]));
    expect(standardController.titleSorts, contains(loc.sortAddedOrder));
    expect(standardController.titleSorts, isNot(contains(loc.sortRelevance)));
    standardController.dispose();

    when(() => mockService.listName).thenReturn(AppConstants.searchList);
    final searchController = ListController(mockService);

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            searchController.initializeControlLocalizations(context);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
        searchController.titleTypes,
        containsAll([
          loc.results,
          loc.movies,
          loc.tvshows,
          loc.cast,
          loc.collection,
          loc.users
        ]));
    expect(searchController.titleSorts, contains(loc.sortRelevance));
    expect(searchController.titleSorts, isNot(contains(loc.sortAddedOrder)));
    searchController.dispose();
  });

  test('anyFilterActive reflects genre, provider, text, and rating filters',
      () {
    final controller = ListController(mockService);
    expect(controller.anyFilterActive, isFalse);

    controller.setGenres(['Action'], false);
    expect(controller.anyFilterActive, isTrue);

    controller.setGenres([], false);
    expect(controller.anyFilterActive, isFalse);

    controller.setFilterByProviders(true);
    expect(controller.anyFilterActive, isTrue);

    controller.setFilterByProviders(false);
    expect(controller.anyFilterActive, isFalse);

    controller.setTextFilter('Query');
    verify(() => mockService.setTextFilter('Query')).called(1);

    controller.textFilterController.text = 'Inception';
    expect(controller.anyFilterActive, isTrue);

    controller.textFilterController.text = '';
    expect(controller.anyFilterActive, isFalse);

    controller.setRatingFilter(RatingFilter.seenOnly);
    expect(controller.anyFilterActive, isTrue);

    controller.setRatingFilter(RatingFilter.followingOnly);
    expect(controller.anyFilterActive, isTrue);

    controller.setRatingFilter(RatingFilter.all);
    expect(controller.anyFilterActive, isFalse);

    expect(controller.selectedGenres, isEmpty);
    expect(controller.excludeGenres, isFalse);
    expect(controller.filterByProviders, isFalse);
    expect(controller.ratingFilter, RatingFilter.all);

    controller.dispose();
  });

  test('toggleFilters and toggleSortDirection persist and notify', () {
    final controller = ListController(mockService);
    bool notified = false;
    controller.addListener(() => notified = true);

    expect(controller.showFilters, isFalse);
    controller.toggleFilters();
    expect(controller.showFilters, isTrue);
    expect(notified, isTrue);

    notified = false;
    expect(controller.isSortAsc, isTrue);
    controller.toggleSortDirection();
    expect(controller.isSortAsc, isFalse);
    expect(notified, isTrue);
    verify(() => mockService.setSort(any(), false)).called(1);
    controller.dispose();
  });

  testWidgets(
      'setSelectedSort and getSelectedSortLabel work for all sort options',
      (WidgetTester tester) async {
    final controller = ListController(mockService);
    late BuildContext currentContext;
    late AppLocalizations loc;

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            currentContext = context;
            loc = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ),
    );

    final sortMappings = {
      loc.sortAlphabetically: SortOption.alphabetically,
      loc.sortRelevance: SortOption.relevance,
      loc.sortRating: SortOption.rating,
      loc.sortUserRating: SortOption.userRating,
      loc.sortDateRated: SortOption.dateRated,
      loc.sortReleaseDate: SortOption.releaseDate,
      loc.sortRuntime: SortOption.runtime,
      loc.sortAddedOrder: SortOption.addedOrder,
      'unknown': SortOption.alphabetically,
    };

    for (final entry in sortMappings.entries) {
      controller.setSelectedSort(currentContext, entry.key);
      expect(controller.selectedSort, entry.value);
      expect(controller.getSelectedSortLabel(loc),
          entry.key == 'unknown' ? loc.sortAlphabetically : entry.key);
    }
    controller.dispose();
  });

  testWidgets(
      'setSelectedType and getSelectedTypeLabel work for all media types',
      (WidgetTester tester) async {
    final controller = ListController(mockService);
    late BuildContext currentContext;
    late AppLocalizations loc;

    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            currentContext = context;
            loc = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ),
    );

    final typeMappings = {
      loc.movies: ApiConstants.movie,
      loc.tvshows: ApiConstants.tv,
      loc.miniseries: AppConstants.miniseries,
      loc.cast: ApiConstants.person,
      loc.collection: ApiConstants.collection,
      loc.users: ApiConstants.user,
      loc.allTypes: '',
    };

    for (final entry in typeMappings.entries) {
      controller.setSelectedType(currentContext, entry.key);
      expect(controller.selectedType, entry.value);
      expect(controller.getSelectedTypeLabel(loc), entry.key);
    }
    controller.dispose();
  });

  test('setProviderListIds and setupFilters delegate to listService', () async {
    when(() => mockService.setFilters(
          text: any(named: 'text'),
          type: any(named: 'type'),
          genres: any(named: 'genres'),
          excludeGenres: any(named: 'excludeGenres'),
          filterByProviders: any(named: 'filterByProviders'),
          providerListIds: any(named: 'providerListIds'),
          ratingFilter: any(named: 'ratingFilter'),
          sort: any(named: 'sort'),
          ascending: any(named: 'ascending'),
        )).thenAnswer((_) async {});

    final controller = ListController(mockService);
    controller.setProviderListIds([8, 337]);
    expect(controller.providerListIds, [8, 337]);
    verify(() => mockService.setProvidersFilter(false, [8, 337])).called(1);

    await controller.setupFilters();
    verify(() => mockService.setFilters(
          text: any(named: 'text'),
          type: any(named: 'type'),
          genres: any(named: 'genres'),
          excludeGenres: any(named: 'excludeGenres'),
          filterByProviders: any(named: 'filterByProviders'),
          providerListIds: [8, 337],
          ratingFilter: any(named: 'ratingFilter'),
          sort: any(named: 'sort'),
          ascending: any(named: 'ascending'),
        )).called(1);
    controller.dispose();
  });

  test(
      'onScrollNotification triggers loadNextPage only when conditions are met',
      () {
    final controller = ListController(mockService);

    final triggerMetrics = FixedScrollMetrics(
      minScrollExtent: 0,
      maxScrollExtent: 1000,
      pixels: 850,
      viewportDimension: 500,
      axisDirection: AxisDirection.down,
      devicePixelRatio: 1.0,
    );
    final triggerNotification = FakeScrollNotification(triggerMetrics);

    controller.onScrollNotification(triggerNotification, 50.0);
    verify(() => mockService.loadNextPage()).called(1);

    final zeroScrollMetrics = FixedScrollMetrics(
      minScrollExtent: 0,
      maxScrollExtent: 1000,
      pixels: 0,
      viewportDimension: 500,
      axisDirection: AxisDirection.down,
      devicePixelRatio: 1.0,
    );
    final zeroScrollNotification = FakeScrollNotification(zeroScrollMetrics);
    controller.onScrollNotification(zeroScrollNotification, 50.0);
    verifyNever(() => mockService.loadNextPage());

    when(() => mockService.isLoading).thenReturn(ValueNotifier<bool>(true));
    controller.onScrollNotification(triggerNotification, 50.0);
    verifyNever(() => mockService.loadNextPage());

    controller.dispose();
  });
}
