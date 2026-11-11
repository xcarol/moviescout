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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moviescout/features/discovery/services/discoverlist_service.dart';
import 'package:moviescout/core/services/error_service.dart';
import 'package:moviescout/features/titles/repositories/cloud_title_repository.dart';
import 'package:moviescout/features/titles/repositories/local_title_repository.dart';
import 'package:moviescout/core/services/cloud_database_service.dart';
import 'package:moviescout/core/services/local_database_service.dart';
import 'package:moviescout/features/settings/services/app_lifecycle_service.dart';
import 'package:moviescout/features/settings/services/preferences_service.dart';
import 'package:moviescout/features/settings/services/language_service.dart';
import 'package:moviescout/core/theme/theme_service.dart';
import 'package:moviescout/core/theme/app_theme.dart';
import 'package:moviescout/features/settings/services/background_tasks_service.dart';
import 'package:moviescout/core/services/tmdb_configuration_service.dart';
import 'package:moviescout/features/discovery/services/tmdb_genre_service.dart';
import 'package:moviescout/features/settings/services/ai_service.dart';
import 'package:moviescout/core/services/web_translation_service.dart';
import 'package:moviescout/features/settings/services/tmdb_provider_service.dart';
import 'package:moviescout/features/settings/services/region_service.dart';
import 'package:moviescout/features/watchlist/services/pinned_service.dart';
import 'package:moviescout/features/watchlist/services/following_service.dart';
import 'package:moviescout/features/watchlist/services/user_following_service.dart';
import "package:moviescout/features/watchlist/services/watchlist_service.dart";
import "package:moviescout/features/watchlist/services/rateslist_service.dart";
import 'package:moviescout/features/auth/services/supabase_auth_service.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/firebase_options.dart';
import 'package:moviescout/features/home/screens/main_screen.dart';
import 'package:moviescout/core/navigation/deep_link_service.dart';
import 'package:moviescout/core/utils/metadata_translator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/features/notifications/services/notification_service.dart';
import 'package:moviescout/features/watchlist/services/watchlist_update_service.dart';
import 'package:moviescout/core/services/app_service.dart';
import 'package:moviescout/features/watchlist/services/uninitialized_titles_worker.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

@pragma('vm:entry-point')
void mainShortcut() {
  _runMain();
}

void main(List<String> args) async {
  _runMain();
}

