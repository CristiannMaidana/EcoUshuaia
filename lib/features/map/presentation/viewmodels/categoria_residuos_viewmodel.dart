import 'package:eco_ushuaia/features/map/domain/entities/categoria_residuos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:flutter/material.dart';

class CategoriaResiduosViewmodel extends ChangeNotifier{
  final CategoriaResiduosRepository repo;

  CategoriaResiduosViewmodel(this.repo);

  bool _loading = false;
  bool get loading => _loading;

  bool _loadedOnce = false;
  bool get loadedOnce => _loadedOnce;

  String? _error;
  String? get error => _error;

  List<CategoriaResiduos> _items = const [];
  List<CategoriaResiduos> get items => _items;

  final Map<int, CategoriaResiduos> _byId = {};
  Map<int, CategoriaResiduos> get byId => _byId;

  // IDs de categorías actualmente seleccionadas/visibles
  final Set<int> _selectedIds = {};
  Set<int> get selectedIds => _selectedIds;

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
        ..addEntries(result.map((e) => MapEntry(e.idCategoriaResiduos, e)));

      if (_selectedIds.isEmpty) {
        _selectedIds.addAll(_byId.keys);
      } else {
        _selectedIds.removeWhere((id) => !_byId.containsKey(id));
      }

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

  bool isSelected(int id) => _selectedIds.contains(id);

  void toggleCategoria(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }
}