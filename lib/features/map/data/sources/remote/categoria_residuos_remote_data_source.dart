import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/categoria_residuos_dto.dart';

class CategoriaResiduosRemoteDataSource {
  final ApiClient api;

  CategoriaResiduosRemoteDataSource(this.api);

  Future<List<CategoriaResiduosDto>> list ({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/categoria_residuos/', query: filtros);

    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => CategoriaResiduosDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}