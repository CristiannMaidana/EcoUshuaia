import 'package:eco_ushuaia/features/map/presentation/services/mapbox_container_pins_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:flutter/foundation.dart';

class MapNativeCoordinator extends ChangeNotifier {
  final ContenedorViewModel _contenedorViewModel;
  final ZonaMapaViewModel _zonaMapaViewModel;

  MapboxNavigationMapViewBridge? _navigationBridge;
  MapboxContainerPinsBridge? _containerPinsBridge;
  Future<void> _pendingZonesSynchronization = Future<void>.value();

  Map<String, dynamic> _navigationPayload = const <String, dynamic>{};
  bool _routeReady = false;
  bool _navigationStarted = false;

  MapNativeCoordinator({
    required ContenedorViewModel contenedorViewModel,
    required ZonaMapaViewModel zonaMapaViewModel,
  }) : _contenedorViewModel = contenedorViewModel,
       _zonaMapaViewModel = zonaMapaViewModel {
    _contenedorViewModel.addListener(_onContenedoresChanged);
    _zonaMapaViewModel.addListener(_onZonasChanged);
  }

  Map<String, dynamic> get navigationPayload => _navigationPayload;
  bool get routeReady => _routeReady;
  bool get navigationStarted => _navigationStarted;
  bool get hasNavigationBridge => _navigationBridge != null;

  Future<void> attachNavigationMapBridge( MapboxNavigationMapViewBridge bridge ) async {
    _navigationBridge = bridge;
    _pendingZonesSynchronization = synchronizeZonesWithNativeMap();
    await _pendingZonesSynchronization;
  }

  Future<void> attachContainerPinsBridge( MapboxContainerPinsBridge bridge ) async {
    _containerPinsBridge = bridge;
    await synchronizeVisibleContainersWithNativeMap();
  }

  void handleNavigationPayload(Map<String, dynamic> payload) {
    _navigationPayload = payload;
    _routeReady = payload['hasRoute'] == true;
    _navigationStarted =
        payload['isNavigating'] == true ||
        payload['shouldEnterRouteMode'] == true;
    notifyListeners();
  }

  Future<void> startNavigation() async {
    final payload = await _navigationBridge?.startNavigation();
    if (payload != null) handleNavigationPayload(payload);
  }

  Future<void> cancelNavigation() async {
    final payload = await _navigationBridge?.cancelNavigation();
    if (payload != null) handleNavigationPayload(payload);
  }

  Future<void> previewRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String profile,
    List<Map<String, double>>? routePoints,
  }) async {
    final payload = await _navigationBridge?.previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
      profile: profile,
      routePoints: routePoints,
    );
    if (payload != null) handleNavigationPayload(payload);
  }

  Future<void> centerTurnByTurnCamera() async {
    await _navigationBridge?.centerTurnByTurnCamera();
  }

  Future<void> centerOnCoordinate({ required double latitude, required double longitude }) async {
    await _navigationBridge?.centerOnCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> showDestinationPreview({ required double latitude, required double longitude }) async {
    await _navigationBridge?.showDestinationPreview(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> clearDestinationPreview() async {
    await _navigationBridge?.clearDestinationPreview();
  }

  Future<void> updateNavigationPreviewSheetInset(
    double height,
    String state,
  ) async {
    await _navigationBridge?.updatePreviewSheetInset(
      height: height,
      state: state,
    );
  }

  Future<void> changeMapStyle(MapStyle style) async {
    await _navigationBridge?.setMapStyle(style);
  }

  Future<void> synchronizeVisibleContainersWithNativeMap() async {
    final bridge = _containerPinsBridge;
    if (bridge == null) return;

    final containers = _contenedorViewModel.hasActiveFilters
        ? _contenedorViewModel.contenedorFiltrado
        : _contenedorViewModel.items;
    if (containers.isEmpty) {
      await bridge.clearContainers();
    } else {
      await bridge.setContainers(containers);
    }
  }

  Future<void> synchronizeZonesWithNativeMap() async {
    final bridge = _navigationBridge;
    if (bridge == null) return;

    final zones = _zonaMapaViewModel.itemsConCoordenadas;
    if (zones.isEmpty) {
      await bridge.clearZones();
    } else {
      await bridge.setZones(zones);
    }
  }

  Future<void> hideAllZones(double sheetHeight) async {
    await _pendingZonesSynchronization;
    await _navigationBridge?.hideZones(sheetHeight: sheetHeight);
  }

  Future<void> showAllZones(double sheetHeight) async {
    await _pendingZonesSynchronization;
    await _navigationBridge?.showAllZones(sheetHeight: sheetHeight);
  }

  Future<void> showUserZoneOrFirstAvailable({
    required int? userZoneId,
    required double sheetHeight,
  }) async {
    await _pendingZonesSynchronization;
    final zones = _zonaMapaViewModel.itemsConCoordenadas;
    if (zones.isEmpty) return;

    // Usa la zona del usuario cuando existe; de lo contrario conserva el
    // comportamiento actual mostrando la primera zona disponible.
    final zoneId =
        _zonaMapaViewModel.zonaConCoordenadasPorId(userZoneId)?.idZona ??
        zones.first.idZona;
    await _navigationBridge?.showMyZone(
      zoneId: zoneId,
      sheetHeight: sheetHeight,
    );
  }

  Future<void> showFirstTwoAffectedZones(double sheetHeight) async {
    await _pendingZonesSynchronization;
    final zones = _zonaMapaViewModel.itemsConCoordenadas;
    if (zones.isEmpty) return;

    // La pantalla actual representa las zonas afectadas usando las dos
    // primeras zonas disponibles.
    final zoneIds = zones
        .take(2)
        .map((zone) => zone.idZona)
        .toList(growable: false);
    await _navigationBridge?.showAffectedZones(
      zoneIds: zoneIds,
      activeZoneId: zoneIds.first,
      sheetHeight: sheetHeight,
    );
  }

  void _onContenedoresChanged() {
    synchronizeVisibleContainersWithNativeMap();
  }

  void _onZonasChanged() {
    _pendingZonesSynchronization = synchronizeZonesWithNativeMap();
  }

  @override
  void dispose() {
    _contenedorViewModel.removeListener(_onContenedoresChanged);
    _zonaMapaViewModel.removeListener(_onZonasChanged);
    super.dispose();
  }
}
