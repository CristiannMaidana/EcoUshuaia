import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';

abstract class HorarioRecoleccionFiltrosRepository {
  Future<List<HorarioRecoleccionFiltros>> list({Map<String, dynamic> filtros});
}