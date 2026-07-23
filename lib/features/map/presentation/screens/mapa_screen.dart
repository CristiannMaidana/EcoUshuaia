import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/horario_recoleccion_filtros_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/zona_mapa_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_container_pins_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/categoria_residuos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/horario_recoleccion_filtros_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_quick_action_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/address_turn_by_turn.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/buttons_quick_access_on_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/mapbox_navigation_map_view.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_controller.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_add_containers_to_route.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_options_of_nav_to_route.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_for_change_styles_of_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_of_details_of_container_in_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_of_zones_of_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_search_bar.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/features/map/data/sources/local/location_service.dart';
import 'package:provider/provider.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              ContenedorViewModel(ctx.read<ContenedorRepository>())..load(),
        ),
        ChangeNotifierProxyProvider2<
          UsuarioViewModel,
          ContenedorViewModel,
          UsuarioContenedoresFavoritosViewModel
        >(
          create: (ctx) => UsuarioContenedoresFavoritosViewModel(
            ctx.read<UsuarioContenedorFavoritosRepository>(),
          ),
          update: (_, usuarioVm, contenedorVm, favoritosVm) => favoritosVm!
            ..syncWithUserIdAndContenedores(
              usuarioVm.usuario?.idUsuario,
              contenedorVm.items,
            ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CategoriaResiduosViewmodel(
            ctx.read<CategoriaResiduosRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ResiduoViewmodel(ctx.read<ResiduoRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HorarioRecoleccionFiltrosViewModel(
            ctx.read<HorarioRecoleccionFiltrosRepository>(),
          )..initAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapSearchViewModel(AddressSearchService()),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ZonaMapaViewModel(ctx.read<ZonaMapaRepository>())..load(),
        ),
      ],
      child: MapaPage(),
    );
  }
}

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaScreenStatePage();
}

class _MapaScreenStatePage extends State<MapaPage> {
  final _perms = LocationPermissionService.I;
  bool _hasLocationPermission = false;
  MapController? _mapController;

  MapboxNavigationMapViewBridge? _nativeNavigationBridge;
  MapboxContainerPinsBridge? _containerPinsBridge;
  Map<String, dynamic> _nativeNavigationPayload = const <String, dynamic>{};
  bool _nativeRouteReady = false;
  bool _nativeNavigationStarted = false;
  MapStyle _estiloActual = MapStyle.Estandar;

  ContenedorViewModel? _vm;
  ZonaMapaViewModel? _zonaVm;

  Contenedor? _contenedorSeleccionado;
  bool _containerSelectedFromSearch = false;

  bool _cambio = false;
  MapQuickAction? _pendingQuickAction;

  //Variable para manejar el tamaño del sheet
  final GlobalKey<SheetSearchBarState> _filterKey =
      GlobalKey<SheetSearchBarState>();

  final GlobalKey<FlotanteSheetState> _flotanteKey =
      GlobalKey<FlotanteSheetState>();

  //=== Variable y metodos para el SheetAddContainer ===
  double _addressLon = 0;
  double _addressLat = 0;
  Map<String, double> _userPoint = const <String, double>{'lon': 0, 'lat': 0};

  // KEYS
  // Key of content of sheet
  final GlobalKey<SheetOptionsOfNavToRouteState> _keySheetOptionsOfNavToRoute = GlobalKey<SheetOptionsOfNavToRouteState>();

  // Keys of sheet
  final GlobalKey<SheetOfZonesOfMapState> _keyOfSheetOfZonesOfMap = GlobalKey<SheetOfZonesOfMapState>();
  final GlobalKey<SheetOfDetailsOfContainerInMapState> _keyOfSheetOfDetailsContainerOnMap = GlobalKey<SheetOfDetailsOfContainerInMapState>();
  final GlobalKey<SheetForChangeStylesOfMapState> _keySheetForChangeStylesOfMap = GlobalKey<SheetForChangeStylesOfMapState>();
  final GlobalKey<SheetAddContainersToRouteState> _keySheetAddContainerToRoute = GlobalKey<SheetAddContainersToRouteState>();

  // Condicion para mostrar el sheet
  bool openSheetAddContainer = false;
  bool openSheetAddAddress = false;

  void _agregarDireccionNueva(Contenedor contenedor) {
    _keySheetOptionsOfNavToRoute.currentState?.addContenedor(contenedor);
  }

