import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/horario_recoleccion_filtros_dto.dart';

class HorarioRecoleccionFiltrosRemoteDataSources {
  final ApiClient api;

  HorarioRecoleccionFiltrosRemoteDataSources(this.api);

  static const String _url = '/horario_recoleccion';

  Future<List<HorarioRecoleccionFiltrosDto>> porHora({required String horaInicio, required String horaFin}) async {
    final data = await api.get('$_url/horario_inicio/$horaInicio/horario_fin/$horaFin');
    return _toDtoList(data);
  }

  Future<List<HorarioRecoleccionFiltrosDto>> porDiaZona({
    required int dia, required int zona}) async {
    final data = await api.get('$_url/dia/$dia/zona/$zona');
    return _toDtoList(data);
  }
  
  Future<List<HorarioRecoleccionFiltrosDto>> porHoraMannanaZona({
    required String hhmmss, required int mannana, required int zona,}) async {
    final data = await api.get('$_url/horario_inicio/$hhmmss/dia_mannana/$mannana/zona_id/$zona');
    return _toDtoList(data);
  }

  Future<List<HorarioRecoleccionFiltrosDto>> semanaDesdeDiaZona({
    required int desdeDia, required int zona}) async {
    final data = await api.get('$_url/semana/$desdeDia/zona/$zona');
    return _toDtoList(data);
  }
  
  Future<List<HorarioRecoleccionFiltrosDto>> _toDtoList(dynamic data) async {
    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List){
      list = data;
    } else {
      list = const [];
    }

    return list.whereType<Map>().map((e) => HorarioRecoleccionFiltrosDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}