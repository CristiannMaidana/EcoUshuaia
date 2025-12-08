import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/services.dart';

class MapController {
  MapboxMap? _map;
  PointAnnotationManager? _contenedorAnnotationManager;
  Uint8List? _contenedorIcon;

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
    switch (style) {
      case MapStyle.Estandar:
        await map!.style.setStyleURI(MapboxStyles.STANDARD);
        break;

      case MapStyle.Satelite:
        await map!.style.setStyleURI(MapboxStyles.SATELLITE_STREETS);
        break;

      case MapStyle.Oscuro:
        await map!.style.setStyleURI(MapboxStyles.DARK);
        break;

      case MapStyle.Terreno:
        await map!.style.setStyleURI(MapboxStyles.OUTDOORS);
        break;

      default:
        return;
    }
  }

  void attach(MapboxMap map) {
    _map = map;
  }

  void detach() {
    _map = null;
  }

  // Asegura que el PointAnnotationManager para contenedores esté creado
  Future<void> _ensureContenedorAnnotationManager() async {
    final map = _map;
    if (map == null) return;

    if (_contenedorAnnotationManager == null) {
      _contenedorAnnotationManager =
          await map.annotations.createPointAnnotationManager();
    }
  }
  
  // Cargar el icono del contenedor desde assets
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

    if (_contenedorAnnotationManager == null || _contenedorIcon == null) return;

    final List<PointAnnotationOptions> options = contenedores.map((c) {
      return PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(c.coordenada!.longitud, c.coordenada!.latitud),
        ),
        image: _contenedorIcon!,
      );
    }).toList();

    await _contenedorAnnotationManager!.createMulti(options);
  }
}
