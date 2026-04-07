import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/usuario_contenedor_favoritos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:flutter/widgets.dart';

class UsuarioContenedoresFavoritosViewModel extends ChangeNotifier {
  final UsuarioContenedorFavoritosRepository repo;

  UsuarioContenedoresFavoritosViewModel(this.repo);

  bool _loading = false;
  bool _loadedOnce = false;
  String? _error;
  int? _currentIdUsuario;
  List<Contenedor> _contenedores = const [];
  List<Contenedor> _favoritos = const [];
  final Map<int, UsuarioContenedorFavoritos> _favoritosByContenedorId = {};

  bool get loading => _loading;
  bool get loadedOnce => _loadedOnce;
  String? get error => _error;
  Set<int> get favoritosIds => _favoritosByContenedorId.keys.toSet();
  List<Contenedor> get favoritos => _favoritos;

  bool isFavorito(int idContenedor) => _favoritosByContenedorId.containsKey(idContenedor);
  UsuarioContenedorFavoritos? favoritoRelacionByContenedorId(int idContenedor) => _favoritosByContenedorId[idContenedor];
  int? favoritoRelacionIdByContenedorId(int idContenedor) => _favoritosByContenedorId[idContenedor]?.idUsuarioRegistroContenedor;

  UsuarioContenedoresFavoritosViewModel syncWithUserIdAndContenedores(
    int? idUsuario,
    List<Contenedor> contenedores,
  ) {
    _contenedores = contenedores;
    final changed = _rebuildFavoritos();

    if (idUsuario == null) {
      clear();
      return this;
    }

    if (_currentIdUsuario != idUsuario || (!_loadedOnce && !_loading)) {
      loadByUsuario(idUsuario);
      return this;
    }

    if (changed) notifyListeners();
    return this;
  }

  Future<void> loadByUsuario(int idUsuario, {bool forceRefresh = false}) async {
    if (_loading) return;
    if (!forceRefresh && _loadedOnce && _currentIdUsuario == idUsuario) {
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final relaciones = await repo.listByUsuario(idUsuario);
      _favoritosByContenedorId
        ..clear()
        ..addEntries(relaciones.map((e) => MapEntry(e.idContenedor, e)));
      _currentIdUsuario = idUsuario;
      _loadedOnce = true;
      _rebuildFavoritos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<Contenedor> filtrarContenedoresFavoritos(List<Contenedor> contenedores) {
    final seen = <int>{};
    return contenedores
        .where((c) => _favoritosByContenedorId.containsKey(c.idContenedor))
        .where((c) => seen.add(c.idContenedor))
        .toList(growable: false);
  }

  void clear() {
    if (_favoritosByContenedorId.isEmpty &&
        _favoritos.isEmpty &&
        _currentIdUsuario == null &&
        _error == null &&
        !_loadedOnce) {
      return;
    }

    _favoritosByContenedorId.clear();
    _favoritos = const [];
    _currentIdUsuario = null;
    _error = null;
    _loadedOnce = false;
    notifyListeners();
  }

  bool _rebuildFavoritos() {
    final next = filtrarContenedoresFavoritos(_contenedores);
    if (_sameContenedores(_favoritos, next)) return false;
    _favoritos = next;
    return true;
  }

  bool _sameContenedores(List<Contenedor> current, List<Contenedor> next) {
    if (current.length != next.length) return false;
    for (var i = 0; i < current.length; i++) {
      if (current[i].idContenedor != next[i].idContenedor) return false;
    }
    return true;
  }

  Future<UsuarioContenedorFavoritos> addFavorito(int idContenedor, {String? notaUsuarioContenedor}) async {
    final idUsuario = _currentIdUsuario;
    if (idUsuario == null) {
      throw StateError('No hay usuario cargado para guardar favorito');
    }

    final current = _favoritosByContenedorId[idContenedor];
    if (current != null) return current;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await repo.create(
        idUsuario: idUsuario,
        idContenedor: idContenedor,
        notaUsuarioContenedor: notaUsuarioContenedor,
      );
      _favoritosByContenedorId[idContenedor] = created;
      _rebuildFavoritos();
      return created;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeFavoritoById(int idContenedor) async {
    await removeFavoritoByContenedorId(idContenedor);
  }

  Future<void> removeFavoritoByRelacionId(int idUsuarioRegistroContenedor) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await repo.deleteById(idUsuarioRegistroContenedor);
      _favoritosByContenedorId.removeWhere(
        (_, relacion) =>
            relacion.idUsuarioRegistroContenedor == idUsuarioRegistroContenedor,
      );
      _rebuildFavoritos();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeFavoritoByContenedorId(int idContenedor) async {
    final relacion = _favoritosByContenedorId[idContenedor];
    if (relacion == null) return;

    final idRelacion = relacion.idUsuarioRegistroContenedor;
    if (idRelacion == null) {
      throw StateError('No hay id de relacion para eliminar favorito');
    }

    await removeFavoritoByRelacionId(idRelacion);
  }
}
