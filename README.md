# Movie Scout

Movie Scout is your ultimate movie and series tracker. Discover where your favorite titles are streaming and keep your personal watchlist up to date.  

**Key Features:**  
- **Stream Availability**: Easily find out which streaming platforms host your favorite movies and series.  
- **Search and Organize**: Quickly search, add, or remove titles from your list.  
- **Detailed Information**: View essential details like posters, titles, brief descriptions, and more.  
- **User-Friendly Design**: Enjoy a clean and intuitive interface designed for movie and TV enthusiasts.  

Whether you’re keeping track of what to watch next or exploring new favorites, Movie Scout ensures you’re always in the know.  

**Discover. Track. Watch.**  
Download Movie Scout now and streamline your streaming experience!

## Development environment

### Flutter installation

- Install Android Studio using snap: `sudo snap install android-studio --classic`  
- Install flutter following this guide: [Start building Flutter Android apps on Linux](https://docs.flutter.dev/get-started/install/linux/android)  
- Add flutter path to _.zshrc_: `export PATH=$PATH:$HOME/workspace/devtools/flutter/bin`  
- Run `flutter doctor --android-licenses` to review and accept andriod licenses.  

### Firebase & Crashlytics

Got configuration steps from _https://firebase.google.com/docs/crashlytics/get-started?platform=flutter_  

Project configuration at Firebase [Movie Scout](https://console.firebase.google.com/project/movie-scout-a6608/overview)


Install Flutter Fire

    dart pub global activate flutterfire_cli

Add its path to _.zshrc_

    export PATH=$PATH":"$HOME/.pub-cache/bin

Login to Firebase  

    firebase login

Configure project  

    flutterfire configure

Select  

✔ Select a Firebase project to configure your Flutter application with  
· overmap-1503847389383 (Overmaps)  
✔ Which platforms should your configuration support (use arrow keys & space to select)?  
· android  

This process will generate the files:  

    google-services.json
    firebase_options.dart

### VSCODE

Set in _.vscode/launch.json_

    "configurations": [
        {
          "name": "moviescout",
          "request": "launch",
          "type": "dart"
        }
      ]

### Internationalization

Followed this guide: [i18n|Flutter](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)  

Run `flutter gen-l10n` to update the i18n generated files.  

## Icons

The [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) tool is used to generate the icons for different platforms  

The file used as the app logo is _./lib/assets/logo-icon.png_  defined in the _pubspec.yaml_ file under the _flutter_launcher_icons_ section.  

After updating the logo run:  $ `dart run flutter_launcher_icons`

## Build and run Android App

Setup this file in the path _./android_:  

- _key.properties_

    storePassword=(Stored in BitWarden with the name _Android signing_)  
    keyPassword=(Stored in BitWarden with the name _Android signing_)  
    keyAlias=upload  
    storeFile=/home/xcarol/workspace/moviescout/upload-keystore.jks (Stored in BitWarden with the name _Android signing_)  

### Build

#### Bundle

`flutter build appbundle --release`

## Application signing and publishing

The keystore (and password) used for the app signing is at the Bitwarden vault. These are the same used in the _key.properties_ file.  

### Publishing a new version for internal test

- Modify the last (build) number in _version: 1.0.0+**X**_ at the _pubspec.yaml_ file before building the new .aab bundle.

- Build the bundle as explained above.

- Go to: [Create an internal test version](https://play.google.com/console/u/0/developers/5602401961225582177/app/4972075179053080011/app-dashboard) to upload it.
