import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/horario_recoleccion_filtros_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_container_pins_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/categoria_residuos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/horario_recoleccion_filtros_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/address_turn_by_turn.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/container_detail.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/mapbox_navigation_map_view.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_controller.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/flotante_sheet.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_add_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_address.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_search_bar.dart';
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
      ],
      child: MapaPage(),
    );
  }
}

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaScreenStatePage();
}

class _MapaScreenStatePage extends State<MapaPage> {
  final GlobalKey<ContainerDetailState> _detailKey =
      GlobalKey<ContainerDetailState>();
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

  Contenedor? _contenedorSeleccionado;

  bool _cambio = false;

  //Variable para manejar el tamaño del sheet
  final GlobalKey<SheetSearchBarState> _filterKey =
      GlobalKey<SheetSearchBarState>();

  final GlobalKey<FlotanteSheetState> _flotanteKey =
      GlobalKey<FlotanteSheetState>();

  //=== Variable y metodos para el SheetAddContainer ===
  double _addressLon = 0;
  double _addressLat = 0;
  Map<String, double> _userPoint = const <String, double>{'lon': 0, 'lat': 0};

  final GlobalKey<SheetAddContainerState> _addContainerSheetKey =
      GlobalKey<SheetAddContainerState>();

  final GlobalKey<SheetAddressState> _sheetAddressKey = GlobalKey<SheetAddressState>();

  // Condicion para mostrar el sheet
  bool openSheetAddContainer = false;
  bool openSheetAddAddress = false;

  // Metodo para abrir el sheetAddContainer
  Future<void> _abrirSheetAddContainer() async {
    if (openSheetAddContainer) return;
    await _getCoordenates();
    if (!mounted) return;
    setState(() => openSheetAddContainer = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addContainerSheetKey.currentState?.expand();
    });
  }

  // Metodo para cerrar el sheetAddContainer
  void _cerrarSheetAddContainer() {
    if (!openSheetAddContainer) return;
    final sheetState = _addContainerSheetKey.currentState;
    if (sheetState == null) {
      setState(() => openSheetAddContainer = false);
      return;
    }
    sheetState.collapse();
  }

  void _agregarDireccionNueva(Contenedor contenedor) {
    _sheetAddressKey.currentState?.addContenedor(contenedor);
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

  // Callback que recibe el contenedor tocado desde MapController
  void _onContenedorTap(Contenedor c) {
    setState(() {
      _contenedorSeleccionado = c;
      _detailKey.currentState?.subirSheet();
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

  Future<void> _onMapboxNavigationMapReady(
    MapboxNavigationMapViewBridge bridge,
  ) async {
    _nativeNavigationBridge = bridge;
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

  Future<void> _paintNativeRoute({required String profile}) async {
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

    _sheetAddressKey.currentState?.reportPreviewSheetMetrics();

    final payload = await bridge.previewRoute(
      originLatitude: originLatitude,
      originLongitude: originLongitude,
      destinationLatitude: _addressLat,
      destinationLongitude: _addressLon,
      profile: profile,
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

  // Metodos de tipo de transporte para previsualizar ruta
  Future<void> _previewNativeDrivingRoute() {
    return _paintNativeRoute(profile: 'automobile');
  }

  Future<void> _previewNativeWalkingRoute() {
    return _paintNativeRoute(profile: 'walking');
  }

  Future<void> _previewNativeCyclingRoute() {
    return _paintNativeRoute(profile: 'cycling');
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final ok = await _perms.ensureWhenInUsePermission(context);
      if (!mounted) return;
      setState(() => _hasLocationPermission = ok);

      if (ok && _mapController != null) {
        await _mapController!.enableUserPuck();

        final vm = context.read<ContenedorViewModel>();
        await _mapController!.showContenedores(vm.items);
      }

      if (ok) {
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

      final vm = context.read<ContenedorViewModel>();
      await _mapController!.showContenedores(vm.items);
    }
    if (ok) {
      await _getCoordenates(updateAddress: false);
    }
  }

  Future<void> _mostrarOpciones(BuildContext context) async {
    final estilo = await showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(.4),
      backgroundColor: camarone50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estilo de mapa',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Elegi como queres ver el mapa.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                MapStylePicker(seleccionado: _estiloActual),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || estilo == null) return;

    setState(() => _estiloActual = estilo);

    await _nativeNavigationBridge?.setMapStyle(estilo);
  }

  @override
  void dispose() {
    _vm?.removeListener(_onVmChanged);
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

  void _abrirDetalleDireccion() {
    final sheet = _flotanteKey.currentState;
    sheet?.showSecondChild();
  }

  Future<double>? _getMetros(double lat, double lon) {
    return _mapController?.getMetros(lon, lat);
  }

  @override
  Widget build(BuildContext context) {
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

        if (!_nativeRouteReady || !_nativeNavigationStarted)
          Positioned(
            right: 24,
            bottom: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    FloatingActionButton(
                      heroTag: 'fab-map-style',
                      onPressed: () => _mostrarOpciones(context),
                      backgroundColor: camarone500,
                      child: Image.asset('assets/icons/mapa/maps-style.png'),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'fab-center-camera',
                      onPressed: _centerNativeTurnByTurnCamera,
                      backgroundColor: camarone500,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
            ),
            child2: SheetAddress(
              key: _sheetAddressKey,
              openOptionContainer: _abrirSheetAddContainer,
              tuUbicacion: 'Tu ubicación',
              direccion: direccionSeleccionada.isEmpty
                  ? 'Dirección seleccionada'
                  : direccionSeleccionada,
              userPoint: _userPoint,
              generateRouteCar: _previewNativeDrivingRoute,
              generateRouteBike: _previewNativeCyclingRoute,
              generateRouteWalk: _previewNativeWalkingRoute,
              onPreviewSheetMetricsChanged: _updateNativePreviewSheetInset,
              iniciarRuta: _startNativeNavigation,
              navigationPayload: _nativeNavigationPayload,
              cancelNavigation: _cancelNativeNavigation,
              cancelSetCamera: _centerNativeTurnByTurnCamera,
            ),
          ),

        //Sheet de detalles de contenedor seleccionado
        if (_contenedorSeleccionado != null)
          ContainerDetail(
            key: _detailKey,
            container: _contenedorSeleccionado!,
            distancia: _getMetros,
            buscarDireccion: _buscarDireccion,
            abrirDetalleDireccion: _abrirDetalleDireccion,
            generateRouteCar: _previewNativeDrivingRoute,
          ),

        //Sheet para agregar contenedores a la ruta
        if (openSheetAddContainer)
          Positioned.fill(
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _cerrarSheetAddContainer,
                  child: const SizedBox.expand(),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SheetAddContainer(
                    key: _addContainerSheetKey,
                    lon: _addressLon,
                    lat: _addressLat,
                    onClosed: () {
                      if (!mounted) return;
                      setState(() => openSheetAddContainer = false);
                    },
                    add: _agregarDireccionNueva,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
