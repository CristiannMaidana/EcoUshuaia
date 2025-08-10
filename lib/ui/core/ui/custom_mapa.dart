import 'package:eco_ushuaia/ui/core/ui/custom_mapa_controller.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomMapa extends StatefulWidget {
  final void Function(CustomMapaController controller) onMapReady;

  const CustomMapa({
    Key? key,
    required this.onMapReady,
  }) : super(key: key);

  @override
  State<CustomMapa> createState() => _CustomMapaState();
}

class _CustomMapaState extends State<CustomMapa> {
  late final String accessToken;
  MapboxMap? _mapboxMap;
  final _controller = CustomMapaController(null);

  @override
  void initState() {
    super.initState();
    accessToken = const String.fromEnvironment("ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);
  }
  
  void _onMapCreated(MapboxMap map) {
    _mapboxMap = map;
    _controller.attach(map);
    widget.onMapReady(_controller); 
  }

  @override
  void dispose() {
    _controller.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("map"),
      onMapCreated: _onMapCreated,
    );
  }
}