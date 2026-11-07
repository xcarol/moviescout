import 'package:moviescout/services/settings/preferences_service.dart';
import 'package:moviescout/utils/app_constants.dart';

// TODO: Delete when the promo ends
// Encapsulates temporary promotion, badge, and onboarding logic for the Discover tab.
// Deleting this file will cause compilation errors at every call site that needs cleanup.
class DiscoverPromotionManager {
  static const String _hasSeenDiscoverBadge = 'has_seen_discover_badge';
  static const String _hasDismissedDiscoverPromo =
      'has_dismissed_discover_promo';
  static const String _hasIntroducedNewDiscoverV1 =
      'has_introduced_new_discover_v1';

  static bool get shouldShowTabBadge {
    return !(PreferencesService().prefs.getBool(_hasSeenDiscoverBadge) ??
        false);
  }

  static void markTabBadgeSeen() {
    PreferencesService().prefs.setBool(_hasSeenDiscoverBadge, true);
  }

  static bool get shouldShowPromoCard {
    final prefs = PreferencesService().prefs;
    final hasDismissed = prefs.getBool(_hasDismissedDiscoverPromo) ?? false;
    final hasSeenTab = prefs.getBool(_hasSeenDiscoverBadge) ?? false;
    return !hasDismissed && !hasSeenTab;
  }

  static void dismissPromoCard() {
    PreferencesService().prefs.setBool(_hasDismissedDiscoverPromo, true);
  }

  static void markDiscoverTabVisited() {
    markTabBadgeSeen();
    dismissPromoCard();
  }

  static bool shouldAutoExpandFilters(String listName) {
    if (listName != AppConstants.discoverlist) return false;
    final prefs = PreferencesService().prefs;
    final hasIntroduced = prefs.getBool(_hasIntroducedNewDiscoverV1) ?? false;
    if (!hasIntroduced) {
      prefs.setBool(_hasIntroducedNewDiscoverV1, true);
      return true;
    }
    return false;
  }
}
