import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/zona_mapa_repository.dart';
import 'package:flutter/widgets.dart';

class ZonaMapaViewModel extends ChangeNotifier {
  final ZonaMapaRepository repo;

  ZonaMapaViewModel(this.repo);

  bool _loading = false;
  String? _error;
  List<ZonaMapa> _items = const [];

  bool get loading => _loading;
  String? get error => _error;
  List<ZonaMapa> get items => _items;

  Future<void> load({Map<String, dynamic>? filtros}) async {
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
