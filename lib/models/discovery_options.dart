import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviescout/l10n/app_localizations.dart';

enum DiscoveryTheme {
  any,
  space,
  timeTravel,
  dystopiaAi,
  heist,
  whodunit,
  psychologicalThriller,
  superhero,
  zombiesApocalypse,
  supernatural,
  medievalFantasy,
  war,
  adrenalineAction,
  comedy,
  tearjerkerDrama,
  survivalAdventure,
  filmNoirMafia,
}

enum DiscoveryMode {
  forYou,
  hiddenGems,
  topRated,
  newReleases,
}

enum DiscoveryEpoch {
  all,
  e2020s,
  e2010s,
  e2000s,
  e80s90s,
  classics,
}

enum DiscoveryDuration {
  any,
  shortFilm,
  short,
  standard,
  epic,
}

class DiscoveryThemeDefinition {
  final DiscoveryTheme theme;
  final String emoji;
  final List<int> movieGenreIds;
  final List<int> tvGenreIds;
  final List<int> keywordIds;

  const DiscoveryThemeDefinition({
    required this.theme,
    required this.emoji,
    this.movieGenreIds = const [],
    this.tvGenreIds = const [],
    this.keywordIds = const [],
  });
}

class DiscoveryOptions {
  final DiscoveryTheme theme;
  final DiscoveryMode mode;
  final DiscoveryEpoch epoch;
  final DiscoveryDuration duration;
  final bool filterByProviders;

  const DiscoveryOptions({
    this.theme = DiscoveryTheme.any,
    this.mode = DiscoveryMode.forYou,
    this.epoch = DiscoveryEpoch.all,
    this.duration = DiscoveryDuration.any,
    this.filterByProviders = true,
  });

  bool get isDefault =>
      theme == DiscoveryTheme.any &&
      mode == DiscoveryMode.forYou &&
      epoch == DiscoveryEpoch.all &&
      duration == DiscoveryDuration.any;

  DiscoveryOptions copyWith({
    DiscoveryTheme? theme,
    DiscoveryMode? mode,
    DiscoveryEpoch? epoch,
    DiscoveryDuration? duration,
    bool? filterByProviders,
  }) {
    return DiscoveryOptions(
      theme: theme ?? this.theme,
      mode: mode ?? this.mode,
      epoch: epoch ?? this.epoch,
      duration: duration ?? this.duration,
      filterByProviders: filterByProviders ?? this.filterByProviders,
    );
  }

  static DiscoveryOptions loadFromPrefs(SharedPreferences prefs) {
    DiscoveryTheme theme = DiscoveryTheme.any;
    final themeName = prefs.getString('discover_theme');
    if (themeName != null) {
      theme = DiscoveryTheme.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => DiscoveryTheme.any,
      );
    }

    DiscoveryMode mode = DiscoveryMode.forYou;
    final modeName = prefs.getString('discover_mode');
    if (modeName != null) {
      mode = DiscoveryMode.values.firstWhere(
        (e) => e.name == modeName,
        orElse: () => DiscoveryMode.forYou,
      );
    }

    DiscoveryEpoch epoch = DiscoveryEpoch.all;
    final epochName = prefs.getString('discover_epoch');
    if (epochName != null) {
      epoch = DiscoveryEpoch.values.firstWhere(
        (e) => e.name == epochName,
        orElse: () => DiscoveryEpoch.all,
      );
    }

    DiscoveryDuration duration = DiscoveryDuration.any;
    final durationName = prefs.getString('discover_duration');
    if (durationName != null) {
      duration = DiscoveryDuration.values.firstWhere(
        (e) => e.name == durationName,
        orElse: () => DiscoveryDuration.any,
      );
    }

    final filterByProviders =
        prefs.getBool('discover_filter_by_providers') ?? true;

