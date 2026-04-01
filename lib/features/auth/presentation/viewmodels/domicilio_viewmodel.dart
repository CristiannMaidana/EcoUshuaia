import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/auth/domain/entities/domicilio.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/domicilio_repository.dart';
import 'package:flutter/foundation.dart';

class DomicilioViewModel extends ChangeNotifier {
  final DomicilioRepository repo;

  DomicilioViewModel(this.repo);

  bool _loading = false;
  bool _loadedOnce = false;
  String? _error;
  Domicilio? _domicilio;
  int? _currentIdDomicilio;

  bool get loading => _loading;
  bool get loadedOnce => _loadedOnce;
  String? get error => _error;
  Domicilio? get domicilio => _domicilio;

  Future<Domicilio> create({
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await repo.create(
        calle: calle,
        numero: numero,
        barrio: barrio,
        ciudad: ciudad,
        codigoPostal: codigoPostal,
        provincia: provincia,
        pais: pais,
        coordenada: coordenada,
      );
      _domicilio = created;
      _currentIdDomicilio = created.idDomicilio;
      _loadedOnce = true;
      return created;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadById(int? idDomicilio, {bool forceRefresh = false}) async {
    if (idDomicilio == null) {
      clear();
      return;
    }

    if (_loading) return;
    if (!forceRefresh &&
        _loadedOnce &&
        _currentIdDomicilio == idDomicilio &&
        _domicilio != null) {
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _domicilio = await repo.getById(idDomicilio);
      _currentIdDomicilio = idDomicilio;
      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Domicilio> update({
    required int idDomicilio,
    required String calle,
    required String numero,
    required String barrio,
    required String ciudad,
    required String codigoPostal,
    required String provincia,
    required String pais,
    Coordenada? coordenada,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await repo.update(
        idDomicilio: idDomicilio,
        calle: calle,
        numero: numero,
        barrio: barrio,
        ciudad: ciudad,
        codigoPostal: codigoPostal,
        provincia: provincia,
        pais: pais,
        coordenada: coordenada,
      );
      _domicilio = updated;
      _currentIdDomicilio = updated.idDomicilio ?? idDomicilio;
      _loadedOnce = true;
      return updated;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  DomicilioViewModel syncWithUserId(int? idDomicilio) {
    if (idDomicilio == null) {
      if (_domicilio != null || _currentIdDomicilio != null || _error != null) {
        clear();
      }
      return this;
    }

    if (_currentIdDomicilio != idDomicilio || (!_loadedOnce && !_loading)) {
      loadById(idDomicilio);
    }

    return this;
  }

  void clear() {
    _domicilio = null;
    _error = null;
    _loadedOnce = false;
    _currentIdDomicilio = null;
    notifyListeners();
  }
}
