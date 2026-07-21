import 'package:flutter/material.dart';

class SheetAddContainersToRoute extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  const SheetAddContainersToRoute({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.70,
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
    final fadeStart = widget.initialSheetSize + 0.17;

    // Evita división por 0 o rangos inválidos
    if (widget.maxSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (widget.maxSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
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