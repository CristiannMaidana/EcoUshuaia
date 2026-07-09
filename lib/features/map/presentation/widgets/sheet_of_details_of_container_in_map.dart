import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfDetailsOfContainerInMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  final Contenedor selectedContainer;
  
  const SheetOfDetailsOfContainerInMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
    required this.selectedContainer,
  });

  @override
  State<SheetOfDetailsOfContainerInMap> createState() => SheetOfDetailsOfContainerInMapState();
}

class SheetOfDetailsOfContainerInMapState extends State<SheetOfDetailsOfContainerInMap> {
  late final DraggableScrollableController draggableControllerOfDetailsContainerSheet;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfDetailsContainerSheet.isAttached) return 0.0;

    final currentSize = draggableControllerOfDetailsContainerSheet.size - 0.12;

    final opacity =
        (currentSize - widget.initialSheetSize) /
        (widget.maxSheetSize - widget.minSheetSize);

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
    return draggableControllerOfDetailsContainerSheet.size > widget.initialSheetSize;
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

  @override
  Widget build (BuildContext context) {
    final vmUsuarioFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();

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
                              ],
                            ),
                          ),
                        ),
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