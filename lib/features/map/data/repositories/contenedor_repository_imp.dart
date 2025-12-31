import 'package:eco_ushuaia/features/map/data/sources/remote/contenedor_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';

class ContenedorRepositoryImp implements ContenedorRepository{
  final ContenedorRemoteDataSource remote;

  ContenedorRepositoryImp(this.remote);

  @override
  Future<List<Contenedor>> list({Map<String, dynamic>? filtros}) async {
    final dtos = await remote.list(filtros: filtros);
    return dtos.map((e) => e.toEntity()).toList(growable: false);
  }

  @override
  Future<List<Contenedor>> filtrosResiduos(List<int> ids) async {
    final dtos = await remote.filtrosResiduos(ids);
    return dtos.map((e) => e.toEntity()).toList(growable: false);
  }
}