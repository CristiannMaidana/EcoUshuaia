import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';

abstract class ContenedorRepository {
  Future<List<Contenedor>> list({Map<String, dynamic>? filtros});
}