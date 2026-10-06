# MovieScout Vercel Backend

This repository contains the configuration and static assets deployed to Vercel for MovieScout.

## Responsibilities

1. **URL Redirects (`vercel.json`)**:
   - Redirects `/movie/:path*`, `/tv/:path*`, `/person/:path*`, and `/collection/:path*` to `themoviedb.org`.

2. **Web Landing Page & Legal Documents (`public/`)**:
   - Serves `index.html`, `privacy.html`, `terms.html`, and Google site verification files directly on `https://moviescout.xicra.com/`.

3. **Android App Links (`public/.well-known/assetlinks.json`)**:
   - Handles Digital Asset Links verification for Android deep linking.

> Note: User authentication and cloud data persistence have been migrated to Supabase. The legacy Firebase Custom Auth serverless function has been deprecated and removed.
