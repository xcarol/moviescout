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

Useful _.vscode/launch.json_

```
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [

    {
      "name": "MovieScout Web",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--web-port", "8080", "--device-id", "chrome"],
    },
    {
      "name": "MovieScout Android",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--device-id", "RMX2001"]
    }
  ]
}
```

On _MovieScout Web_ parameter `--web-port` is important to set it as the one defined at the [Authorized JavaScript origins](https://console.cloud.google.com/apis/credentials/oauthclient/522907829647-g3amo1mcfp0smq336kqsaf8826g3d418.apps.googleusercontent.com?inv=1&invt=AbpCsw&project=movie-scout-a6608)

On _MovieScout Android_ parameter `--device-id` set the desired device name.  

### Internationalization

Followed this guide: [i18n|Flutter](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)  

Run `flutter gen-l10n` to update the i18n generated files.  

## Icons

The [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) tool is used to generate the icons for different platforms  

The file used as the app logo is _./lib/assets/logo-icon.png_  defined in the _pubspec.yaml_ file under the _flutter_launcher_icons_ section.  

After updating the logo run:  $ `dart run flutter_launcher_icons`

## Tmdb integration

Get the **API Read Access Token** from [The Movie DB API Settings](https://www.themoviedb.org/settings/api)     
Create a file called _.env_ in the root directory and add the key:
```
TMDB_API_KEY=apiReadAccessTokenGotFromTmdb
``` 

## Google Sign In

Get the **OAuth 2.0 Client ID** from [Google APIs & Services > Credentials](https://console.cloud.google.com/apis/credentials?inv=1&invt=Abo3Jg&project=movie-scout-a6608)     
Create a file called _.env_ in the root directory and add the key:
```
OAUTH_CLIENT_ID=googleOauthClintIDGotFromGoogle
``` 

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
