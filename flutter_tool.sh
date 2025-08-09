#!/bin/bash

set -e

show_help() {
  echo "Ús: ./build_flutter_app.sh [opcions]"
  echo ""
  echo "Opcions disponibles:"
  echo "  --firebase-login         Fer login a Firebase"
  echo "  --flutterfire-config     Configurar Firebase amb flutterfire"
  echo "  --launcher-icons         Generar icones de l'app"
  echo "  -a, --install-apk        Instal·lar APK en un dispositiu connectat"
  echo "  -d, --build-debug        Construir l'app Android (.aab)"
  echo "  -g, --gen-l10n           Generar fitxers de localització"
  echo "  -i, --build-isar         Genera els fitxers d'esquema per Isar"
  echo "  -r, --build-release      Construir APK release"
  echo "  -w, --wipe-cache         Netejar la caché i les dades de l'usuari"
  echo "  -h, --help               Mostrar aquesta ajuda"
}

run_firebase_login=false
run_flutterfire_config=false
run_gen_l10n=false
run_launcher_icons=false
run_build_debug=false
run_build_release=false
run_build_isar=false
run_wipe_cache=false
run_install_apk=false

if [ $# -eq 0 ]; then
  show_help
  exit 0
fi

for arg in "$@"; do
  case $arg in
    --firebase-login)
      run_firebase_login=true
      ;;
    --flutterfire-config)
      run_flutterfire_config=true
      ;;
    --launcher-icons)
      run_launcher_icons=true
      ;;
    -a|--install-apk)
      run_install_apk=true
      ;;
    -d|--build-debug)
      run_build_debug=true
      ;;
    -g|--gen-l10n)
      run_gen_l10n=true
      ;;
    -i|--build-isar)
      run_build_isar=true
      ;;
    -r|--build-release)
      run_build_release=true
      ;;
    -w|--wipe-cache)
      run_wipe_cache=true
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Opció desconeguda: $arg"
      show_help
      exit 1
      ;;
  esac
done

if $run_firebase_login; then
  echo "▶️ firebase login"
  firebase login
fi

if $run_flutterfire_config; then
  echo "▶️ flutterfire configure"
  flutterfire configure
fi

if $run_gen_l10n; then
  echo "▶️ flutter gen-l10n"
  flutter gen-l10n
fi

if $run_launcher_icons; then
  echo "▶️ dart run flutter_launcher_icons"
  dart run flutter_launcher_icons
fi

if $run_build_debug; then
  echo "▶️ llegint versió de pubspec.yaml"
  version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  if [ -z "$version" ]; then
    echo "⚠️ No s'ha pogut obtenir la versió del pubspec.yaml"
    exit 1
  fi

  echo "▶️ actualitzant VERSION=$version a .env"
  if [ -f .env ]; then
    sed -i.bak '/^VERSION=/d' .env
  fi
  echo "VERSION=$version" >> .env

  echo "▶️ flutter build appbundle --release"
  flutter build appbundle --release
fi

if $run_build_release; then
  echo "▶️ llegint versió de pubspec.yaml"
  version=$(grep '^version:' pubspec.yaml | awk '{print $2}')

  if [ -z "$version" ]; then
    echo "⚠️ No s'ha pogut obtenir la versió del pubspec.yaml"
    exit 1
  fi

  echo "▶️ actualitzant VERSION=$version a .env"
  if [ -f .env ]; then
    sed -i.bak '/^VERSION=/d' .env
  fi
  echo "VERSION=$version" >> .env

  echo "▶️ flutter build apk --release"
  flutter build apk --release
fi

if $run_build_isar; then
  echo "▶️ dart run isar_generator"
  dart run build_runner build
fi

if $run_wipe_cache; then
  echo "▶️ Netejant la caché i les dades de l'usuari"
  rm -rf ~/local/share/com.xicra.moviescout
  rm -rf ~/.cache/com.xicra.moviescout
  echo "✅ Caché i dades netejades"
fi

if $run_install_apk; then # 🆕
  echo "▶️ Buscant dispositius connectats..."
  devices=$(adb devices | grep -w "device" | awk '{print $1}')
  if [ -z "$devices" ]; then
    echo "❌ No s'ha trobat cap dispositiu connectat via ADB."
    exit 1
  fi

  echo "Dispositius disponibles:"
  select selected_device in $devices; do
    if [ -n "$selected_device" ]; then
      apk_path="build/app/outputs/flutter-apk/app-release.apk"
      if [ ! -f "$apk_path" ]; then
        echo "❌ No s'ha trobat l'APK: $apk_path"
        echo "▶️ Has executat abans l'opció --release?"
        exit 1
      fi
      echo "▶️ Instal·lant APK en $selected_device..."
      adb -s "$selected_device" install -r "$apk_path"
      echo "✅ APK instal·lat correctament!"
      break
    else
      echo "❌ Selecció no vàlida."
    fi
  done
fi