    return DiscoveryOptions(
      theme: theme,
      mode: mode,
      epoch: epoch,
      duration: duration,
      filterByProviders: filterByProviders,
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString('discover_theme', theme.name);
    await prefs.setString('discover_mode', mode.name);
    await prefs.setString('discover_epoch', epoch.name);
    await prefs.setString('discover_duration', duration.name);
    await prefs.setBool('discover_filter_by_providers', filterByProviders);
  }

  static const Map<DiscoveryTheme, DiscoveryThemeDefinition> themes = {
    DiscoveryTheme.any: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.any,
      emoji: '✨',
    ),
    DiscoveryTheme.space: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.space,
      emoji: '🚀',
      movieGenreIds: [878],
      tvGenreIds: [10765],
      keywordIds: [9882, 3801, 4565, 9951, 161176, 2199, 209714],
    ),
    DiscoveryTheme.timeTravel: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.timeTravel,
      emoji: '⏳',
      movieGenreIds: [878],
      tvGenreIds: [10765],
      keywordIds: [4379, 207317, 285775, 18035, 9798, 163053],
    ),
    DiscoveryTheme.dystopiaAi: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.dystopiaAi,
      emoji: '🤖',
      movieGenreIds: [878],
      tvGenreIds: [10765],
      keywordIds: [4563, 310, 12190, 4776, 4458, 2227],
    ),
    DiscoveryTheme.heist: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.heist,
      emoji: '💰',
      movieGenreIds: [80],
      tvGenreIds: [80],
      keywordIds: [10051, 642, 9714, 10053, 11134],
    ),
    DiscoveryTheme.whodunit: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.whodunit,
      emoji: '🔍',
      movieGenreIds: [9648],
      tvGenreIds: [9648],
      keywordIds: [210024, 9713, 703, 9826, 209174],
    ),
    DiscoveryTheme.psychologicalThriller: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.psychologicalThriller,
      emoji: '🔪',
      movieGenreIds: [53],
      tvGenreIds: [9648, 80],
      keywordIds: [12554, 10714, 1852, 9840, 10700],
    ),
    DiscoveryTheme.superhero: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.superhero,
      emoji: '🦸',
      movieGenreIds: [28, 878],
      tvGenreIds: [10759, 10765],
      keywordIds: [9715, 9717, 180547, 229266],
    ),
    DiscoveryTheme.zombiesApocalypse: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.zombiesApocalypse,
      emoji: '🧟',
      movieGenreIds: [27],
      tvGenreIds: [10765],
      keywordIds: [12377, 186565, 209594, 10349],
    ),
    DiscoveryTheme.supernatural: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.supernatural,
      emoji: '👻',
      movieGenreIds: [27],
      tvGenreIds: [9648, 10765],
      keywordIds: [10224, 9712, 9716, 9726, 10683],
    ),
    DiscoveryTheme.medievalFantasy: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.medievalFantasy,
      emoji: '⚔️',
      movieGenreIds: [14],
      tvGenreIds: [10765],
      keywordIds: [4152, 1701, 11417, 13084, 14758],
    ),
    DiscoveryTheme.war: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.war,
      emoji: '🎖️',
      movieGenreIds: [10752],
      tvGenreIds: [10768],
      keywordIds: [1956, 6091, 5619, 1826, 10322, 2956],
    ),
    DiscoveryTheme.adrenalineAction: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.adrenalineAction,
      emoji: '🏎️',
      movieGenreIds: [28],
      tvGenreIds: [10759],
      keywordIds: [818, 779, 5565, 9825, 9748],
    ),
    DiscoveryTheme.comedy: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.comedy,
      emoji: '😂',
      movieGenreIds: [35],
      tvGenreIds: [35],
      keywordIds: [9727, 10292, 9724],
    ),
    DiscoveryTheme.tearjerkerDrama: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.tearjerkerDrama,
      emoji: '💔',
      movieGenreIds: [18],
      tvGenreIds: [18],
      keywordIds: [12392, 242698, 225571],
    ),
    DiscoveryTheme.survivalAdventure: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.survivalAdventure,
      emoji: '🏝️',
      movieGenreIds: [12],
      tvGenreIds: [10759],
      keywordIds: [10349, 4426, 10085, 2673],
    ),
    DiscoveryTheme.filmNoirMafia: DiscoveryThemeDefinition(
      theme: DiscoveryTheme.filmNoirMafia,
      emoji: '🕵️',
      movieGenreIds: [80],
      tvGenreIds: [80],
      keywordIds: [10756, 9706, 10183, 10084, 10754],
    ),
  };

  static String getThemeLabel(BuildContext context, DiscoveryTheme theme) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return theme.name;
    switch (theme) {
      case DiscoveryTheme.any:
        return l10n.discoveryThemeAny;
      case DiscoveryTheme.space:
        return l10n.discoveryThemeSpace;
      case DiscoveryTheme.timeTravel:
        return l10n.discoveryThemeTimeTravel;
      case DiscoveryTheme.dystopiaAi:
        return l10n.discoveryThemeDystopiaAi;
      case DiscoveryTheme.heist:
        return l10n.discoveryThemeHeist;
      case DiscoveryTheme.whodunit:
        return l10n.discoveryThemeWhodunit;
      case DiscoveryTheme.psychologicalThriller:
        return l10n.discoveryThemePsychologicalThriller;
      case DiscoveryTheme.superhero:
        return l10n.discoveryThemeSuperhero;
      case DiscoveryTheme.zombiesApocalypse:
        return l10n.discoveryThemeZombiesApocalypse;
      case DiscoveryTheme.supernatural:
        return l10n.discoveryThemeSupernatural;
      case DiscoveryTheme.medievalFantasy:
        return l10n.discoveryThemeMedievalFantasy;
      case DiscoveryTheme.war:
        return l10n.discoveryThemeWar;
      case DiscoveryTheme.adrenalineAction:
        return l10n.discoveryThemeAdrenalineAction;
      case DiscoveryTheme.comedy:
        return l10n.discoveryThemeComedy;
      case DiscoveryTheme.tearjerkerDrama:
        return l10n.discoveryThemeTearjerkerDrama;
      case DiscoveryTheme.survivalAdventure:
        return l10n.discoveryThemeSurvivalAdventure;
      case DiscoveryTheme.filmNoirMafia:
        return l10n.discoveryThemeFilmNoirMafia;
    }
  }

  static String getModeLabel(BuildContext context, DiscoveryMode mode) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return mode.name;
    switch (mode) {
      case DiscoveryMode.forYou:
        return l10n.discoveryModeForYou;
      case DiscoveryMode.hiddenGems:
        return l10n.discoveryModeHiddenGems;
      case DiscoveryMode.topRated:
        return l10n.discoveryModeTopRated;
      case DiscoveryMode.newReleases:
        return l10n.discoveryModeNewReleases;
    }
  }

  static String getEpochLabel(BuildContext context, DiscoveryEpoch epoch) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return epoch.name;
    switch (epoch) {
      case DiscoveryEpoch.all:
        return l10n.discoveryEpochAll;
      case DiscoveryEpoch.e2020s:
        return l10n.discoveryEpoch2020s;
      case DiscoveryEpoch.e2010s:
        return l10n.discoveryEpoch2010s;
      case DiscoveryEpoch.e2000s:
        return l10n.discoveryEpoch2000s;
      case DiscoveryEpoch.e80s90s:
        return l10n.discoveryEpoch80s90s;
      case DiscoveryEpoch.classics:
        return l10n.discoveryEpochClassics;
    }
  }

  static String getDurationLabel(
      BuildContext context, DiscoveryDuration duration) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return duration.name;
    switch (duration) {
      case DiscoveryDuration.any:
        return l10n.discoveryDurationAny;
      case DiscoveryDuration.shortFilm:
        return l10n.discoveryDurationShortFilm;
      case DiscoveryDuration.short:
        return l10n.discoveryDurationShort;
      case DiscoveryDuration.standard:
        return l10n.discoveryDurationStandard;
      case DiscoveryDuration.epic:
        return l10n.discoveryDurationEpic;
    }
  }
}
