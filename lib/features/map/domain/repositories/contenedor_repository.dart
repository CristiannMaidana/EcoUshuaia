import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';

abstract class ContenedorRepository {
  Future<List<Contenedor>> list({Map<String, dynamic>? filtros});

  Future<List<Contenedor>> filtrosResiduos(List<int> ids);

  Future<List<Contenedor>> filtrosRangoHorario(List<int> ids);

  Future<List<Contenedor>> filtrosDiaHorario(List<int> ids);

  // TODO: Crear metodo abstracto para los filtros del dia de mañana
}