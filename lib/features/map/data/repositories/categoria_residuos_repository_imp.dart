import 'package:eco_ushuaia/features/map/data/sources/remote/categoria_residuos_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/entities/categoria_residuos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';

class CategoriaResiduosRepositoryImp implements CategoriaResiduosRepository{
  final CategoriaResiduosRemoteDataSource remote;

  CategoriaResiduosRepositoryImp(this.remote);

  @override
  Future<List<CategoriaResiduos>> list ({Map<String, dynamic>? filtros}) async {
    final dtos = await remote.list(filtros: filtros);

    return dtos.map((e)=> e.toEntity()).toList();
  }
}