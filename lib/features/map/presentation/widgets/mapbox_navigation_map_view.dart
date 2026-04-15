import 'dart:io';

import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapboxNavigationMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final ValueChanged<MapboxNavigationMapViewBridge>? onMapReady;
  final ValueChanged<Map<String, dynamic>>? onRoutePreviewed;
  final ValueChanged<Map<String, dynamic>>? onRouteProgress;
  final ValueChanged<Map<String, dynamic>>? onNavigationStateChanged;
  final ValueChanged<Map<String, dynamic>>? onNavigationError;

  const MapboxNavigationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 13,
    this.onMapReady,
    this.onRoutePreviewed,
    this.onRouteProgress,
    this.onNavigationStateChanged,
    this.onNavigationError,
  });

  @override
  State<MapboxNavigationMapView> createState() =>
      _MapboxNavigationMapViewState();
}

class _MapboxNavigationMapViewState extends State<MapboxNavigationMapView> {
  MapboxNavigationMapViewBridge? _bridge;

  void _onPlatformViewCreated(int id) {
    final bridge = MapboxNavigationMapViewBridge.fromViewId(id);
    _bridge = bridge;
    _setBridgeHandlers(bridge);
    widget.onMapReady?.call(bridge);
  }

  void _setBridgeHandlers(MapboxNavigationMapViewBridge bridge) {
    bridge.setEventHandlers(
      onRoutePreviewed: widget.onRoutePreviewed,
      onRouteProgress: widget.onRouteProgress,
      onNavigationStateChanged: widget.onNavigationStateChanged,
      onNavigationError: widget.onNavigationError,
    );
  }

  @override
  void didUpdateWidget(covariant MapboxNavigationMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bridge = _bridge;
    if (bridge == null) return;

    if (oldWidget.onRoutePreviewed != widget.onRoutePreviewed ||
        oldWidget.onRouteProgress != widget.onRouteProgress ||
        oldWidget.onNavigationStateChanged != widget.onNavigationStateChanged ||
        oldWidget.onNavigationError != widget.onNavigationError) {
      _setBridgeHandlers(bridge);
    }
  }

  @override
  void dispose() {
    _bridge?.clearEventHandlers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return UiKitView(
      viewType: MapboxNavigationMapViewBridge.viewType,
      creationParams: MapboxNavigationMapViewBridge.creationParams(
        latitude: widget.latitude,
        longitude: widget.longitude,
        zoom: widget.zoom,
      ),
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
