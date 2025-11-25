import 'package:eco_ushuaia/features/calendar/domain/entities/categoria_noticias.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:flutter/material.dart';

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

  Future<void> load({Map<String, dynamic>? filtros}) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repo.list(filtros: filtros);
      _items = result;
      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}