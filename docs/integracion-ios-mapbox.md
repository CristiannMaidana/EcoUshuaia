# Integracion iOS y Mapbox

## Alcance

La funcionalidad avanzada de mapa, busqueda y navegacion del proyecto se implementa mediante integracion nativa iOS con Mapbox.

Esta integracion combina:

- `UiKitView` en Flutter
- `MethodChannel`
- implementaciones nativas en Swift
- bridges del lado Flutter

## Punto de entrada en Flutter

El widget principal para renderizar el mapa nativo es:

- `lib/features/map/presentation/widgets/mapbox_navigation_map_view.dart`

Ese widget:

- crea un `UiKitView`
- inicializa bridges por `viewId`
- conecta callbacks de navegacion, preview y seleccion de contenedores

## Bridges Flutter

Los bridges principales se encuentran en:

- `lib/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart`
- `lib/features/map/presentation/services/mapbox_container_pins_bridge.dart`
- `lib/features/map/presentation/services/native_map_search_bridge.dart`

Responsabilidades:

- invocar metodos nativos
- transformar payloads
- escuchar eventos enviados desde Swift

## Componentes nativos en iOS

Los archivos principales del lado iOS son:

- `ios/Runner/MapboxNavigationMapViewFactory.swift`
- `ios/Runner/NavigationMapView.swift`
- `ios/Runner/NavigationChannelHandler.swift`
- `ios/Runner/ContainerPinsChannelHandler.swift`
- `ios/Runner/ContainerPinsCoordinator.swift`
- `ios/Runner/SearchChannelHandler.swift`
- `ios/Runner/MapboxSearchNative.swift`
- `ios/Runner/NativeMapRuntime.swift`
- `ios/Runner/NavigationCoreNative.swift`

## Funcionalidades cubiertas por la integracion

### Mapa nativo

La vista nativa encapsula el mapa, el control de camara y la logica de preview/navegacion.

Archivo principal:

- `ios/Runner/NavigationMapView.swift`

### Contenedores sobre el mapa

Los contenedores se proyectan como anotaciones nativas y pueden emitir eventos de seleccion hacia Flutter.

Archivos relacionados:

- `lib/features/map/presentation/services/mapbox_container_pins_bridge.dart`
- `ios/Runner/ContainerPinsChannelHandler.swift`
- `ios/Runner/ContainerPinsCoordinator.swift`

### Preview de destino y ruta

La app puede:

- centrar el mapa en un destino
- mostrar preview de destino
- calcular y pintar ruta
- actualizar el inset del mapa segun el estado del bottom sheet

Archivos relacionados:

- `lib/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart`
- `ios/Runner/NavigationChannelHandler.swift`
- `ios/Runner/NavigationMapView.swift`
- `ios/Runner/NavigationCoreNative.swift`

### Navegacion asistida

La integracion expone operaciones para:

- iniciar navegacion
- cancelar navegacion
- centrar la camara turn-by-turn
- consultar estado actual

### Busqueda y geocodificacion

La busqueda de direcciones y la geocodificacion inversa se resuelven a traves de:

- `lib/features/map/presentation/services/native_map_search_bridge.dart`
- `ios/Runner/SearchChannelHandler.swift`
- `ios/Runner/MapboxSearchNative.swift`

## Registro del lado iOS

La factoria del platform view se registra desde:

- `ios/Runner/NavigationChannelHandler.swift`

La busqueda nativa se registra mediante:

- `ios/Runner/SearchChannelHandler.swift`

## Dependencias y requisitos

Aspectos visibles en el repositorio:

- `ios/Podfile` fija `platform :ios, '15.6'`
- `ios/Runner/Info.plist` contiene `MBXAccessToken`
- el proyecto iOS resuelve dependencias de Mapbox mediante Swift Package Manager

## Comportamiento por plataforma

La implementacion avanzada de mapa documentada en este archivo corresponde a iOS.

El widget `MapboxNavigationMapView` devuelve una vista vacia fuera de iOS, por lo que esta integracion no representa una implementacion nativa equivalente para Android dentro del estado actual del repositorio.
