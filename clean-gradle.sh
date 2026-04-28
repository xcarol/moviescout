#!/bin/bash
# Safe Gradle clean and rebuild for Flutter projects (Linux)
#
# Useful for resolving issues related with NEVERENDING BUILDS.

echo "Killing any leftover Gradle daemons..."
PIDS=$(ps aux | grep '[g]radle' | grep -v 'clean-gradle.sh' | awk '{print $2}')
if [ ! -z "$PIDS" ]; then
    echo "Found Gradle processes: $PIDS"
    kill -9 "$PIDS"
else
    echo "No Gradle processes found."
fi

echo "Cleaning Gradle cache..."
sudo rm -fr ~/.gradle

echo "Rebuilding with refreshed dependencies..."
./gradlew build --refresh-dependencies

echo "Building debug APK..."
./gradlew assembleDebug
