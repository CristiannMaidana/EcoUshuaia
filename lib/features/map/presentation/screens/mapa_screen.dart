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
import 'package:eco_ushuaia/features/map/presentation/controllers/map_native_coordinator.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_sheet_flow_controller.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_add_containers_to_route.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_floating_with_dynamic_content.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_for_show_all_the_favorites_containers.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_options_of_nav_to_route.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_for_change_styles_of_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_of_details_of_container_in_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_of_zones_of_map.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_preview_address.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheets/sheet_search_bar.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/features/map/data/sources/local/location_service.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:provider/provider.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ContenedorViewModel(ctx.read<ContenedorRepository>())..load(),
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
          create: (ctx) => ResiduoViewmodel(ctx.read<ResiduoRepository>())..load(),
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
          create: (ctx) => ZonaMapaViewModel(ctx.read<ZonaMapaRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MapNativeCoordinator(
            contenedorViewModel: ctx.read<ContenedorViewModel>(),
            zonaMapaViewModel: ctx.read<ZonaMapaViewModel>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MapSheetFlowController(),
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

  MapStyle _estiloActual = MapStyle.Estandar;

  Contenedor? _contenedorSeleccionado;

  MapQuickAction? _pendingQuickAction;

  //=== Variable y metodos para el SheetAddContainer ===
  double _addressLon = 0;
  double _addressLat = 0;
  Map<String, double> _userPoint = const <String, double>{'lon': 0, 'lat': 0};

  // KEYS
  // Key of content of sheet
  final GlobalKey<SheetOptionsOfNavToRouteState> _keySheetOptionsOfNavToRoute = GlobalKey<SheetOptionsOfNavToRouteState>();
  final GlobalKey<SheetSearchBarState> _keySheetSearchBar = GlobalKey<SheetSearchBarState>();

  // Keys of sheet
  final GlobalKey<SheetOfZonesOfMapState> _keyOfSheetOfZonesOfMap = GlobalKey<SheetOfZonesOfMapState>();
  final GlobalKey<SheetOfDetailsOfContainerInMapState> _keyOfSheetOfDetailsContainerOnMap = GlobalKey<SheetOfDetailsOfContainerInMapState>();
  final GlobalKey<SheetForChangeStylesOfMapState> _keySheetForChangeStylesOfMap = GlobalKey<SheetForChangeStylesOfMapState>();
  final GlobalKey<SheetAddContainersToRouteState> _keySheetAddContainerToRoute = GlobalKey<SheetAddContainersToRouteState>();
  final GlobalKey<SheetFloatingWithDynamicContentState> _keySheetFloating = GlobalKey<SheetFloatingWithDynamicContentState>();
  final GlobalKey<SheetForShowAllTheFavoritesContainersState> _keySheetAllTheFavoriteContainerOfUser = GlobalKey<SheetForShowAllTheFavoritesContainersState>();
  final GlobalKey<SheetPreviewAddressState> _keySheetPreviewAddress = GlobalKey<SheetPreviewAddressState>();

  // PROVIDERS
  // Provider for the navigation flow between sheets.
  MapSheetFlowController get _mapSheetFlow => context.read<MapSheetFlowController>();
  MapNativeCoordinator get _nativeMapCoordinator => context.read<MapNativeCoordinator>();

  void _closeContainerDetailsFromFlow() {
    final previousSheet = _mapSheetFlow.closeCurrentSheetAndReturnPreviousDestination();
    if (previousSheet != MapSheetDestination.search) return;

    _keySheetFloating.currentState?.changeToFirstChild();
    _keySheetSearchBar.currentState?.expand();
  }

  Future<void> _closeAddressPreviewFromFlow() async {
    final previousSheet = _mapSheetFlow.closeCurrentSheetAndReturnPreviousDestination();
    if (previousSheet != MapSheetDestination.search) return;

    _keySheetFloating.currentState?.changeToFirstChild();
    await _keySheetSearchBar.currentState?.expand();
  }

  Future<void> _returnToPreviousSheetFromNavigation() async {
    final previousSheet = _mapSheetFlow.returnFromNavigationToPreviousDestination();
    if (previousSheet == MapSheetDestination.containerDetails) {
      await _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    } else if (previousSheet == MapSheetDestination.addressPreview) {
      await _keySheetPreviewAddress.currentState?.expandSheet(
        _addressLat,
        _addressLon,
      );
    }
  }

  void _agregarDireccionNueva(Contenedor contenedor) {
    _keySheetOptionsOfNavToRoute.currentState?.addContenedor(contenedor);
  }

  Future<void> _getCoordenates({bool updateAddress = true}) async {
    final ok =
        _hasLocationPermission ||
        await _perms.ensureWhenInUsePermission(context);
    if (!mounted || !ok) return;
    if (!_hasLocationPermission) setState(() => _hasLocationPermission = ok);

    Map<String, double> puntos;
    try {
      final position = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );
      puntos = <String, double>{
        'lon': position.longitude,
        'lat': position.latitude,
      };
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

  // Callback que recibe el contenedor tocado desde MapController
  void _onContenedorTap(Contenedor c) {
    _mapSheetFlow.startContainerDetailsFromMap();
    setState(() {
      _contenedorSeleccionado = c;
      _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    });
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
    await _showUserZone(0);
  }

  void _openQuickSearchAddress() {
    _keySheetSearchBar.currentState?.openSearch();
  }

  Future<void> _runPendingQuickAction() async {
    final action = _pendingQuickAction;
    if (action == null || !mounted) return;

    switch (action) {
      case MapQuickAction.myZone:
        if (!_nativeMapCoordinator.hasNavigationBridge) return;
        await _openQuickMyZone();
        _pendingQuickAction = null;
        break;
      case MapQuickAction.favoritos:
        await _openQuickFavoritos();
        _pendingQuickAction = null;
        break;
      case MapQuickAction.searchAddress:
        if (_keySheetSearchBar.currentState == null) return;
        _openQuickSearchAddress();
        _pendingQuickAction = null;
        break;
    }
  }

  Future<void> _onMapboxNavigationMapReady( MapboxNavigationMapViewBridge bridge, ) async {
    await _nativeMapCoordinator.attachNavigationMapBridge(bridge);
    await _runPendingQuickAction();
  }

  Future<void> _onMapboxContainerPinsReady( MapboxContainerPinsBridge bridge, ) async {
    await _nativeMapCoordinator.attachContainerPinsBridge(bridge);
    await _runPendingQuickAction();
  }

  void _onMapboxContainerSelected(int idContenedor) {
    final vm = context.read<ContenedorViewModel>();

    final candidates = <Contenedor>[...vm.items, ...vm.contenedorFiltrado];
    for (final contenedor in candidates) {
      if (contenedor.idContenedor == idContenedor) {
        _onContenedorTap(contenedor);
        return;
      }
    }
  }

  Future<void> _centerNativeTurnByTurnCamera() async {
    final nativeMapCoordinator = _nativeMapCoordinator;
    if (!_hasLocationPermission) {
      await _retryPermission();
      return;
    }

    if (nativeMapCoordinator.hasNavigationBridge) {
      await nativeMapCoordinator.centerTurnByTurnCamera();
    }
  }

  Future<void> _paintNativeRoute({required String profile, List<Map<String, double>>? routePoints}) async {
    final nativeMapCoordinator = _nativeMapCoordinator;
    if (!nativeMapCoordinator.hasNavigationBridge) return;

    if (_userPoint['lat'] == 0 || _userPoint['lon'] == 0) {
      await _getCoordenates(updateAddress: false);
    }

    final originLatitude = _userPoint['lat'];
    final originLongitude = _userPoint['lon'];
    if (originLatitude == null || originLongitude == null) return;
    if (originLatitude == 0 && originLongitude == 0) return;
    if (_addressLat == 0 && _addressLon == 0) return;

    _keySheetOptionsOfNavToRoute.currentState?.reportPreviewSheetMetrics();

    await nativeMapCoordinator.previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: _addressLat,
      destinationLongitude: _addressLon,
      profile: profile,
      routePoints: routePoints,
    );
  }

  Future<void> _showUserZone(double sheetHeight) async {
    final usuarioZoneId = context.read<UsuarioViewModel>().usuario?.idZona;
    await _nativeMapCoordinator.showUserZoneOrFirstAvailable(
      userZoneId: usuarioZoneId,
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
    if (ok) {
      if (!mounted) return;
      await _getCoordenates(updateAddress: false);
    }
  }

  Future<void> _changeMapStyle(MapStyle style) async {
    if (!mounted) return;
    setState(() => _estiloActual = style);
    await _nativeMapCoordinator.changeMapStyle(style);
  }

  // Metodo para buscar direccion desde parametros
  Future<void> _buscarDireccion(double lat, double lon) async {
    setState(() {
      _addressLat = lat;
      _addressLon = lon;
    });
    await _nativeMapCoordinator.showDestinationPreview(
      latitude: lat,
      longitude: lon,
    );
  }

  //Abre widget para datos de navegacion a direccion
  Future<void> _openSheetOptionsOfNav() async {
    _mapSheetFlow.openNavigationFromCurrentSheet();
    _keySheetFloating.currentState?.changeToSecondChild();
  }

  Future<void> _openAddressPreviewFromSearch() async {
    _mapSheetFlow.startAddressPreviewFromSearch();
    _keySheetPreviewAddress.currentState?.expandSheet(_addressLat, _addressLon);
    _keySheetFloating.currentState?.collapseSheet();
  }

  Future<void> _goToContainerSelectedOnMap(Contenedor contenedor) async {
    final coord = contenedor.coordenada;
    if (coord == null) return;
    final nativeMapCoordinator = _nativeMapCoordinator;

    await nativeMapCoordinator.clearDestinationPreview();
    await nativeMapCoordinator.centerOnCoordinate(
      latitude: coord.latitud,
      longitude: coord.longitud,
    );
    if (!mounted) return;

    _mapSheetFlow.startContainerDetailsFromSearch();
    setState(() {
      _contenedorSeleccionado = contenedor;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    });
    await _keySheetFloating.currentState?.collapseSheet();
  }

  Future<void> _goToContainerSelectedOnMapFromAllFavorites(Contenedor contenedor) async {
    final coord = contenedor.coordenada;
    if (coord == null) return;
    final nativeMapCoordinator = _nativeMapCoordinator;

    await nativeMapCoordinator.clearDestinationPreview();
    
    await _keySheetFloating.currentState?.collapseSheet();
    
    await _keySheetAllTheFavoriteContainerOfUser.currentState?.collapseSheet();
    
    await nativeMapCoordinator.centerOnCoordinate(
      latitude: coord.latitud,
      longitude: coord.longitud,
    );
    if (!mounted) return;

    _mapSheetFlow.startContainerDetailsFromSearch();
    setState(() {
      _contenedorSeleccionado = contenedor;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _keyOfSheetOfDetailsContainerOnMap.currentState?.expandSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quickActionVm = context.watch<MapQuickActionViewmodel>();
    final nativeMapCoordinator = context.watch<MapNativeCoordinator>();
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
              onRoutePreviewed: nativeMapCoordinator.handleNavigationPayload,
              onRouteProgress: nativeMapCoordinator.handleNavigationPayload,
              onNavigationStateChanged: nativeMapCoordinator.handleNavigationPayload,
              onNavigationError: nativeMapCoordinator.handleNavigationPayload,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddressTurnByTurn(
                  navigationPayload: nativeMapCoordinator.navigationPayload,
                  hasRoute: nativeMapCoordinator.routeReady,
                  isNavigating: nativeMapCoordinator.navigationStarted,
                  onCancelNavigation: nativeMapCoordinator.cancelNavigation,
                ),
              ),
            ),
          ],
        ),

        // Seccion de permisos de ubicacion
        if (!_hasLocationPermission)
          if (!nativeMapCoordinator.routeReady || !nativeMapCoordinator.navigationStarted)
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
        if (!nativeMapCoordinator.routeReady || !nativeMapCoordinator.navigationStarted)
          ButtonsQuickAccessOnMap(
            actionButtonStyleMap: () => _keySheetForChangeStylesOfMap.currentState?.expandSheet(),
            actionButtonZones: () => _keyOfSheetOfZonesOfMap.currentState?.expandSheet(), 
            actionButtonCenterCamera: _centerNativeTurnByTurnCamera
          ),

        // Barra de navegacion del mapa
        if (!nativeMapCoordinator.routeReady || !nativeMapCoordinator.navigationStarted)
          SheetFloatingWithDynamicContent(
            key: _keySheetFloating,
            childNavOptions: SheetOptionsOfNavToRoute(
                key: _keySheetOptionsOfNavToRoute,
                openOptionContainer: () => _keySheetAddContainerToRoute.currentState?.expandSheet(),
                tuUbicacion: 'Tu ubicación',
                direccion: direccionSeleccionada.isEmpty
                    ? 'Dirección seleccionada'
                    : direccionSeleccionada,
                userPoint: _userPoint,
                destinationPoint: <String, double>{'lon': _addressLon, 'lat': _addressLat},
                generateRoute: _paintNativeRoute,
                onPreviewSheetMetricsChanged: nativeMapCoordinator.updateNavigationPreviewSheetInset,
                iniciarRuta: nativeMapCoordinator.startNavigation,
                navigationPayload: nativeMapCoordinator.navigationPayload,
                cancelNavigation: nativeMapCoordinator.cancelNavigation,
                cancelSetCamera: _centerNativeTurnByTurnCamera,
                onNavigateBack: _returnToPreviousSheetFromNavigation,
              ),
              childSearchBar: SheetSearchBar(
                key: _keySheetSearchBar,
                buscarDireccion: _buscarDireccion,
                abrirDetalleDireccion: _openAddressPreviewFromSearch,
                goToContainer: _goToContainerSelectedOnMap,
                functionForOpenSheetOfAllTheFavorites: () async => _keySheetAllTheFavoriteContainerOfUser.currentState?.expandSheet(),
              ),
          ),

        //Sheet for zones options
        if (!nativeMapCoordinator.routeReady || !nativeMapCoordinator.navigationStarted)
          SheetOfZonesOfMap(
            key: _keyOfSheetOfZonesOfMap,
            onHideZones: nativeMapCoordinator.hideAllZones,
            onShowAllZones: nativeMapCoordinator.showAllZones,
            onShowMyZone: _showUserZone,
            onShowAffectedZones: nativeMapCoordinator.showFirstTwoAffectedZones,
            backToUserLocation: _centerNativeTurnByTurnCamera,
          ),

        //Sheet de detalles de contenedor seleccionado
        if (_contenedorSeleccionado != null)
          SheetOfDetailsOfContainerInMap(
            key: _keyOfSheetOfDetailsContainerOnMap,
            selectedContainer: _contenedorSeleccionado!,
            searchDirection: _buscarDireccion,
            openDetailDirection: _openSheetOptionsOfNav,
            generateRouteWithCar: () => _paintNativeRoute(profile: 'automobile'),
            onClose: _closeContainerDetailsFromFlow,
            onCloseForNavButtonExpandSheet: () async => _keySheetFloating.currentState?.expandSheetToMidSize(),
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
        ),

        SheetForShowAllTheFavoritesContainers(
          key: _keySheetAllTheFavoriteContainerOfUser,
          goToContainer: _goToContainerSelectedOnMapFromAllFavorites,
        ),

        SheetPreviewAddress(
          key: _keySheetPreviewAddress,
          searchDirection: _buscarDireccion,
          openDetailDirection: _openSheetOptionsOfNav,
          generateRouteWithCar: () => _paintNativeRoute(profile: 'automobile'),
          onCloseForSearchAddress: _closeAddressPreviewFromFlow,
          onCloseForNavButtonExpandSheet: () async => _keySheetFloating.currentState?.expandSheetToMidSize(),
        ),
      ],
    );
  }
}
