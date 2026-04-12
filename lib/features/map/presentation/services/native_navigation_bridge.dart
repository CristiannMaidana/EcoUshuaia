import 'package:eco_ushuaia/features/map/presentation/models/native_waypoint.dart';
import 'package:flutter/services.dart';

class NativeNavigationBridge {
  static const MethodChannel _channel = MethodChannel('eco_ushuaia/navigation');

  const NativeNavigationBridge();

  Future<String?> ping() async {
    try {
      return await _channel.invokeMethod<String>('pingNavigation');
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> openNativeNavigation({
    required double latitude,
    required double longitude,
    String? title,
  }) {
    return _invokeVoid('openNativeNavigation', <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
    });
  }

  Future<void> startNavigation({
    required List<NativeWaypoint> waypoints,
    String profile = 'automobile',
  }) {
    return _invokeVoid('startNavigation', <String, dynamic>{
      'profile': profile,
      'waypoints': waypoints.map((w) => w.toMap()).toList(growable: false),
    });
  }

  Future<void> stopNavigation() {
    return _invokeVoid('stopNavigation');
  }

  Future<void> _invokeVoid(String method, [Map<String, dynamic>? args]) async {
    try {
      await _channel.invokeMethod<void>(method, args);
    } on MissingPluginException {
      // Native implementation is intentionally scaffolded in this phase.
    }
  }
}
