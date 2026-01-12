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
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:moviescout/utils/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/firebase_options.dart';
import 'package:moviescout/repositories/tmdb_title_repository.dart';
import 'package:moviescout/screens/main_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await dotenv.load(fileName: ".env");
  await PreferencesService().init();
  await IsarService.init();
  await TmdbGenreService().init();

  final repository = TmdbTitleRepository();
  final preferencesService = PreferencesService();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: repository),
      Provider.value(value: preferencesService),
      ChangeNotifierProvider(create: (_) => ThemeService()),
      ChangeNotifierProvider(create: (_) => LanguageService()),
      ChangeNotifierProvider(create: (_) => TmdbUserService()),
      ChangeNotifierProxyProvider<TmdbUserService, TmdbProviderService>(
        create: (_) => TmdbProviderService(),
        update: (_, userService, providerService) => providerService!
          ..setup(userService.accountId, userService.sessionId,
              userService.accessToken),
      ),
      ChangeNotifierProvider(
          create: (_) => TmdbWatchlistService(
              AppConstants.watchlist, repository, preferencesService)),
      ChangeNotifierProvider(
          create: (_) => TmdbRateslistService(
              AppConstants.rateslist, repository, preferencesService)),
      ChangeNotifierProvider(
          create: (_) => TmdbDiscoverlistService(
              AppConstants.discoverlist, repository, preferencesService)),
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
