import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/zona_mapa_repository.dart';
import 'package:flutter/widgets.dart';

class ZonaMapaViewModel extends ChangeNotifier {
  final ZonaMapaRepository repo;

  ZonaMapaViewModel(this.repo);

  bool _loading = false;
  String? _error;
  List<ZonaMapa> _items = const [];
  List<ZonaMapa> _itemsConCoordenadas = const [];
  Map<int, ZonaMapa> _itemsConCoordenadasPorId = const {};

  bool get loading => _loading;
  String? get error => _error;
  List<ZonaMapa> get items => _items;
  List<ZonaMapa> get itemsConCoordenadas => _itemsConCoordenadas;
  bool get hasItemsConCoordenadas => _itemsConCoordenadas.isNotEmpty;

  ZonaMapa? zonaConCoordenadasPorId(int? idZona) {
    if (idZona == null) return null;
    return _itemsConCoordenadasPorId[idZona];
  }

  void _rebuildDerivedState(List<ZonaMapa> zonas) {
    _itemsConCoordenadas = zonas
        .where((zona) => zona.coordenada != null)
        .toList(growable: false);
    _itemsConCoordenadasPorId = {
      for (final zona in _itemsConCoordenadas) zona.idZona: zona,
    };
  }

  Future<void> load({Map<String, dynamic>? filtros}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await repo.list(filtros: filtros);
      _rebuildDerivedState(_items);
    } catch (e) {
      _error = e.toString();
      _items = const [];
      _rebuildDerivedState(_items);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
