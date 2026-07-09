import 'package:flutter/material.dart';

class SheetOfDetailsOfContainerInMap extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;
  
  const SheetOfDetailsOfContainerInMap ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.47,
  });

  @override
  State<SheetOfDetailsOfContainerInMap> createState() => SheetOfDetailsOfContainerInMapState();
}

class SheetOfDetailsOfContainerInMapState extends State<SheetOfDetailsOfContainerInMap> {
  late final DraggableScrollableController draggableControllerOfDetailsContainerSheet;
  
  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;

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
    return Stack(

    );
  }
}