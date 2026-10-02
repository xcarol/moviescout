# MovieScout Vercel Backend

This repository contains the configuration and static assets deployed to Vercel for MovieScout.

## Responsibilities

1. **URL Redirects (`vercel.json`)**:
   - Redirects `/movie/:path*`, `/tv/:path*`, `/person/:path*`, and `/collection/:path*` to `themoviedb.org`.
   - Redirects `/` to the MovieScout web landing page (`https://xcarol.github.io/moviescout/`).

2. **Android App Links (`public/.well-known/assetlinks.json`)**:
   - Handles Digital Asset Links verification for Android deep linking.

> Note: User authentication and cloud data persistence have been migrated to Supabase. The legacy Firebase Custom Auth serverless function has been deprecated and removed.
