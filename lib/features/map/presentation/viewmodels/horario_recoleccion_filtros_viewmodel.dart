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

  // Lista “principal” (si la necesitás)
  List<HorarioRecoleccionFiltros> _items = const [];
  List<HorarioRecoleccionFiltros> get items => _items;

  // Listas por filtro
  List<HorarioRecoleccionFiltros> itemsDiaZona = const [];
  List<HorarioRecoleccionFiltros> itemsHoraMannanaZona = const [];

  // Rangos horarios
  List<HorarioRecoleccionFiltros> itemsHoraUno   = const []; // 06–12
  List<HorarioRecoleccionFiltros> itemsHoraDos   = const []; // 12–18
  List<HorarioRecoleccionFiltros> itemsHoraTres  = const []; // 18–24

  // ================= Cargas individuales =================
  Future<void> loadHoras() => _withLoading(() async {
        final r = await Future.wait<List<HorarioRecoleccionFiltros>>([
          repo.porHora(horaInicio: '06:00:00', horaFin: '12:00:00'),
          repo.porHora(horaInicio: '12:00:00', horaFin: '18:00:00'),
          repo.porHora(horaInicio: '18:00:00', horaFin: '24:00:00'),
        ]);
        itemsHoraUno  = r[0];
        itemsHoraDos  = r[1];
        itemsHoraTres = r[2];
      });

  Future<void> loadDia({int zona = 1}) =>
      _loadDiaBase(offset: 0, assign: (x) => itemsDiaZona = x, zona: zona);

  Future<void> loadMannana({int zona = 1}) =>
      _loadDiaBase(offset: 1, assign: (x) => itemsHoraMannanaZona = x, zona: zona);

  // Cargo lista desde repo
  Future<void> initAll({int zona = 1}) => _withLoading(() async {
        final d = today();
        final r = await Future.wait<List<HorarioRecoleccionFiltros>>([
          repo.porHora(horaInicio: '06:00:00', horaFin: '12:00:00'),  // 0
          repo.porHora(horaInicio: '12:00:00', horaFin: '18:00:00'),  // 1
          repo.porHora(horaInicio: '18:00:00', horaFin: '24:00:00'),  // 2
          repo.porDiaZona(dia: d, zona: zona),                        // 3 (hoy)
          repo.porDiaZona(dia: (d + 1) % 7, zona: zona),              // 4 (mañana)
        ]);

        itemsHoraUno          = r[0];
        itemsHoraDos          = r[1];
        itemsHoraTres         = r[2];
        itemsDiaZona          = r[3];
        itemsHoraMannanaZona  = r[4];

        // Items es la unión de todo
        _items = r.expand((e) => e).toList();
      });

  // Metodo para limpiar todos los items
  void clear() {
    _items = const [];
    itemsDiaZona            = const [];
    itemsHoraMannanaZona    = const [];
    itemsHoraUno            = const [];
    itemsHoraDos            = const [];
    itemsHoraTres           = const [];
    _error = null;
    _loadedOnce = false;
    notifyListeners();
  }

  // ================= DRY helpers =================
  Future<void> _withLoading(Future<void> Function() body) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await body();
      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDiaBase({
    required int offset,
    required void Function(List<HorarioRecoleccionFiltros>) assign,
    int zona = 1,
  }) =>
      _withLoading(() async {
        final d = (today() + offset) % 7;
        final data = await repo.porDiaZona(dia: d, zona: zona);
        assign(data);
      });

  /// Lunes=1 … Sábado=6, Domingo=0
  int today({DateTime? date}) {
    final w = (date ?? DateTime.now()).weekday;
    return (w == DateTime.sunday) ? 0 : w;
  }
}