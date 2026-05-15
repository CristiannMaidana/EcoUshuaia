# Configuracion

## Objetivo

Este documento resume los puntos de configuracion visibles en el repositorio para poder ejecutar la aplicacion en un entorno local.

## Backend

La URL base de la API se define en:

- `lib/config/env/env.dart`

Configuracion actual:

```dart
class Env {
  static const String BASE_URL = 'http://127.0.0.1:8000/api/';
  static const Duration connecTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
```

### Consideraciones

- `BASE_URL` debe apuntar a una API accesible desde el simulador o dispositivo.
- Si la app corre fuera del host donde vive el backend, `127.0.0.1` debe reemplazarse por una IP o dominio valido para ese entorno.

## Mapbox en iOS

La integracion nativa iOS utiliza un token configurado en:

- `ios/Runner/Info.plist`

Clave utilizada:

- `MBXAccessToken`

Ademas, en el proyecto iOS existen referencias a dependencias de:

- Mapbox Maps
- Mapbox Navigation
- Mapbox Search

## Permisos de ubicacion

La app utiliza ubicacion para:

- mostrar la posicion del usuario
- centrar el mapa
- calcular rutas
- resolver resultados cercanos

Configuracion visible:

- `ios/Runner/Info.plist`: `NSLocationWhenInUseUsageDescription`
- `ios/Podfile`: `PERMISSION_LOCATION_WHENINUSE=1`

## iOS

### Version minima

La plataforma minima definida en el proyecto iOS es:

- `ios/Podfile`: `platform :ios, '15.6'`

### Pods

El proyecto utiliza CocoaPods junto con paquetes Swift. Despues de instalar dependencias Flutter, es recomendable ejecutar:

```bash
cd ios
pod install
cd ..
```

## Android

Configuracion visible en el repositorio:

- namespace: `com.example.eco_ushuaia`
- applicationId: `com.example.eco_ushuaia`

Archivo:

- `android/app/build.gradle.kts`

El `AndroidManifest.xml` principal se encuentra en:

- `android/app/src/main/AndroidManifest.xml`

## Dependencias Flutter

Las dependencias principales declaradas en `pubspec.yaml` son:

- `provider`
- `http`
- `flutter_secure_storage`
- `geolocator`
- `permission_handler`
- `lottie`
- `table_calendar`
- `google_sign_in`

## Sesion y almacenamiento local

La persistencia de tokens se maneja desde:

- `lib/core/services/secure_storage/secure_storage_services.dart`

Claves utilizadas:

- `access_token`
- `refresh_token`

## Recomendacion de mantenimiento

Si el proyecto incorpora mas de un entorno, conviene separar:

- configuracion local
- staging
- produccion

Actualmente, la configuracion observable del backend esta centralizada en `lib/config/env/env.dart`.
