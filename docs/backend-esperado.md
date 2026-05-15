# Backend esperado

## Vision general

La app consume una API HTTP y centraliza las llamadas en:

- `lib/core/network/http_client.dart`

El cliente:

- construye URLs a partir de `Env.BASE_URL`
- agrega headers JSON
- adjunta token `Bearer` cuando corresponde
- maneja errores de red, parseo y servidor

## Autenticacion

La autenticacion observable en el repositorio utiliza access token y refresh token.

Archivos principales:

- `lib/features/auth/data/sources/remote/auth_usuario_remote_data_sources.dart`
- `lib/core/services/secure_storage/secure_storage_services.dart`

### Endpoints utilizados

- `/token/`
- `/token/refresh/`

### Comportamiento esperado

- `/token/` devuelve `access` y `refresh`
- `/token/refresh/` devuelve al menos un nuevo `access`

## Usuario y perfil

Archivos principales:

- `lib/features/shell/data/sources/usuarios_remote_data_sources.dart`
- `lib/features/auth/data/sources/remote/usuarios_create_remote_data_source.dart`
- `lib/features/auth/data/sources/remote/domicilio_remote_data_source.dart`

### Endpoints utilizados

- `/usuarios/`
- `/usuarios/me/`

## Contenedores

Archivos principales:

- `lib/features/map/data/sources/remote/contenedor_remote_data_source.dart`

### Endpoints utilizados

- `/contenedores/`
- `/contenedores/filtros/`
- `/contenedores/por-dia/`
- `/contenedores/por-mannana/`
- `/contenedores/por-categorias/`
- `/contenedores/cerca/{lon},{lat}/{metros}`

### Forma de respuesta esperada

El data source espera respuestas con estructura GeoJSON-like:

- un objeto con `features`
- cada feature con `properties`
- coordenadas en `geometry.coordinates`

La conversion a entidad se resuelve en:

- `lib/features/map/data/models/contenedor_dto.dart`

## Calendario y novedades

Archivos principales:

- `lib/features/calendar/data/sources/calendario_remote_data_sources.dart`
- `lib/features/calendar/data/sources/categoria_noticias_remote_data_sources.dart`

### Endpoint visible

- `/calendarios/`

### Forma de respuesta esperada

Para calendario, el codigo soporta:

- una lista JSON
- un objeto con clave `results`

## Residuos, categorias y filtros

Archivos principales:

- `lib/features/map/data/sources/remote/residuos_remote_data_source.dart`
- `lib/features/map/data/sources/remote/categoria_residuos_remote_data_source.dart`
- `lib/features/map/data/sources/remote/horario_recoleccion_filtros_remote_data_sources.dart`
- `lib/features/map/data/sources/remote/usuario_contenedor_favoritos_remote_data_source.dart`

Estos modulos dependen del backend para poblar:

- residuos
- categorias
- horarios de recoleccion
- favoritos del usuario

## Formato de errores

El `ApiClient` intenta resolver mensajes de error desde:

- `detail`
- listas de strings
- mapas clave/valor

Si la API devuelve un cuerpo JSON con mensajes descriptivos, la app puede mostrarlos al usuario con mayor precision.

## Recomendacion de documentacion adicional

Si el backend evoluciona en paralelo, conviene mantener por separado:

- especificacion de endpoints
- ejemplos de requests y responses
- reglas de autenticacion
- contrato de errores
