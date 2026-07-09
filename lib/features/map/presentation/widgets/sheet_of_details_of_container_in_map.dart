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