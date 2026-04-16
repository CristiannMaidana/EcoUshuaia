import 'package:flutter/services.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';

class MapboxNavigationMapViewBridge {
  static const String viewType = 'eco_ushuaia/mapbox_navigation_map_view';
  static const String _channelPrefix = 'eco_ushuaia/mapbox_navigation_map_view';

  final MethodChannel _channel;

  MapboxNavigationMapViewBridge._(this._channel);

  factory MapboxNavigationMapViewBridge.fromViewId(int viewId) {
    return MapboxNavigationMapViewBridge._(
      MethodChannel('$_channelPrefix/$viewId'),
    );
  }

  static Map<String, dynamic> creationParams({
    required double latitude,
    required double longitude,
    double zoom = 13,
  }) {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'zoom': zoom,
    };
  }

  void setEventHandlers({
    ValueChanged<Map<String, dynamic>>? onRoutePreviewed,
    ValueChanged<Map<String, dynamic>>? onRouteProgress,
    ValueChanged<Map<String, dynamic>>? onNavigationStateChanged,
    ValueChanged<Map<String, dynamic>>? onNavigationError,
  }) {
    _channel.setMethodCallHandler((call) async {
      final payload = _payload(call.arguments);

      switch (call.method) {
        case 'onRoutePreviewed':
          onRoutePreviewed?.call(payload);
          return null;
        case 'onRouteProgress':
          onRouteProgress?.call(payload);
          return null;
        case 'onNavigationStateChanged':
          onNavigationStateChanged?.call(payload);
          return null;
        case 'onNavigationError':
          onNavigationError?.call(payload);
          return null;
        default:
          return null;
      }
    });
  }

  void clearEventHandlers() {
    _channel.setMethodCallHandler(null);
  }

  Future<Map<String, dynamic>?> previewRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    String profile = 'automobile',
  }) {
    return _invokeMap('previewRoute', <String, dynamic>{
      'originLatitude': originLatitude,
      'originLongitude': originLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'profile': profile,
    });
  }

  Future<Map<String, dynamic>?> previewDrivingRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) {
    return previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
      profile: 'automobile',
    );
  }

  Future<Map<String, dynamic>?> previewWalkingRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) {
    return previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
      profile: 'walking',
    );
  }

  Future<Map<String, dynamic>?> previewCyclingRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) {
    return previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
      profile: 'cycling',
    );
  }

  Future<Map<String, dynamic>?> startNavigation() {
    return _invokeMap('startNavigation');
  }

  Future<Map<String, dynamic>?> cancelNavigation() {
    return _invokeMap('cancelNavigation');
  }

  Future<Map<String, dynamic>?> centerTurnByTurnCamera() {
    return _invokeMap('centerTurnByTurnCamera');
  }

  Future<Map<String, dynamic>?> updatePreviewSheetInset({
    required double height,
    required String state,
  }) {
    return _invokeMap('updatePreviewSheetInset', <String, dynamic>{
      'height': height,
      'state': state,
    });
  }

  Future<Map<String, dynamic>?> setMapStyle(MapStyle style) {
    return _invokeMap('setMapStyle', <String, dynamic>{
      'style': _styleId(style),
    });
  }

  Future<Map<String, dynamic>?> getNavigationState() {
    return _invokeMap('getNavigationState');
  }

  Future<Map<String, dynamic>?> _invokeMap(
    String method, [
    Map<String, dynamic>? args,
  ]) async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        method,
        args,
      );
      return result == null ? null : Map<String, dynamic>.from(result);
    } on MissingPluginException {
      return null;
    }
  }

  static Map<String, dynamic> _payload(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static String _styleId(MapStyle style) {
    switch (style) {
      case MapStyle.Estandar:
        return 'standard';
      case MapStyle.Satelite:
        return 'standardSatellite';
      case MapStyle.Oscuro:
        return 'dark';
      case MapStyle.Terreno:
        return 'outdoors';
    }
  }
}
