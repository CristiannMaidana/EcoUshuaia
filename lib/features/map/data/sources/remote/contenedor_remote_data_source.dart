import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/contenedor_dto.dart';

class ContenedorRemoteDataSource {
  final ApiClient api;

  ContenedorRemoteDataSource(this.api);

  Future<List<ContenedorDto>> list() async {
    final data = await api.get('/contenedores/');
    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => ContenedorDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}