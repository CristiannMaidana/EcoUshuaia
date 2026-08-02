import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/medicion_sensor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/data_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/info_state_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfDetailsOfContainerInMap extends SheetGeneric {
  final Contenedor selectedContainer;
  final Future<void> Function(double lat, double lon)? searchDirection;
  final Future<void> Function()? openDetailDirection;
  final Future<void> Function()? generateRouteWithCar;
  final Future<String> Function() getDistanceToSelectedContainer;
  final VoidCallback onClose;
  final Future<void> Function()? onCloseForNavButtonExpandSheet;

  const SheetOfDetailsOfContainerInMap({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.47,
    required this.selectedContainer,
    required this.searchDirection,
    required this.openDetailDirection,
    required this.generateRouteWithCar,
    required this.getDistanceToSelectedContainer,
    required this.onClose,
    this.onCloseForNavButtonExpandSheet,
  });

  @override
  State<SheetOfDetailsOfContainerInMap> createState() => SheetOfDetailsOfContainerInMapState();
}

class SheetOfDetailsOfContainerInMapState extends SheetGenericState<SheetOfDetailsOfContainerInMap> {
  String _distanceToSelectedContainer = 'Desconocido';

  Future<void> _loadDistanceToSelectedContainer() async {
    final selectedContainerId = widget.selectedContainer.idContenedor;
    setState(() {
      _distanceToSelectedContainer = 'Desconocido';
    });
    final distanceToSelectedContainer = await widget.getDistanceToSelectedContainer();
    
    if (!mounted || widget.selectedContainer.idContenedor != selectedContainerId) {
      return;
    }
    setState(() {
      _distanceToSelectedContainer = distanceToSelectedContainer;
    });
  }

  @override
  Future<void> expandSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    final updatedFillLevel = context.read<MedicionSensorViewModel>().load(
      widget.selectedContainer.idContenedor,
    );
    final updatedDistance = _loadDistanceToSelectedContainer();

    await super.expandSheet();
    await Future.wait([updatedFillLevel, updatedDistance]);
  }

  @override
  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    widget.onClose();
    await super.collapseSheet();
  }

  Future<void> collapSheetForNavButton() async {
    if (draggableControllerOfSheet.isAttached) {
      await draggableControllerOfSheet.animateTo(
        initialChildSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
      .timeout(const Duration(milliseconds: 350), onTimeout: () {});
    }
    await widget.onCloseForNavButtonExpandSheet?.call();
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    final vmUsuarioFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final vmResiduos = context.watch<ResiduoViewmodel>();
    final idResiduoOfContainer = widget.selectedContainer.idResiduo;
    final getResiduoOfContainer = idResiduoOfContainer == null
        ? null
        : vmResiduos.getResiduo(idResiduoOfContainer);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),
          
          // Header row with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: camarone100,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: const Icon(Icons.location_on_rounded,
                      size: 38,
                      color: camarone700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(widget.selectedContainer.nombreContenedor ?? 'Contenedor numero',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Zona ${widget.selectedContainer.idZona}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              Row(
                children: [
                  CircleIcon(icon: Icons.favorite,
                    color:
                        vmUsuarioFavoritos.isFavorito(
                          widget.selectedContainer.idContenedor,
                        )
                        ? Colors.yellow.shade400
                        : Colors.grey,
                    onPressed: () {
                      final idContenedor = widget.selectedContainer.idContenedor;
                      vmUsuarioFavoritos.isFavorito(idContenedor)
                          ? vmUsuarioFavoritos.removeFavoritoById(idContenedor)
                          : vmUsuarioFavoritos.addFavorito(idContenedor);
                    },
                  ),
                  
                  const SizedBox(width: 20),
                  CircleIcon(icon: Icons.close, onPressed: collapseSheet),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DataContainer(
                  contenido: getResiduoOfContainer?.nombre ?? 'Desconocido',
                  icon: Icons.circle,
                  colorIcon: getResiduoOfContainer == null
                      ? Colors.grey
                      : getResiduoOfContainer.colorHex.toColor(),
                ),
              ),
              const SizedBox(width: 8),
              DataContainer(
                contenido: widget.selectedContainer.idContenedor.toString(),
                icon: Icons.my_library_books_outlined,
                colorIcon: Colors.black,
              ),
              const SizedBox(width: 8),
              DataContainer(
                contenido: _distanceToSelectedContainer,
                icon: Icons.location_on_outlined,
                colorIcon: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    final vmMap = context.watch<MapSearchViewModel>();
    final medicionSensorViewModel = context.watch<MedicionSensorViewModel>();
    final medicionSensorDelContenedor =
        medicionSensorViewModel.medicionSensor?.idContenedor ==
            widget.selectedContainer.idContenedor
        ? medicionSensorViewModel.medicionSensor
        : null;
    final direccion = vmMap.getDireccionFromPoint(
      widget.selectedContainer.coordenada?.latitud,
      widget.selectedContainer.coordenada?.longitud,
    );

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(22, 8, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoStateContainer(
                      titulo: 'Direccion:',
                      icon: Icons.map_outlined,
                      descripcion: direccion.isNotEmpty
                          ? direccion
                          : widget.selectedContainer.descripcionUbicacion ??
                                'direccion',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoStateContainer(
                      titulo: 'Próx. recolección',
                      icon: Icons.calendar_month_outlined,
                      descripcion:(widget.selectedContainer.capacidadTotal ?? 'Desconocido').toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InfoStateContainer(
                      titulo: 'Nivel de llenado',
                      icon: Icons.delete_outline,
                      descripcion: medicionSensorDelContenedor?.nivelLlenado ?? 'Desconocido',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoStateContainer(
                      titulo: 'Estado',
                      icon: Icons.security_outlined,
                      descripcion: (widget.selectedContainer.capacidadTotal ?? 'Desconocido').toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.notifications_none,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(width: 6),
                          Text('Recordarme'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final coord = widget.selectedContainer.coordenada;
                        if (coord == null) return;

                        await collapSheetForNavButton();
                        await widget.searchDirection?.call(
                          coord.latitud,
                          coord.longitud,
                        );
                        await widget.openDetailDirection?.call();
                        await widget.generateRouteWithCar?.call();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.time_to_leave,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 6),
                          Text('Navegar'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
