import 'package:flutter/foundation.dart';

enum MapQuickAction {
  myZone,
  favoritos,
  searchAddress,
}

class MapQuickActionViewmodel extends ChangeNotifier {
  MapQuickAction? _pendingAction;

  void openMyZone() {
    _pendingAction = MapQuickAction.myZone;
    notifyListeners();
  }

  void openFavoritos() {
    _pendingAction = MapQuickAction.favoritos;
    notifyListeners();
  }

  void openSearchAddress() {
    _pendingAction = MapQuickAction.searchAddress;
    notifyListeners();
  }

  MapQuickAction? consumePendingAction() {
    final action = _pendingAction;
    _pendingAction = null;
    return action;
  }
}
