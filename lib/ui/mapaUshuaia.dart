import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapaUshuaia extends StatefulWidget {
  const MapaUshuaia({Key? key}) : super(key: key);

  @override
  State<MapaUshuaia> createState() => _MapaUshuaiaState();
}

class _MapaUshuaiaState extends State<MapaUshuaia> {
  late final String accessToken;
  MapboxMap? _map;

  static const double lonUshuaia = -68.3030;
  static const double latUshuaia = -54.8019;

  @override
  void initState() {
    super.initState();
    accessToken = const String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: MapWidget(
        styleUri: MapboxStyles.STANDARD,
        cameraOptions: CameraOptions(
          zoom: 12,
          pitch: 0,
          bearing: 0,
        ),
        onMapCreated: (controller) async {
          _map = controller;
          await _map!.setCamera(CameraOptions(
            center: Point(coordinates: Position(lonUshuaia, latUshuaia)),
            zoom: 12,
          ));

          final manager = await _map!.annotations.createPointAnnotationManager();
          await manager.create(PointAnnotationOptions(
            geometry: Point(coordinates: Position(lonUshuaia, latUshuaia)),
            iconSize: 1.2,
          ));
        },
      ),
    );
    }
}