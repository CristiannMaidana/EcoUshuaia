import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/categoria_residuos_dto.dart';

class CategoriaResiduosRemoteDataSource {
  final ApiClient api;

  CategoriaResiduosRemoteDataSource(this.api);

  Future<List<CategoriaResiduosDto>> list ({Map<String, dynamic>? filtros}) async {
    final data = await api.get('/categoria_residuos/', query: filtros);

    return const <CategoriaResiduosDto>[];
  }
}