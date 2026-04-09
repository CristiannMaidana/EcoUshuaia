import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosNavigationMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? title;
  final ValueChanged<Map<String, dynamic>>? onRouteInfoChanged;

  const IosNavigationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.title,
    this.onRouteInfoChanged,
  });

  @override
  State<IosNavigationMapView> createState() => _IosNavigationMapViewState();
}

class _IosNavigationMapViewState extends State<IosNavigationMapView> {
  MethodChannel? _channel;

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('eco_ushuaia/navigation_map_view/$id');

    _channel!.setMethodCallHandler((call) async {
      if (call.method == 'onRouteInfoChanged') {
        final data = Map<String, dynamic>.from(call.arguments as Map);
        widget.onRouteInfoChanged?.call(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return UiKitView(
      viewType: 'eco_ushuaia/navigation_map_view',
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