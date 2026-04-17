import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:flutter/services.dart';

class NativeMapSearchBridge {
  static const MethodChannel _channel = MethodChannel('eco_ushuaia/map_search');

  const NativeMapSearchBridge();

  Future<List<PlaceLocation>> search(String query) async {
    return searchAddress(query);
  }

  Future<List<PlaceLocation>> searchAddress(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <PlaceLocation>[];

    try {
      final raw = await _channel.invokeMethod<List<dynamic>>(
        'searchAddress',
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

  Future<List<PlaceLocation>> searchSuggestions(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <PlaceLocation>[];

    try {
      final raw = await _channel.invokeMethod<List<dynamic>>(
        'searchSuggestions',
        <String, dynamic>{'query': trimmed},
      );
      return (raw ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => _suggestionFromMap(item.cast<String, dynamic>()))
          .whereType<PlaceLocation>()
          .toList(growable: false);
    } on MissingPluginException {
      return const <PlaceLocation>[];
    }
  }

  Future<PlaceLocation?> selectSuggestion(PlaceLocation suggestion) async {
    final suggestionId = suggestion.suggestionId;
    if (suggestionId == null || suggestionId.isEmpty) return suggestion;

    try {
      final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'selectSuggestion',
        <String, dynamic>{'suggestionId': suggestionId},
      );
      if (raw == null) return null;
      return _placeFromMap(raw.cast<String, dynamic>());
    } on MissingPluginException {
      return null;
    }
  }

  Future<PlaceLocation?> reverseSearch({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'reverseSearch',
        <String, dynamic>{'lat': latitude, 'lon': longitude},
      );
      if (raw == null) return null;
      return _placeFromMap(raw.cast<String, dynamic>());
    } on MissingPluginException {
      return null;
    }
  }

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final place = await reverseSearch(latitude: latitude, longitude: longitude);
    return place?.address?.trim().isNotEmpty == true
        ? place!.address
        : place?.name;
  }

  PlaceLocation? _placeFromMap(Map<String, dynamic> map) {
    final lat =
        (map['lat'] as num?)?.toDouble() ??
        (map['latitude'] as num?)?.toDouble();
    final lon =
        (map['lon'] as num?)?.toDouble() ??
        (map['longitude'] as num?)?.toDouble();
    if (lat == null || lon == null) return null;

    return PlaceLocation(
      lat: lat,
      lon: lon,
      name: map['name'] as String?,
      address: map['address'] as String?,
    );
  }

  PlaceLocation? _suggestionFromMap(Map<String, dynamic> map) {
    final suggestionId = map['suggestionId'] as String?;
    if (suggestionId == null || suggestionId.isEmpty) return null;

    return PlaceLocation(
      lat: 0,
      lon: 0,
      name: map['name'] as String?,
      address: map['address'] as String?,
      suggestionId: suggestionId,
    );
  }
}
