import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomMapa extends StatefulWidget{
  
  CustomMapa({
    Key? key,
  }): super (key: key);

  @override
  State<CustomMapa> createState() => _CustomMapaState();
}

class _CustomMapaState extends State<CustomMapa> with SingleTickerProviderStateMixin{
  late final String accessToken;

  @override
  void initState() {
    super.initState();
    accessToken = const String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);
  }

  CameraOptions camera = CameraOptions(
    center: Point(coordinates: Position(-68.3030, -54.8019)),
    zoom: 12,
    bearing: 0,
    pitch: 0,
  );

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      cameraOptions: camera,
    );
  }
}