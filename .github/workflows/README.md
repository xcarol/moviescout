# Comprehensive Android CI/CD Deployment Guide for MovieScout

This guide provides a complete, end-to-end walkthrough for setting up a fully automated continuous integration and continuous deployment (CI/CD) pipeline using **GitHub Actions** for a Flutter Android application (**MovieScout**).

This pipeline builds a signed **Android App Bundle (`.aab`)** and automatically deploys it to the **Internal Testing track** on the **Google Play Console**.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Step 1: Android Signing Keystore (.jks) Setup](#step-1-android-signing-keystore-jks-setup)
3. [Step 2: Firebase Configuration (google-services.json)](#step-2-firebase-configuration-google-servicesjson)
4. [Step 3: Local Environment Variables (.env)](#step-3-local-environment-variables-env)
5. [Step 4: Google Cloud Platform & Play Console Setup](#step-4-google-cloud-platform--play-console-setup)
   * [A. Enable Google Play Android Developer API](#a-enable-google-play-android-developer-api)
   * [B. Create Google Cloud Service Account & Download JSON Key](#b-create-google-cloud-service-account--download-json-key)
   * [C. Invite Service Account to Google Play Console](#c-invite-service-account-to-google-play-console)
6. [Step 5: Flutter & Android Project Configuration](#step-5-flutter--android-project-configuration)
   * [A. Update `android/app/build.gradle`](#a-update-androidappbuildgradle)
   * [B. Update `.gitignore`](#b-update-gitignore)
   * [C. Purge Unwanted Foreground Service Permissions (`AndroidManifest.xml`)](#c-purge-unwanted-foreground-service-permissions-androidmanifestxml)
7. [Step 6: Configure GitHub Repository Secrets](#step-6-configure-github-repository-secrets)
8. [Step 7: Workflow File Setup (`android_release.yml`)](#step-7-workflow-file-setup-android_releaseyml)
9. [Step 8: Executing the Pipeline](#step-8-executing-the-pipeline)
10. [Troubleshooting & Common Pitfalls](#troubleshooting--common-pitfalls)

---

## 1. Prerequisites

Before starting, ensure you have:

* A Flutter project with Android support.
* An active **Google Play Developer Account**.
* An active **Google Cloud Platform (GCP)** project associated with or accessible by your developer account.
* A registered Firebase project (if using Firebase services).
* Administrative access to your GitHub repository (*Settings > Secrets* access).

---

## Step 1: Android Signing Keystore (.jks) Setup

If you don't already have an upload keystore, generate one using `keytool`:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Note down:

1. **Keystore Password** (`storePassword`)
2. **Key Alias** (`keyAlias`, e.g., `upload`)
3. **Key Password** (`keyPassword`)

### Convert Keystore to Base64

To store the binary `.jks` file inside GitHub Secrets:

```bash
base64 -w 0 upload-keystore.jks > keystore_b64.txt
```

> **Warning:** Do not copy trailing terminal characters like `%` (common in Zsh). Always open `keystore_b64.txt` and copy the clean single line.

---

## Step 2: Firebase Configuration (google-services.json)

1. Download `google-services.json` from your Firebase Console under **Project Settings > General > Your Apps > Android app**.
2. Save it locally to `android/app/google-services.json`.
3. Convert the file to Base64 for GitHub Secrets:

```bash
base64 -w 0 android/app/google-services.json > gs_b64.txt
```

---

## Step 3: Local Environment Variables (.env)

If your project uses a `.env` file for storing API keys (e.g., TMDB API keys, API endpoints), copy the full text contents of your local `.env` file.

Example `.env` content:

```env
TMDB_API_KEY=your_tmdb_api_key_here
BASE_URL=https://api.themoviedb.org/3
```

Because `.env` is listed in `.gitignore`, we will recreate it dynamically inside GitHub Actions using a raw text secret named `ENV_FILE`.

---

## Step 4: Google Cloud Platform & Play Console Setup

This step authorizes GitHub Actions to publish builds directly to Google Play Console.

### A. Enable Google Play Android Developer API

1. Navigate to the [Google Cloud Console API Library](https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com).
2. Select your Google Cloud project.
3. Click **Enable** to turn on the **Google Play Android Developer API**.
   * *Critical:* If this API is not enabled, deployment attempts will fail with HTTP 403 (`SERVICE_DISABLED`).

### B. Create Google Cloud Service Account & Download JSON Key

1. Go to **Google Cloud Console > IAM & Admin > Service Accounts**.
2. Click **+ Create Service Account**.
3. Set Service Account Details:
   * **Name**: `moviescout-play-deployer`
   * **ID**: `moviescout-play-deployer`
4. Click **Create and Continue**, then click **Done**.
5. Click on the newly created Service Account email.
6. Select the **Keys** tab > **Add Key** > **Create new key**.
7. Choose **JSON** and click **Create**. A `.json` key file will download to your machine.
8. Convert the JSON key file to Base64:

```bash
base64 -w 0 your-service-account-key.json > play_sa_b64.txt
```

### C. Invite Service Account to Google Play Console

1. Copy the Service Account email address (e.g., `moviescout-play-deployer@your-project.iam.gserviceaccount.com`).
2. Go to the [Google Play Console](https://play.google.com/console).
3. From the left root menu, navigate to **Users and permissions** > **Invite new users**.
4. Paste the Service Account email into the **Email address** field.
5. Under **App permissions**:
   * Click **Add app** and select **MovieScout**.
   * Grant: **Release to internal testing** and **Manage testing tracks**.
6. Click **Invite user** (bottom right). Acceptance is instantaneous.

---

## Step 5: Flutter & Android Project Configuration

### A. Update `android/app/build.gradle`

Configure Gradle to read signing properties dynamically from `key.properties` if present:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### B. Update `.gitignore`

Ensure all sensitive files and generated secrets remain excluded from Git:

```gitignore
# Keystores & Signing
*.jks
*.keystore
/android/key.properties

# Firebase & Cloud Keys
/android/app/google-services.json
*.json

# Environment files
.env
```

### C. Purge Unwanted Foreground Service Permissions (`AndroidManifest.xml`)

Third-party Flutter plugins (e.g., notification or background fetch libraries) often inject `FOREGROUND_SERVICE` and Android 14 sub-permissions into the merged manifest. If your app does not strictly require an ongoing foreground service, Google Play will block API deployments unless you fill out policy declarations.

To automatically strip these injected permissions during build time, edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <!-- Explicitly remove base and Android 14+ foreground service permissions injected by dependencies -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" tools:node="remove" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" tools:node="remove" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" tools:node="remove" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING" tools:node="remove" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" tools:node="remove" />

    <application
        android:label="MovieScout"
        ... >
        ...
    </application>
</manifest>
```

---

## Step 6: Configure GitHub Repository Secrets

Go to your GitHub Repository > **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.

Create the following **7 Secrets**:

| Secret Name | Type | Value / Content |
| :--- | :--- | :--- |
| `ANDROID_KEYSTORE_BASE64` | Base64 | Content of `keystore_b64.txt` |
| `ANDROID_KEYSTORE_PASSWORD` | Text | Password for your `.jks` file |
| `ANDROID_KEY_ALIAS` | Text | Key alias (e.g., `upload`) |
| `ANDROID_KEY_PASSWORD` | Text | Password for the key alias |
| `ENV_FILE` | Text | Full raw text content of your local `.env` file |
| `GOOGLE_SERVICES_JSON` | Base64 | Content of `gs_b64.txt` |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Base64 | Content of `play_sa_b64.txt` |

---

## Step 7: Workflow File Setup (`android_release.yml`)

Create `.github/workflows/android_release.yml` with the following content:

```yaml
name: Android Release Build & Publish

on:
  workflow_run:
    workflows: ["Create Release"]
    types:
      - completed
  workflow_dispatch:

jobs:
  deploy-android:
    name: Build & Deploy Signed Android AppBundle
    if: ${{ github.event_name == 'workflow_dispatch' || github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest

    steps:
      # 1. Checkout repository
      - name: Checkout repository
        uses: actions/checkout@v4

      # 2. Setup Java JDK
      - name: Set up Java JDK
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      # 3. Setup Flutter SDK
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      # 4. Recreate .env file
      - name: Create .env file
        run: |
          echo "${{ secrets.ENV_FILE }}" > .env

      # 5. Recreate google-services.json for Firebase
      - name: Create google-services.json
        run: |
          echo "${{ secrets.GOOGLE_SERVICES_JSON }}" | base64 --decode > android/app/google-services.json

      # 6. Decode Keystore file
      - name: Decode Android Keystore
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks

      # 7. Recreate key.properties file
      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=upload-keystore.jks" >> android/key.properties

      # 8. Fetch Flutter dependencies
      - name: Install dependencies
        run: flutter pub get

      # 9. Build Release AppBundle
      - name: Build Android AppBundle
        run: flutter build appbundle --release

      # 10. Upload AAB as workflow artifact
      - name: Upload AAB Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release-aab
          path: build/app/outputs/bundle/release/app-release.aab

      # 11. Deploy to Google Play Console (Internal Track)
      - name: Deploy to Google Play Internal Testing
        uses: KevinRohn/github-action-upload-play-store@v1.0.2
        with:
          service_account_json: ${{ secrets.PLAY_STORE_SERVICE_ACCOUNT_JSON }}
          package_name: com.xicra.moviescout
          aab_file_path: build/app/outputs/bundle/release/app-release.aab
          track: internal
          release_status: completed
```

---

## Step 8: Executing the Pipeline

You can trigger the pipeline in two ways:

### Option A: Manual Trigger (workflow_dispatch)

1. Go to your GitHub Repository > **Actions**.
2. Select **Android Release Build & Publish**.
3. Click **Run workflow** > Select branch (`master`) > Click **Run workflow**.

### Option B: Tag Push

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## Troubleshooting & Common Pitfalls

### 1. `Google Play Android Developer API has not been used in project... or it is disabled` (HTTP 403)

* **Cause**: The Android Publisher API is turned off in Google Cloud.
* **Fix**: Open the URL provided in the GitHub Actions failure log (or go to [Google Cloud Console API Library](https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com)) and click **Enable**. Wait 3–5 minutes before retrying.

### 2. `You must let us know whether your app uses any Foreground Service permissions` (HTTP 403)

* **Cause**: A third-party package injected `FOREGROUND_SERVICE` or Android 14 sub-permissions (`FOREGROUND_SERVICE_DATA_SYNC`, etc.) into your merged manifest, triggering Google Play policy requirements. Or, an old failed release draft remains stuck in Play Console.
* **Fix**:
  1. Add `tools:node="remove"` for all `FOREGROUND_SERVICE*` permissions in `android/app/src/main/AndroidManifest.xml` (see Step 5.C).
  2. Go to **Google Play Console > Testing > Internal testing** and **Discard draft** if an uncommitted release is stuck.

### 3. `No file or variants found for asset: .env`

* **Cause**: Flutter build failed because `.env` is listed under `assets:` in `pubspec.yaml` but missing from the repository.
* **Fix**: Ensure the `Create .env file` step is executed before `flutter pub get` and that the `ENV_FILE` secret is set.

### 4. `File google-services.json is missing`

* **Cause**: Firebase Gradle plugin cannot find `android/app/google-services.json`.
* **Fix**: Ensure `GOOGLE_SERVICES_JSON` secret is configured with Base64 output of `google-services.json` and decoded to `android/app/google-services.json`.

### 5. Job Skipped (`This job was skipped`) when running manually

* **Cause**: The workflow `if:` condition requires an upstream `workflow_run` event.
* **Fix**: Ensure the `if:` statement includes `github.event_name == 'workflow_dispatch'`.

### 6. Base64 Decoding Errors

* **Cause**: Trailing `%` prompt character copied from Zsh terminal output.
* **Fix**: Output base64 commands to a text file (`> output.txt`) and copy text directly from the file.
