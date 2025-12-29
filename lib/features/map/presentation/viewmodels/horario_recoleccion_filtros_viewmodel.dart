import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/horario_recoleccion_filtros_repository.dart';
import 'package:flutter/widgets.dart';

class HorarioRecoleccionFiltrosViewModel extends ChangeNotifier {
  final HorarioRecoleccionFiltrosRepository repo;
  
  HorarioRecoleccionFiltrosViewModel(this.repo);

  bool _loading = false;
  bool get loading => _loading;

  bool _loadedOnce = false;
  bool get loadedOnce => _loadedOnce;

  String? _error;
  String? get error => _error;

  /// Lista de todos los elementos completos
  List<HorarioRecoleccionFiltros> _items = const [];
  List<HorarioRecoleccionFiltros> get items => _items;

  /// Listas para cada filtro
  List<HorarioRecoleccionFiltros> itemsHoraDiaZona = const [];
  List<HorarioRecoleccionFiltros> itemsDiaZona = const [];
  List<HorarioRecoleccionFiltros> itemsHoraMannanaZona = const [];
  List<HorarioRecoleccionFiltros> itemsSemanaDesdeDiaZona = const [];

  // Helper para obtener los datos del repo
  Future<void> _run(Future<List<HorarioRecoleccionFiltros>> Function() task) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await task();
      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Carga las variantes en paralelo y deja cada una en su lista
  Future<void> loadAll({required String hhmmss, required int dia, required int mannana, required int zona, required int desdeDia,}) async {
    await _run(() async {final results = await Future.wait<List<HorarioRecoleccionFiltros>>([
      repo.porHoraDiaZona(hhmmss: hhmmss, dia: dia, zona: zona),
      repo.porDiaZona(dia: 1, zona: 1),
      repo.porHoraMannanaZona(hhmmss: hhmmss, mannana: mannana, zona: zona),
      repo.semanaDesdeDiaZona(desdeDia: desdeDia, zona: zona),
    ]);
    
    itemsHoraDiaZona        = results[0];
    itemsDiaZona            = results[1];
    itemsHoraMannanaZona    = results[2];
    itemsSemanaDesdeDiaZona = results[3];

    return results.expand((x) => x).toList();
    });
  }
  
  // Metodo para limpiar todas las listas
  void clear() {
    _items = const [];
    itemsHoraDiaZona        = const [];
    itemsDiaZona            = const [];
    itemsHoraMannanaZona    = const [];
    itemsSemanaDesdeDiaZona = const [];
    _error = null;
    _loadedOnce = false;
    notifyListeners();
  }  
}