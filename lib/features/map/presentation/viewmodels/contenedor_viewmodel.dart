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

  // TODO: Lista de contenedores filtrados

  Future<void> load({Map<String, dynamic>? filtros}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repo.list(filtros: filtros);

      // TODO: Cargar la lista de contenedores en base a idResiduo

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