import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/categoria_residuos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/residuo_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/categoria_residuos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/container_detail.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_controller.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/search_bar.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/sheet_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/features/map/data/sources/local/location_service.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_widget.dart';
import 'package:provider/provider.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (ctx) => 
            ContenedorViewModel(ctx.read<ContenedorRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => 
          CategoriaResiduosViewmodel(ctx.read<CategoriaResiduosRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
          ResiduoViewmodel(ctx.read<ResiduoRepository>())..load(),
        ),
      ],
      child: MapaPage(),
    );
  }
}

class MapaPage extends StatefulWidget {
  const MapaPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaScreenStatePage();
}

class _MapaScreenStatePage extends State<MapaPage> {
  final GlobalKey<ContainerDetailState> _detailKey = GlobalKey<ContainerDetailState>();
  final _perms = LocationPermissionService.I;
  bool _hasLocationPermission = false;
  MapController? _mapController;
  MapStyle _estiloActual = MapStyle.Estandar;

  ContenedorViewModel? _vm;

  Contenedor? _contenedorSeleccionado;

  bool _cambio = false;

  //Variable para manejar el tamaño del sheet
  final GlobalKey<SheetSearchBarState> _filterKey = GlobalKey<SheetSearchBarState>();

  void _changes() {
    setState(() {
      _cambio = !_cambio;
      if (_cambio)
        _filterKey.currentState?.expand();
    });
  }

  // Actualiza los contenedores cuando cambia el VM
  void _onVmChanged() {
    final ctrl = _mapController;
    final vm = _vm;
    if (ctrl != null && vm != null) {
      // Si hay filtro activo, cargar los contenedores filtrados, si no con todos
      final data = vm.contenedorFiltrado.isNotEmpty ? vm.contenedorFiltrado : vm.items;
      ctrl.refreshContenedores(data);
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
    final ctrl = _mapController;
    if (vm == null || ctrl == null) return;

    final data = vm.contenedorFiltrado.isNotEmpty ? vm.contenedorFiltrado : vm.items;
    ctrl.applyFilter(data);
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
    });
  }

  Future<void> _retryPermission() async {
    final ok = await _perms.ensureWhenInUsePermission(context);
    if (!mounted) return;
    setState(() => _hasLocationPermission = ok);
    if (ok && _mapController != null) {
      _mapController!.enableUserPuck();

      final vm = context.read<ContenedorViewModel>();
      await _mapController!.showContenedores(vm.items);
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
                Text('Estilo de mapa', style: Theme.of(context).textTheme.headlineLarge,),
                Text('Elegi como queres ver el mapa.', style: Theme.of(context).textTheme.bodyLarge,),
                MapStylePicker(
                  seleccionado: _estiloActual,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || estilo == null) return;

    setState(() => _estiloActual = estilo);

    _mapController?.setStyle(estilo);
  }

  @override
  void dispose() {
    _vm?.removeListener(_onVmChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomMapa(
          onMapReady: (controller) async {
            _mapController = controller;

            // Conectar callback de tap de contenedor
            controller.onContenedorTap = _onContenedorTap;

            if (_hasLocationPermission) {
              await controller.enableUserPuck();
            }

            _vm = context.read<ContenedorViewModel>();

            // Si cargaron contenedores cargo
            if (_vm!.items.isNotEmpty) {
              await controller.refreshContenedores(_vm!.items);
            } else {
              // Crear listener de un solo uso, cargar el resto de contenedore y actualizar una unica vez
              void once() async {
                if (!_vm!.loading) {
                  _vm!.removeListener(once);
                  await _mapController?.refreshContenedores(_vm!.items);
                }
              }
              _vm!.addListener(once);
            }
          },
        ),

        if (!_hasLocationPermission)
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
                      child: Text('Conceder permiso', style: Theme.of(context).textTheme.labelLarge,),
                    ),
                  ],
                ),
              ),
            ),
          ),

        Positioned(
          right: 24,
          bottom: 180,
          child: Row(
            children: [
              FloatingActionButton(
                onPressed: () => _mostrarOpciones(context),
                backgroundColor: camarone500,
                child: Image.asset('assets/icons/mapa/maps-style.png'),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: () async {
                  if (!_hasLocationPermission) {
                    await _retryPermission();
                    return;
                  }
                  await _mapController?.centerOnUserOnce();
                },
                backgroundColor: camarone500,
                child: const Icon(Icons.my_location, color: Colors.black, size: 32,),
              ),
            ],
          ),
        ),

        // Barra de navegacion del mapa
        SheetSearchBar(
          key: _filterKey,
          navBar: SerchBar(changeHeader: _changes),
          cambio: _cambio,
          closeFilter: _changes,
          aplicarFiltros: _applyFilters,
        ),

        if (_contenedorSeleccionado != null)
          ContainerDetail(
            key: _detailKey,
            container: _contenedorSeleccionado!,
          ),
      ],
    );
  }
}