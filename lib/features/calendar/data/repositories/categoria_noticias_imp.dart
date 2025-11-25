import 'package:eco_ushuaia/features/calendar/data/sources/categoria_noticias_remote_data_sources.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/categoria_noticias.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';

class CategoriaNoticiasImp implements CategoriaNoticiasRepositories{
  final CategoriaNoticiasRemoteDataSources remote;

  CategoriaNoticiasImp(this.remote);

  @override
  Future<List<CategoriaNoticias>> list({Map<String, dynamic>? filtros}) async {
    final dtos = await remote.list(filtros: filtros);
    return dtos.map((e) => e.toEntity()).toList();  
  }
}