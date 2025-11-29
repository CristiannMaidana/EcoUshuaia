import 'package:flutter/material.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/categoria_noticias.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';

class CategoriaNoticiasViewmodel extends ChangeNotifier{
  final CategoriaNoticiasRepositories repo;
  
  CategoriaNoticiasViewmodel(this.repo);

  bool _loading = false;
  bool get loading => _loading;

  bool _loadedOnce = false;
  bool get loadedOnce => _loadedOnce;

  String? _error;
  String? get error => _error;

  List<CategoriaNoticias> _items = const [];
  List<CategoriaNoticias> get items => _items;

  final Map<int, CategoriaNoticias> _byId = {};
  Map<int, CategoriaNoticias> get byId => _byId;

  Future<void> load({Map<String, dynamic>? filtros}) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repo.list(filtros: filtros);
      _items = result;
      _byId
        ..clear()
        ..addEntries(result.map((e) => MapEntry(e.idCategoriaNoticias, e)));

      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String? labelFor(int id) => _byId[id]?.categoria;

  Color? colorFor(int id) {
    final hex = _byId[id]?.colorHex;
    if (hex == null) return null;
    var v = hex.replaceAll('#', '');
    if (v.length == 6) v = 'FF$v';
    return Color(int.parse(v, radix: 16));
  }
}