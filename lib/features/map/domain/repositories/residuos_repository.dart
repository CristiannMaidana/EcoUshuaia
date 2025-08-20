import 'package:eco_ushuaia/features/map/domain/entities/residuos_entity.dart';

abstract class ResiduosRepository {
  Future<ResiduosEntity> getResiduo();
}