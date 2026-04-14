class MapboxNavigationMapViewBridge {
  static const String viewType = 'eco_ushuaia/mapbox_navigation_map_view';

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
}
