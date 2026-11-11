# MovieScout — Design System & Style Guide

This document is the **Single Source of Truth** for User Interface (UI), User Experience (UX), and component architecture in MovieScout.
**All contributors and agents must follow these guidelines strictly to ensure visual and functional consistency across the entire application.**

---

## 1. Core Principles

1. **Defensive Theming & Mode Compatibility:**
   - MovieScout supports **Dark Mode** (default) and **Light Mode**.
   - Every new or refactored component must render and be legible in both modes using semantic color tokens (`Theme.of(context).colorScheme` and `Theme.of(context).extension<CustomColors>()!`).
   - Never hardcode raw color hex values (`Color(0x...)`, `Colors.black`, `Colors.white`), except for specific semi-transparent overlays rendered directly on top of images.

2. **Brand Fallback Assets:**
   - **Strictly forbidden** to replace missing posters, thumbnails, or avatars with generic icons or symbols (`Icons.movie`, `Icons.person`, etc.).
   - Always use [`AppPosterImage`](lib/core/widgets/app_poster_image.dart) with the appropriate fallback asset.

3. **Adaptive & Responsive Layouts (Flutter Build Responsive Layout):**
   - Never assume the app runs solely on a vertical phone screen. It runs on phones, foldables, tablets, desktop, resizable windows, and in landscape orientation.
   - Base all adaptive layout decisions on available screen space (`LayoutBuilder` and `BoxConstraints`), never on platform checks or physical device hardware dimensions.

---

## 2. Design Tokens

All visual constants are centralized under `lib/core/theme/`:

### 2.1 Colors (`ColorScheme` & `CustomColors`)

Location: [`lib/core/theme/custom_colors.dart`](lib/core/theme/custom_colors.dart) and [`lib/core/theme/theme_service.dart`](lib/core/theme/theme_service.dart).

- **Material Color Scheme (`Theme.of(context).colorScheme`):**
  - `primary`: Accent emerald (`#10B981` dark / `#059669` light) for primary actions, prominent buttons, and active indicators.
  - `surface`: Background color for screens, scaffolds, and cards.
  - `surfaceContainerHighest`: Elevated containers, input backgrounds, and image placeholders.
  - `onSurface`: Text and icons on surface backgrounds.
  - `onSurfaceVariant`: Secondary text, subtitles, timestamps, and helper labels.
  - `error` / `onError`: Destructive actions, warnings, and error messages (`#EF4444`).
- **Semantic Extensions (`Theme.of(context).extension<CustomColors>()!`):**
  - `appBarBackground` / `appBarText`: Main app bar background and title/icon color.
  - `ratedTitle`: Community / TMDB vote average (golden `#E5BA73`).
  - `userRatedTitle`: Logged-in user's personal rating (`#10B981`).
  - `followingUserRatedTitle`: Rating from followed community users (`#5B86E5`).
  - `chipCardBackground`: Background for vertical chip cards.
  - `watchedOverlayColor`: Darkened overlay (`#66000000` dark / `#4D000000` light) for watched titles.
  - `dividerColor`: Color for dividers and borders.
  - `navigationBarSelected` / `navigationBarNotSelected`: Active and inactive navigation colors.

### 2.2 Spacing (`AppSpacing`)

Location: [`lib/core/theme/app_spacing.dart`](lib/core/theme/app_spacing.dart).
Mathematical 4dp / 8dp scale. **Never hardcode arbitrary raw padding or margin values.**

| Token | Value | Typical Usage |
| :--- | :--- | :--- |
| `AppSpacing.xxs` | `2.0` | Minimal internal spacing (badges, micro-icons) |
| `AppSpacing.xs` | `4.0` | Gap between label and icon, card margins |
| `AppSpacing.sm` | `8.0` | Standard internal spacing, chip spacing, grid gaps |
| `AppSpacing.md` | `12.0` | Gap between form fields, list item paddings |
| `AppSpacing.lg` | `16.0` | Standard screen margin on mobile, section padding |
| `AppSpacing.xl` | `24.0` | Wide margins, detail headers |
| `AppSpacing.xxl` | `32.0` | Empty states and error view paddings |
| `AppSpacing.xxxl`| `48.0` | Maximum block separation |

