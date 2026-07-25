import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';

class SheetForShowAllTheFavoritesContainers extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  final Future<void> Function(Contenedor contenedor) goToContainer;
  
  const SheetForShowAllTheFavoritesContainers({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.80,
    required this.goToContainer,
  });

  @override
  State<SheetForShowAllTheFavoritesContainers> createState() => SheetForShowAllTheFavoritesContainersState();
}

class SheetForShowAllTheFavoritesContainersState extends State<SheetForShowAllTheFavoritesContainers> {
  late final DraggableScrollableController draggableControllerOfShowTheFavoritesContainers;
  bool _isSheetOpen = false;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return 0.0;

    final currentSize = draggableControllerOfShowTheFavoritesContainers.size;
    
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
    draggableControllerOfShowTheFavoritesContainers = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfShowTheFavoritesContainers.removeListener(_onSheetChanged);
    draggableControllerOfShowTheFavoritesContainers.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    _isSheetOpen = draggableControllerOfShowTheFavoritesContainers.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return;

    await draggableControllerOfShowTheFavoritesContainers.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return;

    await draggableControllerOfShowTheFavoritesContainers.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return false;
    return _isSheetOpen;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfShowTheFavoritesContainers.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfShowTheFavoritesContainers.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfShowTheFavoritesContainers.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfShowTheFavoritesContainers.size < (widget.maxSheetSize / 2);

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfShowTheFavoritesContainers.size < _snapMidpoint
            ? widget.initialSheetSize
            : widget.maxSheetSize;

    draggableControllerOfShowTheFavoritesContainers.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
      
  @override
  Widget build(BuildContext context) {
    final vmFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final favoritos = vmFavoritos.favoritos;

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
            controller: draggableControllerOfShowTheFavoritesContainers,
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
                                //Header del widget (Texto - Boton cerrar)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Favoritos',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    
                                    CircleIcon(icon: Icons.close,
                                      onPressed: collapseSheet,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.favorite, color: camarone600,),
                                        const SizedBox(width: 15),
                                        Text('${favoritos.length} contenedores favoritos', 
                                          style: Theme.of(context).textTheme.labelLarge
                                        ),
                                      ],
                                    ),

                                    TextButton(
                                      onPressed: () {}, 
                                      child: Row(
                                        children: [
                                          Text('Ordenar', 
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              color: camarone600
                                              )
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(Icons.swap_vert, color: camarone600,)
                                        ],
                                      )
                                    )
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
                                  favoritos.isEmpty? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('No hay contenedores guardados'),
                                    ) : Column(
                                          children: favoritos.map(
                                              (contenedor) => Padding(
                                                padding: EdgeInsets.only(bottom: 10),
                                                child: CartaDetallesRecientes(
                                                  contenedor: contenedor,
                                                  deleteFavorito: () => vmFavoritos.removeFavoritoById(contenedor.idContenedor),
                                                  ir: widget.goToContainer,
                                                ),
                                              ),
                                            ).toList(growable: false),
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