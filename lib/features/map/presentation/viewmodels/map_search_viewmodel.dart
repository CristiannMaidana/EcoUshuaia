import 'dart:async';
import 'dart:collection';
import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:flutter/foundation.dart';

class MapSearchViewModel extends ChangeNotifier {
  final MapboxSearchService svc;
  MapSearchViewModel(this.svc);

  bool loading = false;
  String? error;

  // Lista de resultados y sugerencias de búsqueda direcciones
  List<PlaceLocation> results = const [];
  List<PlaceLocation> suggestions = const [];

  Timer? _debounce;
  // Conserva nombre para no tener que rebuscar en la api siempre
  final LinkedHashMap<int, String?> _reverseNameCache = LinkedHashMap();
  final Map<int, Future<String?>> _reverseNameInFlight = {};

  // Buscar y devolver el primer resultado
  Future<PlaceLocation?> searchFirst(String query) async {
    if (query.trim().isEmpty) return null;
    loading = true; 
    error = null; 
    notifyListeners();
    try {
      results = await svc.search(query);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      error = e.toString();
      results = const [];
      return null;
    } finally {
      loading = false; 
      notifyListeners();
    }
  }

  // Sugerencias mientras escribe
  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) { 
      suggestions = const []; 
      notifyListeners(); 
      return; 
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        suggestions = await svc.search(query);
      } catch (_) {
        suggestions = const [];
      }
      notifyListeners();
    });
  }

  // Limpiar sugerencias
  void clearSuggestions() { 
    suggestions = const []; 
    notifyListeners(); 
  }

  @override
  void dispose() { 
    _debounce?.cancel(); 
    super.dispose(); 
  }

  String getDireccionFromPoint(double? lat, double? lon) {
    if (lat == null || lon == null) return '';

    final key = _coordKey(lat, lon);
    if (_reverseNameCache.containsKey(key)) {
      return _reverseNameCache[key] ?? '';
    }
    if (_reverseNameInFlight.containsKey(key)) return '';

    _reverseNameInFlight[key] = svc
        .addressFromPoint(lat, lon)
        .then((name) {
          _reverseNameCache.remove(key);
          _reverseNameCache[key] = name;
          if (_reverseNameCache.length > 128) {
            _reverseNameCache.remove(_reverseNameCache.keys.first);
          }
          notifyListeners();
          return name;
        })
        .catchError((_) {
          notifyListeners();
          return null;
        })
        .whenComplete(() => _reverseNameInFlight.remove(key));

    return '';
  }

  int _coordKey(double lat, double lon) {
    final latE5 = (lat * 100000).round();
    final lonE5 = (lon * 100000).round();
    return Object.hash(latE5, lonE5);
  }
}
