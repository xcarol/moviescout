import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/models/translation_content_type.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
import 'package:moviescout/core/utils/tmdb_edit_script.dart';
import 'package:moviescout/features/settings/services/language_service.dart';
import 'package:moviescout/features/settings/services/region_service.dart';
import 'package:moviescout/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TmdbEditWebViewScreen extends StatefulWidget {
  final String editUrl;
  final String? targetLanguageCode;
  final TranslationContentType contentType;
  final String translatedTitle;
  final String translatedDescription;

  const TmdbEditWebViewScreen({
    super.key,
    required this.editUrl,
    this.targetLanguageCode,
    this.contentType = TranslationContentType.movie,
    this.translatedTitle = '',
    this.translatedDescription = '',
  });

  static const Map<String, String> _tmdbLocaleOverrides = {
    'ar': 'ar-SA',
    'ca': AppConstants.catalan,
    'cs': 'cs-CZ',
    'da': 'da-DK',
    'de': AppConstants.german,
    'el': 'el-GR',
    'en': AppConstants.english,
    'es': AppConstants.spanish,
    'eu': AppConstants.basque,
    'fi': 'fi-FI',
    'fr': AppConstants.french,
    'gl': AppConstants.galician,
    'he': 'he-IL',
    'hi': 'hi-IN',
    'hu': 'hu-HU',
    'id': 'id-ID',
    'it': AppConstants.italian,
    'iw': 'he-IL',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'nl': 'nl-NL',
    'no': 'no-NO',
    'pl': 'pl-PL',
    'pt': AppConstants.portuguesePt,
    'ro': 'ro-RO',
    'ru': 'ru-RU',
    'sk': 'sk-SK',
    'sv': 'sv-SE',
    'th': 'th-TH',
    'tr': 'tr-TR',
    'uk': 'uk-UA',
    'vi': 'vi-VN',
    'zh-cn': 'zh-CN',
    'zh-tw': 'zh-TW',
  };

  static String resolveTmdbLanguage(String targetLanguageCode) {
    final normalized = targetLanguageCode.trim().toLowerCase();
    if (normalized.isEmpty) return '';

    final override = _tmdbLocaleOverrides[normalized];
    if (override != null) return override;

    if (normalized.contains('-')) {
      final parts = normalized.split('-');
      if (parts.length == 2) {
        return '${parts[0]}-${parts[1].toUpperCase()}';
      }
    }

    return AppConstants.supportedLanguages.firstWhere(
      (lang) => lang.toLowerCase().startsWith('$normalized-'),
      orElse: () => targetLanguageCode.trim(),
    );
  }

  static String defaultAppLocaleCode() {
    final languageCode = LanguageService().locale.languageCode;
    final countryCode = RegionService().currentRegion ??
        LanguageService().locale.countryCode ??
        'US';
    return '$languageCode-$countryCode';
  }

  static Uri buildEditUri(
    String baseEditUrl,
    String? targetLanguageCode, {
    bool includePrimaryFacts = false,
  }) {
    final baseUri = Uri.parse(baseEditUrl);
    final queryParams = Map<String, String>.from(baseUri.queryParameters);
    final rawLanguage =
        (targetLanguageCode != null && targetLanguageCode.trim().isNotEmpty)
            ? targetLanguageCode
            : defaultAppLocaleCode();
    final resolvedLanguage = resolveTmdbLanguage(rawLanguage);
    if (resolvedLanguage.isNotEmpty) {
      queryParams['language'] = resolvedLanguage;
    }
    if (includePrimaryFacts) {
      queryParams.putIfAbsent('active_nav_item', () => 'primary_facts');
    }
    return baseUri.replace(queryParameters: queryParams);
  }

  @override
  State<TmdbEditWebViewScreen> createState() => _TmdbEditWebViewScreenState();
}

class _TmdbEditWebViewScreenState extends State<TmdbEditWebViewScreen> {
  late final WebViewController _controller;
  late final Uri _initialUri;
  Timer? _retryTimer;

  double _progress = 0.0;
  bool _backgroundInitialized = false;
  String? _statusBanner;

  bool get _hasTranslationToInject =>
      widget.translatedTitle.trim().isNotEmpty ||
      widget.translatedDescription.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initialUri = TmdbEditWebViewScreen.buildEditUri(
      widget.editUrl,
      widget.targetLanguageCode,
      includePrimaryFacts: _hasTranslationToInject,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() {
              _progress = progress / 100.0;
            });
          },
          onPageStarted: (_) {
            _retryTimer?.cancel();
          },
          onPageFinished: (_) {
            if (_hasTranslationToInject) {
              _attemptInjection(retryCount: 0, manual: false);
            }
          },
        ),
      )
      ..loadRequest(_initialUri);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_backgroundInitialized) {
      _backgroundInitialized = true;
      _controller.setBackgroundColor(Theme.of(context).colorScheme.surface);
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Map<String, dynamic>? _decodeJsResult(Object? raw) {
    dynamic current = raw;
    for (var i = 0; i < 2; i++) {
      if (current is Map<String, dynamic>) return current;
      if (current is Map) return Map<String, dynamic>.from(current);
      if (current is String) {
        try {
          current = jsonDecode(current);
        } catch (_) {
          return null;
        }
      } else {
        return null;
      }
    }
    if (current is Map<String, dynamic>) return current;
    if (current is Map) return Map<String, dynamic>.from(current);
    return null;
  }

  Future<void> _attemptInjection({
    required int retryCount,
    required bool manual,
  }) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      final script = TmdbEditScript.build(
        contentType: widget.contentType,
        translatedTitle: widget.translatedTitle,
        translatedDescription: widget.translatedDescription,
      );
      final raw = await _controller.runJavaScriptReturningResult(script);
      if (!mounted) return;

      final result = _decodeJsResult(raw);
      if (kDebugMode) {
        debugPrint('TMDb injection result: $result');
      }
      final status = result?['status'] as String?;

      if (status == 'login') {
        setState(() {
          _statusBanner = l10n.tmdbEditLoginRequired;
        });
        return;
      }

      if (status == 'injected') {
        setState(() {
          _statusBanner = null;
        });
        SnackMessage.showSnackBar(
          l10n.tmdbTranslationInjected,
          context: context,
        );
        return;
      }

      if (!manual && retryCount < 2) {
        _retryTimer?.cancel();
        _retryTimer = Timer(const Duration(milliseconds: 700), () {
          _attemptInjection(retryCount: retryCount + 1, manual: false);
        });
        return;
      }

      setState(() {
        _statusBanner = l10n.tmdbFieldsNotFound;
      });
    } catch (_) {
      if (!mounted) return;
      if (manual) {
        setState(() {
          _statusBanner = l10n.tmdbFieldsNotFound;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tmdbEditPageTitle),
        actions: [
          if (_hasTranslationToInject)
            IconButton(
              tooltip: l10n.tmdbInjectTranslation,
              icon: const Icon(Icons.edit_note),
              onPressed: () => _attemptInjection(retryCount: 0, manual: true),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
        bottom: _progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(value: _progress),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (_statusBanner != null)
              Container(
                width: double.infinity,
                color: colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.gapSm,
                    Expanded(
                      child: Text(
                        _statusBanner!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
