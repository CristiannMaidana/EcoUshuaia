import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/models/native_waypoint.dart';
import 'package:eco_ushuaia/features/map/presentation/services/native_map_view_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:geolocator/geolocator.dart' as geo;

class MapController {
  NativeMapViewBridge? _bridge;

  /// Callback que la UI puede setear para reaccionar al contenedor tocado.
  void Function(Contenedor contenedor)? onContenedorTap;

  MapController(this._bridge);

  Future<void> enableUserPuck() async {
    await _bridge?.setUserLocationEnabled(true);
  }

  Future<void> centerOnUserOnce({double zoom = 15}) async {
    await _bridge?.centerOnUser(zoom: zoom);
  }

  Future<void> setStyle(MapStyle style) async {
    await _bridge?.setMapStyle(style);
  }

  void attach(NativeMapViewBridge bridge) {
    _bridge = bridge;
  }

  void detach() {
    _bridge = null;
    onContenedorTap = null;
  }

  /// Agrega en el mapa una lista de contenedores.
  Future<void> showContenedores(List<Contenedor> contenedores) async {
    await _bridge?.setContainers(contenedores);
  }

  /// Refresca los contenedores en el mapa.
  Future<void> refreshContenedores(List<Contenedor> contenedores) async {
    await _bridge?.setContainers(contenedores);
  }

  // Cargar los contenedores filtrados por opciones de filtros.
  Future<void> applyFilter(List<Contenedor> filtroContenedor) async {
    await refreshContenedores(filtroContenedor);
  }

  // Metodo para obtener la distancia entre dos puntos.
  Future<double> getMetros(double lon, double lat) async {
    final pos = await geo.Geolocator.getCurrentPosition(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
      ),
    );

    return geo.Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      lat,
      lon,
    );
  }

  Future<Map<String, double>> getPoint() async {
    final pos = await geo.Geolocator.getCurrentPosition(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
      ),
    );
    return <String, double>{'lon': pos.longitude, 'lat': pos.latitude};
  }

  // Centrar el mapa en la dirección buscada.
  Future<void> centerOnAddress({
    required double lat,
    required double lon,
    double zoom = 15,
  }) async {
    await _bridge?.showDestination(latitude: lat, longitude: lon, zoom: zoom);
  }

  // Marca la ruta desde la ubicacion del usuario a la direccion.
  Future<void> addRoute({required double lat, required double lon}) async {
    await _bridge?.previewRoute(
      waypoints: <NativeWaypoint>[
        NativeWaypoint(latitude: lat, longitude: lon),
      ],
    );
  }
}
