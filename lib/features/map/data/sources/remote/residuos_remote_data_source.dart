import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/residuos_dto.dart';

class ResiduosRemoteDataSource {
  final ApiClient api;

  ResiduosRemoteDataSource(this.api);

  Future<List<ResiduosDto>> list({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/residuos/', query: filtros);

   List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => ResiduosDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}