import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:moviescout/core/models/translation_content_type.dart';
import 'package:moviescout/core/theme/app_spacing.dart';
import 'package:moviescout/core/utils/app_constants.dart';
import 'package:moviescout/core/utils/snack_bar.dart';
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

  static String buildInjectionScript({
    required TranslationContentType contentType,
    required String translatedTitle,
    required String translatedDescription,
  }) {
    final titleJson = jsonEncode(translatedTitle);
    final descJson = jsonEncode(translatedDescription);
    final isPersonJson = jsonEncode(contentType == TranslationContentType.person);

    return '''
(function() {
  var path = (window.location && window.location.pathname) ? window.location.pathname : '';
  if (path.indexOf('/login') !== -1 || document.querySelector('form[action*="/login"]')) {
    return JSON.stringify({ status: 'login', appliedTitle: false, appliedDescription: false });
  }

  function isEditable(el, allowedTags) {
    if (!el || el.disabled || el.readOnly) return false;
    var tag = el.tagName ? el.tagName.toLowerCase() : '';
    if (allowedTags.indexOf(tag) === -1) return false;
    if (tag === 'input') {
      var type = (el.type || 'text').toLowerCase();
      if (type !== 'text' && type !== 'search' && type !== '') return false;
    }
    var style = window.getComputedStyle(el);
    if (style.display === 'none' || style.visibility === 'hidden') return false;
    var rect = el.getBoundingClientRect();
    return rect.width > 0 && rect.height > 0;
  }

  function isExcludedTitleField(el) {
    var meta = ((el.name || '') + ' ' + (el.id || '')).toLowerCase();
    return meta.indexOf('original') !== -1 ||
      meta.indexOf('tagline') !== -1 ||
      meta.indexOf('subtitle') !== -1 ||
      meta.indexOf('username') !== -1 ||
      meta.indexOf('search') !== -1;
  }

  function findFirstEditable(root, selectors, allowedTags, excludeFn) {
    if (!root) return null;
    for (var i = 0; i < selectors.length; i++) {
      var list = root.querySelectorAll(selectors[i]);
      for (var j = 0; j < list.length; j++) {
        var el = list[j];
        if (!isEditable(el, allowedTags)) continue;
        if (excludeFn && excludeFn(el)) continue;
        return { el: el, selector: selectors[i] };
      }
    }
    return null;
  }

  function setFieldValue(el, value) {
    if (!el) return false;
    try { el.focus(); } catch (_) {}
    var proto = Object.getPrototypeOf(el);
    var desc = proto ? Object.getOwnPropertyDescriptor(proto, 'value') : null;
    if (desc && typeof desc.set === 'function') {
      desc.set.call(el, value);
    } else {
      el.value = value;
    }
    el.dispatchEvent(new Event('input', { bubbles: true }));
    el.dispatchEvent(new Event('change', { bubbles: true }));
    el.dispatchEvent(new KeyboardEvent('keyup', { bubbles: true }));
    el.dispatchEvent(new Event('blur', { bubbles: true }));
    return true;
  }

  var titleText = $titleJson;
  var descText = $descJson;
  var isPerson = $isPersonJson;

  var descSelectors = isPerson
    ? [
        'textarea[name="translated_biography"]',
        'textarea#translated_biography',
        'textarea[name="biography"]',
        'textarea#biography',
        'textarea[name\$="[biography]"]',
        'textarea[id*="biography"]'
      ]
    : [
        'textarea[name="translated_overview"]',
        'textarea#translated_overview',
        'textarea[name="overview"]',
        'textarea#overview',
        'textarea[name\$="[overview]"]',
        'textarea[id*="overview"]'
      ];

  var descMatch = findFirstEditable(document, descSelectors, ['textarea'], null);
  var formScope = (descMatch && descMatch.el && descMatch.el.form) ? descMatch.el.form : document;

  var appliedDescription = false;
  if (descText.length > 0 && descMatch) {
    appliedDescription = setFieldValue(descMatch.el, descText);
  }

  var appliedTitle = false;
  var titleMatch = null;
  if (!isPerson && titleText.length > 0) {
    var titleSelectors = [
      'input[name="translated_title"]',
      'input#translated_title',
      'input[name="translated_name"]',
      'input#translated_name',
      'input[name="title"]',
      'input#title',
      'input[name="name"]',
      'input#name',
      'input[name\$="[title]"]',
      'input[name\$="[name]"]',
      'input[id*="translated"][id*="title"]',
      'input[id*="translated"][id*="name"]',
      'input[name*="title"]',
      'input[id*="title"]',
      'input[name*="name"]',
      'input[id*="name"]'
    ];

    titleMatch = findFirstEditable(formScope, titleSelectors, ['input', 'textarea'], isExcludedTitleField);
    if (!titleMatch && formScope !== document) {
      titleMatch = findFirstEditable(document, titleSelectors, ['input', 'textarea'], isExcludedTitleField);
    }

    if (!titleMatch && formScope !== document) {
      var textInputs = formScope.querySelectorAll('input');
      for (var k = 0; k < textInputs.length; k++) {
        var candidate = textInputs[k];
        if (!isEditable(candidate, ['input']) || isExcludedTitleField(candidate)) continue;
        var meta = ((candidate.name || '') + ' ' + (candidate.id || '')).toLowerCase();
        if (meta.indexOf('date') !== -1 || meta.indexOf('runtime') !== -1 ||
            meta.indexOf('budget') !== -1 || meta.indexOf('revenue') !== -1 ||
            meta.indexOf('homepage') !== -1 || meta.indexOf('imdb') !== -1 ||
            meta.indexOf('status') !== -1) continue;
        titleMatch = { el: candidate, selector: 'form-first-text-input' };
        break;
      }
    }

    if (titleMatch) {
      appliedTitle = setFieldValue(titleMatch.el, titleText);
    }
  }

  var formDebug = [];
  if ((!isPerson && titleText.length > 0 && !appliedTitle) || (descText.length > 0 && !appliedDescription)) {
    var allFields = (formScope || document).querySelectorAll('input, textarea');
    for (var f = 0; f < allFields.length; f++) {
      var el = allFields[f];
      if (el.type === 'hidden') continue;
      formDebug.push({
        tag: el.tagName,
        type: el.type || '',
        id: el.id || '',
        name: el.name || '',
        disabled: !!el.disabled,
        readOnly: !!el.readOnly
      });
    }
  }

  var status = (appliedTitle || appliedDescription) ? 'injected' : 'not_found';
  return JSON.stringify({
    status: status,
    appliedTitle: appliedTitle,
    appliedDescription: appliedDescription,
    titleSelector: titleMatch ? titleMatch.selector : null,
    descSelector: descMatch ? descMatch.selector : null,
    formDebug: formDebug
  });
})();
''';
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
      final script = TmdbEditWebViewScreen.buildInjectionScript(
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
