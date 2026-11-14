import 'package:flutter/material.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import "package:moviescout/features/auth/services/supabase_auth_service.dart";
import 'package:moviescout/core/navigation/app_navigator.dart';
import 'package:moviescout/features/watchlist/services/watchlist_service.dart';
import 'package:moviescout/features/discovery/services/discover_promotion_manager.dart';
import 'package:moviescout/features/discovery/widgets/discover_promo_card.dart';
import 'package:moviescout/core/widgets/app_empty_state.dart';
import 'package:moviescout/core/widgets/item_list.dart';
import 'package:moviescout/core/widgets/custom_refresh_builder.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:provider/provider.dart';

class WatchList extends StatefulWidget {
  final VoidCallback? onExploreDiscover;

  const WatchList({super.key, this.onExploreDiscover});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late Future<void> _init;
  late WatchlistService _watchlistService;
  late Widget _watchlistWidget;
  bool get _showPromoCard => DiscoverPromotionManager.shouldShowPromoCard;

  @override
  void initState() {
    super.initState();
    _init = _loadData();
  }

  void _dismissPromo() {
    DiscoverPromotionManager.dismissPromoCard();
    setState(() {});
  }

  Future<void> _loadData() async {
    _watchlistService = Provider.of<WatchlistService>(context, listen: false);
    _watchlistWidget = ItemList(
      _watchlistService,
      key: ValueKey('watchlist'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _watchlistService.syncFromServer(
        locale: Localizations.localeOf(context),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        return body();
      },
    );
  }

  Widget body() {
    final watchlistService =
        Provider.of<WatchlistService>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: watchlistService.isLoading,
      builder: (context, isLoading, child) {
        return Selector<WatchlistService, bool>(
          selector: (_, service) => service.listIsEmpty && !isLoading,
          shouldRebuild: (prev, next) => prev != next,
          builder: (context, isEmpty, child) {
            final content = isEmpty ? emptyBody() : watchlistBody();
            if (_showPromoCard) {
              return Column(
                children: [
                  DiscoverPromoCard(
                    onExplore: () {
                      _dismissPromo();
                      widget.onExploreDiscover?.call();
                    },
                    onDismiss: _dismissPromo,
                  ),
                  Expanded(child: content),
                ],
              );
            }
            return content;
          },
        );
      },
    );
  }

  Widget emptyBody() {
    final loc = AppLocalizations.of(context)!;
    final isGoogleLoggedIn =
        Provider.of<SupabaseAuthService>(context).isLoggedIn;

    final emptyWidget = isGoogleLoggedIn
        ? AppEmptyState(
            imageAsset: 'assets/empty-watchlist.png',
            title: loc.emptyWatchlistTitle,
            message: loc.emptyWatchlistMessage,
          )
        : AppEmptyState(
            imageAsset: 'assets/empty-watchlist.png',
            title: loc.emptyWatchlistTitle,
            message: loc.emptyWatchlistGuestMessage,
            actionLabel: loc.messageEmptyLogin,
            onAction: () => context.toLogin(),
          );

    return CustomRefreshIndicator(
      onRefresh: () async {
        await _watchlistService.syncFromServer(
          locale: Localizations.localeOf(context),
          forceUpdate: true,
        );
        if (!_watchlistService.hasLoadedItems) {
          await _watchlistService.filterItems();
        }
      },
      builder: customRefreshBuilder,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: emptyWidget,
            ),
          ),
        ),
      ),
    );
  }

  Widget watchlistBody() {
    return _watchlistWidget;
  }
}
