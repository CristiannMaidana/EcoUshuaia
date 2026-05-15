# Eco Ushuaia

Aplicación móvil desarrollada en Flutter para centralizar funcionalidades vinculadas al reciclaje urbano, la consulta de contenedores, la navegación asistida, el calendario de novedades y la gestión básica de cuenta.

El proyecto combina una interfaz desarrollada en Flutter con integración nativa iOS para mapa, búsqueda de direcciones y navegación basada en Mapbox.

## Resumen

Eco Ushuaia está orientada a una experiencia móvil enfocada en:

- autenticacion y persistencia de sesion
- consulta y visualizacion de contenedores
- busqueda de direcciones y puntos cercanos
- previsualizacion y asistencia de rutas
- calendario de eventos y novedades
- configuracion de perfil y preferencias

## Funcionalidades principales

### Autenticacion y sesion

- inicio de sesion con credenciales
- registro de usuario
- restauracion de sesion con tokens
- persistencia segura con `flutter_secure_storage`
- cierre de sesion

### Mapa y navegacion

- visualizacion de contenedores en mapa
- filtros por residuos y horarios
- contenedores favoritos
- busqueda de direcciones
- geocodificacion inversa
- previsualizacion de destino
- generacion de ruta segun perfil de movilidad
- integracion nativa iOS con Mapbox

### Calendario y novedades

- calendario visual de eventos
- detalle de novedades por fecha
- seccion de noticias y anuncios

### Perfil y configuracion

- consulta de datos del usuario
- edicion de nombre, email, password y domicilio
- preferencias de notificaciones y mapa
- acciones de soporte y sesion

## Stack tecnológico

- Flutter
- Dart
- Provider
- `http`
- `flutter_secure_storage`
- `geolocator`
- `permission_handler`
- `lottie`
- `table_calendar`
- Swift
- Mapbox Maps
- Mapbox Navigation
- Mapbox Search

## Arquitectura

El proyecto esta organizado por features y capas:

- `presentation`: pantallas, widgets, viewmodels y controladores
- `domain`: entidades y contratos de repositorios
- `data`: DTOs, fuentes de datos e implementaciones de repositorios
- `core`: red, servicios, validaciones, tema y componentes reutilizables
- `app`: bootstrap de la aplicacion y registro de dependencias

El manejo de estado se apoya en `Provider` y `ChangeNotifier`. La composicion principal de dependencias se encuentra en `lib/app/di/di.dart`.

## Modulos principales

- `features/auth`: login, registro, sesion y direccion inicial
- `features/home`: panel principal y accesos rapidos
- `features/map`: contenedores, mapa, busqueda, filtros, favoritos y rutas
- `features/calendar`: calendario, eventos y novedades asociadas
- `features/news`: componentes de noticias y novedades
- `features/settings`: perfil, domicilio, preferencias y sesion
- `features/shell`: contenedor de navegacion principal y datos de usuario

## Estructura del proyecto

```text
lib/
|-- app/
|-- bootstrap/
|-- config/
|-- core/
`-- features/
    |-- auth/
    |-- calendar/
    |-- home/
    |-- map/
    |-- news/
    |-- settings/
    `-- shell/
```

## Requisitos

- Flutter SDK 3.x
- Dart SDK compatible con `pubspec.yaml`
- Xcode y CocoaPods para iOS
- Android Studio o toolchain Android para Android
- Backend disponible y accesible desde la aplicación

### iOS

- iOS 15.6 o superior
- dependencias de Mapbox resueltas correctamente

## Configuracion inicial

### Backend

La URL base de la API se define en:

`lib/config/env/env.dart`

Actualiza `BASE_URL` segun tu entorno.

### Mapbox en iOS

La integracion nativa iOS utiliza la clave `MBXAccessToken` en:

`ios/Runner/Info.plist`

### Ubicacion

La app requiere permisos de ubicacion para mostrar posicion, centrar mapa y calcular rutas.

## Instalacion

```bash
git clone <repo-url>
cd eco_ushuaia
flutter pub get
```

Para iOS:

```bash
cd ios
pod install
cd ..
```

## Ejecucion

### iOS

```bash
flutter run -d ios
```

### Android

```bash
flutter run -d android
```

### Seleccionar dispositivo

```bash
flutter devices
flutter run -d <device-id>
```

## Comandos utiles

```bash
flutter analyze
flutter test
flutter clean
flutter pub get
```

## Documentacion adicional

Este README resume el panorama general del repositorio. La documentacion tecnica complementaria se encuentra en [`/docs`](./docs/README.md).

- [Arquitectura](./docs/arquitectura.md)
- [Integracion iOS y Mapbox](./docs/integracion-ios-mapbox.md)
- [Configuracion](./docs/configuracion.md)
- [Desarrollo local](./docs/desarrollo-local.md)
- [Backend esperado](./docs/backend-esperado.md)
- [Roadmap tecnico](./docs/roadmap-tecnico.md)
