#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export JAVA_HOME="${JAVA_HOME:-/opt/android-studio/jbr}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "==> Sincronizando cambios con Capacitor..."
npx cap sync android

echo "==> Compilando APK..."
cd android
./gradlew assembleDebug

echo "==> Copiando APK listo para instalar..."
cp app/build/outputs/apk/debug/app-debug.apk "$SCRIPT_DIR/../TorrePerfecta-debug.apk"

echo "=========================================================="
echo " APK generado con éxito:"
echo " $(realpath "$SCRIPT_DIR/../TorrePerfecta-debug.apk")"
echo "=========================================================="
