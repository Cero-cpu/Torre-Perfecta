#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(realpath "$SCRIPT_DIR/..")"
cd "$SCRIPT_DIR"

export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"

KEYSTORE="$SCRIPT_DIR/android/torre-perfecta.keystore"
KEY_ALIAS="torreperfecta"
STORE_PASS="torre123456"

echo "=========================================================="
echo " ==> 1. Sincronizando cambios web con Capacitor..."
echo "=========================================================="
npx cap sync android

echo "=========================================================="
echo " ==> 2. Compilando AAB y APK Release..."
echo "=========================================================="
cd android
./gradlew bundleRelease assembleRelease

echo "=========================================================="
echo " ==> 3. Verificando y firmando automáticamente..."
echo "=========================================================="
AAB_SRC="$SCRIPT_DIR/android/app/build/outputs/bundle/release/app-release.aab"
APK_SRC="$SCRIPT_DIR/android/app/build/outputs/apk/release/app-release.apk"

# Fallback si el apk se generó con nombre unsigned
if [ ! -f "$APK_SRC" ] && [ -f "$SCRIPT_DIR/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
    APK_SRC="$SCRIPT_DIR/android/app/build/outputs/apk/release/app-release-unsigned.apk"
fi

# Copiar a la carpeta raíz del proyecto
cp "$AAB_SRC" "$ROOT_DIR/TorrePerfecta-release.aab"
cp "$APK_SRC" "$ROOT_DIR/TorrePerfecta-release.apk"

# Firmar con jarsigner por seguridad para garantizar firma completa
jarsigner -sigalg SHA256withRSA -digestalg SHA-256 -keystore "$KEYSTORE" -storepass "$STORE_PASS" -keypass "$STORE_PASS" "$ROOT_DIR/TorrePerfecta-release.aab" "$KEY_ALIAS" > /dev/null
jarsigner -sigalg SHA256withRSA -digestalg SHA-256 -keystore "$KEYSTORE" -storepass "$STORE_PASS" -keypass "$STORE_PASS" "$ROOT_DIR/TorrePerfecta-release.apk" "$KEY_ALIAS" > /dev/null

echo "=========================================================="
echo " ¡LISTO! Archivos firmados para subir o instalar:"
echo " 1) Google Play Console (AAB):"
echo "    $ROOT_DIR/TorrePerfecta-release.aab"
echo " 2) Instalador directo (APK):"
echo "    $ROOT_DIR/TorrePerfecta-release.apk"
echo "=========================================================="