void _runMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (Firebase.apps.isEmpty) {
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } catch (e) {
          if (e.toString().contains('duplicate-app')) {
            await Firebase.initializeApp();
          } else {
            rethrow;
          }
        }
      }

      FlutterError.onError = (errorDetails) {
        if (ErrorService.isNetworkError(errorDetails.exception)) {
          ErrorService.log(
            errorDetails.exception,
            stackTrace: errorDetails.stack,
          );
          return;
        }
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        if (ErrorService.isNetworkError(error)) {
          ErrorService.log(error, stackTrace: stack);
          return true;
        }
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );
    }
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error initializing Firebase',
      stackTrace: stackTrace,
      reportToCrashlytics: false,
    );
  }

  try {
    await Future.wait([
      dotenv.load(fileName: ".env"),
      PreferencesService().init(),
      LocalDatabaseService.init(),
    ]);

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      publishableKey: dotenv.env['SUPABASE_API_KEY'] ?? '',
    );
    CloudDatabaseService.init();
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error basic initializing services',
      stackTrace: stackTrace,
    );
  }

  debugPrint('Running MovieScout...');

  try {
    await Future.wait([
      RegionService().init(),
      TmdbGenreService().init(),
      TmdbConfigurationService().init(),
      MetadataTranslator.init(),
      NotificationService().init(),
      AppService().init(),
      AiService().init(),
    ]).timeout(const Duration(seconds: 5), onTimeout: () => []);

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        await Workmanager().initialize(
          callbackDispatcher,
        );
        WatchlistUpdateService().setupWorker();
      } catch (e, stackTrace) {
        ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
      }
    }
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error app initializing services',
      stackTrace: stackTrace,
    );
  }

  final repository = LocalTitleRepository.instance;
  final cloudRepository = CloudTitleRepository.instance;

  final tmdbProviderService =
      TmdbProviderService(cloudRepository: cloudRepository);
  final rateslistService =
      RateslistService(repository, cloudRepository: cloudRepository);
  final watchlistService =
      WatchlistService(repository, cloudRepository: cloudRepository);
  final discoverlistService =
      TmdbDiscoverlistService(AppConstants.discoverlist, repository);

  rateslistService.addListener(watchlistService.refresh);
  rateslistService.addListener(discoverlistService.refresh);
  watchlistService.addListener(discoverlistService.refresh);

  AppService().attachServices(
    watchlistService: watchlistService,
    rateslistService: rateslistService,
    discoverlistService: discoverlistService,
    providerService: tmdbProviderService,
  );

  UninitializedTitlesWorker.dispatch();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: ThemeService()),
      ChangeNotifierProvider(create: (_) => LanguageService()),
      ChangeNotifierProvider(create: (_) => RegionService()),
      ChangeNotifierProvider(create: (_) => SupabaseAuthService()),
      ChangeNotifierProxyProvider<SupabaseAuthService, TmdbProviderService>(
        create: (_) => tmdbProviderService,
        update: (_, authService, providerService) => providerService!..setup(),
      ),
      ChangeNotifierProvider<PinnedService>(
        create: (_) =>
            PinnedService(repository, cloudRepository: cloudRepository),
      ),
      ChangeNotifierProvider<FollowingService>(
        create: (_) =>
            FollowingService(repository, cloudRepository: cloudRepository),
      ),
      ChangeNotifierProxyProvider<SupabaseAuthService, UserFollowingService>(
        create: (_) => UserFollowingService(),
        update: (_, authService, userFollowingService) {
          userFollowingService!.updateAuth(authService);
          return userFollowingService;
        },
      ),
      ChangeNotifierProxyProvider2<FollowingService, SupabaseAuthService,
          RateslistService>(
        create: (_) => rateslistService,
        update: (_, followingService, authService, rateslistService) {
          rateslistService!.followingService = followingService;
          rateslistService.updateAuth(authService);
          return rateslistService;
        },
      ),
      ChangeNotifierProxyProvider2<PinnedService, SupabaseAuthService,
          WatchlistService>(
        create: (_) => watchlistService,
        update: (_, pinnedService, authService, watchlistService) {
          watchlistService!.pinnedService = pinnedService;
          watchlistService.updateAuth(authService);
          return watchlistService;
        },
      ),
      ChangeNotifierProvider<TmdbDiscoverlistService>.value(
        value: discoverlistService,
      ),
      ChangeNotifierProvider(create: (_) => NotificationService()),
      ChangeNotifierProvider(create: (_) => AppService()),
      ChangeNotifierProvider(create: (_) => WebTranslationService()),
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
    AppLifecycleService.instance.init();

    final watchlistService =
        Provider.of<WatchlistService>(context, listen: false);
    DeepLinkService().init(watchlistService);
    NotificationService().handleColdStartNotification();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      Future.delayed(const Duration(seconds: 1), () {
        NotificationService().requestPermissionOnFirstLaunch();
      });
    }

    final themeProvider = ThemeService();
    themeProvider.init();

    final regionProvider = Provider.of<RegionService>(context, listen: false);
    regionProvider.addListener(_onRegionChanged);
  }

  void _onRegionChanged() async {
    if (!mounted) return;
    final providerService =
        Provider.of<TmdbProviderService>(context, listen: false);
    await providerService.reloadProviders();
  }

  @override
  void dispose() {
    try {
      final regionProvider = Provider.of<RegionService>(context, listen: false);
      regionProvider.removeListener(_onRegionChanged);
    } catch (e, stackTrace) {
      ErrorService.log(e, stackTrace: stackTrace, reportToCrashlytics: false);
    }

    AppLifecycleService.instance.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService().checkSystemPermission();
      final regionService = RegionService();
      if (regionService.manualRegion == null) {
        regionService.detectRegion();
      }

      final watchlistService =
          Provider.of<WatchlistService>(context, listen: false);
      if (!watchlistService.hasLoadedItems) {
        watchlistService.filterItems();
      }
      final rateslistService =
          Provider.of<RateslistService>(context, listen: false);
      if (!rateslistService.hasLoadedItems) {
        rateslistService.filterItems();
      }
    }
  }

  @override
  Future<bool> didPushRoute(String route) async {
    return true;
  }

  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    return true;
  }

  @override
  Future<bool> didPopRoute() async {
    if (DeepLinkService().isExternalRouteAtTop) {
      DeepLinkService.moveToBackground();
      return true;
    }
    return false;
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageService>(context);
    final themeProvider = Provider.of<ThemeService>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
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
      theme: AppTheme.buildTheme(
        brightness: Brightness.light,
        themeService: themeProvider,
      ),
      darkTheme: AppTheme.buildTheme(
        brightness: Brightness.dark,
        themeService: themeProvider,
      ),
      title: 'MovieScout',
      home: const MainScreen(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: DeepLinkService().navigatorKey,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        if (settings.name == '/callback') {
          return PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
              return const SizedBox.shrink();
            },
          );
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        );
      },
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final iconBrightness = isDark ? Brightness.light : Brightness.dark;

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              systemNavigationBarIconBrightness: iconBrightness,
              statusBarColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
              statusBarIconBrightness: iconBrightness,
            ),
          );
        });

        return child!;
      },
    );
  }
}
