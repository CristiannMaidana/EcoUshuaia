import 'dart:io';
import 'package:eco_ushuaia/features/map/presentation/services/native_map_view_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosNavigationMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? title;
  final ValueChanged<NativeMapViewBridge>? onMapReady;
  final ValueChanged<int>? onContainerSelected;
  final ValueChanged<Map<String, dynamic>>? onRouteInfoChanged;

  const IosNavigationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title,
    this.onMapReady,
    this.onContainerSelected,
    this.onRouteInfoChanged,
  });

  @override
  State<IosNavigationMapView> createState() => _IosNavigationMapViewState();
}

class _IosNavigationMapViewState extends State<IosNavigationMapView> {
  NativeMapViewBridge? _bridge;

  void _onPlatformViewCreated(int id) {
    final bridge = NativeMapViewBridge.fromViewId(id);
    _bridge = bridge;
    bridge.setEventHandlers(
      onRouteInfoChanged: widget.onRouteInfoChanged,
      onContainerSelected: widget.onContainerSelected,
      onMapReady: () => widget.onMapReady?.call(bridge),
    );
    widget.onMapReady?.call(bridge);
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
      viewType: NativeMapViewBridge.viewType,
      creationParams: {
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'title': widget.title,
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
