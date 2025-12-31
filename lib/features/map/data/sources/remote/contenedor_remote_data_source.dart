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

  //Filtra contenedores por id de residuos
  Future<List<ContenedorDto>> filtrosResiduos(List<int> ids) async {
    //Elimina espacios y deja comas
    final idStrings = ids.join(',');

    final data = await api.get('/contenedores/filtros/?residuos=$idStrings');

    if (data is Map<String, dynamic> && data['features'] is List) {
      final features = (data['features'] as List)
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
      return features.map(ContenedorDto.fromGeoJsonFeature).toList();
    }
    
    return const <ContenedorDto>[];
  }

  //Filtra contenedores por id de horario de recoleccion
  Future<List<ContenedorDto>> filtrosRangoHorario(List<int> ids) async {
    //Elimina espacios y deja comas
    final idStrings = ids.join(',');

    final data = await api.get('/contenedores/por-categorias/?categorias=$idStrings');

    if (data is Map<String, dynamic> && data['features'] is List) {
      final features = (data['features'] as List)
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
      return features.map(ContenedorDto.fromGeoJsonFeature).toList();
    }
    
    return const <ContenedorDto>[];
  }
}