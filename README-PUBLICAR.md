# Torre Perfecta: publicar en Google Play

Necesitas instalado: **Node.js (versión actual LTS; Capacitor 8 pide una reciente, si `npm install` se queja actualiza Node)** y la **última versión de Android Studio** (con el SDK de Android y su JDK 21 incluido).

## 0. Revisa esto ANTES de empezar
1. **Nombre del paquete**: `com.alqenix.torreperfecta` (archivo `capacitor.config.json`). Una vez subido a Play **no se puede cambiar**. Cámbialo ahora si quieres otro.
2. **Política de privacidad**: `https://sites.google.com/view/torreperfecta/privacidad` (términos: `.../terminos`). Ya comprobé que ambos abren sin iniciar sesión. Usa el de privacidad en Play Console.
3. **AdMob**: el juego ya trae tus IDs reales (ver paso 9). Pon `ADMOB_TEST=true` mientras pruebas en tu teléfono y vuelve a `false` antes del .aab final.

## 1. Instalar dependencias (en una terminal, dentro de esta carpeta)
```
npm install @capacitor/core @capacitor/app @capacitor/browser @capacitor/android @capacitor-community/admob
npm install -D @capacitor/cli @capacitor/assets
npx cap add android
```

## 2. Íconos y pantalla de carga (usa la carpeta `assets/`)
```
npx @capacitor/assets generate --android
```

## 3. Configurar AdMob en Android
**a)** Abre `android/app/src/main/res/values/strings.xml` y añade dentro de `<resources>`:
```
<string name="admob_app_id">ca-app-pub-7768094116195335~6116557955</string>
```
**b)** Abre `android/app/src/main/AndroidManifest.xml` y añade dentro de `<application>` (junto a `<activity>`):
```
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="@string/admob_app_id" />
```
**c)** En ese mismo archivo, en la etiqueta `<activity ...>`, añade `android:screenOrientation="portrait"`.
**d)** En ese mismo archivo, justo encima de `<application>`, añade `<uses-permission android:name="android.permission.VIBRATE" />` (para que funcione la vibración del juego).

## 4. Sincronizar y abrir
```
npx cap sync android
npx cap open android
```

## 5. Probar en un teléfono real
Conecta el teléfono (depuración USB activada) y pulsa ▶ Run en Android Studio. Comprueba:
- Salen anuncios de prueba (con la etiqueta "Test Ad") cada 3 partidas.
- "Continuar con anuncio" aparece al perder con 5 o más pisos y te deja seguir.
- El botón Atrás pausa la partida; Ajustes > Política de privacidad abre el navegador.

## 6. Versión
En `android/app/build.gradle`: `versionCode 1` y `versionName "1.0"`. Cada subida nueva a Play necesita un `versionCode` mayor.

## 7. Generar el archivo para Play (.aab)
Android Studio > **Build > Generate Signed App Bundle / APK > Android App Bundle**. Crea un keystore nuevo.
**Guarda el archivo .jks y sus contraseñas en dos sitios distintos.** Si los pierdes tendrás problemas para actualizar la app.
El resultado queda en `android/app/release/app-release.aab`.

## 8. Subir a Play Console
1. Crea la app y sube el .aab primero a **Prueba interna** (disponible en minutos).
2. Rellena en "Contenido de la app" (ver `store/listing.md`): política de privacidad, anuncios (Sí), acceso a la app, clasificación de contenido, público objetivo, seguridad de los datos y ID de publicidad.
3. Ficha de la tienda: textos de `store/listing.md`, ícono `store/icon-512.png`, gráfico `store/feature-graphic-1024x500.png` y **al menos 2 capturas de pantalla** hechas desde tu teléfono.
4. Si tu cuenta de desarrollador es personal y nueva, Play puede exigir una **prueba cerrada con testers durante varios días** antes de la producción. Compruébalo en tu Play Console.

## 9. Anuncios reales (ya configurados)
`www/index.html` ya lleva tus IDs reales de AdMob (intersticial y recompensado) con `ADMOB_TEST=false`, y `strings.xml` lleva el ID real de la app.
- **Nunca toques tus propios anuncios reales**: AdMob puede suspender la cuenta. Para probar en tu teléfono, pon `ADMOB_TEST=true`, ejecuta `npx cap sync android` y prueba. Antes de generar el .aab final vuelve a ponerlo en `false`.
- Las unidades nuevas pueden tardar hasta una hora, o más, en mostrar anuncios. Mientras tanto es normal que salgan vacíos.
- Cada subida nueva a Play necesita un `versionCode` mayor.
