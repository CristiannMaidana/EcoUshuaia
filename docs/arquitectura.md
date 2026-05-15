# Arquitectura

## Vision general

El proyecto esta organizado por features y capas. La separacion principal busca mantener aisladas las responsabilidades de UI, dominio, acceso a datos y servicios compartidos.

## Capas

### `presentation`

Contiene la capa de interfaz y coordinacion de pantalla:

- pantallas
- widgets
- viewmodels
- controladores
- bridges hacia integracion nativa

Ejemplos visibles en el repositorio:

- `lib/features/auth/presentation/`
- `lib/features/map/presentation/`
- `lib/features/calendar/presentation/`

### `domain`

Define el modelo de negocio expuesto hacia la UI:

- entidades
- contratos de repositorios

Ejemplos:

- `lib/features/map/domain/entities/`
- `lib/features/map/domain/repositories/`
- `lib/core/domain/entities/`

### `data`

Resuelve la obtencion y transformacion de datos:

- data sources remotos
- data sources locales
- DTOs
- implementaciones de repositorios

Ejemplos:

- `lib/features/auth/data/`
- `lib/features/calendar/data/`
- `lib/features/map/data/`
- `lib/features/shell/data/`

### `core`

Agrupa piezas compartidas por toda la aplicacion:

- cliente de red
- storage seguro
- validaciones
- tema
- componentes reutilizables
- utilidades varias

Rutas principales:

- `lib/core/network/`
- `lib/core/services/`
- `lib/core/theme/`
- `lib/core/ui/`
- `lib/core/utils/`

### `app`

Centraliza el arranque de la aplicacion:

- configuracion del `MaterialApp`
- registro de providers
- composicion de dependencias

Archivos principales:

- `lib/bootstrap/main.dart`
- `lib/app/app.dart`
- `lib/app/di/di.dart`

## Gestion de estado

El manejo de estado visible en el proyecto se apoya en:

- `Provider`
- `ChangeNotifier`
- `MultiProvider`
- `ProxyProvider`
- `ChangeNotifierProvider`
- `ChangeNotifierProxyProvider`

La configuracion global de dependencias y servicios compartidos se compone en `lib/app/di/di.dart`.

## Flujo general de dependencias

La estructura habitual en cada feature es:

1. la UI consume un `ViewModel`
2. el `ViewModel` depende de un contrato de repositorio
3. el repositorio delega en uno o mas data sources
4. el data source usa `ApiClient` u otros servicios

## Features principales

### `features/auth`

Incluye:

- login
- registro
- bootstrap de sesion
- direccion inicial del usuario

### `features/home`

Incluye:

- pantalla principal
- accesos rapidos
- resumen visual de contenidos

### `features/map`

Es el modulo mas grande del proyecto. Incluye:

- mapa
- contenedores
- favoritos
- filtros
- busqueda de direcciones
- preview de rutas
- navegacion asistida
- bridges Flutter hacia Mapbox nativo en iOS

### `features/calendar`

Incluye:

- calendario visual
- eventos
- novedades vinculadas a fechas
- base de UI para recordatorios

### `features/news`

Incluye componentes de novedades y su presentacion en home y calendario.

### `features/settings`

Incluye:

- perfil
- edicion de domicilio
- preferencias
- cierre de sesion

### `features/shell`

Actua como contenedor principal de navegacion y compone el flujo entre tabs y datos de usuario.

## Estructura resumida

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

## Observaciones

- El proyecto combina una arquitectura por features con una separacion clasica `presentation/domain/data`.
- El modulo `map` concentra gran parte de la complejidad funcional y la integracion nativa.
- La inyeccion de dependencias esta resuelta manualmente mediante providers, sin contenedor externo adicional.
