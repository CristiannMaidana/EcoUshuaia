import 'dart:async';
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
}