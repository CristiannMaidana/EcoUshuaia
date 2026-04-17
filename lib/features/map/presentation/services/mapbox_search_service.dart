import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:eco_ushuaia/features/map/presentation/services/native_map_search_bridge.dart';

class AddressSearchService {
  final NativeMapSearchBridge _bridge;

  AddressSearchService({NativeMapSearchBridge? bridge})
    : _bridge = bridge ?? const NativeMapSearchBridge();

  Future<List<PlaceLocation>> search(String query) async {
    return _bridge.searchAddress(query);
  }

  Future<List<PlaceLocation>> suggestions(String query) async {
    return _bridge.searchSuggestions(query);
  }

  Future<PlaceLocation?> selectSuggestion(PlaceLocation suggestion) async {
    return _bridge.selectSuggestion(suggestion);
  }

  Future<String?> addressFromPoint(double lat, double lon) async {
    return _bridge.reverseGeocode(latitude: lat, longitude: lon);
  }
}
