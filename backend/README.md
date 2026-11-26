# MovieScout Web Companion & Vercel Backend

This directory contains the **SvelteKit (Svelte 5) + TypeScript** web companion and Vercel configuration for `https://moviescout.xicra.com/`.

## Responsibilities

1. **Public SSR Pages (SEO, OpenGraph & JSON-LD)**:
   - `/` — Multi-language landing page (11 languages)
   - `/movie/[id]` and `/tv/[id]` — Movie and TV series detail pages (supports slugs like `/movie/550-fight-club` with canonical URLs and 302 redirects for extra sub-paths)
   - `/tv/[id]/season/[seasonNumber]` and `/tv/[id]/season/[seasonNumber]/episode/[episodeNumber]` — Season and episode pages
   - `/person/[id]` — Person biography, credits, and gallery
   - `/collection/[id]` — Movie collection page ordered chronologically

2. **Static Assets & Preserved Contracts (`static/`)**:
   - **Android App Links (`static/.well-known/assetlinks.json`)**: Digital Asset Links verification for Android deep linking (`Content-Type: application/json` via `vercel.json`).
   - **Legal & Verification**: `privacy.html`, `terms.html`, and `google5da2fd1c2b04afea.html`.
   - **Remote Config JSONs**: `ai-models.json`, `ai-prompts.json`, and `tmdb-edit-selectors.json` (served with `Access-Control-Allow-Origin: *` and `Cache-Control: public, max-age=0, must-revalidate`).

## Project Structure (Feature-First)

Following the Flutter app's **feature-first** organization (see [DEVELOP.md](../DEVELOP.md#architecture--directory-structure) and the official [Flutter Guide to App Architecture](https://docs.flutter.dev/app-architecture)), both `src/lib/components/` and `src/lib/server/` group shared primitives under `core/` and domain modules by feature:

```text
src/lib/
├── components/
│   ├── core/        # Shared UI components (AppHeader, AppFooter, PosterImage, MediaCarousel, ClickableNames, ConsentBanner, ...)
│   ├── titles/      # Movie & TV UI (TitleDetailView, TitleChip, RatingBadges, TrailerModal, WatchProviders)
│   └── people/      # Person UI (PersonChip)
├── server/
│   ├── core/        # Shared server utilities (cache, omdb, tmdb-client, routing, base seo)
│   ├── titles/      # Movie & TV loaders, TMDB client, and SEO (tmdb-titles, title-loader, title-seo)
│   ├── seasons/     # Season & episode TMDB client and SEO (tmdb-seasons, season-seo)
│   ├── people/      # Person TMDB client and SEO (tmdb-people, person-seo)
│   └── discovery/   # Collection TMDB client and SEO (tmdb-collections, collection-seo)
├── constants/       # Shared URLs, image sizes, and app constants
├── i18n/            # Locale/region resolution, metadata helpers, and synced Flutter translations
├── styles/          # Dark-mode CSS tokens (aligned with STYLE_GUIDE.md) and global styles
├── types/           # TypeScript domain contracts
└── utils/           # Pure shared helpers (credits filtering, date formatting, GA4 consent & pageviews)
```

For UI rules, colors, spacing, radii, and fallback assets, see [STYLE_GUIDE.md](../STYLE_GUIDE.md).

## Local Development

1. Install dependencies (automatically runs `npm run sync` via `postinstall`):
   ```bash
   cd backend
   npm install
   ```

2. Configure environment variables for SSR routes (copy `.env.example` to `.env` in `backend/`):
   ```env
   TMDB_API_RAT=your_tmdb_api_read_access_token
   OMDB_API_KEY=your_omdb_api_key
   PUBLIC_GA_MEASUREMENT_ID=G-XXXXXXXXXX
   ```
   - `TMDB_API_RAT` is required for `/movie/*`, `/tv/*`, `/person/*`, and `/collection/*`.
   - `OMDB_API_KEY` is optional (pages render without OMDb scores if omitted or rate-limited).
   - `PUBLIC_GA_MEASUREMENT_ID` is optional (Google Analytics 4 Measurement ID `G-...` for web analytics). When omitted, neither `gtag.js` nor the consent banner loads.

3. Run locally or verify production build (`npm run sync` runs automatically before `dev`, `check`, and `build`):
   ```bash
   npm run dev      # Development server
   npm run check    # sync + svelte-kit sync + svelte-check
   npm run build    # sync + production build (@sveltejs/adapter-vercel)
   npm run preview  # Preview production build locally
   ```

