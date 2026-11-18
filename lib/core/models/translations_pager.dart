import 'package:moviescout/core/models/translation_context.dart';
import 'package:moviescout/features/titles/models/tmdb_translation.dart';
import 'package:moviescout/l10n/app_localizations.dart';

class TranslationPageData {
  final List<TmdbTranslation> translations;
  final String editUrl;
  final TranslationContext translationContext;

  const TranslationPageData({
    required this.translations,
    required this.editUrl,
    required this.translationContext,
  });
}

class TranslationsPager {
  final int itemCount;
  final int initialIndex;
  final Future<TranslationPageData?> Function(int index) loadPage;
  final String Function(int index, AppLocalizations l10n)? pageTitleBuilder;

  const TranslationsPager({
    required this.itemCount,
    required this.initialIndex,
    required this.loadPage,
    this.pageTitleBuilder,
  });
}
