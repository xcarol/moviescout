# Test Execution Rules (to avoid wasting credits on tests)
- DO NOT automatically run `flutter test` or any test commands after making code modifications, unless required by the user.
- Assume the changes are correct and wait for the user to manually verify or explicitly request running tests.

# Code Style & Comments Rules
- DO NOT add obvious, redundant, or trivial comments/docstrings (e.g. `/// Formatted author names`, `/// Creates an instance...`, `// Optional metadata`).
- Only write comments when strictly necessary to explain complex, non-obvious business logic, workarounds, or subtle edge cases. Always in english.

# Implementation Plan & Task Rules
- NEVER overwrite an existing Implementation Plan or Task document/artifact. If a new version or plan is needed, simply rename the previous file by adding a version number instead of overwriting it.

# Hot reload & Restart
- DO NOT ask to reload or restart the application, just let me know and I will do it manually.

# Localization (l10n) Rules
- DO NOT manually edit generated localization files (`lib/l10n/app_localizations*.dart`) or run `flutter gen-l10n`.
- Only edit the source `.arb` files (`lib/l10n/app_*.arb`) and notify the user when localizations need to be regenerated.

# UI/UX & Design System Rules
- ALWAYS follow the rules defined in `STYLE_GUIDE.md`.
- USE DESIGN TOKENS:
  - Spacings: Use `AppSpacing` (`xxs` through `xxxl`), never hardcode raw numbers for padding, margin, or sized boxes.
  - Border Radii: Use `AppRadius` (`card: 12.0`, `dialog: 16.0`, `bottomSheet: 24.0`, `borderSm: 8.0`, etc.).
  - Breakpoints: Use `AppBreakpoints` (`largeScreenMinWidth = 600.0`, `maxContentWidth = 800.0`, `maxGridCrossAxisExtent = 480.0`).
  - Colors: Use `Theme.of(context).colorScheme` and `Theme.of(context).extension<CustomColors>()!`. Never hardcode raw hex colors (`Color(0x...)`).
- IMAGES & FALLBACKS:
  - ALWAYS use `AppPosterImage` for posters, thumbnails, and avatars.
  - NEVER replace image fallbacks with generic icons or symbols (`Icons.movie`, `Icons.person`).
  - Use proper fallback types: `PosterFallbackType.movie` (`movie.png`), `PosterFallbackType.tvShow` (`tvshow.png`), `PosterFallbackType.person` (`person.png`), `PosterFallbackType.user` (`user.png` for community profiles), `PosterFallbackType.account` (`account.png` for own logged-in account).
- RESPONSIVE LAYOUTS:
  - Detail screens, settings, and forms: Always constrain horizontal expansion with `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: AppBreakpoints.maxContentWidth), child: ...))`.
  - Main navigation: Use `NavigationRail` when `maxWidth > 600` and `BottomNavigationBar` when `maxWidth <= 600`.
  - Lists: Adapt to `GridView.builder` with `SliverGridDelegateWithMaxCrossAxisExtent` on wide screens.
- EMPTY & ERROR STATES:
  - Use `AppEmptyState` for empty lists and search results instead of bare text.
  - Use `AppErrorView` with retry callback (`onRetry`) instead of infinite loading spinners or blank screens.