## Automatic Shared i18n & Assets Sync

`scripts/sync-shared-assets.mjs` runs automatically on `postinstall`, `npm run dev`, `npm run check`, and `npm run build`. Its outputs (`src/lib/i18n/generated/` and `static/assets/`) are gitignored and generated fresh on every install/build:

- Discovers all locales from `../assets/l10n/countries_*.json` and reads matching `../lib/l10n/app_*.arb` files → generates `src/lib/i18n/generated/messages/<locale>.json`, `keys.ts`, and `registry.ts`.
- Copies `../assets/l10n/{countries,genres,languages,person_jobs,status}_*.json` → `src/lib/i18n/generated/metadata/`.
- Copies all root `*.png` assets from `../assets/` → `static/assets/`.

When **adding a new language**, `sync-shared-assets.mjs` picks up its `.arb` and metadata tables automatically; you only need to register the locale in `src/lib/i18n/locales.ts` and add its web-only strings in `src/lib/i18n/web-messages.ts` (enforced by TypeScript).

## How to Deploy (Vercel)

- **Root Directory**: `backend`
- **Build & Deployment → Root Directory**: Ensure **"Include files outside the Root Directory in the Build Step"** is enabled (so Vercel's build can read `../lib/l10n` and `../assets`).
- **Framework Preset**: `SvelteKit` (detected automatically via `@sveltejs/adapter-vercel`)
- **Ignored Build Step**: Configured in `vercel.json` (`ignoreCommand`) so changes in `backend/`, `lib/l10n/`, `assets/l10n/`, or `assets/` trigger a deploy automatically.
- **Environment Variables** (*Project Settings → Environment Variables*):
  - `TMDB_API_RAT` (required, server-only)
  - `OMDB_API_KEY` (optional, server-only)
  - `PUBLIC_GA_MEASUREMENT_ID` (optional, public client-side GA4 Measurement ID)

1. **Automatic Deployment**: Pushing commits to the tracked branch builds and deploys `backend/` automatically to `https://moviescout.xicra.com/`.
2. **Manual CLI Deployment**:
   ```bash
   cd backend
   npx -y vercel --prod
   ```

## Google Analytics 4 & Cookie Consent

To enable web usage statistics using an existing Google Analytics 4 property (such as the MovieScout Firebase/GA4 property):

1. In [Google Analytics](https://analytics.google.com/), go to **Admin → Data collection and modification → Data streams**.
2. Find an existing _Web Data Stream_ (**movie_scout (web)**) or click **Add stream → Web**, enter `https://moviescout.xicra.com`, name the stream (e.g. `MovieScout Web Companion`), keep **Enhanced measurement** enabled, and click **Create stream**.
3. Copy the existing (or new generated) **Measurement ID** (`G-...`) and configure it as `PUBLIC_GA_MEASUREMENT_ID` in both:
   - Local development (`backend/.env`) if you want to verify events locally.
   - Vercel Dashboard (*Project Settings → Environment Variables*) for production/preview builds.

How the integration behaves (`src/lib/utils/analytics.svelte.ts`, `ConsentBanner.svelte`, and `+layout.svelte`):
- **Privacy by default:** When `PUBLIC_GA_MEASUREMENT_ID` is set, a compact, non-modal consent bar is shown until the user accepts or declines. Zero requests to `googletagmanager.com` are made and no GA cookies are written before explicit acceptance.
- **SPA page tracking:** Initializes GA4 with `send_page_view: false` and dispatches `page_view` events on initial consented load and across client-side `afterNavigate` route transitions.
- **Easy opt-out:** Users can reopen the banner and update or revoke consent at any time via **Cookie settings** in `AppFooter.svelte` (which also clears `_ga*` cookies).

## Domain & Google Verification

- **Google Search Console**: Verified for `https://moviescout.xicra.com/` via `static/google5da2fd1c2b04afea.html`.
- **Google Cloud OAuth Consent Screen**: `moviescout.xicra.com` is an **Authorized Domain**, enabling verified links for `/privacy.html` and `/terms.html`.
- **Android App Links**: `static/.well-known/assetlinks.json` contains the SHA-256 certificate fingerprints for debug and Play App Signing keys.
