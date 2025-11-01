# Movie Scout

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/7487a433b43b4c8781d753122b470d5b)](https://app.codacy.com/gh/xcarol/moviescout/dashboard)

Movie Scout is a movie and series tracker based on TMDB. It focuses on _What I want to watch now_ instead of _Look what I have for you to watch_ apps.  

**Key Features:**  

- **Stream Availability**: Easily find out which streaming platforms host your favorite movies and series.  
- **Search and Organize**: Quickly search, add, or remove titles from your list.  
- **Detailed Information**: View essential details like posters, titles, brief descriptions, and more.  
- **User-Friendly Design**: Enjoy a clean and intuitive interface designed for movie and TV enthusiasts.  

Whether you’re keeping track of what to watch next or exploring new favorites, Movie Scout ensures you’re always in the know.  

**Discover. Track. Watch.**  
Download Movie Scout now and streamline your streaming experience!

## IDMB Import Export

To import titles from IMDB go to your Imdb account > [Watchlist](https://www.imdb.com/user/ur49413795/watchlist/) > Export  
and Imdb account > [Ratings](https://www.imdb.com/es-es/user/ur49413795/ratings) > Export.  

Download the CSV files from [Exports](https://www.imdb.com/exports/?ref_=wl) and import them with the menu option _Import From IMDB_.

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
- movie-scout-a6608 (MovieScout)  

✔ Which platforms should your configuration support (use arrow keys & space to select)?  
- android  
- web 

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

Add `"flutterMode": "profile"` parameter for profiling.  

On _MovieScout Web_ parameter `--web-port` is important to set it as the one defined at the [Authorized JavaScript origins](https://console.cloud.google.com/apis/credentials/oauthclient/522907829647-g3amo1mcfp0smq336kqsaf8826g3d418.apps.googleusercontent.com?inv=1&invt=AbpCsw&project=movie-scout-a6608)

On _MovieScout Android_ parameter `--device-id` set the desired device name.  

### Internationalization

Followed this guide: [i18n|Flutter](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)  

Run `flutter gen-l10n` to update the i18n generated files.  

### Shared Preferences (deprecated)

~~The shared preferences are located at: _~/.local/share/com.xicra.moviescout_ folder.~~  

### Isar

Shared Preferences are not intended for huge data and a list of 1000 titles may reach 70MB which is even to much to hold in memory.  

Isar was adopted beacuse its easy to use and has power enough for the kind of queries needed by the app.

**NOTE:** Each time TmdbTitle class changes its "Schema" i.e. the public attributes, the command `dart run build_runner build` has to be executed. It is also available running the script _flutter_tool.sh_  with _-i_ parameter

## Icons

The [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) tool is used to generate the icons for different platforms  

The file used as the app logo is _./assets/logo-icon.png_  defined in the _pubspec.yaml_ file under the _flutter_launcher_icons_ section.  

After updating the logo run:  $ `dart run flutter_launcher_icons`

## Tmdb integration

Get the **API Read Access Token** from [The Movie DB API Settings](https://www.themoviedb.org/settings/api)     
Create a file called _.env_ in the root directory and add the key:
```
TMDB_API_RAT=apiReadAccessTokenGotFromTmdb
``` 
NOTICE! As stated in the [TMDB API Documentation about Providers](https://developer.themoviedb.org/reference/movie-watch-providers), the data source is [**JustWatch**](https://www.justwatch.com/).  

## Flutter tool box

Use the shell script `./flutter_tool.sh` to execute most used commands in the project.  
Run `./flutter_tool.sh --help` to view the tool options.    

## Application signing and publishing

Setup this file in the path _./android_:  

- _key.properties_

    storePassword=(Stored in BitWarden with the name _Android signing_)  
    keyPassword=(Stored in BitWarden with the name _Android signing_)  
    keyAlias=upload  
    storeFile=/home/xcarol/workspace/moviescout/upload-keystore.jks (Stored in BitWarden with the name _Android signing_)  

### Check app > build.gradle

This attribute shuld be like this
```
    buildTypes {
        release {
            signingConfig = signingConfigs.release
        }
    }
```
it is worth comparing it with the same Overmaps file to imitate it as much as possible.

### Publishing a new version for internal test

- Modify the last (build) number in _version: 1.0.0+**X**_ at the _pubspec.yaml_ file before building the new .aab bundle.
- Build the bundle `flutter build appbundle --release`.
- Go to: [Create an internal test version](https://play.google.com/console/u/0/developers/5602401961225582177/app/4972075179053080011/app-dashboard) to upload it.

## Troubleshooting

### adb cannot start a debug session with error: Access Denied  

With the mobile connected and developer option _Enable USB install_ ON
- Run `lsusb` to see the Android device. 
- It will output something like `Bus 001 Device 005: ID 18d1:4ee2 Google Inc.` we need the ID, usually the `18d1`.
- Create or open the file _/etc/udev/rules.d/51-android.rules_ and add
```
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
```
Check the `ATTR{idVendor}` corresponds with the ouput of `lsusb`.
- Give read permissions if the file didn't exist
`sudo chmod a+r /etc/udev/rules.d/51-android.rules`
- Restart _udev_
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```
Now the device should appear in the output of `adb devices` and debugger should be able to connect.  
