# MovieScout Vercel Backend

This repository contains the configuration and static assets deployed to Vercel for MovieScout.

## Responsibilities

1. **URL Redirects (`vercel.json`)**:
   - Redirects `/movie/:path*`, `/tv/:path*`, `/person/:path*`, and `/collection/:path*` to `themoviedb.org`.

2. **Web Landing Page & Legal Documents (`public/`)**:
   - Serves `index.html`, `privacy.html`, `terms.html`, and Google site verification files directly on `https://moviescout.xicra.com/`.

3. **Android App Links (`public/.well-known/assetlinks.json`)**:
   - Handles Digital Asset Links verification for Android deep linking.

## How to Deploy

The project uses Vercel's official GitHub integration:

1. **Automatic Deployment (Recommended)**:
   - The Vercel project is linked to the `xcarol/moviescout` GitHub repository with **Root Directory** configured as `backend`.
   - Any commit pushed to the repository that touches files in `backend/` will automatically trigger a new deployment in Vercel to `https://moviescout.xicra.com/`.
   - You can monitor deployment status on the [Vercel Dashboard](https://vercel.com/dashboard).

2. **Manual CLI Deployment**:
   - Run from the `backend/` folder:
     ```bash
     cd backend
     npx -y vercel --prod
     ```

## Domain & Google Verification

- **Google Search Console**: Verified for the URL prefix `https://moviescout.xicra.com/` using the HTML verification file in `public/google*.html`.
- **Google Cloud OAuth Consent Screen**: `moviescout.xicra.com` is configured as an **Authorized Domain**, enabling verified links for Privacy Policy (`/privacy.html`) and Terms of Service (`/terms.html`).

