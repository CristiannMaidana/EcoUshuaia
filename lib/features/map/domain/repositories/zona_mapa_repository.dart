import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';

abstract class ZonaMapaRepository {
  Future<List<ZonaMapa>> list({Map<String, dynamic>? filtros});
}
