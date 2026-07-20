import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/data_container.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/info_state_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfDetailsOfContainerInMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  
  final Contenedor selectedContainer;
  final Future<double>? Function(double lat, double lon)? distances;
  final Future<void> Function(double lat, double lon)? searchDirection;
  final VoidCallback? openDetailDirection;
  final Future<void> Function()? generateRouteWithCar;
  
  const SheetOfDetailsOfContainerInMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
    
    required this.distances,
    required this.selectedContainer,
    required this.searchDirection,
    required this.openDetailDirection,
    required this.generateRouteWithCar, 
  });

  @override
  State<SheetOfDetailsOfContainerInMap> createState() => SheetOfDetailsOfContainerInMapState();
}

class SheetOfDetailsOfContainerInMapState extends State<SheetOfDetailsOfContainerInMap> {
  late final DraggableScrollableController draggableControllerOfDetailsContainerSheet;
  bool _isSheetOpen = false;
  // TODO: calculate the distance for the user to the container
  Future<double>? _metrosFuture;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return 0.0;

    final currentSize = draggableControllerOfDetailsContainerSheet.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = widget.initialSheetSize + 0.17;

    // Evita división por 0 o rangos inválidos
    if (widget.maxSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (widget.maxSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    draggableControllerOfDetailsContainerSheet = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfDetailsContainerSheet.removeListener(_onSheetChanged);
    draggableControllerOfDetailsContainerSheet.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    _isSheetOpen = draggableControllerOfDetailsContainerSheet.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return;

    await draggableControllerOfDetailsContainerSheet.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return;

    await draggableControllerOfDetailsContainerSheet.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return false;
    return _isSheetOpen;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfDetailsContainerSheet.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfDetailsContainerSheet.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfDetailsContainerSheet.size < (widget.maxSheetSize / 2);

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfDetailsContainerSheet.size < _snapMidpoint
            ? widget.initialSheetSize
            : widget.maxSheetSize;

    draggableControllerOfDetailsContainerSheet.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }


  // Functions specific to the sheet
  String _formatDistance(double meters) {
    if (meters.isNaN || meters.isInfinite) return '';
    if (meters < 1000) return '${meters.round()} M';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} KM';
  }

  @override
  Widget build (BuildContext context) {
    final vmUsuarioFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final vmResiduos = context.watch<ResiduoViewmodel>();
    final vmMap = context.watch<MapSearchViewModel>();

    // Get info of the selected residuo
    final idResiduoOfContainer = widget.selectedContainer.idResiduo;
    final Residuos? getResiduoOfContainer = (idResiduoOfContainer == null) ? null : vmResiduos.getResiduo(idResiduoOfContainer);
    
    //Get distance to the container
    final String direccion = vmMap.getDireccionFromPoint(
      widget.selectedContainer.coordenada?.latitud,
      widget.selectedContainer.coordenada?.longitud,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // Functionality for close the sheet if is expand and touch out of the sheet.
        if (isExpandedSheet())
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: collapseSheet,
            child: const SizedBox.expand(),
          ),
        

        // -Sheet of zones-
        // Handle of the sheet settings
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfDetailsContainerSheet,
            initialChildSize: widget.initialSheetSize,
            minChildSize: widget.minSheetSize,
            maxChildSize: widget.maxSheetSize,
            builder: (context, scrollControllerDefault) {
              // Style of sheet for view
              return SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!,width: 1,),),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeOutCubic,
                    opacity: _contentOpacity,
                    child: Column(
                      children: [
                        // HEADER OF SHEET
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragUpdate: _dragFromHeaderSheet,
                          onVerticalDragEnd: _dragEndFromHeaderSheet,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            child: Column(
                              children: [
                                // Grab Bar
                                BarraAgarre(),
                                SizedBox(height: 8),

                                // Text of header and button
                                //Header del widget (Icon - Texto - Boton cerrar)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Icono location del contenedor
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: camarone100,
                                            borderRadius: BorderRadius.all(Radius.circular(18)),
                                          ),
                                          child: Icon(Icons.location_on_outlined,
                                            size: 38,
                                            color: camarone700
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // Informacion basica del contenedor (Zona y nombre)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,),
                                              child: Text('Zona ${widget.selectedContainer.idZona}',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text(widget.selectedContainer.nombreContenedor ??'Contenedor numero',
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Icons of actions
                                    Row(
                                      children: [
                                        CircleIcon(icon: Icons.favorite,
                                          color: vmUsuarioFavoritos.isFavorito(
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
                                        SizedBox(width: 20),
                                        CircleIcon(icon: Icons.close,
                                          onPressed: collapseSheet,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                //Informacion de contenedores ( Tipo de residuo, id del contenedor, distancia)
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
                                    SizedBox(width: 8),
                                    SizedBox(
                                      child: DataContainer(
                                        contenido:(widget.selectedContainer.idContenedor).toString(),
                                        icon: Icons.my_library_books_outlined,
                                        colorIcon: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      child: FutureBuilder<double>(
                                        future: _metrosFuture,
                                        builder: (context, snap) {
                                          final text = snap.hasData
                                              ? _formatDistance(snap.data!)
                                              : '';
                                          return DataContainer(
                                            contenido: text,
                                            icon: Icons.location_on_outlined,
                                            colorIcon: Colors.black,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                        // BODY
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollControllerDefault,
                            child: Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(22, 8, 22, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Informacion de estado de contenedor
                                  // -Direccion -Prox.Recoleccion
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Direccion:',
                                          icon: Icons.map_outlined,
                                          descripcion: direccion.isNotEmpty
                                              ? direccion
                                              : widget.selectedContainer.descripcionUbicacion ??'direccion',
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Próx. recolección',
                                          icon: Icons.calendar_month_outlined,
                                          descripcion:(widget.selectedContainer.capacidadTotal ??'Desconocido').toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  // -Nivel llenado -Estado
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Nivel de llenado',
                                          icon: Icons.delete_outline,
                                          descripcion:(widget.selectedContainer.capacidadTotal ??'Desconocido').toString(),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: InfoStateContainer(
                                          titulo: 'Estado',
                                          icon: Icons.security_outlined,
                                          descripcion:(widget.selectedContainer.capacidadTotal ??'Desconocido').toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                
                                  // FOOTER
                                  //Botones de accion
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              const Icon(Icons.notifications_none,
                                                color: Colors.black,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 6),
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
                                        
                                            collapseSheet();
                                            final buscarDireccion = widget.searchDirection;
                                            if (buscarDireccion != null) {
                                              await buscarDireccion(
                                                coord.latitud,
                                                coord.longitud,
                                              );
                                            }
                                            widget.openDetailDirection?.call();
                                            final generateRouteCar = widget.generateRouteWithCar;
                                            if (generateRouteCar != null) {
                                              await generateRouteCar();
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.map_outlined,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 6),
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
                          )
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          )
        )
      ],
    );
  }
}
