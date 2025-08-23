import '../entities/residuo.dart';

abstract class ResiduosRepository {
  Future<List<Residuo>> listar();
}