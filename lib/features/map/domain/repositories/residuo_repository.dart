import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';

abstract class ResiduoRepository {
  Future<List<Residuos>> list({Map<String, dynamic>? filtros});
}