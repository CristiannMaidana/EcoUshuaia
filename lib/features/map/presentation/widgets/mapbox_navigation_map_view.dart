import 'dart:io';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapboxNavigationMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;

  const MapboxNavigationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 13,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return UiKitView(
      viewType: MapboxNavigationMapViewBridge.viewType,
      creationParams: MapboxNavigationMapViewBridge.creationParams(
        latitude: latitude,
        longitude: longitude,
        zoom: zoom,
      ),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
