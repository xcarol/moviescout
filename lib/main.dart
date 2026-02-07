import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart'
    show PlatformDispatcher, TargetPlatform, defaultTargetPlatform, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/services/discoverlist_service.dart';
import 'package:moviescout/services/isar_service.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/language_service.dart';
import 'package:moviescout/services/theme_service.dart';
import 'package:moviescout/services/tmdb_genre_service.dart';
import 'package:moviescout/services/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/region_service.dart';
import 'package:moviescout/services/tmdb_pinned_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/firebase_options.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/screens/main_screen.dart';
import 'package:moviescout/services/deep_link_service.dart';
import 'package:moviescout/utils/person_translator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/watchlist_update_worker.dart';
import 'package:moviescout/services/notification_service.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kDebugMode);
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  try {
    await dotenv.load(fileName: ".env");
    await PreferencesService().init();
    await IsarService.init();
    await TmdbGenreService().init();
    await RegionService().init();
    await PersonTranslator.init();
    await NotificationService().init();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      await Workmanager().registerPeriodicTask(
        "watchlistUpdateTask",
        "updateWatchlistProviders",
        frequency: const Duration(hours: 24),
        existingWorkPolicy: ExistingWorkPolicy.keep,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    }
  } catch (e) {
    debugPrint('Service initialization failed: $e');
  }

  debugPrint('Running Movie Scout...');
  final repository = TmdbTitleRepository();
  final preferencesService = PreferencesService();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: repository),
      Provider.value(value: preferencesService),
      ChangeNotifierProvider(create: (_) => ThemeService()),
      ChangeNotifierProvider(create: (_) => LanguageService()),
      ChangeNotifierProvider(create: (_) => RegionService()),
      ChangeNotifierProvider(create: (_) => TmdbUserService()),
      ChangeNotifierProxyProvider<TmdbUserService, TmdbProviderService>(
        create: (_) => TmdbProviderService(),
        update: (_, userService, providerService) => providerService!
          ..setup(userService.accountId, userService.sessionId,
              userService.accessToken),
      ),
      ChangeNotifierProxyProvider<TmdbUserService, TmdbPinnedService>(
        create: (_) => TmdbPinnedService(repository, preferencesService),
        update: (_, userService, pinnedService) => pinnedService!
          ..setup(userService.accountId, userService.sessionId,
              userService.accessToken),
      ),
      ChangeNotifierProvider(
          create: (_) => TmdbRateslistService(
              AppConstants.rateslist, repository, preferencesService)),
      ChangeNotifierProxyProvider2<TmdbRateslistService, TmdbPinnedService,
          TmdbWatchlistService>(
        create: (_) => TmdbWatchlistService(
            AppConstants.watchlist, repository, preferencesService),
        update: (_, rateslistService, pinnedService, watchlistService) {
          rateslistService.removeListener(watchlistService!.refresh);
          rateslistService.addListener(watchlistService.refresh);
          watchlistService.pinnedService = pinnedService;
          return watchlistService;
        },
      ),
      ChangeNotifierProxyProvider2<TmdbRateslistService, TmdbWatchlistService,
          TmdbDiscoverlistService>(
        create: (_) => TmdbDiscoverlistService(
            AppConstants.discoverlist, repository, preferencesService),
        update: (_, rateslistService, watchlistService, discoverlistService) {
          rateslistService.removeListener(discoverlistService!.refresh);
          watchlistService.removeListener(discoverlistService.refresh);
          rateslistService.addListener(discoverlistService.refresh);
          watchlistService.addListener(discoverlistService.refresh);
          return discoverlistService;
        },
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final watchlistService =
        Provider.of<TmdbWatchlistService>(context, listen: false);
    DeepLinkService().init(watchlistService);
    NotificationService().handleColdStartNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);
    final languageProvider = Provider.of<LanguageService>(context);
    themeProvider.setupTheme();
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    userService.setup();

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLanguages
          .map((e) => LanguageService.parseLocale(e))
          .toList(),
      locale: languageProvider.locale,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: themeProvider.lightColorScheme,
        scrollbarTheme: themeProvider.lightScrollbarTheme,
        extensions: <ThemeExtension<dynamic>>[
          themeProvider.lightCustomColors,
          themeProvider.lightTitleListTheme,
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: themeProvider.darkColorScheme,
        scrollbarTheme: themeProvider.darkScrollbarTheme,
        extensions: <ThemeExtension<dynamic>>[
          themeProvider.darkCustomColors,
          themeProvider.darkTitleListTheme,
        ],
      ),
      themeMode: ThemeMode.system,
      title: 'Movie Scout',
      home: const MainScreen(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: DeepLinkService().navigatorKey,
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final theme = Theme.of(context);
          final iconBrightness = theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;
          final backgroundColor = theme.colorScheme.onPrimary;

          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: backgroundColor,
              systemNavigationBarIconBrightness: iconBrightness,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconBrightness,
            ),
          );
        });

        return child!;
      },
    );
  }
}
