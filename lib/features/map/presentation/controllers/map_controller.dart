import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/services.dart';

class MapController {
  MapboxMap? _map;
  PointAnnotationManager? _contenedorAnnotationManager;
  Uint8List? _contenedorIcon;

  // Icon de la ubicacion a buscar y punto
  PointAnnotationManager? _direccionAnnotationManager;
  Uint8List? _searchIcon;

  final Map<String, Contenedor> _annotationToContenedor = {};

  /// Callback que la UI puede setear para reaccionar al contenedor tocado
  void Function(Contenedor contenedor)? onContenedorTap;

  MapController(this._map);

  Future<void> enableUserPuck() async {
    final ByteData byte = await rootBundle.load('assets/icons/mapa/location.png');
    final Uint8List imageData = byte.buffer.asUint8List();
    final map = _map;
    if (map == null) return;

    await map.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        puckBearingEnabled: true,
        locationPuck: LocationPuck(
          locationPuck2D: LocationPuck2D(
            topImage: imageData,
          ),
        ),
      ),
    );
  }

  Future<void> centerOnUserOnce({double zoom = 15}) async {
    final map = _map;
    if (map == null) return;

    final pos = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );
    
    await map.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(pos.longitude, pos.latitude),
        ),
        zoom: zoom,
      ),
    );
  }

  Future<void> setStyle(MapStyle style) async {
    final map = _map;
    if (map == null) return;

    switch (style) {
      case MapStyle.Estandar:
        await map.style.setStyleURI(MapboxStyles.STANDARD);
        break;

      case MapStyle.Satelite:
        await map.style.setStyleURI(MapboxStyles.SATELLITE_STREETS);
        break;

      case MapStyle.Oscuro:
        await map.style.setStyleURI(MapboxStyles.DARK);
        break;

      case MapStyle.Terreno:
        await map.style.setStyleURI(MapboxStyles.OUTDOORS);
        break;
    }
  }

  void attach(MapboxMap map) {
    _map = map;
  }

  void detach() {
    _map = null;
    _contenedorAnnotationManager = null;
    _contenedorIcon = null;
    _annotationToContenedor.clear();
    onContenedorTap = null;

    _direccionAnnotationManager = null;
    _searchIcon = null;
  }

  Future<void> _ensureContenedorAnnotationManager() async {
    final map = _map;
    if (map == null) return;

    _contenedorAnnotationManager ??= await map.annotations.createPointAnnotationManager();

    if (_contenedorAnnotationManager != null) {
      _contenedorAnnotationManager!.tapEvents(
        onTap: (PointAnnotation tapped) async {
          await _onContenedorTapped(tapped);
        },
      );
    }
  }

  Future<void> _ensureContenedorIcon() async {
    if (_contenedorIcon != null) return;

    final byte = await rootBundle.load('assets/icons/mapa/container.png');
    _contenedorIcon = byte.buffer.asUint8List();
  }

  /// Agrega en el mapa una lista de contenedores.
  Future<void> showContenedores(List<Contenedor> contenedores) async {
    final map = _map;
    if (map == null || contenedores.isEmpty) return;

    await _ensureContenedorAnnotationManager();
    await _ensureContenedorIcon();

    final mgr = _contenedorAnnotationManager;
    if (mgr == null || _contenedorIcon == null) return;

    final options = contenedores.where((c) => c.coordenada != null)
        .map((c) {
          final coord = c.coordenada!;
          return PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(
                coord.longitud,
                coord.latitud,
              ),
            ),
            image: _contenedorIcon,
          );
        })
        .toList();

    if (options.isEmpty) return;

    final annotations = await mgr.createMulti(options);

    //Cargo el mapa con Contenedor
    _annotationToContenedor.clear();
    for (var i = 0; i < annotations.length && i < contenedores.length; i++) {
      _annotationToContenedor[annotations[i]! .id] = contenedores[i];
    }
  }
  
  /// Refresca los contenedores en el mapa.
  Future<void> refreshContenedores(List<Contenedor> contenedores) async {
    final map = _map;
    if (map == null) return;

    await _ensureContenedorAnnotationManager();
    await _ensureContenedorIcon();

    final mgr = _contenedorAnnotationManager;
    if (mgr == null) return;

    // limpiar anteriores para evitar duplicados
    await mgr.deleteAll();
    // agregar de nuevo
    await showContenedores(contenedores);
  }

  ///Callback interno cuando se toca un contenedor
  Future<void> _onContenedorTapped(PointAnnotation annotation) async {
    final _contenedorSeleccionado = _annotationToContenedor[annotation.id];

    onContenedorTap!(_contenedorSeleccionado!);
  }

  // Cargar los contenedores filtrados por opciones de filtros
  Future<void> applyFilter(List<Contenedor> filtroContenedor) async {
    await refreshContenedores(filtroContenedor);
  }


  //==== Metodos de generacion de direccion a buscar ===
  // Inicializo el punto que muestra la direccion destino
  Future<void> _ensureDireccionAnnotationManager() async {
    final map = _map;
    if (map == null) return;

    _direccionAnnotationManager ??=
        await map.annotations.createPointAnnotationManager();
  }

  // Inicializo el icon para el punto que muestra la direccion destino
  Future<void> _ensureDireccionIcon() async {
    if (_searchIcon != null) return;

    final byte = await rootBundle.load('assets/icons/mapa/map_pin.png');
    _searchIcon = byte.buffer.asUint8List();
  }

  // Centrar el mapa en la dirección buscada
  Future<void> centerOnAddress({required double lat, required double lon, double zoom = 15}) async {
    if (_map == null) return;
    await _map!.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(lon, lat)), 
        zoom: zoom
      )
    );

    // Inicializo y creo icon para el punto de la direccion
    await _ensureDireccionAnnotationManager();
    await _ensureDireccionIcon();

    final mgr = _direccionAnnotationManager;
    if (mgr == null || _searchIcon == null) return;

    // Borra cualquier pin previo de búsqueda
    await mgr.deleteAll();

    // Crear el nuevo pin en la dirección buscada
    final options = PointAnnotationOptions(
      geometry: Point(coordinates: Position(lon, lat)),
      image: _searchIcon!,
    );

    await mgr.create(options);
  }
}
