import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/contenedor_dto.dart';

class ContenedorRemoteDataSource {
  final ApiClient api;

  ContenedorRemoteDataSource(this.api);

  Future<List<ContenedorDto>> list({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/contenedores/', query: filtros);

    if (data is Map<String, dynamic> && data['features'] is List) {
      final features = (data['features'] as List)
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
      return features.map(ContenedorDto.fromGeoJsonFeature).toList(growable: false);
    }

    return const <ContenedorDto>[];
  }
}