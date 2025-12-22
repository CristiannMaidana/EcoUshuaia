import 'package:eco_ushuaia/features/map/domain/entities/categoria_residuos.dart';

abstract class CategoriaResiduosRepository {
  Future<List<CategoriaResiduos>> list ({Map<String, dynamic>? filtros});
}