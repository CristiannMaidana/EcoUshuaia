import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:flutter/widgets.dart';

class ContenedorViewModel extends ChangeNotifier {
  final ContenedorRepository repo;

  ContenedorViewModel(this.repo);

  bool _loading = false;
  String? _error;
  List<Contenedor> _items = const [];
  
  bool get loading => _loading;
  String? get error => _error;
  List<Contenedor> get items => _items;

  // Map de contenedores filtrados
  final Map<int, List<Contenedor>> _byResiduo = {};

  // Lista de contenedores filtrados para mostrar en el mapa
  List<Contenedor> _contenedorFiltrado = [];
  List<Contenedor> get contenedorFiltrado => _contenedorFiltrado;

  Future<void> load({Map<String, dynamic>? filtros}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repo.list(filtros: filtros);

      // Cargar la lista de contenedores en base a idResiduo
      _byResiduo.clear();
      for (final c in _items) {
        final id = c.idResiduo;
        if (id != null) {
          (_byResiduo[id] ??= <Contenedor>[]).add(c);
        }
      }

      // Sin filtros activos al cargar
      _contenedorFiltrado = const [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Cargar por idResiduo todos los contenedores de la lista
  void filterResiduos(int idResiduo) {
    if (contenedorFiltrado.isEmpty){
      _contenedorFiltrado = List<Contenedor>.from(_byResiduo[idResiduo]!);
    }
    else {
      _contenedorFiltrado.addAll(_byResiduo[idResiduo]!);
    }
    notifyListeners();
  }

  // Limpia contendores filtrados
  void clearAllFilter() {
    _contenedorFiltrado = [];
    notifyListeners();
  }

  // Metodo para actualizar la lista de contenedores visibles en base a lo que esta cargado
  Future<void> applyFilter(Map<dynamic, List<int>> idMap) async {
    List<Contenedor> result = [];

    // --- separar grupos ---
    final idsResiduos = idMap[1]; // puede ser null/empty
    final hEntries = idMap.entries
        .where((e) => e.key is String && (e.key as String).startsWith('H_'))
        .where((e) => (e.value).isNotEmpty)
        .toList();

    // filtros rango horarios
    Future<List<Contenedor>> _fetchForH(String k, List<int> ids) {
      switch (k) {
        case 'H_0': return repo.filtrosDiaHorario(ids);       // Hoy
        case 'H_1': return repo.filtrosMannanaHorario(ids);   // Mañana
        case 'H_2':
        case 'H_3':
        case 'H_4': return repo.filtrosRangoHorario(ids);     // Rangos horarios
        default:   return Future.value(const []);
      }
    }

    // Unir todos los H seleccionados
    List<Contenedor> unionH = [];
    if (hEntries.isNotEmpty) {
      final lists = await Future.wait(
        hEntries.map((e) => _fetchForH(e.key as String, e.value)),
      );
      final seen = <int>{};
      for (final lst in lists) {
        for (final c in lst) {
          final id = c.idContenedor;
          // ignore: unnecessary_null_comparison
          if (id != null && seen.add(id)) unionH.add(c);
        }
      }
    }

    // Combinar con residuos haciendo interseccion
    if (idsResiduos != null && idsResiduos.isNotEmpty) {
      final porRes = await repo.filtrosResiduos(idsResiduos);
      if (unionH.isEmpty) {
        result = porRes; // solo residuos
      } else {
        final setH = unionH.map((c) => c.idContenedor).whereType<int>().toSet();
        result = porRes.where((c) => setH.contains(c.idContenedor)).toList();
      }
    } else {
      // solo H, o nada seleccionado
      result = unionH.isNotEmpty ? unionH : _items;
    }

    _contenedorFiltrado = result;
    notifyListeners();
  }
}