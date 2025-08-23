import '../../../../core/network/http_client.dart';
import '../models/residuo_dto.dart';

class ResiduosRemoteDataSource {
  final ApiClient api;
  ResiduosRemoteDataSource(this.api);

  Future<List<ResiduoDto>> listar() async {
    final data = await api.get('/residuos/');

    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => ResiduoDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}