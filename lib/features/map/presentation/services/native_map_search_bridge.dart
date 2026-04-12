import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:flutter/services.dart';

class NativeMapSearchBridge {
  static const MethodChannel _channel = MethodChannel('eco_ushuaia/map_search');

  const NativeMapSearchBridge();

  Future<List<PlaceLocation>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <PlaceLocation>[];

    try {
      final raw = await _channel.invokeMethod<List<dynamic>>(
        'search',
        <String, dynamic>{'query': trimmed},
      );
      return (raw ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => _placeFromMap(item.cast<String, dynamic>()))
          .whereType<PlaceLocation>()
          .toList(growable: false);
    } on MissingPluginException {
      return const <PlaceLocation>[];
    }
  }

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await _channel.invokeMethod<String>(
        'reverseGeocode',
        <String, dynamic>{'latitude': latitude, 'longitude': longitude},
      );
    } on MissingPluginException {
      return null;
    }
  }

  PlaceLocation? _placeFromMap(Map<String, dynamic> map) {
    final lat = (map['latitude'] as num?)?.toDouble();
    final lon = (map['longitude'] as num?)?.toDouble();
    if (lat == null || lon == null) return null;

    return PlaceLocation(
      lat: lat,
      lon: lon,
      name: map['name'] as String?,
      address: map['address'] as String?,
    );
  }
}
