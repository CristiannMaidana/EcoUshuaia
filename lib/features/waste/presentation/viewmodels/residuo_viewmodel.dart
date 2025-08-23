import 'package:eco_ushuaia/features/waste/domain/repositories/residuo_repository.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/residuo.dart';

class ResiduosViewModel extends ChangeNotifier {
  final ResiduosRepository repo;
  
  ResiduosViewModel(this.repo);

  bool _loading = false;
  String? _error;
  List<Residuo> _items = const [];

  bool get loading => _loading;
  String? get error => _error;
  List<Residuo> get items => _items;

  Future<void> cargar() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repo.listar();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}