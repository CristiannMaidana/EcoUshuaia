import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapboxSearchService {
  // Instancias de GeoCodingApi de mapbox_search
  final GeoCodingApi _geo;
  final GeoCodingApi _reverseAddressGeo;
  final GeoCodingApi _reversePlaceGeo;

  MapboxSearchService()
      : _geo = GeoCodingApi(
          country: "AR", // Restringir busquedas a Argentina
          limit: 10, // Limitar resultados a 10
          language: 'es',
          types: const [PlaceType.address, PlaceType.place],
        ),
        _reverseAddressGeo = GeoCodingApi(
          country: "AR",
          limit: 1,
          language: 'es',
          types: const [PlaceType.address],
        ),
        _reversePlaceGeo = GeoCodingApi(
          country: "AR",
          limit: 1,
          language: 'es',
          types: const [PlaceType.place],
        );

  Future<List<PlaceLocation>> search(String query) async {
    final resp = await _geo.getPlaces(query.trim());
    return resp.fold(
      (places) => places
          .where((p) => p.center != null)
          .map((p) => PlaceLocation(
                lat: p.center!.lat,
                lon: p.center!.long,
                name: p.text,
                address: p.placeName,
              ))
          .toList(),
      (err) => throw Exception('Mapbox search error: ${err.message}'),
    );
  }

  // Buscar una direccion en base a un punto
  Future<String?> addressFromPoint(double lat, double lon) async {
    final location = (lat: lat, long: lon);

    final addrResp = await _reverseAddressGeo.getAddress(location);
    final addrName = addrResp.fold(
      (places) =>
          places.isNotEmpty == true ? _formatAddress(places.first) : null,
      (err) => throw Exception('Mapbox reverse-geocoding error: ${err.message}'),
    );
    if (addrName != null && addrName.trim().isNotEmpty) return addrName;

    // Si no encontro una direccion buscar un lugar
    final placeResp = await _reversePlaceGeo.getAddress(location);
    return placeResp.fold(
      (places) =>
          places.isNotEmpty == true ? _formatAddress(places.first) : null,
      (err) => throw Exception('Mapbox reverse-geocoding error: ${err.message}'),
    );
  }

  // Ordeno el string
  String? _formatAddress(MapBoxPlace place) {
    final street = place.text?.trim();
    final number = (place.addressNumber ?? place.address)?.trim();
    if (street != null && street.isNotEmpty) {
      if (number != null && number.isNotEmpty) return '$street $number';
      return street;
    }
    final full = place.placeName?.trim();
    return (full == null || full.isEmpty) ? null : full;
  }
}
