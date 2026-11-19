import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:moviescout/core/models/translation_content_type.dart';

class TmdbEditSelectorsConfig {
  static const String defaultLoginPathToken = '/login';
  static const String defaultLoginFormSelector = 'form[action*="/login"]';

  static const List<String> defaultTitleSelectors = [
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
    'input[id*="name"]',
  ];

  static const List<String> defaultOverviewSelectors = [
    'textarea[name="translated_overview"]',
    'textarea#translated_overview',
    'textarea[name="overview"]',
    'textarea#overview',
    'textarea[name\$="[overview]"]',
    'textarea[id*="overview"]',
  ];

  static const List<String> defaultBiographySelectors = [
    'textarea[name="translated_biography"]',
    'textarea#translated_biography',
    'textarea[name="biography"]',
    'textarea#biography',
    'textarea[name\$="[biography]"]',
    'textarea[id*="biography"]',
  ];

  static const List<String> defaultExcludedTitleKeywords = [
    'original',
    'tagline',
    'subtitle',
    'username',
    'search',
  ];

  static const List<String> defaultExcludedFallbackInputKeywords = [
    'date',
    'runtime',
    'budget',
    'revenue',
    'homepage',
    'imdb',
    'status',
  ];

  final String loginPathToken;
  final String loginFormSelector;
  final List<String> titleSelectors;
  final List<String> overviewSelectors;
  final List<String> biographySelectors;
  final List<String> excludedTitleKeywords;
  final List<String> excludedFallbackInputKeywords;
  final String? customScriptTemplate;

  const TmdbEditSelectorsConfig({
    this.loginPathToken = defaultLoginPathToken,
    this.loginFormSelector = defaultLoginFormSelector,
    this.titleSelectors = defaultTitleSelectors,
    this.overviewSelectors = defaultOverviewSelectors,
    this.biographySelectors = defaultBiographySelectors,
    this.excludedTitleKeywords = defaultExcludedTitleKeywords,
    this.excludedFallbackInputKeywords = defaultExcludedFallbackInputKeywords,
    this.customScriptTemplate,
  });

  static List<String> _parseStringList(
    dynamic raw,
    List<String> fallback,
  ) {
    if (raw is! List) return fallback;
    final items = raw
        .map((e) => e?.toString().trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    return items.isNotEmpty ? items : fallback;
  }

  factory TmdbEditSelectorsConfig.fromJson(Map<String, dynamic> json) {
    final loginPath = json['login_path_token']?.toString().trim() ?? '';
    final loginForm = json['login_form_selector']?.toString().trim() ?? '';
    final customTemplate =
        json['custom_script_template']?.toString().trim() ?? '';

    return TmdbEditSelectorsConfig(
      loginPathToken: loginPath.isNotEmpty ? loginPath : defaultLoginPathToken,
      loginFormSelector:
          loginForm.isNotEmpty ? loginForm : defaultLoginFormSelector,
      titleSelectors: _parseStringList(
        json['title_selectors'],
        defaultTitleSelectors,
      ),
      overviewSelectors: _parseStringList(
        json['overview_selectors'],
        defaultOverviewSelectors,
      ),
      biographySelectors: _parseStringList(
        json['biography_selectors'],
        defaultBiographySelectors,
      ),
      excludedTitleKeywords: _parseStringList(
        json['excluded_title_keywords'],
        defaultExcludedTitleKeywords,
      ),
      excludedFallbackInputKeywords: _parseStringList(
        json['excluded_fallback_input_keywords'],
        defaultExcludedFallbackInputKeywords,
      ),
      customScriptTemplate: customTemplate.isNotEmpty ? customTemplate : null,
    );
  }
}

class TmdbEditScript {
  TmdbEditScript._();

  static TmdbEditSelectorsConfig _config = const TmdbEditSelectorsConfig();

  static TmdbEditSelectorsConfig get currentConfig => _config;

  static bool applyConfigJson(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map) return false;
      _config = TmdbEditSelectorsConfig.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      return true;
    } catch (e) {
      debugPrint('Error parsing TMDb edit selectors config JSON: $e');
      return false;
    }
  }

  @visibleForTesting
  static void resetForTesting() {
    _config = const TmdbEditSelectorsConfig();
  }

  static String build({
    required TranslationContentType contentType,
    required String translatedTitle,
    required String translatedDescription,
    TmdbEditSelectorsConfig? config,
  }) {
    final activeConfig = config ?? _config;
    final isPerson = contentType == TranslationContentType.person;
    final titleJson = jsonEncode(translatedTitle);
    final descJson = jsonEncode(translatedDescription);
    final isPersonJson = jsonEncode(isPerson);

    final customTemplate = activeConfig.customScriptTemplate;
    if (customTemplate != null && customTemplate.isNotEmpty) {
      return customTemplate
          .replaceAll('__TITLE_JSON__', titleJson)
          .replaceAll('__DESC_JSON__', descJson)
          .replaceAll('__IS_PERSON_JSON__', isPersonJson);
    }

    final loginPathJson = jsonEncode(activeConfig.loginPathToken);
    final loginFormJson = jsonEncode(activeConfig.loginFormSelector);
    final titleSelectorsJson = jsonEncode(activeConfig.titleSelectors);
    final descSelectorsJson = jsonEncode(
      isPerson
          ? activeConfig.biographySelectors
          : activeConfig.overviewSelectors,
    );
    final excludedTitleJson = jsonEncode(activeConfig.excludedTitleKeywords);
    final excludedFallbackJson =
        jsonEncode(activeConfig.excludedFallbackInputKeywords);

    return '''
(function() {
  var loginPathToken = $loginPathJson;
  var loginFormSelector = $loginFormJson;
  var path = (window.location && window.location.pathname) ? window.location.pathname : '';
  if ((loginPathToken && path.indexOf(loginPathToken) !== -1) ||
      (loginFormSelector && document.querySelector(loginFormSelector))) {
    return JSON.stringify({ status: 'login', appliedTitle: false, appliedDescription: false });
  }

  var titleText = $titleJson;
  var descText = $descJson;
  var isPerson = $isPersonJson;
  var titleSelectors = $titleSelectorsJson;
  var descSelectors = $descSelectorsJson;
  var excludedTitleKeywords = $excludedTitleJson;
  var excludedFallbackKeywords = $excludedFallbackJson;

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

  function containsAnyKeyword(meta, keywords) {
    for (var i = 0; i < keywords.length; i++) {
      if (meta.indexOf(keywords[i]) !== -1) return true;
    }
    return false;
  }

  function isExcludedTitleField(el) {
    var meta = ((el.name || '') + ' ' + (el.id || '')).toLowerCase();
    return containsAnyKeyword(meta, excludedTitleKeywords);
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

  var descMatch = findFirstEditable(document, descSelectors, ['textarea'], null);
  var formScope = (descMatch && descMatch.el && descMatch.el.form) ? descMatch.el.form : document;

  var appliedDescription = false;
  if (descText.length > 0 && descMatch) {
    appliedDescription = setFieldValue(descMatch.el, descText);
  }

  var appliedTitle = false;
  var titleMatch = null;
  if (!isPerson && titleText.length > 0) {
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
        if (containsAnyKeyword(meta, excludedFallbackKeywords)) continue;
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
}