  Future<void> _getCoordenates({bool updateAddress = true}) async {
    final ok =
        _hasLocationPermission ||
        await _perms.ensureWhenInUsePermission(context);
    if (!mounted || !ok) return;
    if (!_hasLocationPermission) setState(() => _hasLocationPermission = ok);

    final ctrl = _mapController ?? MapController(null);
    Map<String, double> puntos;
    try {
      puntos = await ctrl.getPoint();
    } catch (_) {
      return;
    }
    if (!mounted) return;

    setState(() {
      final lon = puntos['lon'] ?? _addressLon;
      final lat = puntos['lat'] ?? _addressLat;
      if (updateAddress) {
        _addressLon = lon;
        _addressLat = lat;
      }
      _userPoint = <String, double>{'lon': lon, 'lat': lat};
    });
  }

  void _changes() {
    setState(() {
      _cambio = !_cambio;
      if (_cambio) _filterKey.currentState?.expand();
    });
  }

  List<Contenedor> _containersForCurrentMapState(ContenedorViewModel vm) {
    return vm.hasActiveFilters ? vm.contenedorFiltrado : vm.items;
  }

  // Actualiza los contenedores cuando cambia el VM
  void _onVmChanged() {
    final vm = _vm;
    final bridge = _containerPinsBridge;
    if (vm != null && bridge != null) {
      final data = _containersForCurrentMapState(vm);
      if (data.isEmpty) {
        bridge.clearContainers();
      } else {
        bridge.setContainers(data);
      }
    }
  }

  void _onZonaVmChanged() {
    _syncZonesToNative();
  }

  Future<void> _syncZonesToNative() async {
    final bridge = _nativeNavigationBridge;
    final vm = _zonaVm;
    if (bridge == null || vm == null) return;

    final zonas = vm.items
        .where((zona) => zona.coordenada != null)
        .toList(growable: false);
    if (zonas.isEmpty) {
      await bridge.clearZones();
      return;
    }

    await bridge.setZones(zonas);
  }

  // Callback que recibe el contenedor tocado desde MapController
  void _onContenedorTap(Contenedor c) {
    setState(() {
      _containerSelectedFromSearch = false;
      _contenedorSeleccionado = c;
      _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    });
  }

  // Cargar los contenedores filtrados en mapa
  void _applyFilters() {
    final vm = _vm;
    final bridge = _containerPinsBridge;
    if (vm == null || bridge == null) return;

    final data = _containersForCurrentMapState(vm);
    if (data.isEmpty) {
      bridge.clearContainers();
    } else {
      bridge.setContainers(data);
    }
  }

  Future<void> _openQuickFavoritos() async {
    final contenedorVm = context.read<ContenedorViewModel>();
    final favoritosVm = context.read<UsuarioContenedoresFavoritosViewModel>();
    final idUsuario = context.read<UsuarioViewModel>().usuario?.idUsuario;

    if (contenedorVm.items.isEmpty && !contenedorVm.loading) {
      await contenedorVm.load();
    }
    if (idUsuario != null && !favoritosVm.loadedOnce && !favoritosVm.loading) {
      await favoritosVm.loadByUsuario(idUsuario);
    }

    await contenedorVm.applyFilter(
      const <dynamic, List<int>>{},
      filtrarFavoritos: favoritosVm.filtrarContenedoresFavoritos,
    );
  }

  Future<void> _openQuickMyZone() async {
    final zonaVm = context.read<ZonaMapaViewModel>();
    if (zonaVm.items.isEmpty && !zonaVm.loading) {
      await zonaVm.load();
    }
    await _testShowMyZone(0);
  }

  void _openQuickSearchAddress() {
    _filterKey.currentState?.openSearch();
  }

  Future<void> _runPendingQuickAction() async {
    final action = _pendingQuickAction;
    if (action == null || !mounted) return;

    switch (action) {
      case MapQuickAction.myZone:
        if (_nativeNavigationBridge == null) return;
        await _openQuickMyZone();
        _pendingQuickAction = null;
        break;
      case MapQuickAction.favoritos:
        await _openQuickFavoritos();
        _pendingQuickAction = null;
        break;
      case MapQuickAction.searchAddress:
        if (_filterKey.currentState == null) return;
        _openQuickSearchAddress();
        _pendingQuickAction = null;
        break;
    }
  }

  Future<void> _onMapboxNavigationMapReady(
    MapboxNavigationMapViewBridge bridge,
  ) async {
    _nativeNavigationBridge = bridge;
    final zonaVm = context.read<ZonaMapaViewModel>();
    if (_zonaVm != zonaVm) {
      _zonaVm?.removeListener(_onZonaVmChanged);
      _zonaVm = zonaVm..addListener(_onZonaVmChanged);
    }
    await _syncZonesToNative();
    await _runPendingQuickAction();
  }