### 2.3 Border Radii (`AppRadius`)

Location: [`lib/core/theme/app_radius.dart`](lib/core/theme/app_radius.dart).

| Token | Value | Target Components |
| :--- | :--- | :--- |
| `AppRadius.xs` (`4.0`) | `Radius.circular(4.0)` | Small thumbnails, mini-posters in lists |
| `AppRadius.sm` (`8.0`) | `AppRadius.borderSm` | Standard buttons, selection tiles (`RadioListTile`) |
| `AppRadius.md` (`12.0`) | `AppRadius.card` | Content cards (`TitleCard`, `TitleChip`, `PersonCard`) |
| `AppRadius.lg` (`16.0`) | `AppRadius.dialog` | Dialogs and alerts (`AlertDialog`, `Dialog`) |
| `AppRadius.xl` (`24.0`) | `AppRadius.bottomSheet` | Bottom modal sheets (`showModalBottomSheet`, top radius) |
| `AppRadius.full` (`999.0`)| `AppRadius.borderFull` | Pills, tags, and circular avatars |

### 2.4 Typography & Text Scaling

Location: [`lib/core/theme/app_typography.dart`](lib/core/theme/app_typography.dart) and [`lib/core/utils/ui_utils.dart`](lib/core/utils/ui_utils.dart).

- Always use styles from `Theme.of(context).textTheme`:
  - `titleLarge` (20sp bold): Screen titles and major headers.
  - `titleMedium` (16sp bold/w600): Card titles (`TitleCard`, `PersonCard`, `CollectionCard`).
  - `titleSmall` (14sp bold/w600): Vertical chip titles (`TitleChip`, `PersonChip`).
  - `bodyLarge` / `bodyMedium` (16sp / 14sp): Body text, reviews, and overviews.
  - `bodySmall` (12sp): Subtitles, release dates, genres, and runtimes.
  - `labelMedium` (12sp bold/medium): Compact chip labels and secondary buttons.
- **Accessibility Bounds:** When rendering text in layout-critical or fixed-size containers, wrap with [`UiUtils.clampedTextScale(context)`](lib/core/utils/ui_utils.dart) to clamp text scaling between `1.0` and `1.3`.

### 2.5 Responsive Breakpoints (`AppBreakpoints`)

Location: [`lib/core/theme/app_breakpoints.dart`](lib/core/theme/app_breakpoints.dart).

- `AppBreakpoints.largeScreenMinWidth` (`600.0`): Breakpoint between mobile and wide display (tablet/desktop/web).
- `AppBreakpoints.maxContentWidth` (`800.0`): Maximum content width for detail screens, forms, and settings.
- `AppBreakpoints.maxGridCrossAxisExtent` (`480.0`): Maximum card width for adaptive lists in grid mode.

---

## 3. Mandatory Reusable Components

### 3.1 Images & Fallbacks: [`AppPosterImage`](lib/core/widgets/app_poster_image.dart)

Every catalog poster, thumbnail, person photo, or avatar **must use** `AppPosterImage`. It handles memory cache sizing, disk caching, 200ms smooth fade-in, and brand fallback assets automatically:

