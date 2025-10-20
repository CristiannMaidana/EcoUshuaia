import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/calendar/data/models/calendario_dto.dart';

class CalendarioRemoteDataSources {
  final ApiClient api;

  CalendarioRemoteDataSources(this.api);

  Future<List<CalendarioDto>> list({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/calendarios/', query: filtros);
    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }
    return list.whereType<Map>().map((e) => CalendarioDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}