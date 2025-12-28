import 'package:eco_ushuaia/features/map/data/models/horario_recoleccion_filtros_dto.dart';
import 'package:eco_ushuaia/features/map/data/sources/remote/horario_recoleccion_filtros_remote_data_sources.dart';
import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/horario_recoleccion_filtros_repository.dart';

class HorarioRecoleccionFiltrosRepositoryImp extends HorarioRecoleccionFiltrosRepository{
  final HorarioRecoleccionFiltrosRemoteDataSources remote;

  HorarioRecoleccionFiltrosRepositoryImp(this.remote);

  @override
  Future<List<HorarioRecoleccionFiltros>> porHoraDiaZona({
    required String hhmmss,
    required int dia,
    required int zona,
  }) async {
    final data = await remote.porHoraDiaZona(
      hhmmss: hhmmss,
      dia: dia,
      zona: zona,
    );
    return _map(data);
  }

  @override
  Future<List<HorarioRecoleccionFiltros>> porDiaZona({
    required int dia,
    required int zona,
  }) async {
    final data = await remote.porDiaZona(dia: dia, zona: zona);
    return _map(data);
  }

  @override
  Future<List<HorarioRecoleccionFiltros>> porHoraMannanaZona({
    required String hhmmss,
    required int mannana,
    required int zona,
  }) async {
    final data = await remote.porHoraMannanaZona(
      hhmmss: hhmmss,
      mannana: mannana,
      zona: zona,
    );
    return _map(data);
  }

  @override
  Future<List<HorarioRecoleccionFiltros>> semanaDesdeDiaZona({
    required int desdeDia,
    required int zona,
  }) async {
    final data = await remote.semanaDesdeDiaZona(
      desdeDia: desdeDia,
      zona: zona,
    );
    return _map(data);
  }

  List<HorarioRecoleccionFiltros> _map(List<HorarioRecoleccionFiltrosDto> list) =>
   list.map((e) => e.toEntity()).toList();
}