  Future<void> _onMapboxContainerPinsReady(
    MapboxContainerPinsBridge bridge,
  ) async {
    _containerPinsBridge = bridge;

    final vm = context.read<ContenedorViewModel>();
    if (_vm != vm) {
      _vm?.removeListener(_onVmChanged);
      _vm = vm..addListener(_onVmChanged);
    }

    final data = _containersForCurrentMapState(vm);

    if (data.isEmpty) {
      await bridge.clearContainers();
    } else {
      await bridge.setContainers(data);
    }
    await _runPendingQuickAction();
  }

  void _onMapboxContainerSelected(int idContenedor) {
    final vm = _vm;
    if (vm == null) return;

    final candidates = <Contenedor>[...vm.items, ...vm.contenedorFiltrado];
    for (final contenedor in candidates) {
      if (contenedor.idContenedor == idContenedor) {
        _onContenedorTap(contenedor);
        return;
      }
    }
  }

  void _onNativeNavigationPayload(Map<String, dynamic> payload) {
    if (!mounted) return;

    setState(() {
      _nativeNavigationPayload = payload;
      _nativeRouteReady = payload['hasRoute'] == true;
      _nativeNavigationStarted =
          payload['isNavigating'] == true ||
          payload['shouldEnterRouteMode'] == true;
    });
  }

  Future<void> _startNativeNavigation() async {
    final payload = await _nativeNavigationBridge?.startNavigation();
    if (payload != null) _onNativeNavigationPayload(payload);
  }

  Future<void> _cancelNativeNavigation() async {
    final payload = await _nativeNavigationBridge?.cancelNavigation();
    if (payload != null) _onNativeNavigationPayload(payload);
  }

  Future<void> _centerNativeTurnByTurnCamera() async {
    if (!_hasLocationPermission) {
      await _retryPermission();
      return;
    }

    if (_nativeNavigationBridge != null) {
      await _nativeNavigationBridge!.centerTurnByTurnCamera();
      return;
    }

    await _mapController?.centerOnUserOnce();
  }

