#!/bin/bash
# Safe Gradle clean and rebuild for Flutter projects (Linux)
#
# Useful for resolving issues related with NEVERENDING BUILDS.

echo "Cleaning Kotlin DSL cache..."
rm -rf ~/.gradle/caches/8.14/kotlin-dsl/

echo "Fixing Gradle cache permissions..."
sudo chown -R $USER:$USER ~/.gradle

echo "Killing any leftover Gradle daemons..."
PIDS=$(ps aux | grep '[g]radle' | grep -v 'clean-gradle.sh' | awk '{print $2}')
if [ ! -z "$PIDS" ]; then
    echo "Found Gradle processes: $PIDS"
    kill -9 $PIDS
else
    echo "No Gradle processes found."
fi

echo "Cleaning project build..."
cd ~/workspace/moviescout/android
./gradlew clean

echo "Rebuilding with refreshed dependencies..."
./gradlew build --refresh-dependencies

echo "Building debug APK..."
./gradlew assembleDebug
