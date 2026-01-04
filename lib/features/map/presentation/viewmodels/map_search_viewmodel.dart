import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:flutter/material.dart';

class MapSearchViewModel extends ChangeNotifier {
  final MapboxSearchService svc;
  MapSearchViewModel(this.svc);

  bool loading = false;
  String? error;
  List<PlaceLocation> results = const [];

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

  void clear() { results = const []; error = null; notifyListeners(); }
}