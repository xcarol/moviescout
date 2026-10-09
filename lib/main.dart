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
import 'package:moviescout/services/tmdb_lists/discoverlist_service.dart';
import 'package:moviescout/services/core/error_service.dart';
import 'package:moviescout/repositories/cloud_title_repository.dart';
import 'package:moviescout/repositories/local_title_repository.dart';
import 'package:moviescout/services/core/cloud_database_service.dart';
import 'package:moviescout/services/core/local_database_service.dart';
import 'package:moviescout/services/system/app_lifecycle_service.dart';
import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/services/settings/language_service.dart';
import 'package:moviescout/services/settings/theme_service.dart';
import 'package:moviescout/services/settings/background_tasks_service.dart';
import 'package:moviescout/services/core/tmdb_configuration_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_genre_service.dart';
import 'package:moviescout/services/api/web_translation_service.dart';
import 'package:moviescout/services/tmdb_content/tmdb_provider_service.dart';
import 'package:moviescout/services/tmdb_lists/tmdb_user_service.dart';
import 'package:moviescout/services/settings/region_service.dart';
import 'package:moviescout/services/lists/pinned_service.dart';
import 'package:moviescout/services/lists/following_service.dart';
import "package:moviescout/services/lists/watchlist_service.dart";
import "package:moviescout/services/lists/rateslist_service.dart";
import 'package:moviescout/services/auth/supabase_auth_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/firebase_options.dart';
import 'package:moviescout/screens/main_screen.dart';
import 'package:moviescout/services/system/deep_link_service.dart';
import 'package:moviescout/utils/country_translator.dart';
import 'package:moviescout/utils/language_translator.dart';
import 'package:moviescout/utils/person_translator.dart';
import 'package:moviescout/utils/genre_translator.dart';
import 'package:moviescout/utils/status_translator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:moviescout/services/notifications/notification_service.dart';
import 'package:moviescout/services/workers/watchlist_update_service.dart';
import 'package:moviescout/services/settings/edit_settings_service.dart';
import 'package:app_links/app_links.dart';
import 'package:moviescout/widgets/misc/shortcut_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviescout/services/workers/uninitialized_titles_worker.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

@pragma('vm:entry-point')
void mainShortcut() {
  _runMain(isFromShortcutActivity: true);
}

void main(List<String> args) async {
  _runMain(isFromShortcutActivity: args.contains('--from-shortcut-activity'));
}

