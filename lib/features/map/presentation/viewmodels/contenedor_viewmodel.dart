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
  List<Contenedor> _contenedorFiltrado = const [];
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

      // TODO: Sin filtros activos al cargar
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // TODO: Filtra por un idResiduo específico todos los contenedores y actualiza el estado del VM

  // TODO:Limpia filtros y vuelve a mostrar todos
}