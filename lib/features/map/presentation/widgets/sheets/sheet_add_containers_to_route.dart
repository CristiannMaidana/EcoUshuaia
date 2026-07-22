import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/slider_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddContainersToRoute extends StatefulWidget {
  final double lon;
  final double lat;
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  final ValueChanged<Contenedor> add;
  final Future<void> Function(double lat, double lon)? buscarDireccion;
  final VoidCallback? abrirDetalleDireccion;
  final Future<void> Function()? generateRouteCar;

  const SheetAddContainersToRoute({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.70,
    required this.lon,
    required this.lat,
    required this.add,
    this.buscarDireccion,
    this.abrirDetalleDireccion,
    this.generateRouteCar,
  });

  @override
  State<SheetAddContainersToRoute> createState() => SheetAddContainersToRouteState();
}

class SheetAddContainersToRouteState extends State<SheetAddContainersToRoute> {
  late final DraggableScrollableController draggableControllerOfSheetAddContainerToRoute;
  bool _isSheetOpen = false;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

  @override
  void initState() {
    super.initState();
    draggableControllerOfSheetAddContainerToRoute = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfSheetAddContainerToRoute.removeListener(_onSheetChanged);
    draggableControllerOfSheetAddContainerToRoute.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    _isSheetOpen = draggableControllerOfSheetAddContainerToRoute.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return;

    await draggableControllerOfSheetAddContainerToRoute.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return;

    await draggableControllerOfSheetAddContainerToRoute.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return false;
    return _isSheetOpen;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfSheetAddContainerToRoute.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfSheetAddContainerToRoute.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfSheetAddContainerToRoute.size < (widget.maxSheetSize / 2);

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfSheetAddContainerToRoute.size < _snapMidpoint
            ? widget.initialSheetSize
            : widget.maxSheetSize;

    draggableControllerOfSheetAddContainerToRoute.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfSheetAddContainerToRoute.isAttached) return 0.0;

    final currentSize = draggableControllerOfSheetAddContainerToRoute.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = widget.initialSheetSize + 0.10;

    // Evita división por 0 o rangos inválidos
    if (widget.maxSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (widget.maxSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final vmContenedores = context.watch<ContenedorViewModel>();
    final contenedoresCercanos = vmContenedores.contenedorCercanos;

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
        

        // -Sheet of add containers-
        // Handle of the sheet settings
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfSheetAddContainerToRoute,
            initialChildSize: widget.initialSheetSize,
            minChildSize: widget.minSheetSize,
            maxChildSize: widget.maxSheetSize,
            builder: (context, scrollControllerDefault) {
              return SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!,width: 1,),),
                  ),
                  child: AnimatedOpacity(
                    opacity: _contentOpacity, 
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeOutCubic,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Agregar parada',
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text('Elegí uno o más contenedores para incluir en tu recorrido.', 
                                            style: Theme.of(context).textTheme.labelMedium,
                                            softWrap: true,
                                            maxLines: null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 70),
                                    CircleIcon(icon: Icons.close,
                                      onPressed: collapseSheet,
                                    ),
                                  ],
                                ),
                                SliderCustom(
                                  lon: widget.lon,
                                  lat: widget.lat,
                                ),
                                // Text of number of containers found
                                Row(
                                  children: [
                                    Icon(Icons.circle, size: 10, color: camarone600,),
                                    const SizedBox(width: 10),
                                    Text('${contenedoresCercanos.length} contenedores encontrados', 
                                      style: Theme.of(context).textTheme.labelLarge
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // BODY
                        Expanded(
                          child: CustomScrollView(
                            controller: scrollControllerDefault,
                            slivers: [
                              //==== Manejo de estados de conexion del provider ====
                              // Representacion de la pantalla si esta cargando
                              if (vmContenedores.loading)
                                const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              // Representación de la pantalla si ocurrio un error
                              else if (vmContenedores.error != null)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(child: Text(vmContenedores.error!)),
                                )
                              // Representación del contenido
                              else
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                        child: CartaDetallesRecientes(
                                          contenedor: contenedoresCercanos[index],
                                          ir: widget.add,
                                          //TODO: implementar eliminar favorito desde la carta de detalles recientes
                                          deleteFavorito: () {},
                                          bajarSheet: collapseSheet,
                                        ),
                                      );
                                    },
                                    childCount: contenedoresCercanos.length,
                                  ),
                                ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 24)
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                )
              );
            }
          ),
        )
      ],
    );
  }
}