```dart
// Movies or TV Shows (2/3 aspect ratio)
AppPosterImage(
  imageUrl: title.posterPath,
  fallbackType: title.isMovie ? PosterFallbackType.movie : PosterFallbackType.tvShow,
  aspectRatio: 2 / 3,
)

// Episodes (16/9 aspect ratio)
AppPosterImage(
  imageUrl: episode.stillPath,
  fallbackType: PosterFallbackType.tvShow,
  aspectRatio: 16 / 9,
)

// Actors / Crew (2/3 aspect ratio)
AppPosterImage(
  imageUrl: person.posterPath,
  fallbackType: PosterFallbackType.person,
  aspectRatio: 2 / 3,
)

// Community User Profile (3rd person — circular avatar)
AppPosterImage(
  imageUrl: user.avatarUrl,
  fallbackType: PosterFallbackType.user, // assets/user.png
  aspectRatio: 1.0,
)

// Own Account Profile (1st person — AppDrawer)
AppPosterImage(
  imageUrl: currentAccount.avatarUrl,
  fallbackType: PosterFallbackType.account, // assets/account.png
  aspectRatio: 1.0,
)
```

#### Brand Fallback Assets Map:
- `assets/movie.png`: Fallback for movies (cards and lists).
- `assets/tvshow.png`: Fallback for TV shows (cards and lists).
- `assets/movie_poster.png`: Full 2:3 vertical poster fallback for large carousels/hero headers.
- `assets/tvshow_poster.png`: Full 2:3 vertical poster fallback for large carousels/hero headers.
- `assets/person.png`: Fallback for actors, directors, and crew members.
- `assets/user.png`: Fallback for 3rd-person community user profiles.
- `assets/account.png`: Fallback for the 1st-person logged-in user account.

### 3.2 Empty States: [`AppEmptyState`](lib/core/widgets/app_empty_state.dart)

Never display bare, unstyled `Text` widgets when a list or search result is empty:

```dart
AppEmptyState(
  icon: Icons.movie_outlined,
  title: localizations.emptyList,
  message: localizations.emptyListSubtitle, // optional
  actionLabel: localizations.explore,     // optional
  onAction: () => ...                      // optional
)
```

### 3.3 Error Views with Retry: [`AppErrorView`](lib/core/widgets/app_error_view.dart)

When an asynchronous request fails (network timeout, offline, API error), replace infinite loading spinners or blank screens with:

```dart
AppErrorView(
  title: loc.errorMessageGeneric,
  message: loc.networkErrorMessage,
  onRetry: () => _retryLoadingData(),
)
```

### 3.4 Floating Feedback: [`SnackMessage`](lib/core/utils/snack_bar.dart)

- For user feedback: `SnackMessage.showSnackBar(loc.itemSaved)`.
- Automatically clears previous queued snackbars and enforces standard durations (4s standard, 8s for interactive action snacks).

---

## 4. Layout Patterns & Responsive Architecture

### 4.1 Adaptive Navigation
In root navigation screens:
- If `constraints.maxWidth > AppBreakpoints.largeScreenMinWidth` (`600px`): render a side `NavigationRail` inside a `Row`.
- If `constraints.maxWidth <= 600px`: render a bottom `NavigationBar` on the `Scaffold`.

### 4.2 Adaptive Lists and Grids
- On compact screens (`<= 600px`): use `ListView.builder` with `Divider` separation.
- On wide screens (`> 600px`): adapt to `GridView.builder` with `SliverGridDelegateWithMaxCrossAxisExtent` (`maxCrossAxisExtent: AppBreakpoints.maxGridCrossAxisExtent`, fixed card height, and `AppSpacing.sm` padding/spacing).

### 4.3 Detail Views & Forms
Every detail view ([`TitleDetails`](lib/features/titles/screens/title_details.dart), [`PersonDetails`](lib/features/people/screens/person_details.dart), [`SeasonDetails`](lib/features/seasons/screens/season_details.dart), [`EpisodeDetails`](lib/features/seasons/screens/episode_details.dart), [`SettingsScreen`](lib/features/settings/screens/settings.dart), [`UserDetails`](lib/features/auth/screens/user_details.dart)) must constrain its body horizontally so content does not stretch across wide desktop monitors:

```dart
body: SingleChildScrollView(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppBreakpoints.maxContentWidth, // 800.0
      ),
      child: _detailsBody(...),
    ),
  ),
)
```
