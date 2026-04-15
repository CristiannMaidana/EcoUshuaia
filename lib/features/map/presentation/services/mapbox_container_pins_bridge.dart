import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:flutter/services.dart';

class MapboxContainerPinsBridge {
  static const String _channelPrefix =
      'eco_ushuaia/mapbox_navigation_map_view/container_pins';

  final MethodChannel _channel;

  MapboxContainerPinsBridge._(this._channel);

  factory MapboxContainerPinsBridge.fromViewId(int viewId) {
    return MapboxContainerPinsBridge._(
      MethodChannel('$_channelPrefix/$viewId'),
    );
  }

  void setEventHandlers({ValueChanged<int>? onContainerSelected}) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onContainerSelected':
          final args = Map<String, dynamic>.from(call.arguments as Map);
          final id = (args['idContenedor'] as num?)?.toInt();
          if (id != null) {
            onContainerSelected?.call(id);
          }
          return null;
        default:
          return null;
      }
    });
  }

  void clearEventHandlers() {
    _channel.setMethodCallHandler(null);
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

  Future<void> _invokeVoid(String method, [Map<String, dynamic>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } on MissingPluginException {
      // El canal nativo solo existe en iOS.
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
