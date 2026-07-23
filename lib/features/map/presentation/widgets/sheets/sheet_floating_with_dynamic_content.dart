import 'package:flutter/material.dart';

class SheetFloatingWithDynamicContent extends StatefulWidget {
  final double initialSheetSize;
  final double initChildSearchBarSize;
  final double initChildNavOptionsSize;
  final double maxSheetSize;
  final Widget childNavOptions;
  final Widget childSearchBar;
  final List<double> snapPoints;


  const SheetFloatingWithDynamicContent ({
    super.key,
    this.initialSheetSize = 0.093,
    this.initChildSearchBarSize = 0.80,
    this.initChildNavOptionsSize = 0.55,
    this.maxSheetSize = 0.80,
    required this.childNavOptions,
    required this.childSearchBar,
    this.snapPoints = const [0.093, 0.55, 0.80],
  });

  @override
  State<SheetFloatingWithDynamicContent> createState() => SheetFloatingWithDynamicContentState();
}

class SheetFloatingWithDynamicContentState extends State<SheetFloatingWithDynamicContent> {
  late final DraggableScrollableController draggableControllerOfSheetFloatign;
  bool _isSheetOpen = false;
  bool isShowingSecondChild = false;
  double? _headerDragStartSize;

  @override
  void initState() {
    super.initState();
    draggableControllerOfSheetFloatign = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfSheetFloatign.removeListener(_onSheetChanged);
    draggableControllerOfSheetFloatign.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    _isSheetOpen = draggableControllerOfSheetFloatign.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet() async {
    if (!draggableControllerOfSheetFloatign.isAttached) return;

    await draggableControllerOfSheetFloatign.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheetFloatign.isAttached) return;

    await draggableControllerOfSheetFloatign.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfSheetFloatign.isAttached) return false;
    return _isSheetOpen;
  }

  void dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfSheetFloatign.isAttached) return;
    _headerDragStartSize ??= draggableControllerOfSheetFloatign.size;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfSheetFloatign.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfSheetFloatign.jumpTo(nexRangeOfSheet);
  }

  void dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfSheetFloatign.isAttached) return;

    final currentSize = draggableControllerOfSheetFloatign.size;
    final dragStartSize = _headerDragStartSize ?? currentSize;
    _headerDragStartSize = null;
    final snapPoints = <double>{
      widget.initialSheetSize,
      widget.maxSheetSize,
      ...widget.snapPoints.map(
        (point) => point
            .clamp(widget.initialSheetSize, widget.maxSheetSize)
            .toDouble(),
      ),
    }.toList()
      ..sort();

    late final double targetToGoSheet;
    const snapTolerance = 0.0005;
    if (currentSize > dragStartSize + snapTolerance) {
      targetToGoSheet = snapPoints.firstWhere(
        (point) => point >= currentSize - snapTolerance,
        orElse: () => widget.maxSheetSize,
      );
    } else if (currentSize < dragStartSize - snapTolerance) {
      targetToGoSheet = snapPoints.reversed.firstWhere(
        (point) => point <= currentSize + snapTolerance,
        orElse: () => widget.initialSheetSize,
      );
    } else {
      targetToGoSheet = snapPoints.reduce(
        (closest, point) =>
            (currentSize - point).abs() < (currentSize - closest).abs()
            ? point
            : closest,
      );
    }

    draggableControllerOfSheetFloatign.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }


  // Calcula el nivel de padding para ir agrandandoce en base al tamaño de arrastre
  double get _t {
    if (!draggableControllerOfSheetFloatign.isAttached) return 0.0;
    final s = draggableControllerOfSheetFloatign.size;
    final max = widget.maxSheetSize;
    final v = (s - widget.initialSheetSize) / (max - widget.initialSheetSize);
    return v.clamp(0.0, 1.0);
  }

  double _mix(double a, double b, double t) => a + (b - a) * t;

  @override
  Widget build(BuildContext context) {
    //==== Construcción del Sheet animado =====
    // Valores animados según el estado de expansión
    final double animatedBottom = _mix(20, 0, _t);
    final double animatedBorde = _mix(36, 0, _t);
    final double animatedAncho = _mix(16, 0, _t);

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
        AnimatedPadding(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(animatedAncho, 0, animatedAncho, animatedBottom),
          child: DraggableScrollableSheet(
            controller: draggableControllerOfSheetFloatign,
            initialChildSize: widget.initialSheetSize,
            minChildSize: widget.initialSheetSize,
            maxChildSize: widget.maxSheetSize,
            builder: (context, scrollController) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36),
                    bottom: Radius.circular(animatedBorde),
                  ),
                  border: Border.all(width: .5, color: Colors.grey[400]!),
                ),
                child: PrimaryScrollController(
                  controller: scrollController,
                  child: isShowingSecondChild ? widget.childNavOptions : widget.childSearchBar,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
