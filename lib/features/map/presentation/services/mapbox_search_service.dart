import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapboxSearchService {
  // Instancia de GeoCodingApi de mapbox_search
  final GeoCodingApi _geo = GeoCodingApi(
    country: "AR",  // Restringir busquedas a Argentina
    limit: 10,      // Limitar resultados a 10
    language: 'es',
    types: const [PlaceType.address, PlaceType.place],
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
}