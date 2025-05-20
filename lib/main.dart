import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart'
    show PlatformDispatcher, TargetPlatform, defaultTargetPlatform, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviescout/models/custom_colors.dart';
import 'package:moviescout/services/preferences_service.dart';
import 'package:moviescout/services/tmbd_genre_servcie.dart';
import 'package:moviescout/services/tmdb_rateslist_service.dart';
import 'package:moviescout/services/tmdb_user_service.dart';
import 'package:moviescout/services/tmdb_watchlist_service.dart';
import 'package:provider/provider.dart';
import 'package:moviescout/firebase_options.dart';
import 'package:moviescout/screens/watch_list.dart';

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
  await TmdbGenreService().init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TmdbUserService()),
      ChangeNotifierProvider(create: (_) => TmdbWatchlistService('watchlist')),
      ChangeNotifierProvider(create: (_) => TmdbRateslistService('rateslist')),
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
  final seedColor = Color(0xFF0000FF);

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
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ca', 'ES'),
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            inWatchlist: Colors.orange,
            notInWatchlist: Colors.blueGrey,
            ratedTitle: Colors.orange,
          ),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            inWatchlist: Colors.amber,
            notInWatchlist: Colors.grey,
            ratedTitle: Colors.amber,
          ),
        ],
      ),
      themeMode: ThemeMode.system,
      title: 'Movie Scout',
      home: const WatchList(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final theme = Theme.of(context);
          final iconBrightness = theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;
          final backgroundColor = theme.colorScheme.primary;

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
