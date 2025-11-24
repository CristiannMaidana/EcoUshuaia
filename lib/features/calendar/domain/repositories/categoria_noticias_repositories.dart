import 'package:eco_ushuaia/features/calendar/domain/entities/categoria_noticias.dart';

abstract class CategoriaNoticiasRepositories {
  Future<List<CategoriaNoticias>> list({Map<String, dynamic>? filtros});
}