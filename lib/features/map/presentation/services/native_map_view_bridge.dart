import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/models/native_route_info.dart';
import 'package:eco_ushuaia/features/map/presentation/models/native_waypoint.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:flutter/services.dart';

class NativeMapViewBridge {
  static const String viewType = 'eco_ushuaia/navigation_map_view';
  static const String _channelPrefix = 'eco_ushuaia/navigation_map_view';

  final MethodChannel _channel;

  NativeMapViewBridge._(this._channel);

  factory NativeMapViewBridge.fromViewId(int viewId) {
    return NativeMapViewBridge._(MethodChannel('$_channelPrefix/$viewId'));
  }

  void setEventHandlers({
    ValueChanged<NativeRouteInfo>? onRouteInfoChanged,
    ValueChanged<int>? onContainerSelected,
    VoidCallback? onMapReady,
    ValueChanged<String>? onMapError,
  }) async {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onRouteInfoChanged':
          final args = call.arguments;
          if (args is Map) {
            onRouteInfoChanged?.call(NativeRouteInfo.fromMap(args));
          }
          return null;
        case 'onContainerSelected':
          final args = Map<String, dynamic>.from(call.arguments as Map);
          final id = (args['idContenedor'] as num?)?.toInt();
          if (id != null) onContainerSelected?.call(id);
          return null;
        case 'onMapReady':
          onMapReady?.call();
          return null;
        case 'onMapError':
          final args = Map<String, dynamic>.from(call.arguments as Map);
          onMapError?.call(args['message'] as String? ?? 'Map error');
          return null;
        default:
          return null;
      }
    });
  }

  void clearEventHandlers() {
    _channel.setMethodCallHandler(null);
  }

  Future<void> ping() {
    return _invokeVoid('pingMapView');
  }

  Future<void> setUserLocationEnabled(bool enabled) {
    return _invokeVoid('setUserLocationEnabled', <String, dynamic>{
      'enabled': enabled,
    });
  }

  Future<void> centerOnUser({double zoom = 15}) {
    return _invokeVoid('centerOnUser', <String, dynamic>{'zoom': zoom});
  }

  Future<void> centerOnCoordinate({
    required double latitude,
    required double longitude,
    double zoom = 15,
  }) {
    return _invokeVoid('centerOnCoordinate', <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
    });
  }

  Future<void> showDestination({
    required double latitude,
    required double longitude,
    String? title,
    double zoom = 15,
  }) {
    return _invokeVoid('showDestination', <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'zoom': zoom,
    });
  }

  Future<void> setMapStyle(MapStyle style) {
    return _invokeVoid('setMapStyle', <String, dynamic>{
      'style': _styleId(style),
    });
  }

  Future<void> setContainers(List<Contenedor> contenedores) {
    return _invokeVoid('setContainers', <String, dynamic>{
      'containers': contenedores
          .where((c) => c.coordenada != null)
          .map(_containerToMap)
          .toList(growable: false),
    });
  }

  Future<void> clearContainers() {
    return _invokeVoid('clearContainers');
  }

  Future<void> previewRoute({
    required List<NativeWaypoint> waypoints,
    String profile = 'automobile',
  }) {
    return _invokeVoid('previewRoute', <String, dynamic>{
      'profile': profile,
      'waypoints': waypoints.map((w) => w.toMap()).toList(growable: false),
    });
  }

  Future<void> clearRoutePreview() {
    return _invokeVoid('clearRoutePreview');
  }

  Future<void> _invokeVoid(String method, [Map<String, dynamic>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } on MissingPluginException {
      // Native implementation is intentionally scaffolded in this phase.
    }
  }

  static String _styleId(MapStyle style) {
    switch (style) {
      case MapStyle.Estandar:
        return 'standard';
      case MapStyle.Satelite:
        return 'satelliteStreets';
      case MapStyle.Oscuro:
        return 'dark';
      case MapStyle.Terreno:
        return 'outdoors';
    }
  }

  static Map<String, dynamic> _containerToMap(Contenedor c) {
    final coord = c.coordenada!;
    return <String, dynamic>{
      'idContenedor': c.idContenedor,
      'title': c.nombreContenedor,
      'description': c.descripcionUbicacion,
      'latitude': coord.latitud,
      'longitude': coord.longitud,
      'idResiduo': c.idResiduo,
      'idZona': c.idZona,
    };
  }
}
