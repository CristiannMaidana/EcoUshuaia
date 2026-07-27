import 'package:eco_ushuaia/features/map/presentation/controllers/sheet_flow_navigation_controller.dart';

enum MapSheetDestination {
  search,
  containerDetails,
  addressPreview,
  navigation,
}

class MapSheetFlowController extends SheetFlowNavigationController<MapSheetDestination> {
  void startContainerDetailsFromMap() {
    setStack(const <MapSheetDestination>[MapSheetDestination.containerDetails]);
  }

  void startContainerDetailsFromSearch() {
    setStack(const <MapSheetDestination>[
      MapSheetDestination.search,
      MapSheetDestination.containerDetails,
    ]);
  }

  void startAddressPreviewFromSearch() {
    setStack(const <MapSheetDestination>[
      MapSheetDestination.search,
      MapSheetDestination.addressPreview,
    ]);
  }

  void openNavigationFromCurrentSheet() {
    push(MapSheetDestination.navigation);
  }

  /// Cierra el destino actual y devuelve el que queda visible anteriormente.
  MapSheetDestination? closeCurrentSheetAndReturnPreviousDestination() {
    return pop();
  }

  MapSheetDestination? returnFromNavigationToPreviousDestination() {
    if (current != MapSheetDestination.navigation) return null;
    return pop();
  }
}
