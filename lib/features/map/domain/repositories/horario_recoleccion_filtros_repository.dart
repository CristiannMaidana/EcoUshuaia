import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';

abstract class HorarioRecoleccionFiltrosRepository {  
  Future<List<HorarioRecoleccionFiltros>> porHora({
    required String horaInicio, required String horaFin});

  Future<List<HorarioRecoleccionFiltros>> porDiaZona({
    required int dia, required int zona});

  Future<List<HorarioRecoleccionFiltros>> semanaDesdeDiaZona({
    required int desdeDia, required int zona});
}