import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/zona_mapa_dto.dart';

class ZonaMapaRemoteDataSource {
  final ApiClient api;

  ZonaMapaRemoteDataSource(this.api);

  Future<List<ZonaMapaDto>> list({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/zonas/', query: filtros);

    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }

    return list
        .whereType<Map>()
        .map((e) => ZonaMapaDto.fromJson(e.cast<String, dynamic>()))
        .toList(growable: false);
  }
}
