import 'package:eco_ushuaia/features/map/data/mappers/residuos_mappers.dart';
import 'package:eco_ushuaia/features/map/data/sources/remote/ResiduoApiSource.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos_entity.dart';

class ResiduoRepositoryImpl {
  final ResiduoApiSource _api;
  ResiduoRepositoryImpl(this._api);

  @override
  Future<List<ResiduosEntity>> getResiduos() async {
    final dtos = await _api.fetchResiduo();
    return dtos.map((d) => d.toEntity()).toList();
  }
}