void _runMain({bool isFromShortcutActivity = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final appLinks = AppLinks();
  Uri? initialUri = await appLinks.getInitialLink();

  if (isFromShortcutActivity && initialUri == null) {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('last_shortcut_uri');
    if (saved != null) {
      initialUri = Uri.tryParse(saved);
    }
  }

  final isShortcut = isFromShortcutActivity;

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
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kDebugMode,
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
      CountryTranslator.init(),
      LanguageTranslator.init(),
      PersonTranslator.init(),
      GenreTranslator.init(),
      StatusTranslator.init(),
      NotificationService().init(),
      EditSettingsService().init(),
    ]).timeout(const Duration(seconds: 5), onTimeout: () => []);

    if (!isShortcut &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        await Workmanager().initialize(
          callbackDispatcher,
        );
        WatchlistUpdateService().setupWorker();
      } catch (e) {
        // Ignore Workmanager initialization errors (especially in separate processes)
      }
    }
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error app initializing services',
      stackTrace: stackTrace,
    );
  }

  final repository = LocalTitleRepository();
  final cloudRepository = CloudTitleRepository();

  if (!isShortcut) {
    UninitializedTitlesWorker.dispatch();
  }

  runApp(MultiProvider(
    providers: [
      Provider.value(value: repository),
      Provider.value(value: cloudRepository),
      ChangeNotifierProvider(create: (_) => LanguageService()),
      ChangeNotifierProvider(create: (_) => RegionService()),
      ChangeNotifierProvider(create: (_) => SupabaseAuthService()),
      ChangeNotifierProvider(create: (_) => TmdbUserService()),
      ChangeNotifierProxyProvider2<TmdbUserService, SupabaseAuthService,
          TmdbProviderService>(
        create: (_) => TmdbProviderService(cloudRepository: cloudRepository),
        update: (_, userService, authService, providerService) =>
            providerService!
              ..setup(userService.accountId, userService.sessionId,
                  userService.accessToken),
      ),
      ChangeNotifierProvider<PinnedService>(
        create: (_) =>
            PinnedService(repository, cloudRepository: cloudRepository),
      ),
      ChangeNotifierProvider<FollowingService>(
        create: (_) =>
            FollowingService(repository, cloudRepository: cloudRepository),
      ),
      ChangeNotifierProxyProvider2<FollowingService, SupabaseAuthService,
          RateslistService>(
        create: (_) =>
            RateslistService(repository, cloudRepository: cloudRepository),
        update: (_, followingService, authService, rateslistService) {
          rateslistService!.followingService = followingService;
          rateslistService.updateAuth(authService);
          return rateslistService;
        },
      ),
      ChangeNotifierProxyProvider3<RateslistService, PinnedService,
          SupabaseAuthService, WatchlistService>(
        create: (_) =>
            WatchlistService(repository, cloudRepository: cloudRepository),
        update: (_, rateslistService, pinnedService, authService,
            watchlistService) {
          rateslistService.removeListener(watchlistService!.refresh);
          rateslistService.addListener(watchlistService.refresh);
          watchlistService.pinnedService = pinnedService;
          watchlistService.updateAuth(authService);
          return watchlistService;
        },
      ),
      ChangeNotifierProxyProvider2<RateslistService, WatchlistService,
          TmdbDiscoverlistService>(
        create: (_) =>
            TmdbDiscoverlistService(AppConstants.discoverlist, repository),
        update: (_, rateslistService, watchlistService, discoverlistService) {
          rateslistService.removeListener(discoverlistService!.refresh);
          watchlistService.removeListener(discoverlistService.refresh);
          rateslistService.addListener(discoverlistService.refresh);
          watchlistService.addListener(discoverlistService.refresh);
          return discoverlistService;
        },
      ),
      ChangeNotifierProvider(create: (_) => NotificationService()),
      ChangeNotifierProvider(create: (_) => EditSettingsService()),
      ChangeNotifierProvider(create: (_) => WebTranslationService()),
    ],
    child: MyApp(isShortcut: isShortcut, initialUri: initialUri),
  ));
}

class MyApp extends StatefulWidget {
  final bool isShortcut;
  final Uri? initialUri;

  const MyApp({super.key, this.isShortcut = false, this.initialUri});

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
    DeepLinkService().isShortcutMode = widget.isShortcut;
    DeepLinkService().init(watchlistService);
    NotificationService().handleColdStartNotification();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      Future.delayed(const Duration(seconds: 1), () {
        NotificationService().requestPermissionOnFirstLaunch();
      });
    }

    final themeProvider = ThemeService();
    themeProvider.setupTheme();
    final userService = Provider.of<TmdbUserService>(context, listen: false);
    userService.setup();

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
    } catch (_) {}

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
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageService>(context);
    final themeProvider = ThemeService();

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
      title: 'MovieScout',
      home: widget.isShortcut
          ? (widget.initialUri != null
              ? ShortcutRouter(uri: widget.initialUri!)
              : const Scaffold(body: Center(child: Text('Shortcut not found'))))
          : const MainScreen(),
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
        return null;
      },
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final statusBarBrightness = Brightness.light;
          final navBarBrightness = Brightness.light;

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              systemNavigationBarIconBrightness: navBarBrightness,
              statusBarColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
              statusBarIconBrightness: statusBarBrightness,
            ),
          );
        });

        return child!;
      },
    );
  }
}
