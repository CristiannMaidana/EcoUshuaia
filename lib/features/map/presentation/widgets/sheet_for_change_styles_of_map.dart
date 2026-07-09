import 'package:flutter/material.dart';

class SheetForChangeStylesOfMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetForChangeStylesOfMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
  });

  @override
  State<SheetForChangeStylesOfMap> createState() => SheetForChangeStylesOfMapState();
}

class SheetForChangeStylesOfMapState extends State<SheetForChangeStylesOfMap> {
    late final DraggableScrollableController draggableControllerOfStylesMapSheet;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfStylesMapSheet.isAttached) return 0.0;

    final currentSize = draggableControllerOfStylesMapSheet.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = widget.initialSheetSize + 0.15;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

      ],
    );
  }
}