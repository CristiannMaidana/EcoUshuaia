import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/calendar/data/models/categoria_noticias_dto.dart';

class CategoriaNoticiasRemoteDataSources {
  final ApiClient api;

  CategoriaNoticiasRemoteDataSources(this.api);

  Future<List<CategoriaNoticiasDto>> list({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/categoria_noticias/', query: filtros);
    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => CategoriaNoticiasDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}