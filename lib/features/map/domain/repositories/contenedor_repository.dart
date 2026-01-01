import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';

abstract class ContenedorRepository {
  Future<List<Contenedor>> list({Map<String, dynamic>? filtros});

  Future<List<Contenedor>> filtrosResiduos(List<int> ids);

  Future<List<Contenedor>> filtrosRangoHorario(List<int> ids);

  Future<List<Contenedor>> filtrosDiaHorario(List<int> ids);
  
  Future<List<Contenedor>> filtrosMannanaHorario(List<int> ids);
  
 // TODO: crear metodo para el filtro de toda la semana
}