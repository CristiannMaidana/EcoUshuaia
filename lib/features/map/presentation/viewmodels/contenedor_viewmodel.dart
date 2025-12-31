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

  // Metodo para actualizar la lista de contenedores visibles desde backend
  Future<void> applyFilter(Map<dynamic, List<int>> idMap) async{
    List<int> idsTipo1 = idMap[1] ?? [];
    //TODO: deberia analizar el map, y en base a eso hacer convinaciones, si solo 1 esta activo ir a 1 si 2 y 1 ir a opcion para cargar ambas listas etc
    _contenedorFiltrado = await repo.filtrosResiduos(idsTipo1);
    
    notifyListeners();
  }
}