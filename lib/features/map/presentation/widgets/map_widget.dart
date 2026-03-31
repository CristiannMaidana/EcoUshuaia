import 'package:eco_ushuaia/core/services/mapbox_initializer.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomMapa extends StatefulWidget {
  final void Function(MapController controller) onMapReady;

  const CustomMapa({
    super.key,
    required this.onMapReady,
  });

  @override
  State<CustomMapa> createState() => _CustomMapaState();
}

class _CustomMapaState extends State<CustomMapa> {
  late final String accessToken;
  // ignore: unused_field
  MapboxMap? _mapboxMap;
  final _controller = MapController(null);

  @override
  void initState() {
    super.initState();
    MapboxInitializer.ensureInitialized();
    accessToken = MapboxInitializer.accessToken;
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
