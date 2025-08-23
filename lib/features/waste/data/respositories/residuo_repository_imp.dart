import 'package:eco_ushuaia/features/waste/domain/repositories/residuo_repository.dart';

import '../../domain/entities/residuo.dart';
import '../datasources/residuos_remote_data_source.dart';

class ResiduosRepositoryImpl implements ResiduosRepository {
  final ResiduosRemoteDataSource remote;

  ResiduosRepositoryImpl(this.remote);

  @override
  Future<List<Residuo>> listar() async {
    final dtos = await remote.listar();
    return dtos.map((e) => e.toEntity()).toList();
  }
}