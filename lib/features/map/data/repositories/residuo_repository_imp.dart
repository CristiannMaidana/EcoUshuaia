import 'package:eco_ushuaia/features/map/data/sources/remote/residuos_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';

class ResiduoRepositoryImp implements ResiduoRepository{
  final ResiduosRemoteDataSource remote;

  ResiduoRepositoryImp(this.remote);

  @override
  Future<List<Residuos>> list({Map<String, dynamic>? filtros}) async{
    final dtos = await remote.list(filtros: filtros);

    return dtos.map((e) => e.toEntity()).toList();
  }
}