  Future<void> _paintNativeRoute({required String profile, List<Map<String, double>>? routePoints}) async {
    final bridge = _nativeNavigationBridge;
    if (bridge == null) return;

    if (_userPoint['lat'] == 0 || _userPoint['lon'] == 0) {
      await _getCoordenates(updateAddress: false);
    }

    final originLatitude = _userPoint['lat'];
    final originLongitude = _userPoint['lon'];
    if (originLatitude == null || originLongitude == null) return;
    if (originLatitude == 0 && originLongitude == 0) return;
    if (_addressLat == 0 && _addressLon == 0) return;

    _keySheetOptionsOfNavToRoute.currentState?.reportPreviewSheetMetrics();

    final payload = await bridge.previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: _addressLat,
      destinationLongitude: _addressLon,
      profile: profile,
      routePoints: routePoints,
    );
    if (payload != null) _onNativeNavigationPayload(payload);
  }

  Future<void> _updateNativePreviewSheetInset(
    double height,
    String state,
  ) async {
    await _nativeNavigationBridge?.updatePreviewSheetInset(
      height: height,
      state: state,
    );
  }

  Future<void> _testHideZones(double sheetHeight) async {
    await _syncZonesToNative();
    await _nativeNavigationBridge?.hideZones(sheetHeight: sheetHeight);
  }

  Future<void> _testShowAllZones(double sheetHeight) async {
    await _syncZonesToNative();
    await _nativeNavigationBridge?.showAllZones(sheetHeight: sheetHeight);
  }

  Future<void> _testShowMyZone(double sheetHeight) async {
    final usuarioZoneId = context.read<UsuarioViewModel>().usuario?.idZona;
    await _syncZonesToNative();
    final zonas =
        _zonaVm?.items
            .where((zona) => zona.coordenada != null)
            .toList(growable: false) ??
        const [];
    if (zonas.isEmpty) return;

    final zoneId = zonas.any((zona) => zona.idZona == usuarioZoneId)
        ? usuarioZoneId
        : zonas.first.idZona;
    if (zoneId == null) return;

    await _nativeNavigationBridge?.showMyZone(
      zoneId: zoneId,
      sheetHeight: sheetHeight,
    );
  }

  Future<void> _testShowAffectedZones(double sheetHeight) async {
    await _syncZonesToNative();
    final zonas =
        _zonaVm?.items
            .where((zona) => zona.coordenada != null)
            .toList(growable: false) ??
        const [];
    if (zonas.isEmpty) return;

    final zoneIds = zonas
        .take(2)
        .map((zona) => zona.idZona)
        .toList(growable: false);
    await _nativeNavigationBridge?.showAffectedZones(
      zoneIds: zoneIds,
      activeZoneId: zoneIds.first,
      sheetHeight: sheetHeight,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final ok = await _perms.ensureWhenInUsePermission(context);
      if (!mounted) return;
      setState(() => _hasLocationPermission = ok);

      if (ok && _mapController != null) {
        await _mapController!.enableUserPuck();
        if (!mounted) return;

        final vm = context.read<ContenedorViewModel>();
        await _mapController!.showContenedores(vm.items);
      }

      if (ok) {
        if (!mounted) return;
        await _getCoordenates(updateAddress: false);
      }
    });
  }

  Future<void> _retryPermission() async {
    final ok = await _perms.ensureWhenInUsePermission(context);
    if (!mounted) return;
    setState(() => _hasLocationPermission = ok);
    if (ok && _mapController != null) {
      await _mapController!.enableUserPuck();
      if (!mounted) return;

      final vm = context.read<ContenedorViewModel>();
      await _mapController!.showContenedores(vm.items);
    }
    if (ok) {
      if (!mounted) return;
      await _getCoordenates(updateAddress: false);
    }
  }

  Future<void> _changeMapStyle(MapStyle style) async {
    if (!mounted) return;
    setState(() => _estiloActual = style);
    await _nativeNavigationBridge?.setMapStyle(style);
  }

  @override
  void dispose() {
    _vm?.removeListener(_onVmChanged);
    _zonaVm?.removeListener(_onZonaVmChanged);
    super.dispose();
  }

  // Metodo para buscar direccion desde parametros
  Future<void> _buscarDireccion(double lat, double lon) async {
    setState(() {
      _addressLat = lat;
      _addressLon = lon;
    });
    await _nativeNavigationBridge?.showDestinationPreview(
      latitude: lat,
      longitude: lon,
    );
  }

  Future<void> _abrirDetalleDireccion() async {
    final sheet = _flotanteKey.currentState;
    await sheet?.expandSecondSheet();
  }

  Future<void> _goToContainerSelectedOnMap(Contenedor contenedor) async {
    final coord = contenedor.coordenada;
    if (coord == null) return;

    await _nativeNavigationBridge?.clearDestinationPreview();
    await _nativeNavigationBridge?.centerOnCoordinate(
      latitude: coord.latitud,
      longitude: coord.longitud,
    );
    if (!mounted) return;

    setState(() {
      _containerSelectedFromSearch = true;
      _contenedorSeleccionado = contenedor;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    });
    await _flotanteKey.currentState?.collapseSheet();
  }

  Future<double>? _getMetros(double lat, double lon) {
    return _mapController?.getMetros(lon, lat);
  }

  @override
  Widget build(BuildContext context) {
    final quickActionVm = context.watch<MapQuickActionViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final action = quickActionVm.consumePendingAction();
      if (action == null || !mounted) return;
      _pendingQuickAction = action;
      await _runPendingQuickAction();
    });

    final direccionSeleccionada = (_addressLat == 0 && _addressLon == 0)
        ? ''
        : context.watch<MapSearchViewModel>().getDireccionFromPoint(
            _addressLat,
            _addressLon,
          );

    return Stack(
      children: [
        Stack(
          children: [
            // Mapa con navegación nativa y pins de contenedores integrados
            MapboxNavigationMapView(
              latitude: -54.8070,
              longitude: -68.3047,
              zoom: 13,
              onMapReady: _onMapboxNavigationMapReady,
              onContainerPinsReady: _onMapboxContainerPinsReady,
              onContainerSelected: _onMapboxContainerSelected,
              onRoutePreviewed: _onNativeNavigationPayload,
              onRouteProgress: _onNativeNavigationPayload,
              onNavigationStateChanged: _onNativeNavigationPayload,
              onNavigationError: _onNativeNavigationPayload,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddressTurnByTurn(
                  navigationPayload: _nativeNavigationPayload,
                  hasRoute: _nativeRouteReady,
                  isNavigating: _nativeNavigationStarted,
                  onCancelNavigation: _cancelNativeNavigation,
                ),
              ),
            ),
          ],
        ),
        const SizedBox.expand(),

        // Seccion de permisos de ubicacion
        if (!_hasLocationPermission)
          if (!_nativeRouteReady || !_nativeNavigationStarted)
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black54),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Necesitamos tu ubicación para mostrarte en el mapa y guiarte a contenedores cercanos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _retryPermission,
                        style: FilledButton.styleFrom(
                          backgroundColor: camarone500,
                        ),
                        child: Text(
                          'Conceder permiso',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

        //Floating buttons of quick actions
        if (!_nativeRouteReady || !_nativeNavigationStarted)
          ButtonsQuickAccessOnMap(
            actionButtonStyleMap: () => _keySheetForChangeStylesOfMap.currentState?.expandSheet(),
            actionButtonZones: () => _keyOfSheetOfZonesOfMap.currentState?.expandSheet(), 
            actionButtonCenterCamera: _centerNativeTurnByTurnCamera
          ),

        // Barra de navegacion del mapa
        if (!_nativeRouteReady || !_nativeNavigationStarted)
          FlotanteSheet(
            key: _flotanteKey,
            minChildSize: .093,
            maxChildSize: .80,
            maxChildSize2: .80,
            snapPoints: const [.093, .30, .55, .80],
            snapPoints2: const [.093, .30, .55, .80],
            onCollapsed: () {
              final isSecond =
                  _flotanteKey.currentState?.isShowingSecondChild ?? false;
              if (!isSecond) {
                _filterKey.currentState?.onSheetCollapsed();
              }
            },
            // ignore: sort_child_properties_last
            child: SheetSearchBar(
              key: _filterKey,
              cambio: _cambio,
              closeFilter: _changes,
              aplicarFiltros: _applyFilters,
              buscarDireccion: _buscarDireccion,
              abrirDetalleDireccion: _abrirDetalleDireccion,
              goToContainer: _goToContainerSelectedOnMap,
            ),
            child2: SheetOptionsOfNavToRoute(
              key: _keySheetOptionsOfNavToRoute,
              openOptionContainer: () => _keySheetAddContainerToRoute.currentState?.expandSheet(),
              tuUbicacion: 'Tu ubicación',
              direccion: direccionSeleccionada.isEmpty
                  ? 'Dirección seleccionada'
                  : direccionSeleccionada,
              userPoint: _userPoint,
              destinationPoint: <String, double>{'lon': _addressLon, 'lat': _addressLat},
              generateRoute: _paintNativeRoute,
              onPreviewSheetMetricsChanged: _updateNativePreviewSheetInset,
              iniciarRuta: _startNativeNavigation,
              navigationPayload: _nativeNavigationPayload,
              cancelNavigation: _cancelNativeNavigation,
              cancelSetCamera: _centerNativeTurnByTurnCamera,
            ),
          ),

        //Sheet for zones options
        if (!_nativeRouteReady || !_nativeNavigationStarted)
          SheetOfZonesOfMap(
            key: _keyOfSheetOfZonesOfMap,
            onHideZones: _testHideZones,
            onShowAllZones: _testShowAllZones,
            onShowMyZone: _testShowMyZone,
            onShowAffectedZones: _testShowAffectedZones,
            backToUserLocation: _centerNativeTurnByTurnCamera,
          ),

        //Sheet de detalles de contenedor seleccionado
        if (_contenedorSeleccionado != null)
          SheetOfDetailsOfContainerInMap(
            key: _keyOfSheetOfDetailsContainerOnMap,
            selectedContainer: _contenedorSeleccionado!,
            distances: _getMetros,
            searchDirection: _buscarDireccion,
            openDetailDirection: _abrirDetalleDireccion,
            generateRouteWithCar: () => _paintNativeRoute(profile: 'automobile'),
            onCloseForSearchContainer: _containerSelectedFromSearch
                ? () => _filterKey.currentState?.expand()
                : null,
          ),

        //Sheet para agregar contenedores a la ruta
        SheetAddContainersToRoute(
          key: _keySheetAddContainerToRoute,
          lon: _addressLon,
          lat: _addressLat,
          add: _agregarDireccionNueva,
        ),

        // Sheet of diferentes styles
        SheetForChangeStylesOfMap(
          key: _keySheetForChangeStylesOfMap,
          selectedStyle: _estiloActual,
          onStyleChanged: _changeMapStyle,
        )
      ],
    );
  }
}
