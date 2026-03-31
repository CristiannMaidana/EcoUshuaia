import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapboxInitializer {
  MapboxInitializer._();

  static bool _initialized = false;
  static String? _accessToken;

  static String get accessToken {
    final token = _accessToken ?? const String.fromEnvironment('ACCESS_TOKEN');
    _accessToken = token;
    return token;
  }

  static void ensureInitialized() {
    if (_initialized) return;
    final token = accessToken;
    MapboxOptions.setAccessToken(token);
    MapBoxSearch.init(token);
    _initialized = true;
  }
}
