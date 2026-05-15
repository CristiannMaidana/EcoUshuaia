# Desarrollo local

## Requisitos previos

Para levantar el proyecto localmente se necesita:

- Flutter SDK 3.x
- Dart SDK compatible con `pubspec.yaml`
- Xcode y CocoaPods para iOS
- Android Studio o toolchain Android
- backend disponible y accesible desde la app

## Instalacion base

Desde la raiz del proyecto:

```bash
flutter pub get
```

Para iOS:

```bash
cd ios
pod install
cd ..
```

## Ejecucion

### Ver dispositivos disponibles

```bash
flutter devices
```

### Ejecutar en iOS

```bash
flutter run -d ios
```

### Ejecutar en Android

```bash
flutter run -d android
```

### Ejecutar en un dispositivo especifico

```bash
flutter run -d <device-id>
```

## Comandos utiles

### Analisis estatico

```bash
flutter analyze
```

### Tests

```bash
flutter test
```

### Limpiar artefactos

```bash
flutter clean
flutter pub get
```

### Reinstalar pods

```bash
cd ios
pod install
cd ..
```

## Puntos a revisar antes de correr

- verificar `BASE_URL` en `lib/config/env/env.dart`
- verificar token de Mapbox en `ios/Runner/Info.plist`
- confirmar permisos de ubicacion en iOS
- confirmar que el backend responde en las rutas esperadas

## Archivos clave para desarrollo

- `lib/bootstrap/main.dart`
- `lib/app/app.dart`
- `lib/app/di/di.dart`
- `lib/config/env/env.dart`

## Nota sobre iOS

La funcionalidad avanzada de mapa y navegacion se apoya en integracion nativa iOS. Si hay cambios en Pods, paquetes Swift o configuracion de Mapbox, conviene revisar:

- `ios/Podfile`
- `ios/Runner/Info.plist`
- `ios/Runner.xcodeproj/`
- `ios/Runner.xcworkspace/`
