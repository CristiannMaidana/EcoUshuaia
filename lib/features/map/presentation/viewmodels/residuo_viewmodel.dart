import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:flutter/widgets.dart';

class ResiduoViewmodel extends ChangeNotifier {
  final ResiduoRepository repo;

  ResiduoViewmodel(this.repo);

  bool _loading = false;
  String? _error;
  List<Residuos> _items = const [];
  
  bool get loading => _loading;
  String? get error => _error;
  List<Residuos> get items => _items;

  Future<void> load({Map <String, dynamic>? filtros}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repo.list(filtros: filtros);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}