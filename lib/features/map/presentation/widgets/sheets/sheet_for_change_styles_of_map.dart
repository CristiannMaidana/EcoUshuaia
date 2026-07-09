import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/map_style_picker.dart';
import 'package:flutter/material.dart';

class SheetForChangeStylesOfMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  final MapStyle selectedStyle;
  final Future<void> Function(MapStyle style) onStyleChanged;

  const SheetForChangeStylesOfMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.37,

    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  State<SheetForChangeStylesOfMap> createState() => SheetForChangeStylesOfMapState();
}

class SheetForChangeStylesOfMapState extends State<SheetForChangeStylesOfMap> {
  late final DraggableScrollableController draggableControllerOfStylesMapSheet;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;
  late MapStyle _selectedStyle;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfStylesMapSheet.isAttached) return 0.0;

    final currentSize = draggableControllerOfStylesMapSheet.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = widget.initialSheetSize + 0.09;

    // Evita división por 0 o rangos inválidos
    if (widget.maxSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (widget.maxSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    draggableControllerOfStylesMapSheet = DraggableScrollableController()
    ..addListener(_onSheetChanged);
    _selectedStyle = widget.selectedStyle;
  }

  @override
  void dispose() {
    draggableControllerOfStylesMapSheet.removeListener(_onSheetChanged);
    draggableControllerOfStylesMapSheet.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfStylesMapSheet.isAttached) return;

    await draggableControllerOfStylesMapSheet.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfStylesMapSheet.isAttached) return;

    await draggableControllerOfStylesMapSheet.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfStylesMapSheet.isAttached) return false;
    return draggableControllerOfStylesMapSheet.size > widget.initialSheetSize;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfStylesMapSheet.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfStylesMapSheet.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfStylesMapSheet.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfStylesMapSheet.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfStylesMapSheet.size < (widget.maxSheetSize / 2);

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfStylesMapSheet.size < _snapMidpoint
            ? widget.initialSheetSize
            : widget.maxSheetSize;

    draggableControllerOfStylesMapSheet.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }


  // Functions specific to the sheet
  Future<void> _handleStyleChanged(MapStyle style) async {
    if (_selectedStyle == style) return;

    setState(() => _selectedStyle = style);
    await widget.onStyleChanged(style);
  }

  @override
  Widget build(BuildContext context) {
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
        
        // SHEET
        // Handle of the sheet settings
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfStylesMapSheet,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BarraAgarre(),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Estilo de mapa',
                                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                            fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        Text('Elegi como queres ver el mapa.',
                                          style: Theme.of(context).textTheme.labelMedium,
                                        ),
                                      ],
                                    ),
                                    CircleIcon(icon: Icons.close,
                                      onPressed: collapseSheet,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //BODY
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollControllerDefault,
                            child: Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(22, 8, 22, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MapStylePicker(
                                    seleccionado: _selectedStyle,
                                    onChanged: _handleStyleChanged,
                                  ),
                                ],
                              ),
                            ),
                          )
                        )
                      ]
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