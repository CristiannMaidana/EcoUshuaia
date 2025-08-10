import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/services.dart';

class CustomMapaController {
  MapboxMap? _map;

  CustomMapaController(this._map);

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

  void attach(MapboxMap map) {
    _map = map;
  }

  void detach() {
    _map = null;
  }
}
