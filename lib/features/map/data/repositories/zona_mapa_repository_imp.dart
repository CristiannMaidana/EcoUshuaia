import 'package:eco_ushuaia/features/map/data/sources/remote/zona_mapa_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/zona_mapa_repository.dart';

class ZonaMapaRepositoryImp implements ZonaMapaRepository {
  final ZonaMapaRemoteDataSource remote;

  ZonaMapaRepositoryImp(this.remote);

  @override
  Future<List<ZonaMapa>> list({Map<String, dynamic>? filtros}) async {
    final dtos = await remote.list(filtros: filtros);
    return dtos.map((e) => e.toEntity()).toList(growable: false);
  }
}
