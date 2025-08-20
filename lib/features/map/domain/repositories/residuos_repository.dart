import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';

abstract class ResiduosRepository {
  Future<Residuos> getResiduo();
}