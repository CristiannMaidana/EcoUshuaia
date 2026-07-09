import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetOfZonesOfMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetOfZonesOfMap({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
  });

  @override
  State<SheetOfZonesOfMap> createState() => SheetOfZonesOfMapState();
}

class SheetOfZonesOfMapState extends State<SheetOfZonesOfMap> {
  late final DraggableScrollableController draggableControllerOfZonesSheet;
  late ScrollController scrollControllerOfZonesSheet;

  @override
  void initState() {
    super.initState();
    draggableControllerOfZonesSheet = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfZonesSheet.removeListener(_onSheetChanged);
    draggableControllerOfZonesSheet.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;
    
    await draggableControllerOfZonesSheet.animateTo(
      widget.maxSheetSize, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfZonesSheet.isAttached) return;

    await draggableControllerOfZonesSheet.animateTo(
      widget.initialSheetSize, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfZonesSheet.isAttached) return false;
    return draggableControllerOfZonesSheet.size > widget.initialSheetSize;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfZonesSheet.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet = (draggableControllerOfZonesSheet.size - detail.delta.dy / heightSheet).clamp(
      widget.minSheetSize,
      widget.maxSheetSize,
    );
    draggableControllerOfZonesSheet.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfZonesSheet.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold || draggableControllerOfZonesSheet.size < 0.30;

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet = drifVelocityOfHandle > velocityThreshold
        ? widget.minSheetSize
        : widget.maxSheetSize;

    draggableControllerOfZonesSheet.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final zonaVm = context.watch<ZonaMapaViewModel>();
    final usuarioZoneId = context.watch<UsuarioViewModel>().usuario?.idZona;
    final userZone = zonaVm.zonaConCoordenadasPorId(usuarioZoneId);

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
          child: DraggableScrollableSheet(
            controller: draggableControllerOfZonesSheet,
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
                              SizedBox(height: 8,),
                              // Text of header and button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text of header
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Zonas del mapa',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Gestiona la visualización de zonas en el mapa.',
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(userZone == null
                                        ? 'No se encontró una zona asignada para tu usuario.'
                                        : 'Tu zona es: ${userZone.nombreZona}.',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  // Button to close header
                                  CircleIcon(icon: Icons.close,
                                    onPressed: collapseSheet,
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
                          
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
